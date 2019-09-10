#!/bin/bash

#Declare the end user's name here!!!
ENDUSER="user"

#Declare variables with paths to files...
TXTWEATHER="/home/$ENDUSER/public_html/weather.txt"
TMPWEATHER="/tmp/weather.txt.tmp"
SNDWEATHER="/home/$ENDUSER/public_html/weather.wav"
PHOWEATHER="/home/$ENDUSER/public_html/weather.pho"

WEATHERURL="http://forecast.weather.gov/MapClick.php?lat=42.66630&lon=-84.55366779999997&unit=0&lg=english&FcstType=text&TextType=1"

#Get the raw NWS text forecast...
#new plain weather = https://forecast-v3.weather.gov/point/42.6663,-84.5537?view=plain&mode=min
/usr/bin/w3m -dump $WEATHERURL > $TMPWEATHER
#echo $WEATHERURL > $TMPWEATHER

#Fondle text into readable format...
/bin/echo "Here's your forecast from the National Weather Service, compiled by Earl." > $TXTWEATHER
#new weather has a header of 15 and tail of 20
/usr/bin/head -n -18 $TMPWEATHER | /usr/bin/tail -n +5 >> $TXTWEATHER
/bin/echo "For more information, visit weather dot gov slash G, R, R." >> $TXTWEATHER

#Make slight text replacement for broadcastability...
/bin/sed -i "s/mph/miles per hour/" $TXTWEATHER
/bin/sed -i "s/Chance of precipitation is/Chance of precipitation/" $TXTWEATHER
/bin/sed -i "s/with a/,/" $TXTWEATHER

#Debug by enabling these lines
#/bin/cat $TXTWEATHER
#/bin/cp $TXTWEATHER $TMPWEATHER

#Read text into an audio file...
espeak -f $TXTWEATHER -w $SNDWEATHER
#espeak -v mb/mb-us2 -f $TXTWEATHER -w $SNDWEATHER > $PHOWEATHER
#mbrola /usr/share/mbrola/us2 $PHOWEATHER $SNDWEATHER

#convert to .mp3
#lame -h -b 128 ${SNDWEATHER}.wav "${SNDWEATHER}.mp3"
#rm -f ${SNDWEATHER}.wav

#Give end user ownership of the files...
/bin/chown $ENDUSER: $TXTWEATHER
/bin/chown $ENDUSER: $SNDWEATHER

#/usr/bin/clear 
