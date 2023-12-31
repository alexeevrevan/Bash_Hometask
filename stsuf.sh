#!/bin/bash

# Проверка и считывание параметров
while [[ $# -gt 0 ]]; do  # Цикл обработки переданных параметров
    case $1 in
    --path)
        path="$2"  # Считывание значения параметра --path
        shift 2
        ;;
    *)
        echo "Ошибка: Неизвестный параметр: $1"  # Вывод сообщения об ошибке для неизвестного параметра
        exit 1
        ;;
    esac
done

# Проверка наличия параметра --path
if [ -z "$path" ]; then  # Проверка, был ли передан параметр --path
    echo "Ошибка: Необходимо указать параметр --path для указания каталога"  # Вывод сообщения об ошибке
    exit 1  # Выход с кодом ошибки
fi

# Есть ли такой каталог
if [ ! -d "$path" ]; then  # Проверка существования указанного каталога
    echo "Ошибка: Каталог \"$path\" не существует"
    exit 1
fi

declare -A suffix_count  # Объявляем ассоциативный массив для подсчета количества файлов с различными суффиксами

# Получаем список файлов в указанном каталоге и проходим по каждому файлу
for file in "$path"/*; do
    if [ -f "$file" ]; then  # Проверяем, является ли объект файлом
        filename=$(basename "$file")  # Получаем имя файла
        suffix="${filename##*.}"  # Получаем суффикс файла
        if [ -z "$suffix" ]; then  # Проверка на наличие суффикса
            ((suffix_count["no_suffix"]++))
        else
            ((suffix_count["$suffix"]++))
        fi
    fi
done

# Формируем строку с результатами подсчета
result=""
for k in "${!suffix_count[@]}"; do
    result+="$k: ${suffix_count["$k"]}\n"  # результат
done

# Сортируем результаты по убыванию количества файлов
sorted_result=$(echo -e "$result" | sort -rn -k2)

echo -e "${sorted_result//no_suffix/no suffix}" | sed 's/\(.*\)/.\1/g'  # Выводим результат