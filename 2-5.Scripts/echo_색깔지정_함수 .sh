#!/bin/bash
# ubuntu 쉘스크립트로 사용하는경우
# echo "\e[40;37m xxxxx \e[0m" 으로 사용할것 

function bg_black (){
echo -e "\E[40;37m$1\E[0m"
}

function bg_red (){
echo -e "\E[41;37m$1\E[0m"
}

function bg_green (){
echo -e "\E[42;37m$1\E[0m"
}

function bg_yellow (){
echo -e "\E[43;37m$1\E[0m"
}

function bg_blue (){
echo -e "\E[44;37m$1\E[0m"
}

function bg_purple (){
echo -e "\E[45;37m$1\E[0m"
}

function bg_mint (){
echo -e "\E[46;37m$1\E[0m"
}

function bg_grey (){
echo -e "\E[47;30m$1\E[0m"
}

function black (){
echo -e "\E[;30m$1\E[0m"
}

function red (){
echo -e "\E[;31m$1\E[0m"
}

function green (){
echo -e "\E[;32m$1\E[0m"
}

function yellow (){
echo -e "\E[;33m$1\E[0m"
}

function blue (){
echo -e "\E[;34m$1\E[0m"
}


function purple (){
echo -e "\E[;35m$1\E[0m"
}

function mint (){
echo -e "\E[;36m$1\E[0m"
}

function grey (){
echo -e "\E[40;37m$1\E[0m"
}

echo '==echo -e colors function==='

bg_black black
echo ""
bg_red red
echo ""
bg_yellow yellow
echo ""
bg_blue blue
echo ""
bg_green green
echo ""
bg_purple purple
echo ""
bg_mint mint
echo ""
bg_grey grey

echo ""
black black
echo ""
red red
echo ""
yellow yellow
echo ""
blue blue
echo ""
green green
echo ""
purple purple
echo ""
mint mint
echo ""
grey grey

#쉘스크립트를 만들때 글자의 색을 변경하고싶을 때 
#위에 미리선언해두고 사용했던 스크립트 
#.bashrc에 입력해두고 사용하면 터미널에서도 사용이 가능
#[출처] echo 색깔지정 함수|작성자 ciw0707
