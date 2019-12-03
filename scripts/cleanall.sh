#!/bin/bash


echo "***************************************************************************************************"
echo "*                                                                                                 *"
echo "*    Note:                                                                                        *"
echo "*        It's dangerous to do this !!!                                                            *"
echo "*        Do you know it will clean all right now?                                                 *"
echo "*                                                                                                 *"
echo "***************************************************************************************************"
echo "Are you sure?  (yes/no):"
read answer
if [ "${answer}" = "yes" -o "${answer}" = "y" ];then
	echo "*********************************************************************************************************"
	echo "*   NOTE:                                                                                               *"
	echo "*        begin to clean all config                                                                      *"
	echo "*                                                                                                       *"
	echo "*********************************************************************************************************"

		kubeadm reset --force
		rm -rf ~/.kube
		systemctl stop docker
		rm -rf /usr/bin/docker
		rm -rf /usr/lib/systemd/system/docker.service
		rm -rf /var/lib/cni/
		rm -rf /var/lib/kubelet/*
		rm -rf /etc/cni/
		ifconfig cni0 down
		ifconfig flannel.1 down
		ifconfig docker0 down
		ip link delete cni0
		ip link delete flannel.1
		ip link delete docker0
		systemctl stop kubelet
		rm -rf /usr/bin/kube*
		rm -rf /usr/lib/systemd/system/kubelet.service
		yum -y remove kubelet


n=$(kubectl get ns | grep kubeedge|wc -l)
if [ 1 = n ] ; then
kubectl create -f 01-namespace.yml
fi

	echo "*********************************************************************************************************"
	echo "*   NOTE:                                                                                               *"
	echo "*         finish clean all config                                                                       *"
	echo "*                                                                                                       *"
	echo "*********************************************************************************************************"
else
	echo "***************************************************************************************************"
	echo "*                            Yes,may be you're right!                                             *"
	echo "***************************************************************************************************"
	exit 1
fi
