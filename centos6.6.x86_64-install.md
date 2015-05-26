# CentOS 6.6 x64完整安装过程纪实

@(CentOS6.6)[完整安装|过程|记载]

**经历无数次的随机蓝屏重启之后，我决定更换宿主机为CentOS6.6 x64**
 
-------------------

[TOC]

## 1.准备安装

**光盘或者启动U盘**
值得一提的是，如果你制作的是启动U盘，系统默认可能检测不到安装介质，需要你自己选择安装介质所处的位置。
我这里U盘被识别的设备名称是sdc,所以选择这个位置就好啦。
系统启动的时候，按左右方向键，就可以打断正常的启动过程，选择临时的启动设备

## 2.磁盘分区
主磁盘2T，sda
| 挂载点|    大小 |   格式| 分区号 |
| :----| ------:|  ---: |  :--: |
|/boot|		400M|	ext3|	sda1|	
|/	  |		48G	|	ext4|	sda5|
|swap |		16G	|	- 	|	sda6|
|/home|		100G|	ext4|	sda2|
|/usr | 	80G	|	ext4|	sda3|
值得一提的是：剩余了很多空闲空间，为vmware的虚拟机准备
安装好之后df -h可以查看
分区的解释：
/tmp分区建议采用系统自带
/var分区对服务器比较重要，如果不做服务器，不用单独分区
多分区的好处是，一旦一个分区发生故障，其他分区不至于“连坐”

## 3.boot loader安装位置
如果是U盘安装的话，系统会默认把boot loader安装在U盘的MBR上，后果是以后U盘要一直插在机器上，而且是第一启动项
更改，**安装在主磁盘的MBR上**（更改启动顺序，把主磁盘排在第一就OK了）
比较有迷惑性是："安装在sda1上"。
如果是装双系统的话，可以考虑，但是现在咱就一个系统没有必要，而且会出问题。
如果装双系统，先windows，因为windows会很霸道的默认覆写磁盘的MBR

任何一块硬盘的第一扇区(512字节)，包含有极其重要的信息，就是MBR(主引导记录)和分区表，
硬盘上的每一个分区的第一扇区是自己的启动扇区，同样重要

原因：计算机启动顺序，**打死也要记住理解**
BIOS——>第一个启动设备——>MBR——>boot loader|——>OS kernel
-------------------------------------------------------------------------- |——>boot loader 2——OS kernel

## 4.安装完成的软件配置
### 4.1软件源替换(163)
refer：http://mirrors.163.com/.help/centos.html
```
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
cd /etc/yum.repos.d/
wget http://mirrors.163.com/.help/CentOS6-Base-163.repo
mv CentOS6-Base-163.repo CentOS-Base.repo

yum clean all
yum makecache
yum update
init 6	//重新启动，确保启动更新后的kernel
```

### 4.2自动识别NTFS磁盘(分区)(fuse-ntfs-3g)
```
rpm -Uvh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
yum install fuse-ntfs-3g
```
当然也可以安装ntfs-3g,但是不能实现自动识别并且挂载ntfs格式，需要手工识别挂载
**fuse-ntfs-3g可以实现自动的识别和挂载ntfs格式磁盘**

### 4.3安装VMware
官网下载最新(现在是11)的安装文件.bundle格式
```
yum -y install gcc
chmod u+x VMware......bundle
./VMware......bundle
```
>baidu的第一个序列号: 1F04Z-6D111-7Z029-AV0Q4-3AEH8

启动：
```
1) 如果提示 找不到"libpk-gtk-module.so"，"libcanberra-gtk-module.so":
	locate libpk-gtk-module.so	//先定位，结果是 /usr/lib64/gtk-2.0/modules/
	vim /etc/ld.so.conf.d/gtk-2.0.conf	//没有就创建
	添加：/usr/lib64/gtk-2.0/modules/
	生效：ldconfig
2)如果提示找不到"C header...."
	yum -y install kernel-devel
	yum -y install kernel-headers
```

### 4.4安装NVIDIA显卡驱动
不安装也是可以的，强迫症患者...这样虚拟机里面才能有3D效果呀
`lspci	//查看显卡型号`
官网下载对应显卡型号的驱动程序 NVIDIA-Linux-x86_64-346.59.run
```
vim /etc/modprobe.d/blacklist.conf
增加 blacklist nouveau	//和NVIDIA冲突
注释 blacklist nvidiafb //#

mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r).img.backup
dracut /boot/initramfs-$(uname -r).img  $(uname -r)

//取消刚才的更改：
vim /etc/modprobe.d/blacklist.conf
注释nouveau那一行，取消nvidiafb注释
//原因：如果不改，下次机器启动很有可能卡死在启动界面(别问为什么，我也不知道)

init 3
lsmod，查看确保nouveau模块没有加载
./NVIDIA-Linux-x86_64-346.59.run
init 6
```
如有问题，自行google
如果中途os起不来，插入liveCD或者Ubuntu(Try模式)光盘，挂载指定分区，编辑对应文件，再重启

### 4.5为VMware虚拟机创建分区并挂载
我的目的是在sda的free space上创建一个新的分区，然后挂在到`/home/xx/vmware`下面
网上的教程:`fdisk /dev/sda`; 然后`n`，但是对于已经存在很多分区来说，这个命令不好用啊。
因为只能指定起始柱面号，终止的指定不了啊
***无奈***：
重新走一遍安装过程，到分区那里，把free space分区，并且格式化成ext4格式，然后到安装boot loader那一步:
强制关机...重启，这样新的分区sda7就出来了，而且是ext4格式，为了解决问题不择手段...

***自动挂载***
```
vim /etc/fstab
//增加一行
UUID=4d727ed2-ff0b-4231-aa85-900c30e2f75e /home/ps/vmware ext4  defaults  0 0
//UUID查找: 
ll /dev/disk/by-uuid/
```
当然`UUID`也可以换成`/dev/sda7`的形式。但有一点好处：
移动存储可能每次插拔被识别的设备名不一样，但是`UUID`一致，所以可以用于自动挂载

### 4.6【视情况而定】
安装虚拟机之后，桥接模式，但是不能连接VPN。根据vmware提示信息，原来linux不允许虚拟网卡开启混杂模式，提示的信息中有个链接，可以找到解决办法。
就是增加对`/dev/vmnet0`的读写权限。
`chmod a+rw /dev/vmnet0`

## 5.扩展知识
**这部分内容本是第一版的安装过程片段，现在作为扩展吧**
1. 安装ntfs-3g
     centos 6 采用ext4
     centos系统不识别ntfs磁盘格式，ntfs-3g可以挂载ntfs磁盘
     ex：`ntfs-3g /dev/sdg1 /mnt/2T-ntfs`
          `mount -t ntfs-3g` 设备被识别的名字 挂载位置
          `umount /mnt/2T-ntfs`
          开机自动挂载`vim /etc/fstab`,在最后增加：
          `<NTFS 分区> <挂载位置> ntfs-3g defaults 0 0`//根据上面的知识，这里采用`UUID`比较好啊
             
2. wget设置代理
     命令行方式：`wget -e http_proxy="http://ip:port" url`
     改配置文件：`vim /etc/wgetrc`,
     `http_proxy=ip:port`
     `use_proxy=on`
     其他代理在配置文件里面有，自己想改么
    
3. 安装ftp
     `yum install ftp`
     Ex: `ftp 192.168.5.105`,账户ftp（和匿名差不多）
          然后就可以执行一系列命令操作啦。如ls，cd啥的。
          上传put，下载get，退出quit         
              
4. 安装axel工具
     ex：`axel url`
          -n：10 线程个数
          -a：显示不刷屏的进度条
          -S5：使用filesearching寻找镜像，提速
          -o：保存位置
          -s：2048 限速2048B
     man axel
	
5. 安装chrome
     参考文章
     http://www.tecmint.com/install-google-chrome-on-redhat-centos-fedora-linux/
     下载需要挂代理，被墙了么
     安装的时候，需要设置系统代理，否则sh脚本执行不正常
```
  vim /etc/profile 
  //在最后增加：
  http_proxy="http://192.168.5.202:808"
  export http_proxy     //保存
  source /etc/profile   //立即生效（反正对sh脚本是管用的）
```
