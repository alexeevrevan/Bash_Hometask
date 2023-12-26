#!/bin/bash

# Обработка трех параметров
while [[ $# -gt 0 ]]; do
    case $1 in
    --path)
        if [ -z "$2" ]; then
            echo "Ошибка: передан пустой параметр для --path"
            exit 1
        fi
        path="$2"  # Сохраняем --path
        shift 2
        ;;
    --old_suffix)
        if [ -z "$2" ]; then
            echo "Ошибка: передан пустой параметр для --old_suffix"
            exit 1
        fi
        old_suffix="$2"  # Сохраняем--old_suffix в переменной old_suffix
        shift 2
        ;;
    --new_suffix)
        if [ -z "$2" ]; then
            echo "Ошибка: передан пустой параметр для --new_suffix"
            exit 1
        fi
        new_suffix="$2"  # Сохраняем значение параметра --new_suffix в переменной new_suffix
        shift 2
        ;;
    *)
        echo "$1"
        shift
        ;;
    esac
done

# Дополнительная проверка корректности параметров
if [ -z "$path" ] || [ ! -d "$path" ] || [ -z "$old_suffix" ] || [[ $old_suffix != .* || $old_suffix == *..* ]] || [ -z "$new_suffix" ] || [[ $new_suffix != .* || $new_suffix == *..* ]]; then
    echo "Ошибка: Некорректные параметры"
    exit 1
fi

# замена суффиксов
for file in "$path"/*"$old_suffix"; do  # Перебор файлов с суффиксом
    if [ -f "$file" ]; then  # Проверяем, является ли текущий элемент файлом
        new_file="${file%$old_suffix}$new_suffix"  # Формируем новое имя файла с новым суффиксом
        mv "$file" "$new_file"  # Переименовываем файл
        echo "Файл $file переименован в $new_file"  # До и после
    fi
done