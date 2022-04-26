#!/bin/bash
# Gadający zegar 1.5.5
# Do działania skryptu potrzebny jest zainstalowany mplayer lub vlc z interfejsem konsoli, tj. cvlc
# Głośność dla MPlayera jest ustawiona w pliku $ HOME/.config/vclock/vclock.conf
# jeśli tego pliku nie ma lub jest pusty lub w pliku nie jest to głośność będzie maksymalna
# Dla cvlc na razie bez regulacji głośności, czyli używana jest konfiguracja systemu.
#
# Do katalogu $HOME/.config/vclock/voice można umieścić swoje pliki dźwiękowe
# ich nazwy i treść powinny dopasuj pliki z /usr/share/vclock/voice

# Ścieżka do niestandardowych plików głosowych i konfiguracji zegara
config="$HOME/.config/vclock";

IFS=$'\t\n';
export XDG_RUNTIME_DIR="/run/user/$( id -u $(ps aux | grep vclock | grep bash | grep -v grep | awk '{ print $1 }' | head -n 1))";

# Domyślna ścieżka do plików dźwiękowych
mpath="/usr/share/vclock/voice";

if [[ -f $(which mplayer) ]] || [[ -f $(which cvlc) ]]; then

	if [[ -d "$config/voice" ]]; then
		voice_orig=($(find $mpath -name "*.mp3"));
		s=0;
		for i in ${voice_orig[@]}; do
			if ! [[ -f "$config/voice/$(basename $i)" ]]; then let s=s+1; fi
		done
		if [[ "$s" = 0 ]]; then
			mpath="$config/voice";
		else
			echo -e "Skrypt $(basename $0): nie wszystkie pliki w $config/voice\nsą używane przez pliki dźwiękowe z $mpath";
		fi
	fi

	# Ustaw poziom głośności z pliku konfiguracyjnego
	if [[ -f "$config/vclock.conf" ]] && [[ $( du $config/vclock.conf | awk '{ print $1 }') != 0 ]]; then
		v="$(/bin/cat $config/vclock.conf | head -n 1)";
	else
		v="15";
	fi
	# Obliczamy godziny i minuty i przypisujemy uzyskane wartości do zmiennych
	h=$(date +"%H");
	m=$(date +"%M");
	# Uruchamiamy mplayer lub cvlc z zestawem plików mp3 nazwy, które są tworzone z godzin i minut
	if [[ -f $(which mplayer) ]]; then
		if [[ "$h" = 15 ]] && [[ "$m" = "00" ]]; then
			mplayer -af volume="-$v" $mpath/mayak.mp3 $mpath/h_15_00.mp3 </dev/null >/dev/null 2>&1
		else
			mplayer -af volume="-$v" $mpath/start.mp3 $mpath/h_$h.mp3 $mpath/m_$m.mp3 </dev/null >/dev/null 2>&1
		fi
	else
		if [[ "$h" = 15 ]] && [[ "$m" = "00" ]]; then
			cvlc --play-and-exit --no-volume-save --gain=0.$v $mpath/mayak.mp3 $mpath/h_15_00.mp3 </dev/null >/dev/null 2>&1
		else
			cvlc --play-and-exit --no-volume-save --gain=0.$v $mpath/start.mp3 $mpath/h_$h.mp3 $mpath/m_$m.mp3 </dev/null >/dev/null 2>&1
		fi
	fi
else
	echo "Błąd wykonania skryptu $(basename $0) - nie zainstalowano aplikacji MPlayer ani vlc.";
fi
exit 0;

