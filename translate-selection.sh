#!/bin/bash

#ENGINE=yandex
ENGINE=google

NOTIFY_CMD='notify-send -t 1000 -u low'
NOTIFY_TEXT='Loading translation for: '
EMPTY_TEXT='Nothing is selected!'
TITLE_PREFIX='Translation: '

BUTTON_CLOSE='Close'
BUTTON_SPEAK='Speak'
BUTTON_WEB='Web'

WINDOW_WIDTH=600

CUT_LEN='24'

checkCommand() {
  if ! command -v $1 > /dev/null; then
    zenity --info --text "Package '$1' is not installed! sudo apt install xsel libnotify-bin zenity trans"
    exit 1
  fi
}

checkCommand trans
checkCommand xsel
checkCommand notify-send
checkCommand zenity
#checkCommand kdialog
#checkCommand yad

urlencode() {
  local LANG=C
  local encoded=""
  local o
  for ((i=0;i<${#1};i++)); do
    if [[ ${1:$i:1} =~ ^[a-zA-Z0-9\.\~\_\-]$ ]]; then
      printf -v o "${1:$i:1}"
    else
      printf -v o '%%%02X' "'${1:$i:1}"
    fi
  encoded+="${o}"
  done
  URLENCODED=$encoded
}

escape() {
  ESCAPED=$(echo "$1" | sed 's/"/\\"/g')
}

CLIPBOARD_TYPE='o'

# Parsing paramters

while (( "$#" )); do
  case "$1" in
    --speak)
      FLAG_SPEAK=1
      shift
      ;;
    -S|--source)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        CLIPBOARD_TYPE=$2
        shift 2
      else
        CLIPBOARD_TYPE='o'
      fi
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done

# Getting the text to translate

TEXT=$(xsel -$CLIPBOARD_TYPE)
if test -z "$TEXT"; then
  TEXT=$(xsel -b)
fi


if test -z "$TEXT"; then
  kdialog --msgbox "$EMPTY_TEXT"
  exit
fi

#TEXT=$TEXT
escape "$TEXT"
TEXT_ESCAPED=$ESCAPED

TEXT_TITLE=$(echo $TEXT | grep -P -o "^.{1,$CUT_LEN}")
escape "$TEXT_TITLE"
TEXT_TITLE_ESCAPED=$ESCAPED

$NOTIFY_CMD "$NOTIFY_TEXT$TEXT_TITLE"

EN=$(echo $TEXT | sed -e 's/[а-яА-Я]//g')
RU=$(echo $TEXT | sed -e 's/[a-zA-Z]//g')

if [ ${#TEXT} -gt 20 ]; then
  PARAMS='-b'
else
  PARAMS=''
fi

if [ ${#RU} -gt ${#EN} ]; then
#   echo "detected RU"
  TRANS_LANG=en
  SRC_LANG=ru
else
#   echo "detected EN"
  TRANS_LANG=ru
  SRC_LANG=en
fi

TRANS_TRANSLATE="trans -no-ansi -l ru -s $SRC_LANG -t $TRANS_LANG -e $ENGINE $PARAMS"
TRANS_SPEAK="trans -speak"
urlencode "$TEXT"
TRANS_URL="https://translate.google.com/?sl=$SRC_LANGu&tl=$TRANS_LANG&text=$URLENCODED&op=translate"

TRANSLATION=$(echo "$TEXT" | $TRANS_TRANSLATE)

if test -z "$TRANSLATION"; then
  ACTION=$(zenity --error --text "Returned empty result from translator engine!" --extra-button="$BUTTON_WEB")

  if [[ $ACTION = "$BUTTON_WEB" ]]; then
    xdg-open $TRANS_URL
  fi
  exit
fi

escape "$TRANSLATION"
TRANSLATION_ESCAPED=$ESCAPED

ACTION=$(zenity --info --text "$TRANSLATION_ESCAPED" --title "$TITLE_PREFIX$TEXT_TITLE" --width=$WINDOW_WIDTH --ok-label="$BUTTON_CLOSE" --extra-button="$BUTTON_SPEAK" --extra-button="$BUTTON_WEB")

if [[ $ACTION = "$BUTTON_SPEAK" ]]; then
  echo "$TEXT" | $TRANS_SPEAK
elif [[ $ACTION = "$BUTTON_WEB" ]]; then
  xdg-open $TRANS_URL
fi
