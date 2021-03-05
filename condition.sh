#!/bin/bash
if test.sh >> $log_file 2>&1; then
    echo “success”
else
    bash circuit_breaker.sh
fi