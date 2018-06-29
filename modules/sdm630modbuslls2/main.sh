#!/bin/bash
. /var/www/html/openWB/openwb.conf

if [[ $evsesources2 = *virtual* ]]
then
	if ps ax |grep -v grep |grep "socat pty,link=$evsesources2,raw tcp:$evselanips2:26" > /dev/null
	then
		echo "test" > /dev/null
	else
		sudo socat pty,link=$evsesources2,raw tcp:$evselanips2:26 &
	fi
else
	echo "echo" > /dev/null
fi
n=0
output=$(sudo python /var/www/html/openWB/modules/sdm630modbuslls2/readsdm.py $evsesources2 $sdmids2)
while read -r line; do
	if (( $n == 0 )); then
		llas21=$(echo "$line" |  cut -c2- )
		llas21=${llas21%??}
		printf "%.3f\n" $llas21 > /var/www/html/openWB/ramdisk/llas21
#		echo "$line" |  cut -c2- |sed 's/\..*$//' > /var/www/html/openWB/ramdisk/llas21

	fi
	if (( $n == 1 )); then
		llas22=$(echo "$line" |  cut -c2- )
		llas22=${llas22%??}
		printf "%.3f\n" $llas22 > /var/www/html/openWB/ramdisk/llas22
#		echo "$line" |  cut -c2- |sed 's/\..*$//' > /var/www/html/openWB/ramdisk/llas22

	fi
	if (( $n == 2 )); then
		llas23=$(echo "$line" |  cut -c2- )
		llas23=${llas23%??}
		printf "%.3f\n" $llas23 > /var/www/html/openWB/ramdisk/llas23
#		echo "$line" |  cut -c2- |sed 's/\..*$//' > /var/www/html/openWB/ramdisk/llas23
	fi
	if (( $n == 3 )); then
		wl1=$(echo "$line" |  cut -c2- |sed 's/\..*$//')
	fi
	if (( $n == 4 )); then
		llkwhs2=$(echo "$line" |  cut -c2- )
		llkwhs2=${llkwhs2%??}
		printf "%.3f\n" $llkwhs2 > /var/www/html/openWB/ramdisk/llkwhs2
	fi
	if (( $n == 5 )); then
		wl2=$(echo "$line" |  cut -c2- |sed 's/\..*$//')
	fi
	if (( $n == 6 )); then
		wl3=$(echo "$line" |  cut -c2- |sed 's/\..*$//')
	fi

	n=$((n + 1))
    done <<< "$output"
llaktuells2=`echo "($wl1+$wl2+$wl3)" |bc`
echo $llaktuells2 > /var/www/html/openWB/ramdisk/llaktuells2

											