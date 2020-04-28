# 概述

离线安装kubernetes

- 目前支持操作系统版本: centos7.5+
- 支持k8s版本: 1.14.1, 1.15.4 ,1.16.8, 1.18.2
- 提供的网络插件2选1: calico(默认)和flannel
- docker的版本为：19.03.8

## 离线包链接

离线包目录
```
tree k8spkg

```


# 使用方法
1.下载离线包到/usr/local/src
2.解压
```shell
tar -zxvf k8spkg.tgz
```

3.下载离线安装程序
```
git clone https://github.com/googlebabaio/k8s-deploy-offline.git
```

4.修改配置文件
```
cd k8s-deploy-offline
vi kubedeploy.ini
```

主要是修改


## 参数文件说明

## 目录说明

## 使用步骤


# roadmap


# 参考
https://download.docker.com/linux/static/stable/x86_64/
