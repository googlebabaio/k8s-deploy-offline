#!/bin/bash

check_ok() {
    if [ $? != 0 ]
        then
        echo "Error, Check the error log."
        exit 1
    fi
}

prepareEnv(){
echo "*********************************************************************************************************"
echo "*   NOTE:                                                                                               *"
echo "*        begin to init os ,including: closeFirewalld ,closeFirewalld,closeSelinux,openBrigeSupport      *"
echo "*                                                                                                       *"
echo "*********************************************************************************************************"

    closeSwapoff
    closeFirewalld
    openBrigeSupport
    closeSelinux

echo "*********************************************************************************************************"
echo "*   NOTE:                                                                                               *"
echo "*         finish init os.                                                                               *"
echo "*                                                                                                       *"
echo "*********************************************************************************************************"

}

closeSwapoff(){
  echo "step:------> closeSwapoff begin"
  swapoff -a
  echo "vm.swappiness = 0">> /etc/sysctl.conf
  sysctl -p
  echo "step:------> closeSwapoff completed."
}

closeFirewalld(){
echo "step:------> closeFirewalld begin"
    systemctl status firewalld
    systemctl stop firewalld.service
    systemctl disable firewalld.service
echo "step:------> closeFirewalld completed."
}


openBrigeSupport(){
    echo "step:------> openBrigeSupport begin"

	cat <<EOF >  /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
fs.may_detach_mounts = 1
vm.overcommit_memory=1
vm.panic_on_oom=0
fs.inotify.max_user_watches=89100
fs.file-max=52706963
fs.nr_open=52706963
net.netfilter.nf_conntrack_max=2310720
EOF

	sysctl -p /etc/sysctl.conf
	check_ok
	sleep 1
    echo "step:------> openBrigeSupport completed."
}


closeSelinux(){
    echo "step:------> closeselinux begin"
	setenforce 0
	sed -i "s/^SELINUX=enforcing/SELINUX=disabled/g" /etc/sysconfig/selinux
	sed -i "s/^SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
	sed -i "s/^SELINUX=permissive/SELINUX=disabled/g" /etc/sysconfig/selinux
	sed -i "s/^SELINUX=permissive/SELINUX=disabled/g" /etc/selinux/config
	check_ok
	sleep 1
	echo "step:------> closeselinux completed."
}

configDocker(){
echo "*********************************************************************************************************"
echo "*   NOTE:                                                                                               *"
echo "*        begin to config docker ,including: remove old version docker ,deploy docker-ce-18.09.5         *"
echo "*                                                                                                       *"
echo "*********************************************************************************************************"
echo "step:------> remove old docker version"
sleep 1
yum remove -y docker docker-common container-selinux docker-selinux docker-engine
check_ok
echo "step:------> remove old docker version completed."
sleep 1

echo "step:------> configDocker begin"

cd /usr/local/src/kubeedge
tar -zxf docker-18.09.5.tgz
cp docker/* /usr/local/bin

cd /usr/lib/systemd/system

cat > docker.service <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.io

[Service]
Environment="PATH=/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin"
EnvironmentFile=-/run/flannel/docker
ExecStart=/usr/local/bin/dockerd --log-level=error $DOCKER_NETWORK_OPTIONS
ExecReload=/bin/kill -s HUP $MAINPID
Restart=on-failure
RestartSec=5
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
Delegate=yes
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable docker
    systemctl start docker
    check_ok
    echo "step:------> configDocker completed."
echo "*********************************************************************************************************"
echo "*   NOTE:                                                                                               *"
echo "*         finish config docker.                                                                         *"
echo "*                                                                                                       *"
echo "*********************************************************************************************************"
}


loadDockerImgs(){
echo "*********************************************************************************************************"
echo "*   NOTE:                                                                                               *"
echo "*            Now,We will load some images (pod-infrastructure,pasue,dns,etc..),                         *"
echo "*            And it will store docker's default datadir !                                               *"
echo "*                                                                                                       *"
echo "*            If you want to change the default docker datadir,Please do something else                  *"
echo "*            After config completed by  manually !                                                      *"
echo "*                                                                                                       *"
echo "*                                                                                                       *"
echo "*********************************************************************************************************"
echo "step:------> loading some docker images"
sleep 1
cd /usr/local/src/kubeedge
echo "step:------> unzip docker images packages"
sleep 1
tar -zxf k8s-imgs.tar.gz
check_ok
echo "step:------> unzip docker images packages completed."

cd images
docker load < etcd.tar
docker load < coredns.tar
docker load < flannel.tar
docker load < pause.tar

docker load < kube-apiserver.tar
docker load < kube-controller-manager.tar
docker load < kube-proxy.tar
docker load < kube-scheduler.tar

docker load < pod2daemon-flexvol.tar
docker load < calico-kube-controllers.tar
docker load < caliconode.tar
docker load < calicocni.tar

docker load < nfs-client-provisioner.tar
docker load < traefik.tar

echo "step:------> loading some k8s images completed."
sleep 1
echo "*********************************************************************************************************"
echo "*   NOTE:                                                                                               *"
echo "*         finish load docker images, the images list :                                                  *"
echo "*                                                                                                       *"
echo "*********************************************************************************************************"
    docker images
}

configKubelet(){
echo "*********************************************************************************************************"
echo "*   NOTE:                                                                                               *"
echo "*        begin to config kube-tools ,including: deploy kubelet/kubectl/kubeadm                          *"
echo "*                                                                                                       *"
echo "*********************************************************************************************************"
	cd /usr/local/src/kubeedge/
	tar -zxf rpm.tar.gz
	cd rpm
	rpm -ivh --force *
  systemctl enable kubelet.service
echo "*********************************************************************************************************"
echo "*   NOTE:                                                                                               *"
echo "*         finish config kube-tools .                                                                    *"
echo "*                                                                                                       *"
echo "*********************************************************************************************************"
}



case $1 in
2)
	prepareEnv
	configDocker
	loadDockerImgs
	configKubelet
	;;
3)
	prepareEnv
	configKubelet
	;;
4)
	prepareEnv
	configDocker
	;;
5)
	prepareEnv
	loadDockerImgs
	;;
6)
	prepareEnv
	configDocker
	loadDockerImgs
	;;
*)
	echo "Error! laozi ling luan le!"
	exit 1
	;;
esac
