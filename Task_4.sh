#!/bin/bash

while [[ $# -gt 0 ]]; do
    case "$1" in
        --path)
            dirpath="$2"
            shift 2
            ;;
        --mask)
            mask="$2"
            shift 2
            ;;
        --number)
            number="$2"
            shift 2
            ;;
        *)
            break
            ;;
    esac
done

command="$1"

if [ -z "$dirpath" ]; then
    dirpath=$(pwd)
fi

if [ ! -d "$dirpath" ]; then
    echo "Path '$dirpath' does not exist"
    exit 1
fi

if [ -z "$mask" ]; then
    mask="*"
fi

if [ -z "$number" ]; then
    number=$(nproc)
fi

if [ ! -x "$(which $command)" ]; then
    echo "$command does not exist"
    exit 1
fi

handler() {
    local files=($dirpath/$mask)
    local all_files=${#files[@]}
    local ind=0
    local count_proc_run=0

    while [ $ind -lt $all_files ]; do
        while [ $count_proc_run -lt $number ] && [ $ind -lt $all_files ]; do
            if [ -f "${files[$ind]}" ]; then
                $command "${files[$ind]}" &
                ((count_proc_run++))
            fi
            ((ind++))
        done
        wait
        count_proc_run=0
    done
    echo "Done processing!"
}

handler