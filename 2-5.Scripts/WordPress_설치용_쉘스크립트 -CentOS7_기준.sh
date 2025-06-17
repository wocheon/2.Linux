#! /bin/bash
exec 2>installerror.txt
echo -e "\E[44;01m###install openssl to wordpress### \E[0m"
echo -e "\E[44;01m###Made by Inwoo cheon### \E[0m"
sleep 1

echo "Continue? [y/n]"
read cont1
if [ $cont1 = y ]
then
echo "ok!"
else
echo "Bye!"
exit
fi
sleep 2


###비밀번호 확인 절차###
hap=0

echo -e "\E[45;30m <file password ?> \E[0m"
read pswd
while [ $pswd != "ciw0707" ]
do

if [ $hap = 4 ]
then
echo -e "\E[0;31m <Recheck File's password!> \E[0m"
exit
fi

hap=`expr $hap + 1`
echo -e "\E[0;31m ${hap} time error! \E[0m">&2
echo -e "\E[45;30m <file password?> \E[0m"
read pswd
done

echo -e "\E[45;37m <Retype password> \E[0m"
read pswd1
if [ $pswd1 != $pswd ]
then
echo -e "\E[0;31m <incorrect password!> \E[0m">&2
exit 0
fi


echo -e '\E[0;34m <Start Install !> \E[0m'
​

​

###프로그램 시작전 기본설정 ###y

echo -e "\E[44;01;32m ##Step1 : Start Install https(openssl)## \E[0m"
sleep 2
echo "Continue? [y/n]"
read cont2
if [ $cont2 = y ]
then
echo "OK!"
else
echo "bye"
exit
fi
sleep 2

echo '<install vim>'
yum install -y vim   
echo " complete!"

echo '<install bash-completion>'
yum install -y bash-completion   
echo " complete!"

echo '<install httpd>'
yum install -y httpd   
echo " complete!"

echo '<install expect>'
yum install -y expect   
echo " complete!"

systemctl start httpd
systemctl enable httpd

echo'< firewall setting >'
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload
echo " complete!"
echo -e "\E[44;01;32m -Start Install openssl- \E[0m"
sleep 2

echo '<install openssl>'
yum install -y openssl  
echo " complete!"

echo '<install mod_ssl>'
yum install -y mod_ssl  
echo " complete!"

echo -e "\E[42;30m generate .csr file : Do you want Default setting? (private.key/cert.crt) [y/n] \E[0m"
read conf1

if [ $conf1 = y ]
then

openssl genrsa -out private.key 2048

expect << EOF
spawn openssl req -new -key private.key -out cert.csr
expect "Country Name"
send "\n"
send "\n"
send "\n"
send "\n"
send "\n"
send "\n"
send "\n"
send "\n"
send "\n"
expect eof
EOF
echo ""

openssl x509 -req -signkey private.key -in cert.csr -out cert.crt
ls -l cert.csr
mv cert.crt /etc/pki/tls/certs/
mv private.key /etc/pki/tls/private
restorecon -Rv /etc/pki/tls/ 
chmod 600 /etc/pki/tls/private/private.key
sed -i 's/localhost.key/private.key/' /etc/httpd/conf.d/ssl.conf
sed -i 's/localhost.crt/cert.crt/' /etc/httpd/conf.d/ssl.conf

else

echo -e "\E[42;30m <private key name: ?> \E[0m"
read private

echo -e "\E[42;30m <cert name: ?> \E[0m"
read cert

openssl genrsa -out ${private}.key 2048
openssl req -new -key ${private}.key -out ${cert}.csr
openssl x509 -req -signkey ${private}.key -in ${cert}.csr -out ${cert}.crt

mv ${cert}.crt /etc/pki/tls/certs/
mv ${private}.key /etc/pki/tls/private
restorecon -Rv /etc/pki/tls/ 
chmod 600 /etc/pki/tls/private/${private}.key

#sed -i "s/SSLCertificateFile \/etc\/pki\/tls\/certs\/localhost.crt/SSLCertificateFile \/etc\/pki\/tls\/certs\/$cert.crt/g" /etc/httpd/conf.d/ssl.conf
#sed -i "s/SSLCertificateKeyFile \/etc\/pki\/tls\/private\/localhost.key/SSLCertificateKeyFile \/etc\/pki\/tls\/private\/$private.key/g" /etc/httpd/conf.d/ssl.conf

sed -i 's/localhost.key/'${private}'.key/' /etc/httpd/conf.d/ssl.conf
sed -i 's/localhost.crt/'${cert}'.crt/' /etc/httpd/conf.d/ssl.conf
fi 

 cat /etc/httpd/conf.d/ssl.conf | egrep "(^SSLCertificateFile|^SSLCertificateKeyFile)"

systemctl restart httpd

echo -e "\E[44;01;32m ##STEP1 Finished!### \E[0m"
##아파치와 PHP연동##
echo -e "\E[44;01;32m ##Step2 : Apache<-->PHP## \E[0m"
sleep 2
echo "Continue? [y/n]"
read cont3
if [ $cont3 = y ]
then
echo "ok!"
else
echo "Bye!"
exit
fi
sleep 2

echo '<Install PHP (1/6)>'
yum install -y epel-release 
#echo '<Install PHP (2/6)>'
#yum install -y yum-utils-noarch 
echo '<Install PHP (2/6)>'
yum install -y yum-utils 
echo '<Install PHP (3/6)>'
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm  
echo '<Install PHP (3/6)>'
yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm  
echo '<Install PHP (4/6)>'
yum install -y --enablerepo=remi-php72 install php  
echo '<Install PHP (5/6)>'
yum install -y --enablerepo=remi-php72 install php-mysql  
echo '<Install PHP (6/6)>'
yum install -y php72 php72-php-fpm php72-php-mysqlnd php72-php-opcache php72-php-xml php72-php-xmlrpc php72-php-gd php72-php-mbstring php72-php-json  
echo " complete!"

echo "$(php -v)"


#yum -y install epel-release
#rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
#yum install -y mod_php72w php72w-cli 
#yum install -y php72w-bcmath php72w-gd php72w-mbstring php72w-mysqlnd php72w-pear php72w-xml php72w-xmlrpc php72w-process
#yum install -y yum-utils-noarch


echo -e "<?php\nphpinfo();\n?>">/var/www/html/info.php

#echo "AddType application/x-httpd-php .php4 .php .phtml .ph .inc .html .htm" >>/etc/httpd/conf/httpd.conf
#echo "AddType application/x-httpd-php-source .phps" >>/etc/httpd/conf/httpd.conf
sed -i '284a\\AddType application/x-httpd-php .php4 .php .phtml .ph .inc .html .htm' /etc/httpd/conf/httpd.conf
sed -i '285a\\AddType application/x-httpd-php-source .phps' /etc/httpd/conf/httpd.conf


#sed -i "s/short\_open\_tag \= Off/short\_open\_tag \= On/g" /etc/php.ini
sed -i 's/short_open_tag = On/short_open_tag = Off/' /etc/php.ini

systemctl restart httpd

echo -e "\E[44;01;32m ##STEP2 Finished!### \E[0m"
sleep 2

##phpmyadmin 설치##
echo -e "\E[44;01;32m ##Step3 : Install phpmyadmin## \E[0m"
sleep 2
echo "Continue? [y/n]"
read cont4
if [ $cont4 = y ]
then
echo "ok!"
else
echo " By!"
exit
fi
sleep 2

echo '<Intall MariaDB & MariaDB-Server>'  
yum install -y mariadb-server mariadb  
echo 'complete!'

systemctl start mariadb.service
systemctl enable mariadb.service

echo -e "\E[42;30m mysql_secure_installation : Do you want apply Default setting?  (password toor): [y/n] \E[0m"
read conf3

if [ $conf3 = y ]
then
expect << EOF
spawn mysql_secure_installation
expect "Enter current password for root"
send "\n"
expect "Set root password?"
send "y\n"
expect "New password"
send "toor\n"
send "toor\n"
send "y\n"
send "y\n"
send "y\n"
send "y\n"
expect eof
EOF
echo ""
else
mysql_secure_installation
fi

echo '<Intall MariaDB & MariaDB-Server>' 
yum install -y --enablerepo=remi-php72 phpmyadmin  
yum install -y phpmyadmin  
echo 'complete!'

echo -e "\E[44;01;32m ##What's Your Subnet IP Address ? ex)192.168.100.0/24 ### \E[0m"
read ipaddr

#sed -i "s/Require ip 127\.0\.0\.1/Require ip 127\.0\.0\.1 192\.168\.100\.0\/24/g" /etc/httpd/conf.d/phpMyAdmin.conf

#sed -i '15a\\Require ip 127.0.0.1 '${ipaddr:1:}'' /etc/httpd/conf.d/phpMyAdmin.conf
#sed -n '14,28p' /etc/httpd/conf.d/phpMyAdmin.conf 

sed -i 's/Require ip 127.0.0.1/Require ip 127.0.0.1 '${ipaddr:0:13}'\/'${ipaddr:14}'/g' /etc/httpd/conf.d/phpMyAdmin.conf

cat /etc/httpd/conf.d/phpMyAdmin.conf | grep ${ipaddr}
systemctl restart httpd

echo -e "\E[44;01;32m ##STEP3 Finished!### \E[0m"
sleep 2
###wordpress 설치###
echo -e "\E[44;01;32m ##Step4 : Install wordpress## \E[0m"
sleep 2
echo "Continue? [y/n]"
read cont5
if [ $cont5 = y ]
then
echo "ok!"
else
echo "Bye!"
exit
fi
sleep 2

echo '<Intall w-get>' 
yum install -y wget  
echo 'complete!'

wget https://wordpress.org/latest.tar.gz 
tar -zxvf latest.tar.gz -C /var/www/html/ 
chown -R apache:apache /var/www/html/wordpress/
echo -e "<VirtualHost *:80>\nDocumentRoot /var/www/html/wordpress\n</VirtualHost>" >/etc/httpd/conf.d/wordpress.conf


#mysql -u root -p 
#systemctl restart httpd
#echo -e "\E[44;01;32m ##Finish## \E[0m"

#> 패스워드입력하면 mariaDB접속
#CREATE DATABASE wordpress CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
#GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY '1q2w3e4r';
#exit

echo -e "\E[44;01;32m -set mariaDB- \E[0m"
sleep 2
echo "Continue? [y/n]"
read cont6
if [ $cont6 = y ]
then
echo "ok!"
else
echo "Bye!"
exit
fi
sleep 2


echo -e "\E[42;30m CREATE DATABASE & GRANT: Do you want apply Default setting? \E[0m"
echo -e "\E[42;30m Default (DBname : wordpress, GRANTuser : wordpressuser@localhost pwd :1q2w3e4r) [y/n]) \E[0m"
echo -e "\E[42;30m *If you change mysql root password, select n* \E[0m"
read conf7

if [ $conf7 = y ]
then

expect << EOF
spawn mysql -u root -p
expect "password:"
send "toor\n"
expect "none"
send "CREATE DATABASE wordpress CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;\n"
send "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY '1q2w3e4r';\n"
send "exit\n"
expect eof
EOF
echo ""

else
echo -e "\E[44;01;32m -Insert New Setting- \E[0m"
echo -e "\E[42;30m <MariaDB root user pasword : ?> \E[0m"
read db1

echo -e "\E[42;30m <DBname: ?> \E[0m"
read db2

echo -e "\E[42;30m <user name: ?> \E[0m"
read grant1

echo -e "\E[42;30m <DBhost name(default :localhost): ?> \E[0m"
read grant2

echo -e "\E[42;30m <user password: ?> \E[0m"
read grant3

expect << EOF
spawn mysql -u root -p
expect "password:"
send "$db1\n"
expect "none"
send "CREATE DATABASE $db2 CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;\n"
send "GRANT ALL ON $db2.* TO '$grant1'@'$grant2' IDENTIFIED BY '$grant3';\n"
send "exit\n"
expect eof
EOF

echo -e "\E[42;30m <Do you want save your custom settings ?> \E[0m"
read save1


if [ $save1 = y ]
then
echo "###your setting list will be saved in the "yoursetting.txt" file ###"
echo -e "MariaDBrootuserpasword=${db1}\n DBname=${db2}\n DBuser=${grant1} \n DBhostname=${grant2}\n DBpassword=${grant3}" >> yoursetting.txt
else
echo " OK!"
fi
sleep 1

fi
systemctl restart httpd

echo -e "\E[44;01m ##ALL STEP Finished!!## \E[0m"
sleep 2
[출처] WordPress 설치용 쉘스크립트 -CentOS7 기준|작성자 ciw0707
