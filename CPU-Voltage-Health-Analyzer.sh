#!/bin/sh
cpu_voltage_table=()
cpu_frequen_table=()
mxhx0=()
mxhx2=()
mxhx7=()
FINAL=7
string=("2x2.27GHz@A530小核   " "" "3x3.15GHz@A720大核" "" "" "2x2.96GHz@A720大核" "" "1x3.3GHz@X4超大核    ")
for i in $(seq 0 ${FINAL});
do
	path="/sys/devices/system/cpu/cpu${i}/cpufreq_health/cpu_voltage"
	vb=`cat $path 2>/dev/null`
	[[ $? -eq 0 ]] && {
		OLD_IFS="$IFS"
		IFS=","
		cpu_voltage_table=($vb)
		IFS="$OLD_IFS"
		echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
		echo -e "\e[36m@   ${string[$i]}  @\e[0m"
		path1="/sys/devices/system/cpu/cpu${i}/cpufreq/scaling_available_frequencies"
		path2="/sys/devices/system/cpu/cpu${i}/cpufreq/scaling_boost_frequencies"
		fb=`cat $path1`
		fb_boost=`cat $path2`
		OLD_IFS="$IFS"
		IFS=" "
		cpu_frequen_table=($fb $fb_boost)
		
		
		IFS="$OLD_IFS"
		m=${#cpu_frequen_table[*]}
        for k in $(seq 0 ${#cpu_frequen_table[@]}); do
            cpu_frequen_table[k]=$((cpu_frequen_table[k]/1000))  # 将频率除以1000，直接赋值给原变量
        done
		j=0
		for s in ${cpu_voltage_table[@]}
		do
			((tmp=m-j-1))
			printf '@ %9s' "${cpu_frequen_table[$tmp]}"
			echo "mhz     ${s}mv   @"
			[[ j -eq 0 ]]&&{
				case $i in
					0)	mxhx0=(${cpu_voltage_table[@]})
					;;
					2)	mxhx2=(${cpu_voltage_table[@]})
					;;
					5)	mxhx5=(${cpu_voltage_table[@]})
					;;
					7)	mxhx7=(${cpu_voltage_table[@]})
					;;
				esac
			}
			((j++))
		done
		#echo $fb
	}
done
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

# echo 为避免被举报，已关闭得分查看，请自行计算。
# exit
		echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
		
j=0
score0=0
for tmp in ${mxhx0[@]}
do
	case $j in
		0)	((score0=score0+(1100-$tmp)*60))
		;;
		5)	((score0=score0+(1100-$tmp)*30))
		;;
		*)	((score0=score0+(1100-$tmp)*10))
		;;
	esac
	((j++))
done
((score0=score0/${#mxhx0[*]}))
j=0
score2=0
for tmp in ${mxhx2[@]}
do
	case $j in
		0)	((score2=score2+(1100-$tmp)*95))
		;;
		*)	((score2=score2+(1100-$tmp)*5))
		;;
	esac
	((j++))
done
((score2=score2/${#mxhx2[*]}))

j=0
score5=0
for tmp in ${mxhx2[@]}
do
	case $j in
		0)	((score5=score5+(1100-$tmp)*95))
		;;
		*)	((score5=score5+(1100-$tmp)*5))
		;;
	esac
	((j++))
done
((score5=score5/${#mxhx5[*]}))

j=0
score7=0
for tmp in ${mxhx7[@]}
do
	case $j in
		0)	((score7=score7+(1100-$tmp)*95))
		;;
		*)	((score7=score7+(1100-$tmp)*5))
		;;
	esac
	((j++))
done
((score7=score7/${#mxhx7[*]}))

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo ""
echo -e "\e[36m"
echo "CPU体质非标准量化得分："
echo "2*2.27GHz A530 小核：  $score0 "
echo "2*2.96GHz A720 大核：  $score2 "
echo "3*3.15GHz A720 大核：  $score5 "
echo "1*3.3GHz  X4 超大核：  $score7 "
#echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo ""
echo "CPU日用体质非标准量化得分："
echo "待适配"
echo ""
#echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "CPU待机体质非标准量化得分："
echo "待适配"
sm=0
while
do
	echo""
	((sm++))
	[[ $sm -eq 19 ]]&& exit
done
#echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
