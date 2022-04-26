# Talking-clock

Niestety strona autora mówiącego zegara już nie jest dostępna w Internecie.

Mówiący zegar 1.5.1 Linux
Opis:	Mówiący zegar.
(Zaktualizowano 10 grudnia 2015 r. - zabronił cronowi wysyłania wiadomości do użytkownika pocztą i ustawił tworzenie vclock.conf z domyślną wartością głośności).

Dwa skrypty bash + mp3 w pakiecie deb.
Skrypt uruchamia mplayera z plikami mp3 odpowiadającymi czasowi.
Wszystko to dzieje się na cronie. Interfejs oparty na zenity służy do łatwego ustawiania czasu rozpoczęcia.
Głośność można ustawić w pliku $HOME/.config/vclock/vclock.conf
Powinien być tylko jeden wiersz z poziomem głośności.
Domyślnie w pliku vckock.conf zapisywana jest liczba 15.
Wyższa liczba - cichszy dźwięk. (man mlayer)

Możesz połączyć swój głos.
Pliki dźwiękowe powinny znajdować się w $HOME/.config/vclock/voice
Nazwy i zawartość plików dźwiękowych muszą być zgodne z plikami w
/usr/share/vclock/voice

Polskojęzyczne pliki dźwiękowe utworzono za pomocą strony:
https://soundoftext.com/

Uwaga!
W Arch Linux, gdy korzystasz z cronie a Mówiący zegar nie działa, uruchom w konsoli:

sudo systemctl enable cronie.service

sudo systemctl start cronie.service

Autor	Sakryukin K.V.
data	19 grudnia 2014 18:35:23

Говорящие часы 1.5.1 Linux
Описание:	Говорящие часы.
(Обновил 10 декабря 2015г. - запретил cron-у отправлять сообщения пользователю на почту и задал формирование vckock.conf со значением громкости по умолчанию).

Два bash скрипта + mp3 упакованные в deb-пакет.
Скрипт запускает mplayer с mp3 файлами соответствующими времени.
Всё это происходит по cron-у. Для простой настройки времени запуска используется интерфейс на основе zenity.
Громкость можно выставить в файле $HOME/.config/vclock/vclock.conf
Должна быть только одна строка с уровнем громкости.
По умолчанию в файле vckock.conf прописано число 15.
Выше число - тише звук. (man mlayer)

Можно подключить свой голос.
Звуковые файлы должны лежать в $HOME/.config/vclock/voice
Имена и содержимое звуковых файлов должны соответствовать файлам из
/usr/share/vclock/voice

Польские аудиофайлы были созданы с помощью веб-сайта:
https://soundoftext.com/

Автор	Сакрюкин К.В.
Дата	19 Декабрь 2014 18:35:23

Предупреждение!
В Arch Linux при использовании cronie и неработающих Говорящих часах выполните в консоли:

sudo systemctl enable cronie.service

sudo systemctl start cronie.service

