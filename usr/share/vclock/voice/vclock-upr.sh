#!/bin/bash
#
# Скрипт управления для говорящих часов /usr/bin/vclock
# Версия 1.5.5 обновление от 3 июня 2016 г.

# Переменные для расцветки вывода консоли
RED='\033[1;31m';
GREEN='\033[1;32m';
NORMAL='\033[0m';

function fun_mess () {
	if [[ -f $(which zenity) ]] && [[ $(zenity --version | sed 's/\..*$//') -ge 2 ]] && [[ "$DISPLAY" != "" ]]; then
		zenity --$1 --title="$(basename $0)" --text="$2" --timeout="5";
	else
		if [[ "$1" = "info" ]]; then
			echo -e "${GREEN}Скрипт $(basename $0). Сообщение: $2${NORMAL}";
		else
			echo -e "${RED}Скрипт $(basename $0). Ошибка: $2${NORMAL}";
		fi
	fi
}

function 1m () {
	crontab -l > /tmp/vclock;
	sed -i '/vclock.sh/d' /tmp/vclock;
	echo "*/1 *	* * *   /usr/bin/vclock.sh > /dev/null 2>&1" >> /tmp/vclock;
	crontab /tmp/vclock;
	fun_mess "info" "Часы влючены\nГоворим каждую минуту";
}

function 15m () {
	crontab -l > /tmp/vclock;
	sed -i '/vclock.sh/d' /tmp/vclock;
	echo "*/15 *	* * *   /usr/bin/vclock.sh > /dev/null 2>&1" >> /tmp/vclock;
	crontab /tmp/vclock;
	fun_mess "info" "Часы влючены\nГоворим каждые 15 минут";
}

function 30m () {
	crontab -l > /tmp/vclock;
	sed -i '/vclock.sh/d' /tmp/vclock;
	echo "*/30 *	* * *   /usr/bin/vclock.sh > /dev/null 2>&1" >> /tmp/vclock;
	crontab /tmp/vclock;
	fun_mess "info" "Часы влючены\nГоворим каждые 30 минут";
}

function 1h () {
	crontab -l > /tmp/vclock;
	sed -i '/vclock.sh/d' /tmp/vclock;
	echo "0 */1	* * *   /usr/bin/vclock.sh > /dev/null 2>&1" >> /tmp/vclock;
	crontab /tmp/vclock;
	fun_mess "info" "Часы влючены\nГоворим каждый час" --timeout="3"
}

function otkl () {
	crontab -l > /tmp/vclock;
	sed -i '/vclock.sh/d' /tmp/vclock;
	crontab /tmp/vclock;
	fun_mess "info" "Часы отключены";
}

function fun_menu () {
	case $upr in
		1-мин)    1m   ;;
		15-мин)    15m   ;;
		30-мин)    30m   ;;
		1-час)    1h  ;;
		Выключить)    otkl   ;;
		Тест)   exec $(dirname $0)/vclock.sh  ;;
		*)     fun_mess "info" "Действие отменено пользователем"    ;;
	esac
}

if [[ -f $( which mplayer) ]] || [[ -f $(which cvlc) ]]; then
	if ! [[ -d "$HOME/.config/vclock" ]]; then
		mkdir -p $HOME/.config/vclock;
		if ! [[ -f "$HOME/.config/vclock/vclock.conf" ]]; then
			echo "15" > $HOME/.config/vclock/vclock.conf;
		fi
	fi
	if [[ -f $(which zenity) ]] && [[ $(zenity --version | sed 's/\..*$//') -ge 2 ]] && [[ "$DISPLAY" != "" ]]; then
		upr=$(zenity --title "Говорящие часы" --text "Выбери действие\n" --height 240 --list --radiolist --column "Выбор" --column "Действие" True Тест False 1-мин False 15-мин False 30-мин  False 1-час False Выключить);
		fun_menu "$upr";
	else
		if [[ "$DISPLAY" = "" ]]; then
			clear;
			PS3="Назнач диапазон времени оповещения или отключи: ";
			select upr in Тест 1-мин 15-мин 30-мин 1-час Выключить; do
				fun_menu "$upr";
				break
			done
		else
			clear;
			echo -e "Установленная версия zenity не поддерживает нужный набор параметров\nГоворящие часы поддержывают zenity 2.32.1 или новее.\n\n";
			PS3="Назнач диапазон времени оповещения или отключи: ";
			select upr in Тест 1-мин 15-мин 30-мин 1-час Выключить; do
				fun_menu "$upr";
				break
			done
		fi
	fi
else
	fun_mess "error" "Не обнаружено приложение mplayer или vlc";
fi
exit 0;
