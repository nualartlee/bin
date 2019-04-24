#!/usr/bin/env bash

##
# Test web servers
# Assert they respond with HTTP
##

# Default file containing sites to test
sites="test-sites.txt"

# Return code
return=0

# Test function
curl-test() {
    echo
    #response=$(curl -I $1 2>&1 | egrep -q "HTTP.+(200)|(301)|(302).+")
    #response=$(curl -w "%{http_code}" $1 | egrep -q "(200)|(301)|(302)")
    #response=$(curl -I $1 2>&1 | grep -E '200|301|302')
    response=$(curl -I $1 2>&1 | grep -e 'HTTP')
    result=$?
    echo "Getting $1: $response"
    if [ "$result" -ne "0" ]; then
        echo "FAIL"
        return=1
    else
        echo "OK"
    fi
}

# Check if a file of sites to test is provided in arguments
if [ -e "$1" ];then
    sites=$1
fi

# Return if nothing to test
if [ ! -e "$sites" ];then
    echo "Nothing to test"
    exit 1
fi

# Test sites
while read -r line;
do
    # Skip if commented with #
    if [[ ${line:0:1} == '#' ]]; then
        echo
        echo "Not testing $line"
        echo "WARNING"
        continue
    else
       curl-test "$line"
    fi
done < "$sites"

# Return
echo
echo
if [ "$return" -ne "0" ]; then
    echo "Tests Failed"
    echo
    exit 1
else
    echo "Tests OK"
    echo
    exit 0
fi

