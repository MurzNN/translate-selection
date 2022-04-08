# translate-selection
Simple Linux bash script for quickly translate selected text in popup window.

_I've discovered a more modern and powerful alternative to my bash-based script - [Crow Translate](https://github.com/crow-translate/crow-translate) application, that do the job much better! So consider switching to it from my bash-scripted attempt._

_Other alternative can be KDE Plasma Widget [Translator](https://store.kde.org/p/1395666/).

## Description in Russian

Простенький скрипт, который переводит выделенный мышкой текст на другой язык. Пока приоритет сделан на перевод с русского язык на английский и обратно, в дальнейшем возможно добавлю и другие языки. Пулл рекьюесты приветствуются ;)

Скрипт пытается автоматически определить на каком языке выделенный текст с помощью поиска количества русских и английских букв, каких больше значит тот язык и используется как базовый для перевода. Также, если выделен короткий текст менее 20 букв - выводится более подробная информация о переводе, если более - только переведённый текст.

Для перевода по-умолчанию используется Google Translate, можно использовать и другие движки, для этого в строке ENGINE нужно заменить `google` на `yandex` или `bing`.

Для удобства запуск скрипта я рекомендую повесить на хоткей `Meta+t`, далее нужно будет просто выделить мышкой нужный текст, нажать хоткей и через некоторое время появится окно с результатом перевода.

### Скрипт использует следующие библиотеки:

- trans - основной скрипт, который фактически и выполняет сам перевод
- xsel - для получения выделенного текста
- libnotify-bin - для вывода всплывающего уведомления о том, что запрошен перевод с сервера
- kdialog - для отображения окна с переводом

На Debian / Ubuntu все необходимые пакеты можно установить командой:
```
sudo apt install xsel libnotify-bin kdialog trans
```
