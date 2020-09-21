#!/bin/bash

times=$1
if [[ -z $times ]]; then
	times=1
fi
#domains=(Linps.cn)
#domains=(mouthhi.com udahuo.com yuanweibox.com o192.com)
domains=$(cat ./data/domain.dat)

i=0
while [[ i -lt $times ]]; do 
	for d in ${domains[@]}; do
		echo -ne $d'-'$i'\t';
		curl --max-time 3 -LIs -H 'Host: '$d http://120.24.190.31 | grep HTTP
	done

	echo -e '\n##################'
	let i=i+1
done
