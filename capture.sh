#!/bin/bash
# Program:
#         Capture weather chart daily
#
# From: CWB
# Weather Chart Type: 色調強化 紅外線 真實色

i=0
j=0
PICTURETYPE=".jpg"
USERAGENT="Mozilla/5.0"
TIMESTAMP=$(date +"%s")
YESTERDAY=$(date +"%Y-%m-%d" -d @$(($TIMESTAMP-86400)))

#真實色
VISTRGB="https://www.cwb.gov.tw/Data/satellite/LCC_VIS_TRGB_2750/LCC_VIS_TRGB_2750"
#紅外線
IR1CR="https://www.cwb.gov.tw/Data/satellite/LCC_IR1_CR_2750/LCC_IR1_CR_2750"
#色調強化
IR1MB="https://www.cwb.gov.tw/Data/satellite/LCC_IR1_MB_2750/LCC_IR1_MB_2750"
#ADDRESS=$VISTRGB-$YESTERDAY
array=($VISTRGB $IR1CR $IR1MB)
# mkdir $YESTERDAY/真實色
# mkdir $YESTERDAY/紅外線
#mkdir $YESTERDAY/色調強化
for pictureType in "${array[@]}"; do
    case ${pictureType} in 
    ${VISTRGB})  FOLDER=$(echo "真實色");;
    ${IR1CR}) FOLDER=$(echo "紅外線");;
    ${IR1MB}) FOLDER=$(echo "色調強化");;
    esac
    ADDRESS=$pictureType-$YESTERDAY
    for i in {00..23}; do
    HOUR=$i
        for j in {00..50..10}; do
        MINUTE=$j
        DATAADDRESS=$ADDRESS-$HOUR-$MINUTE$PICTURETYPE
        wget   $DATAADDRESS -U $USERAGENT -P ./$YESTERDAY/$FOLDER
        sleep 5
        done
    done
done
