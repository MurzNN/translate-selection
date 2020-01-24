#!/bin/bash

#ENGINE=yandex
ENGINE=google

checkCommand()
{
  if ! command -v $1 > /dev/null; then
    kdialog --msgbox "Не установлен $1!  sudo apt install xsel libnotify-bin kdialog trans"
    exit 1
  fi
}

checkCommand trans
checkCommand xsel
checkCommand notify-send
checkCommand kdialog

TEXT=$(xsel -o)

if test -z "$TEXT"; then
#  echo "Ничего не выделено!"
  kdialog --msgbox "Ничего не выделено! Выделите текст."
  exit
fi

TEXT_TITLE=$(echo $TEXT | cut -c -80)

notify-send "Загружается перевод текста $TEXT_CUT" -t 1000 -u low

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


# notify-send -u critical "$(echo $TEXT | trans -no-ansi -l ru -s ru -t en -b)"
#TRANSLATION=$(echo $TEXT | trans -no-ansi -l ru -s $SRC_LANG -t $TRANS_LANG $PARAMS)

#echo "trans -no-ansi -l ru -s $SRC_LANG -t $TRANS_LANG -e $ENGINE $PARAMS \'$TEXT\'"
#exit
#TRANSLATION=$(trans -no-ansi -l ru -s $SRC_LANG -t $TRANS_LANG -e $ENGINE $PARAMS \'$TEXT\')
TRANSLATION=$(echo $TEXT | trans -no-ansi -l ru -s $SRC_LANG -t $TRANS_LANG -e $ENGINE $PARAMS)
#echo $TRANSLATION
#exit

kdialog --msgbox "$TRANSLATION" --title "Перевод $TEXT_TITLE"

#kdialog --msgbox "$TRANSLATION" --title "Перевод $TEXT_CUT"
#<a href='https://translate.google.com/#view=home&op=translate&sl=ru&tl=en&text=%D0%BD%D0%BE%D0%BC%D0%B5%D0%BD%D0%BA%D0%BB%D0%B0%D1%82%D1%83%D1%80%D0%B0'>На сайте</a>
# kdialog --msgbox "$(trans -no-ansi -l ru -s $SRC_LANG -t $TRANS_LANG $PARAMS \"$TEXT\")"
# echo "echo '$TEXT' | ~/bin/trans -no-ansi -l ru -s $SRC_LANG -t $TRANS_LANG $PARAMS"

# echo $TRANSLATION

# notify-send -u critical "$(echo $TRANSLATION)"
# notify-send -u critical "$(echo $TRANSLATION)"
# kdialog --passivepopup "$(echo $TRANSLATION)" 10


# kdialog --msgbox "$(echo $TRANSLATION)" 10
# exit
# notify-send -u critical "$($TEXT | trans -no-ansi -l ru)"
