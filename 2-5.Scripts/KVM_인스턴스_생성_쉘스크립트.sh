#!/bin/bash
echo -e "\E[;34m <Start Install KVM instance> \E[0m"
sleep 1

echo " "
#vm name
echo -e "\E[;32m what is vm name? \E[0m"
read -p "answer ? :" vmname1
echo " "

#vm os
echo -e "\E[;32m what is vm's os? \E[0m"
echo "1.CentOS-7.8"
echo "2.ubuntu-18.04"
read -p "answer ? :" os1
echo " "

until [ $os1 = 1 ] || [ $os1 = 2 ]
do
echo -e "\E[;31m Wrong Answer! select 1or2 ! \E[0m"
read -p "answer ? : " os1
done

if [ $os1 = 1 ]; then
os1="centos"
vmos1="centos-7.8"
elif [ $os1 = 2 ]; then
os1="ubuntu-18.04"
vmos1="ubuntu-18.04"
fi

#vm flaver
echo -e "\E[;32m what is flaver? \E[0m"
echo "1.Cpu1, RAM 1G, 10G disk"
echo "2.Cpu2, RAM 2G, 20G disk"
read -p "answer ? :" flav1
echo " "

until [ $flav1 = 1 ] || [ $flav1 = 2 ]
do
echo -e "\E[;31m Wrong Answer! select 1or2 ! \E[0m"
read -p "answer ? : " flav1
done

if [ $flav1 = 1 ]; then
flav1="cpu1, ram1 10gdisk"
vcpu1=1
vram1=1024
vdisk1=10
else
flav1="cpu2, ram2 20gdisk"
vcpu1=2
vram1=2048
vdisk1=20
fi

#additional disk
echo -e "\E[;32m Do you want attach additional Disk? \E[0m"
echo "1.yes"
echo "2.no"
read -p "answer ? : " adddisk1
echo " "

until [ $adddisk1 = 1 ] || [ $adddisk1 = 2 ]
do
echo -e "\E[;31m Wrong Answer! select 1or2 ! \E[0m"
read -p "answer ? : " adddisk1
done

if [ $adddisk1 = 1 ]; then
read -p "Additional Disk size ? : " addsize1
fi
echo""

#hostname
echo -e "\E[;32m Do you want change hostname? \E[0m"
echo "1.Yes"
echo "2.NO"
read -p "answer ? :" hostconf1

until [ $hostconf1 = 1 ] || [ $hostconf1 = 2 ]
do
echo -e "\E[;31m Wrong Answer! select 1or2 ! \E[0m"
read -p "answer ? : " hostconf1
done

if [ $hostconf1 = 1 ]; then
read -p "hostname ? : " hostname1
host1="--hostname ${hostname1}"
else
host1=""
fi
echo""

#rootpassword
echo -e "\E[;32m what is root password? : \E[0m"
read -p "answer ? :" rootps1
echo " "


#network
echo -e "\E[;32m what is vm's network? \E[0m"
echo "1.bridge"
echo "2.NAT(default)"
echo "3.isolated(testnet)"
read -p "answer ? :" net1
echo " "

until [ $net1 = 1 ] || [ $net1 = 2 ]
do
echo -e "\E[;31m Only bridge setting is Available! \n please select again. \E[0m"
read -p "answer ? : " net1
done

if [ $net1 = 1 ]; then
net1="bridge"
bridge1='--network bridge=br02 --network bridge=br01'
else
echo " can't apply setting! apply default setting"
net1="default"
bridge1='--network network:default'
fi

#install method
echo -e "\E[;32m Can you access internet now? \E[0m"
echo "1.Yes(Use Virt-builder)"
echo "2.NO(Copy exist Image)"
read -p "answer ? :" method1
echo " "

until [ $method1 = 1 ] || [ $method1 = 2 ]
do
echo -e "\E[;31m Wrong Answer! select 1or2 ! \E[0m"
read -p "answer ? : " method1
done

if [ $method1 = 1 ]; then
inst1="Use Virt-Builder(Need internet access)"
else
inst1='Copy exist Image'
fi

#webpage from git
echo -e "\E[;32m Do you want install webpage from git? \E[0m"
echo "1.Yes"
echo "2.NO"
read -p "answer ? :" conf1
echo " "

until [ $conf1 = 1 ] || [ $conf1 = 2 ]
do
echo -e "\E[;31m Wrong Answer! select 1or2 ! \E[0m"
read -p "answer ? : " conf1
done

if [ $conf1 = 1 ]; then
webcon1="yes"
web1="--install httpd --install git-core --install wget --run /vm/testrun.sh"
else
webcon1="no"
web1=""
fi
#check choises
echo -e "\E[;32m check your choises! \E[0m"
echo "vm name : $vmname1"
echo "os : $os1"
echo "flaver : $flav1"
echo "password : $rootps1"
echo "net : $net1"
echo "method : $inst1"
echo "install web from git : $webcon1"

if [ $hostconf1 = 1 ]; then
echo "hostname: $hostname1"
fi

if [ $adddisk1 = 1 ]; then
echo "additional disk size : ${addsize1}G"
fi

#if [ $ipconf1 = 1 ]; then
#echo "changed IP : ${ipadd1} ${ipadd2}"
#fi

#confirm
echo -e "\E[;34m Countinue ? [y/yes/YES] \E[0m"
read conf1

case "$conf1" in
        y|yes|YES)
        echo "start install vm !"
        ;;

        *)
        echo "stop install!"
        exit
esac
#install 1-additional disk

if [ $adddisk1 = 1 ]; then
qemu-img create -f qcow2 -o size=${addsize1}G /vm/${vmname1}.add${addsize1}.qcow

add1="--disk path=/vm/${vmname1}.add${addsize1}.qcow"
else
add1=""
fi

#install 2-install instance

if [ $method1 = 1 ]; then

#use virtbuilder
virt-builder ${vmos1} --format qcow2 --size ${vdisk1}G -o /vm/${vmos1}-${vmname1}.qcow2 --root-password password:${rootps1} ${web1} ${host1}

virt-builder centos-7.8 --format qcow2 --size 6G -o /root/aa.qcow2 --root-password password:test123 --install docker

#if [ $copy1 = 1 ]; then
#virt-copy-in -a /vm/${vmos1}-${vmname1}.qcow2 /root/iplist /root
#rm /root/iplist
#fi

virt-install --name ${vmname1} --vcpus ${vcpu1} --ram ${vram1} --graphics vnc ${bridge1} --disk path=/vm/${vmos1}-${vmname1}.qcow2 ${add1} --import
else

#copy exist image
cp "/vm/scriptimg/${vmos1}-${vcpu1}.qcow2" "/vm/${vmos1}-${vmname1}.qcow2"

virt-customize -a /vm/${vmos1}-${vmname1}.qcow2 --root-password password:$rootps1 ${web1} ${host1}

virt-install --name ${vmname1} --vcpus ${vcpu1} --ram ${vram1} --graphics vnc ${bridge1} --disk path=/vm/${vmos1}-${vmname1}.qcow2 ${add1} --import
fi

#Finish install
echo -e "\E[;34m VM install complete!  \E[0m"


#Virt-builder 옵션을 사용하여 Web서버용 인스턴스 생성
#프로젝트에서 사용한 KVM 인스턴스 생성용 쉘 스크립트
#여기선 RUN과 INSTALL옵션을 썼는데, 이후에 이 옵션을 사용하면
#가끔 이미지가 깨지는 현상이 생겨버려서,
#아예 UPLOAD를 통해 쉘스크립트를 업로드시키고 FIRSTBOOT등을 통해
#실행하는 방식으로 바꾸었음
#[출처] KVM 인스턴스 생성 쉘스크립트|작성자 ciw0707
