#!/bin/bash

echo "***************************************************************************************************"
echo "*                                                                                                 *"
echo "*    Note:                                                                                        *"
echo "*        It's dangerous to do this !!!                                                            *"
echo "*        Do you know it will clean k8s right now?                                                 *"
echo "*                                                                                                 *"
echo "***************************************************************************************************"
echo "Are you sure?  (yes/no):"
read answer
if [ "${answer}" = "yes" -o "${answer}" = "y" ];then
	echo "*********************************************************************************************************"
	echo "*   NOTE:                                                                                               *"
	echo "*        begin to clean k8s config                                                                      *"
	echo "*                                                                                                       *"
	echo "*********************************************************************************************************"

	kubeadm reset --force
	systemctl stop kubelet
	systemctl stop docker
	rm -rf ~/.kube
	rm -rf /var/lib/cni/
	rm -rf /etc/cni/
	rm -rf /var/lib/kubelet/*
	ifconfig cni0 down
	ifconfig flannel.1 down
	ifconfig docker0 down
	ip link delete cni0
	ip link delete flannel.1
	yum remove -y kubelet kubectl kubeadm conntrack-tools cri-tools libnetfilter_cttimeout libnetfilter_queue socat
	rm -rf /etc/kubernetes

	echo "*********************************************************************************************************"
	echo "*   NOTE:                                                                                               *"
	echo "*         finish clean k8s config                                                                       *"
	echo "*                                                                                                       *"
	echo "*********************************************************************************************************"
else
	echo "***************************************************************************************************"
	echo "*                            Yes,may be you're right!                                             *"
	echo "***************************************************************************************************"
	exit 1
fi
