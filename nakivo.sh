#!/bin/bash
shell=$(readlink /proc/$$/exe)
if ! [[ ${shell} =~ "bash" ]]; then
        echo "No bash shell used"
        exit;
fi

if [ -z "$5" ]; then
        PORT=4443
else
        PORT=$5
fi

if [[ $4 == "job" ]]; then
    /usr/lib/zabbix/externalscripts/cli.sh --job-list --host $1 --port $PORT --username $2 --password $3 | tr , . | sed -r 's/ *\| */,/g' | sed 's/^ *//;s/ *$//'
elif [[ $4 == "repository" ]]; then
    output=$(/usr/lib/zabbix/externalscripts/cli.sh --repository-list --host $1 --port $PORT --username $2 --password $3 | tr , . | sed -r 's/  +//g' | sed -r 's/ *: */:/g' | sed -e 's/^[ \t]*//')

	FIELDS=""
	REPOS=()
	values=""
	while IFS= read -r line; do
		if ! [[ $line == \#* ]]; then
			IFS=':'
			read -a strarr <<< "$line"
			key=$(echo ${strarr[0]} | sed -r 's/ *//g')
			if [[ ! " $FIELDS " == *"$key"* ]]; then
				FIELDS+="$key,"
			fi
			values+="${strarr[1]},"
		else	
			REPOS+=(${values:0:-1})	
			values=""
		fi
	done <<< "$output"

	REPOS+=(${values:0:-1})	

	echo ${FIELDS:0:-1}
	for var in "${REPOS[@]}"; do
		echo "${var}"
	done
fi