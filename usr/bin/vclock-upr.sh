#!/bin/bash
#
# Skrypt sterujący dla mówiącego zegara /usr/bin/vclock
# Wersja 1.5.5 zaktualizowana 3 czerwca 2016 r.

# Zmienne do kolorowania wyjścia konsoli
RED='\033[1;31m';
GREEN='\033[1;32m';
NORMAL='\033[0m';

function fun_mess () {
	if [[ -f $(which zenity) ]] && [[ $(zenity --version | sed 's/\..*$//') -ge 2 ]] && [[ "$DISPLAY" != "" ]]; then
		zenity --$1 --title="$(basename $0)" --text="$2" --timeout="5";
	else
		if [[ "$1" = "info" ]]; then
			echo -e "${GREEN}Skrypt $(basename $0). Wiadomość: $2${NORMAL}";
		else
			echo -e "${RED}Skrypt $(basename $0). Błąd: $2${NORMAL}";
		fi
	fi
}

function 1m () {
	crontab -l > /tmp/vclock;
	sed -i '/vclock.sh/d' /tmp/vclock;
	echo "*/1 *	* * *   /usr/bin/vclock.sh > /dev/null 2>&1" >> /tmp/vclock;
	crontab /tmp/vclock;
	fun_mess "info" "Zegarek jest włączony\nPodaję czas co minutę";
}

function 15m () {
	crontab -l > /tmp/vclock;
	sed -i '/vclock.sh/d' /tmp/vclock;
	echo "*/15 *	* * *   /usr/bin/vclock.sh > /dev/null 2>&1" >> /tmp/vclock;
	crontab /tmp/vclock;
	fun_mess "info" "Zegar jest włączony\nPodaję czas co 15 minut";
}

function 30m () {
	crontab -l > /tmp/vclock;
	sed -i '/vclock.sh/d' /tmp/vclock;
	echo "*/30 *	* * *   /usr/bin/vclock.sh > /dev/null 2>&1" >> /tmp/vclock;
	crontab /tmp/vclock;
	fun_mess "info" "Zegar jest włączony\nPodaję czas co 30 minut";
}

function 1h () {
	crontab -l > /tmp/vclock;
	sed -i '/vclock.sh/d' /tmp/vclock;
	echo "0 */1	* * *   /usr/bin/vclock.sh > /dev/null 2>&1" >> /tmp/vclock;
	crontab /tmp/vclock;
	fun_mess "info" "Zegar jest włączony\nPodaję czas co godzinę" --timeout="3"
}

function otkl () {
	crontab -l > /tmp/vclock;
	sed -i '/vclock.sh/d' /tmp/vclock;
	crontab /tmp/vclock;
	fun_mess "info" "Zegar wyłączony";
}

function fun_menu () {
	case $upr in
		1-min)    1m   ;;
		15-min)    15m   ;;
		30-min)    30m   ;;
		1-godz)    1h  ;;
		Wyłączyć)    otkl   ;;
		Test)   exec $(dirname $0)/vclock.sh  ;;
		*)     fun_mess "info" "Akcja anulowana przez użytkownika"    ;;
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
		upr=$(zenity --title "Mówiący zegar" --text "Wybierz akcję\n" --height 240 --list --radiolist --column "Wybór" --column "Akcja" True Тест False 1-min False 15-min False 30-min  False 1-godz False Wyłączyć);
		fun_menu "$upr";
	else
		if [[ "$DISPLAY" = "" ]]; then
			clear;
			PS3="Przypisz zakres czasu alertu lub wyłącz: ";
			select upr in Test 1-min 15-min 30-min 1-godz Wyłączyć; do
				fun_menu "$upr";
				break
			done
		else
			clear;
			echo -e "Zainstalowana wersja zenity nie obsługuje żądanego zestawu opcji\nMówiący zegar obsługuje zenity w wersji 2.32.1 lub nowszej.\n\n";
			PS3="Przypisz zakres czasu alertu lub wyłącz: ";
			select upr in Test 1-min 15-min 30-min 1-godz Wyłączyć; do
				fun_menu "$upr";
				break
			done
		fi
	fi
else
	fun_mess "error" "Nie znaleziono aplikacji mplayer ani vlc";
fi
exit 0;
