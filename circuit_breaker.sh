#!/bin/bash
counter=0
sleep_time=1
max_retry=9

function do_something () {
    if [ $counter -lt 30 ]; then
        echo 1
    else
        echo 0
    fi
}

function closed_state () {
    local res=$(do_something)
    if [[ $res -eq 0 ]]; then
        counter=0
        exit
    else
        counter=$(($counter + 1))
    fi
}

function open_state () {
    echo "> Circuit breaker > Retry number: ${counter}, sleeping for ${sleep_time} seconds."
    total_delay=$(($total_delay + $sleep_time))
    echo "Total delay: ${total_delay}"
    
    if [[ $counter > 10 && $counter < 16 ]]; then
        echo "1"
        sleep_time=${RANDOM:0:1}
    elif [[ $counter > 15 ]]; then
        echo "2"
        sleep_time=${RANDOM:0:2}
    else
        echo "3"
    fi
    sleep $sleep_time
    half_open
}

function half_open () {
    do_something
    local res=$(do_something)
    counter=$(($counter + "1"))
    if [[ $res -eq 0 ]]; then
        closed_state
    else
        open_state
    fi
}

function circuit_breaker () {
    while [ $counter -lt $max_retry ]
    do
        closed_state
        echo "> Circuit breaker > Retry number: ${counter}, sleeping for ${sleep_time} seconds."
        total_delay=$(($total_delay + $sleep_time))
        echo "Total delay: ${total_delay}"
        sleep $sleep_time
    done
    while [ $counter -ge $max_retry ]
    do
        counter=$(($counter + 1))
        open_state
    done
}

circuit_breaker