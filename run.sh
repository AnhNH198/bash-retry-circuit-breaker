#!/bin/bash
counter=0
sleep_time=1
max_retry=9

function closed_state () {
    if ./test.sh $counter; then
        counter=0
        echo "Success"
        exit
    else
        counter=$(($counter + 1))
    fi
}

function open_state () {
    if [[ $counter > 10 && $counter < 16 ]]; then
        sleep_time=${RANDOM:0:2}
    elif [[ $counter > 15 ]]; then
        sleep_time=${RANDOM:0:3}
    else
        :
    fi
    echo "Join failed, retrying in ${sleep_time} seconds."
    sleep $sleep_time
    half_open
}

function half_open () {
    counter=$(($counter + "1"))
    if ./test.sh $counter; then
        closed_state
    else
        open_state
    fi
}

while [ $counter -lt $max_retry ]
do
    closed_state
    echo "Join failed, retrying in ${sleep_time} seconds."
    sleep $sleep_time
done
if [ $counter -ge $max_retry ]; then
    counter=$(($counter + 1))
    open_state
else
    :
fi