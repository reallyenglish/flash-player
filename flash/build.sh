#!/bin/sh

if [ "$flex" = "" ]; then
  flex='/usr/local/flex_sdk'
fi

if [ "$warning" != "" ]; then
  warning=''
else
  warning='-warnings=false'
fi

if [ "$debug" != "" ]; then
  debug='-debug=true'
else
  debug='-debug=false'
fi

mxmlc=$flex/bin/mxmlc
$mxmlc $debug $warning -static-link-runtime-shared-libraries=true -optimize=true -o ../player.swf -file-specs FlashPlayer.as
