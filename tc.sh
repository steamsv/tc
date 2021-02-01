#!/bin/bash
#针对不同的ip进行限速

#清空原有规则
tc qdisc del dev eth0 root

#创建根序列
tc qdisc add dev eth0 root handle 1: htb default 1

#创建一个主分类绑定所有带宽资源（1000M）
tc class add dev eth0 parent 1:0 classid 1:1 htb rate 1000Mbit burst 15k

#创建子分类
tc class add dev eth0 parent 1:1 classid 1:10 htb rate 30Mbit ceil 30Mbit burst 15k

#创建过滤器
#对所有ip限速
tc filter add dev eth0 protocol ip parent 1:0 prio 2 u32 match ip dst 0.0.0.0/0 flowid 1:10
