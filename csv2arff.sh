#!/bin/bash
set -x
#Program:
# Convert .csv to .arff for weka
#2018/06/13 Ghost release
#E-mail: 296776435@qq.com

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/bin
#echo $PATH

file=$1
filepath=${file%.csv}
filename=${filepath##*\/}
echo "@relation $filename" >$2
attributesRow=$(sed -n '1p' $1)
firstDataRow=$(sed -n '2p' $1)



i=0
while((${#attributesRow}>0))
do	
	tmp=${attributesRow%%,*}
	attributes[$i]="'"${tmp// /_}"'"
	##${string//substring/replacement}
	##echo "@attribute $attributes[$i] $datatype" >$2
	remain=${attributesRow#*,}
	if [ "$attributesRow" != "$remain" ]
	then
		attributesRow=$remain
	else
		break
	fi
	i=`expr $i + 1`
done
##got all attr name--attributes
i=0
while((${#firstDataRow}>0))
do	
	data[$i]=${firstDataRow%%,*}
	if [ ${data[$i]:0} -gt 0 ]
	then
		datatype[$i]="NUMBERIC"
	else
		datatype[$i]="STRING"
	fi
	remain=${firstDataRow#*,}
	if [ "$firstDataRow" != "$remain" ]
	then
		firstDataRow=$remain
	else
		break
	fi
	i=`expr $i + 1`
done
##got all attr type--datatype
i=0
while (( ${#attributes[@]} > $i ))
do
	echo "@attribute ${attributes[$i]} ${datatype[$i]}" >>$2
	i=`expr $i + 1`
done
echo "@data">>$2
sed -n '2,$p' $1>>$2
