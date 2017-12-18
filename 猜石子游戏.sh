#!/bin/bash
read -p "游戏开始！请玩家指定石子的个数:" n1
read -p "请玩家指定每次取石子的最多个数:" n2

k=$(($n1%($n2+1)))
j=$(($n1/($n2+1)))


HH () {
for i in `seq 1 $j`
do
	read -p "请玩家取石子:" w
	echo "我取 $((($n2+1)-$w)) 个石子"
	q=$(($q-($n2+1)))
	echo "目前还剩下 $q 个石子"
	[ $q -eq 0 ] && echo "你受到了来自大牙的嘲讽!哈哈哈哈哈哈!"
done
}

if [[ $k -gt 0 ]]
then
	echo "我先取 $k 个石子"	
	q=$(($n1-$k))
	echo "目前还剩下 $q 个石子"
	HH
else
	q=$n1
	HH
fi

