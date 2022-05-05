#!/bin/sh

# Create by Joonsoo on Sunday, April 24th, 2022
# @project Scouter
# @author Joonsoo
#
# param $1 (Process Name) $2 (Interval : sec) $3 (Until : min)

# shellcheck disable=SC2034,SC1087,SC2086,SC2028,SC2039,SC1073,SC1009,SC1061
# Static Values
OUTPUT_PATH="./output.txt"
CSV_PATH="./output.csv"

# Null Check Param
if [ -z $3 ] ; then
  echo "ERROR : Not enough parameters"
  echo "Have to parameters (Process Name, Interval(sec) and Until(min)"
  exit 1
else
  PROCESS_NAME=$1
  INTERVAL=$2
  UNTIL=$3
fi

echo "===== Scouter Start !! ====="
echo "PROCESS NAME is " $PROCESS_NAME " each " $INTERVAL "second, during " $UNTIL "minute"

while [[ "$COUNTER" -lt "$((UNTIL*60))" ]]
do
  PROCESS_ID=$(pgrep $PROCESS_NAME)

  if [ -z $PROCESS_ID ]
  then
    echo "ERROR : No find PROCESS NAME"
    exit 1
  fi

  if [ -z $COUNTER ]
  then
    echo "This is first time.. sleep $INTERVAL(s)"
    sleep $INTERVAL
  fi

  CPU=$(ps $PROCESS_ID -o %cpu | tail -1)
  MEM=$(top -l 1 -pid $PROCESS_ID | grep "$PROCESS_NAME" | awk '{print $8}')
  MEM=${MEM%M}

  echo "$(date)" "\t" "$PROCESS_NAME[$PROCESS_ID]" "\t" "$CPU""%" "\t" "$MEM""MB"
#  echo "$(date)" "\t" "$PROCESS_NAME[$PROCESS_ID]" "\t" "$CPU" "\t" "$MEM" >> $OUTPUT_PATH
  echo "$(date)" "\t" "$PROCESS_NAME[$PROCESS_ID]" "\t" "$CPU" "\t" "$MEM" >> $CSV_PATH


  sleep $INTERVAL
  COUNTER=$((COUNTER + INTERVAL))
  echo $COUNTER "/" $((UNTIL*60)) "sec"
done