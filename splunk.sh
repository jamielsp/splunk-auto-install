#!/bin/bash

cat splunki



splunk_root() {

	echo -e "splunk ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

}
inst_dep () {

	yum install wget -y
}

splunkuser () {
	groupadd splunk
	useradd -d /opt/splunk -m -g splunk splunk

}

extr_mv_splunk_file () {

	tar -xvf splunk-8.2.5-77015bc7a462-Linux-x86_64.tgz 2>&1
	cp -rp splunk/* /opt/splunk/
	chown -R splunk: /opt/splunk/	
}


inst_splunk () {
	cd /opt/splunk/bin/
	./splunk start --accept-license
	sudo cat finished	
}


conf_fw () {

	sudo firewall-cmd --add-port=8000/tcp --permanent
	sudo firewall-cmd --reload
	
}



#---------------splunk whith root privileges

splunk_root

#---------------Downloading resourses 

echo "DOWNLOADING PACKETS"
#wget -O splunk-8.2.5-77015bc7a462-Linux-x86_64.tgz "https://download.splunk.com/products/splunk/releases/8.2.5/linux/splunk-8.2.5-77015bc7a462-Linux-x86_64.tgz" --progress=bar:force 2>&1 | tail -f -n +6 



#----------------CREATING USER BR.....

echo "CREATING USER SPLUNK"
splunkuser


#---------------EXTRACTING and moving splunk file

echo "EXTRACTING AND MOVING SPLUNK FILE"
extr_mv_splunk_file



#--------------CONFIGURING FW

echo "ADDING PORT TO FW"
conf_fw


#---------------INSTALLING SPLUNK

echo "INSTALLING SPLUNK"
inst_splunk
IP=$(hostname -I)
echo "ENTER http://$IP:8000"
