#!/bin/bash

turn=0
declare -A board


display_board(){
	echo "Ход № $turn"
	echo "+-------------------+"
	for ((i=0; i<4; i++)); do
	        echo -n "|"
		for ((j=0; j<4; j++)); do
        	    #echo -n "${board[$i,$j]} "
			if [ "${board[$i,$j]}" -eq 16 ]; then
                               echo -n "    |"
			else
                               printf " %2d |" "${board[$i,$j]}"
                      	fi

        	done
        	echo
		if [ "$i" != 3 ]; then
			echo "|-------------------|"
		else
			echo "+-------------------+"
		fi
	echo
    	done
}

generate_data() {
	numbers=( $(shuf -i 1-16) )
	ind=0
    	for ((i=0; i<4; i++)); do
        	for ((j=0; j<4; j++)); do
            		board[$i,$j]=${numbers[$ind]}
            		((ind++))
#			echo ${board[$i,$j]}
        	done
    	done
}


move(){
	local empty_col
	local empty_row
	local select_num
	local select_col
	local select_row
	while true; do
        	read -p "Ваш ход (q - выход): " select_num
		if [ "$select_num" == "q" ]; then
			echo
			echo "Выход."
			exit 0
		fi
		if ! [[ "$select_num" =~ ^[1-9]$|^1[0-5]$ ]]; then
			echo
    			echo "Некорректный ввод. Введите число от 1 до 15 или 'q' для выхода."
    			continue
		fi

		for ((i=0; i<4; i++)); do
            		for ((j=0; j<4; j++)); do
                		if [ "${board[$i,$j]}" -eq "$select_num" ]; then
                    			select_row=$i
                    			select_col=$j
                		fi
			done
		done

#		echo $select_row $select_col
		for ((i=0; i<4; i++)); do
            		for ((j=0; j<4; j++)); do
                		if [ "${board[$i,$j]}" -eq 16 ]; then
                    			empty_row=$i
                    			empty_col=$j
                		fi
            		done
        	done
#           	echo $empty_row $empty_col
		if [ \
			\( "$select_row" -eq "$empty_row" -a \
			\( "$select_col" -eq "$((empty_col-1))" -o "$select_col" -eq "$((empty_col+1))" \) \) \
			-o \
             		\( "$select_col" -eq "$empty_col" -a \
			\( "$select_row" -eq "$((empty_row-1))" -o \ "$select_row" -eq "$((empty_row+1))" \) \) ]; then
			board[$empty_row,$empty_col]=${board[$select_row,$select_col]}
            		board[$select_row,$select_col]=16
            		break
        	else
			echo
            		echo "Неверный ход!"
			echo "Невозможно костяшку $select_num передвинуть на пустую ячейку."
			possible=()
			if [ "$empty_row" -gt 0 ]; then
    				possible+=(${board[$((empty_row-1)),$empty_col]})
			fi
			if [ "$empty_row" -lt 3 ]; then
    				possible+=(${board[$((empty_row+1)),$empty_col]})
			fi
			if [ "$empty_col" -gt 0 ]; then
    				possible+=(${board[$empty_row,$((empty_col-1))]})
			fi
			if [ "$empty_col" -lt 3 ]; then
    				possible+=(${board[$empty_row,$((empty_col+1))]})
			fi
			str_pos_move=$(printf '%s, ' "${possible[@]}")
			echo
			echo "Можно выбрать: ${str_pos_move%, }"
			echo
		fi
	done
}

win_case(){
	winning_conditions="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 ."
	now=""
    	for ((i=0; i<4; i++)); do
        	for ((j=0; j<4; j++)); do
            		now+="${board[$i,$j]} "
        	done
    	done
	now+="."
#	echo $now
#	echo $winning_conditions
#	echo "Результат сравнения: $( [[ "$now" == "$winning_conditions" ]] && echo "Строка 'now' равна строке 'winning_conditions'" || echo "Строка 'now' не равна строке 'winning_conditions'")"
    	if [[ "$now" == "$winning_conditions" ]]; then
        	echo "Вы собрали головоломку за $turn ходов."
		exit 0
    	fi
}

15puzzle(){
	generate_data
	while true; do
		((turn++))
		display_board
		move
		win_case
	done
}

15puzzle