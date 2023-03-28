#! /bin/bash 

while getopts f:n:p:l: flag 
do 
    case $flag in 
    f) 
    FILEPATH=$OPTARG 
    ;;

    n)
    NUM=$OPTARG
    ;; 

    p)
    PIPELINE=$OPTARG
    ;;

    l)
    LOGSTASH=$OPTARG
    ;;

    \?)
    echo "Wrong flag"
    exit 2 
    ;; 
    esac 
done 

 
if [ -z "$FILEPATH" ]; 
then 
echo "Enter file path"
exit 1
fi 

if [ -z "$NUM" ]; 
then 
echo "Enter number of lines"
exit 1
fi 


if [ ! -f "$LOGSTASH" ]; then
  echo "$LOGSTASH file does not exist."
  exit 3
fi

if [ ! -r "$LOGSTASH" ] | [ ! -w "$LOGSTASH" ]; then
  echo "$LOGSTASH is not readable/writeable ."
  exit 4
fi

if ! ls $FILEPATH 1> /dev/null 2>&1; then
    echo "Files does not exist"
    exit 7
fi


for FILE in $FILEPATH; do
VAL=`wc -l < $FILE`
NUMLINES=`expr $NUMLINES + $VAL + 1`
done


   
if [ "$NUMLINES" -eq "$NUM" ]
then 

    if [ ! -d "./backup" ]; then 
        mkdir backup 
    fi 
    NOW=`date "+%c"`
    cp $LOGSTASH "./backup/$NOW.txt"

    sed -i "0,/path => .*/s++path => ${FILEPATH}+" $LOGSTASH
    sed -i "0,/topic => .*/s++topic => \"${PIPELINE}\"+" $LOGSTASH        
else 
    echo "Number of lines don't match" 
    exit 6     
fi

echo "Executed Logstash"
# tmux new -d -s my_session "LOGSTASH PATH -f ${LOGSTASH}" #Provide the logstash file path ex.bin/logstash
