#!/bin/bash

# Путь к корневой директории проекта
PROJECT_DIR="/home/hzhex/AssemblyTimofey"

# Функция для отображения меню
show_menu() {
    clear
    echo "============================================"
    echo "              МЕНЮ ЗАДАНИЙ                 "
    echo "============================================"
    echo "1. Задание 2.3"
    echo "2. Задание 3.23"
    echo "3. Задание 4.22"
    echo "4. Задание 4.25"
    echo "5. Задание 5.14"
    echo "6. Задание 5.24"
    echo "7. Задание 6.40"
    echo "0. Выход"
    echo "============================================"
    echo -n "Выберите задание (0-7): "
}

# Функция для запуска задания
run_task() {
    local task_number=$1
    local task_dir=""
    local executable=""
    
    case $task_number in
        1)
            task_dir="$PROJECT_DIR/N23++"
            executable="./23"
            ;;
        2)
            task_dir="$PROJECT_DIR/N323++"
            executable="./323"
            ;;
        3)
            task_dir="$PROJECT_DIR/N422++"
            executable="./422"
            ;;
        4)
            task_dir="$PROJECT_DIR/N425++"
            executable="./425"
            ;;
        5)
            task_dir="$PROJECT_DIR/N514+"
            executable="./514"
            ;;
        6)
            task_dir="$PROJECT_DIR/N524+"
            executable="./524"
            ;;
        7)
            task_dir="$PROJECT_DIR/N640+"
            executable="./64"
            ;;
        *)
            echo "Неверный выбор!"
            return 1
            ;;
    esac
    
    # Проверка существования директории
    if [ ! -d "$task_dir" ]; then
        echo "Директория задания не существует: $task_dir"
        return 1
    fi
    
    # Переход в директорию задания
    cd "$task_dir" || return 1
    
    # Проверка наличия исполняемого файла
    if [ ! -x "${executable#./}" ]; then
        echo "Исполняемый файл не найден или не имеет прав на выполнение. Выполняется компиляция..."
        ./compile.sh
    fi
    
    # Запуск задания
    echo "Запуск задания..."
    $executable
    
    # Возврат в директорию проекта
    cd "$PROJECT_DIR" || return 1
    
    echo "Нажмите Enter для возврата в меню"
    read -r
}

# Сделать скрипт исполняемым
chmod +x "$0"

# Основной цикл программы
while true; do
    show_menu
    read -r choice
    
    if [ "$choice" == "0" ]; then
        clear
        echo "Выход из программы."
        exit 0
    elif [[ "$choice" =~ ^[1-7]$ ]]; then
        run_task "$choice"
    else
        echo "Неверный выбор! Нажмите Enter для продолжения."
        read -r
    fi
done
