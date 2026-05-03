#!/bin/bash

# =============================================================================
# ISCSI Cluster Deployment Script
# Описание: Автоматическое развёртывание инфраструктуры и настройка сервисов
# =============================================================================

# -----------------------------------------------------------------------------
# Форматирование
# -----------------------------------------------------------------------------
readonly RESET='\033[0m'
readonly BOLD='\033[1m'
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly MAGENTA='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly DIM='\033[2m'

# -----------------------------------------------------------------------------
# 📊 Вывода
# -----------------------------------------------------------------------------
readonly INFO='ℹ'
readonly SUCCESS='✓'
readonly WARNING='⚠'
readonly ERROR='✗'
readonly ARROW='→'
readonly CHECK='☑'
readonly CROSS='☒'

# -----------------------------------------------------------------------------
# Пути (#TODO: сделать относитьельные пути)
# -----------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/config.env"
LOG_FILE="${SCRIPT_DIR}/deploy_$(date +%Y%m%d_%H%M%S).log"
TERRAFORM_DIR="${SCRIPT_DIR}/terraform"
ANSIBLE_DIR="${SCRIPT_DIR}/ansible"

# -----------------------------------------------------------------------------
# Banner
# -----------------------------------------------------------------------------
show_banner() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   ██████╗  ██████╗ ████████╗███████ ██╗    ██╗ ██████╗                       ║
║   ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝ ██║    ██║██╔═══██╗                      ║
║   ██████╔╝██║   ██║   ██║   █████╗   ██║ █╗ ██║██║   ██║                      ║
║   ██╔══██╗██║   ██║   ██║   ██╔══╝   ██║███╗██║██║   ██║                      ║
║   ██║  ██║╚██████╔╝   ██║   ███████╗ ╚███╔███╔╝╚██████╔╝                      ║
║   ╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚══════╝  ╚══╝╚══╝  ╚═════╝                       ║
║                                                                              ║
║                    iSCSI  + GFS2 Cluster Deployment                           ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo ""
}

# -----------------------------------------------------------------------------
# Вывод
# -----------------------------------------------------------------------------
log_info() {
    echo -e "${BLUE}${INFO}${RESET} ${CYAN}$1${RESET}"
}

log_success() {
    echo -e "${GREEN}${SUCCESS}${RESET} ${GREEN}$1${RESET}"
}

log_warning() {
    echo -e "${YELLOW}${WARNING}${RESET} ${YELLOW}$1${RESET}"
}

log_error() {
    echo -e "${RED}${ERROR}${RESET} ${RED}$1${RESET}"
}

log_step() {
    echo ""
    echo -e "${WHITE}${BOLD}════════════════════════════════════════════════════════════════${RESET}"
    echo -e "${WHITE}${BOLD}  $1${RESET}"
    echo -e "${WHITE}${BOLD}════════════════════════════════════════════════════════════════${RESET}"
    echo ""
}

log_substep() {
    echo -e "${DIM}${ARROW}${RESET} ${CYAN}$1${RESET}"
}


# -----------------------------------------------------------------------------
# Прогресс бар
# -----------------------------------------------------------------------------
show_progress() {
    local duration=$1
    local message=$2
    local bar_width=50
    local progress=0
    
    echo -ne "${DIM}"
    for ((i=0; i<=bar_width; i++)); do
        progress=$((i * 100 / bar_width))
        filled=$((i * 100 / bar_width))
        
        printf "\r  [%-50s] %3d%% %s" \
            "$(printf '#%.0s' $(seq 1 $((i / 1))))" \
            "$progress" \
            "$message"
        
        sleep $(echo "scale=3; $duration / $bar_width" | bc)
    done
    echo -e "${RESET}"
}

# -----------------------------------------------------------------------------
# Ввод пользователя
# -----------------------------------------------------------------------------
prompt_confirm() {
    local message=$1
    local default=${2:-"n"}
    
    while true; do
        echo -ne "${YELLOW}?${RESET} ${message} ${DIM}[${default}]${RESET} "
        read -r response
        
        if [[ -z "$response" ]]; then
            response=$default
        fi
        
        case "$response" in
            [Yy]|[Yy][Ee][Ss])
                return 0
                ;;
            [Nn]|[Nn][Oo])
                return 1
                ;;
            *)
                log_warning "Пожалуйста, введите 'y' или 'n'"
                ;;
        esac
    done
}


prompt_input() {
    local message=$1
    local default=$2
    local variable=$3
    
    while true; do
        if [[ -n "$default" ]]; then
            echo -ne "${YELLOW}?${RESET} ${message} ${DIM}[${default}]${RESET} "
        else
            echo -ne "${YELLOW}?${RESET} ${message} "
        fi
        read -r response
        
        if [[ -z "$response" && -z "$default" ]]; then
            log_warning "Это поле обязательно для заполнения"
            continue
        fi
        
        if [[ -z "$response" ]]; then
            response=$default
        fi
        
        eval "$variable='$response'"
        break
    done
}


# -----------------------------------------------------------------------------
# Проверка зависимостей
# -----------------------------------------------------------------------------
check_dependencies() {
    log_step "Проверка зависимостей"
    
    local deps=("terraform" "ansible" "yc" "jq" "bc")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if command -v "$dep" &> /dev/null; then
            log_substep "Проверка $dep... ${GREEN}OK${RESET}"
        else
            log_substep "Проверка $dep... ${RED}NOT FOUND${RESET}"
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Отсутствуют необходимые зависимости: ${missing[*]}"
        log_info "Установите их и повторите запуск"
        exit 1
    fi
    
    log_success "Все зависимости установлены"
}

load_config() {
    # log_step "Загрузка конфигурации"
    
    # if [[ -f "$CONFIG_FILE" ]]; then
    #     log_substep "Файл конфигурации найден: ${CONFIG_FILE}"
        
    #     if prompt_confirm "Использовать существующую конфигурацию?"; then
    #         set -a
    #         source "$CONFIG_FILE"
    #         set +a
    #         log_success "Конфигурация загружена"
    #         return 0
    #     fi
    # else
    #     log_warning "Файл конфигурации не найден"
    # fi
    
    # Интерактивный ввод
    echo ""
    log_info "Введите параметры развёртывания:"
    echo ""
    prompt_input "Yandex Cloud Service Account Name:" "" "YC_SERVICE_ACCOUNT_NAME"
    prompt_input "Yandex Clound Service Account Description:" "" "YC_SERVICE_ACCOUNT_DESCRIPTION"
    prompt_input "Yandex Cloud Service Account Role:" "" "YC_SERVICE_ACCOUNT_ROLE"
    prompt_input "Yandex Cloud Folder ID:" "" "YC_FOLDER_ID"
    #prompt_input "Зона доступности" "ru-central1-a" "VM_ZONE"
    #prompt_input "Количество узлов GFS" "3" "VM_COUNT"
    #prompt_input "Размер диска (GB)" "25" "DISK_SIZE"
    #prompt_input "Тип диска" "network-hdd" "DISK_TYPE"
    #prompt_input "IQN iSCSI Target" "iqn.2026-05.com.example:storage" "ISCSI_TARGET_IQN"
    
    # Сохранение конфигурации
    if prompt_confirm "Сохранить конфигурацию в файл?"; then
        cat > "$CONFIG_FILE" << EOF
    # Configuration
    # Generated: $(date)

YC_SERVICE_ACCOUNT_NAME=${YC_SERVICE_ACCOUNT_NAME}
YC_SERVICE_ACCOUNT_DESCRIPTION=${YC_SERVICE_ACCOUNT_DESCRIPTION}
YC_SERVICE_ACCOUNT_ROLE=${YC_SERVICE_ACCOUNT_ROLE}
YC_FOLDER_ID="${YC_FOLDER_ID}"

EOF

        log_success "Конфигурация сохранена в ${CONFIG_FILE}"
    fi
}

# -----------------------------------------------------------------------------
# Аутентификация Yandex Cloud
# -----------------------------------------------------------------------------
authenticate_yc() {
    log_step "Аутентификация в Yandex Cloud"
    
    #show_progress 2 "Проверка профиля..."
    
    if yc config profile list &> /dev/null; then
        log_success "Профиль Yandex Cloud активен"
        
        local profile=$(yc config profile list | grep "(active)" | awk '{print $1}')
        if [[ -z "$profile" ]]; then
            profile="default"
        fi
        log_substep "Активный профиль: ${CYAN}${profile}${RESET}"
    else
        log_error "Не удалось аутентифицироваться в Yandex Cloud"
        log_info "Выполните: yc init"
        exit 1
    fi
}

# -----------------------------------------------------------------------------
# Развёртывание Terraform
# -----------------------------------------------------------------------------
run_terraform() {
    log_step "Развёртывание инфраструктуры (Terraform)"
    
    cd "$TERRAFORM_DIR" || exit 1
    
    log_substep "Инициализация Terraform..."
    #show_progress 3 "terraform init"
    
    if ! terraform init -input=false > /dev/null 2>&1; then
        log_error "Ошибка инициализации Terraform"
        exit 1
    fi
    log_success "Terraform инициализирован"
    
    echo ""
    log_substep "План изменений:"
    terraform plan -var="folder_id=$YC_FOLDER_ID" \
                    -var="serviceAccount_Name=$YC_SERVICE_ACCOUNT_NAME" \
                    -var="serviceAccount_Description=$YC_SERVICE_ACCOUNT_DESCRIPTION" \
                    -var="serviceAccount_role=$YC_SERVICE_ACCOUNT_ROLE" \

    
    echo ""
    if ! prompt_confirm "Применить изменения Terraform?"; then
        log_warning "Развёртывание отменено пользователем"
        exit 0
    fi
    
    log_substep "Применение конфигурации..."
    
    #show_progress 50 "terraform apply"
        if ! terraform apply -auto-approve \
                     -var="folder_id=$YC_FOLDER_ID" \
                     -var="serviceAccount_Name=$YC_SERVICE_ACCOUNT_NAME" \
                     -var="serviceAccount_Description=$YC_SERVICE_ACCOUNT_DESCRIPTION" \
                     -var="serviceAccount_role=$YC_SERVICE_ACCOUNT_ROLE" ; then
            log_error "Ошибка применения Terraform"
            exit 1
        fi
    log_success "Изменения инраструктуры применены"
    
    # Сохранение output
#    log_substep "Сохранение выходных данных..."
#    terraform output -json > "${ANSIBLE_DIR}/terraform_outputs.json"
#    log_success "Output сохранён для Ansible"
    
#    cd "$SCRIPT_DIR"
}

# -----------------------------------------------------------------------------
# Main функция
# -----------------------------------------------------------------------------
main() {
    clear
    show_banner
    
    echo -e "${DIM}Время запуска: $(date)${RESET}"
    echo -e "${DIM}Директория: ${SCRIPT_DIR}${RESET}"
    echo ""
    
    check_dependencies
    load_config
    authenticate_yc
    run_terraform
    #run_ansible
    #final_check
    #show_summary
    
    #log_success "Все этапы выполнены успешно!"
}

# Запуск
main "$@"