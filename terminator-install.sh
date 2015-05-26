#!/bin/bash
# install terminator
# by powersea
# 

# 1. enable RPMForge repository 
su
cd /opt/pkgs
bits=$(uname -r | cut -d '.' -f 7)
if [ $bits = "i686" ]; then
	wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.i686.rpm
else
	wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
fi
rpm -Uvh rpmforge*.rpm

# 2. import RPMForge Repository Key 
wget http://dag.wieers.com/rpm/packages/RPM-GPG-KEY.dag.txt
rpm --import RPM-GPG-KEY.dag.txt

# 3. install terminator
yum --enablerepo=rmpforge install terminator

# 4. run tmt = terminator -f >/dev/null 2>&1 &
exit
cd ~/bin/
touch tmt
echo "#!/bin/bash" >> tmt
echo "terminator -f >/dev/null 2>&1 &" >> tmt
chmod +x tmt

