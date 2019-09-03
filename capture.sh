#!/bin/bash
# Program:
#         Capture weather chart daily
#
# From: CWB
# Weather Chart Type: 色調強化 紅外線 真實色

i=0
j=0
LOCAL="/home/mk/DD2/weatherChartDaily/"
PICTURETYPE=".jpg"
USERAGENT="Mozilla/5.0"
TIMESTAMP=$(date +"%s")
YESTERDAY=$(date +"%Y-%m-%d" -d @$(($TIMESTAMP-86400)))
YEAR=$(date +"%Y" -d @$(($TIMESTAMP-86400)))
MONTH=$(date +"%m" -d @$(($TIMESTAMP-86400)))
#真實色
VISTRGB="https://www.cwb.gov.tw/Data/satellite/LCC_VIS_TRGB_2750/LCC_VIS_TRGB_2750"
#紅外線
IR1CR="https://www.cwb.gov.tw/Data/satellite/LCC_IR1_CR_2750/LCC_IR1_CR_2750"
#色調強化
IR1MB="https://www.cwb.gov.tw/Data/satellite/LCC_IR1_MB_2750/LCC_IR1_MB_2750"
#回波-台灣鄰近區域
CV1TW="https://www.cwb.gov.tw/Data/radar/CV1_TW_3600_"
#回波-較大範圍區域
CV1="https://www.cwb.gov.tw/Data/radar/CV1_3600_"
 array=($VISTRGB $IR1CR $IR1MB $CV1)
for chartType in "${array[@]}"; do
    case ${chartType} in 
    ${VISTRGB})  FOLDER=$(echo "真實色")
                        ADDRESS=$(echo $chartType-$YESTERDAY);;
    ${IR1CR}) FOLDER=$(echo "紅外線")
                        ADDRESS=$(echo $chartType-$YESTERDAY);;
    ${IR1MB}) FOLDER=$(echo "色調強化")
                        ADDRESS=$(echo $chartType-$YESTERDAY);;
    ${CV1}) FOLDER=$(echo "雷達回波-較大範圍區域")
                        PICTURETYPE=$(echo ".png")
                        YESTERDAYNODASH=$(date +"%Y%m%d" -d @$(($TIMESTAMP-86400)))
                        ADDRESS=$(echo $chartType$YESTERDAYNODASH);;        
    esac

    # for i in {00..23}; do
    # HOUR=$i
    #     for j in {00..50..10}; do
    #     MINUTE=$j
    #     if [ "${chartType}" != "${CV1}" ]; then
    #         DATAADDRESS=$ADDRESS-$HOUR-$MINUTE$PICTURETYPE
    #         echo $DATAADDRESS
    #     else
    #         DATAADDRESS=$ADDRESS$HOUR$MINUTE$PICTURETYPE   
    #     fi    
    #     wget   $DATAADDRESS -U $USERAGENT -P $LOCAL$YESTERDAY/$FOLDER --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 0 --continue
    #     done
    # done
done
rclone copy  --ignore-existing --verbose --transfers 2 --checkers 10 --contimeout 60s --timeout 300s --retries 3  --stats 1s $LOCAL$YESTERDAY console-share:每日氣象圖/$YEAR/$MONTH/$YESTERDAY
echo -e "Subject: Weather Chart Backup Finish\nTo:mk.pdtltd@gmail.com\n" | ssmtp mk.pdtltd@gmail.com
find . -type d -ctime +1 -name "${YEAR}-*-*"  -exec rm -rf {} \;