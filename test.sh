function test {
    if [ $1 -lt 20 ]; then
        exit 1
    else
        exit 0
    fi
}
test $1