#!/bin/bash

#chmod -R +x scripts

KUBEDEPLOY_INI_FULLPATH=$(pwd)/kubedeploy.ini

echo "------------------------------------Kubernetes Install Menu----------------------------------------"
echo "| Choose your option                                                                              |"
echo "|                                                                                                 |"
echo "|                        1.Install K8s On Master                                                  |"
echo "|                        2.Init Env For All (OS/docker/images/kubelet)                            |"
echo "|                        3.Init Env (OS/kubelet)                                                  |"
echo "|                        4.Install Docker Only                                                    |"
echo "|                        5.Load Docker Images Only                                                |"
echo "|                        6.Install Docker And Load Docker Images                                  |"
echo "|                        7.Uninstall K8s Config                                                   |"
echo "|                        8.Uninstall AlL Config                                                   |"
echo "|                        9.Exit                                                                  |"
echo "|                                                                                                 |"
echo "---------------------------------------------------------------------------------------------------"
echo "Choose your option (1-9):"
read answer
case $answer in
1)
	sh scripts/config-master.sh ${KUBEDEPLOY_INI_FULLPATH}
	;;
2)
	sh scripts/config-initos.sh 2
	;;
3)
	sh scripts/config-initos.sh 3
	;;
4)
	sh scripts/config-initos.sh 4
	;;
5)
	sh scripts/config-initos.sh 5
	;;
6)
	sh scripts/config-initos.sh 6
	;;
7)
	sh scripts/cleank8s.sh
	;;
8)
	sh scripts/cleanall.sh
	;;
9)
	echo "byebye"
	exit 1
	;;
*)
	echo "Error! The number you input isn't 1 to 10"
	exit 1
	;;
esac
