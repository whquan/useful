#!/bin/bash
# install vim, colorscheme, plugins etc.
# install new vim
su
yum -y remove $(rpm -qa | grep ^vim)

mkdir -p /opt/pkgs
cd /opt/pkgs
wget ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2
tar jxvf vim-*.tar.bz2
rm -f vim*.tar.bz2
cd vim*

yum -y install gcc make ncurses-devel
./configure --disable-selinux \
		--enable-multibyte \
		--with-features=huge \
		--with-modified-by=ViruSzZ \
		--enable-pythoninterp \
        --with-python-config-dir=/usr/lib/python2.6/config

make && make install
hash -r
exit

# install colorscheme
cd ~
mkdir -p ~/.vim/colors
cd ~/.vim/colors
wget https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim
wget https://raw.githubusercontent.com/altercation/solarized/master/vim-colors-solarized/colors/solarized.vim

# install vundle
mkdir -p ~/.vim/bundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
todo_vundle = "vundle: Update ~/.vimrc. Refer to https://github.com/gmarik/Vundle.vim"

# install pathogen
mkdir -p ~/.vim/autoload 
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
todo_pathogen = "pathogen: Update ~/.vimrc. Refer to https://github.com/tpope/vim-pathogen"

# install Taglist
su
yum -y install ctags
exit
todo_taglist = "taglist: update ~/.vimrc. 1) add \" Plugin 'taglist.vim' \"\
										  2) :PluginInstall\
										  3) set key map"

# install YouCompleteMe
git clone https://github.com/Valloric/YouCompleteMe.git ~/.vim/bundle/YouCompleteMe
cd ~/.vim/bundle/YouCompleteMe
git submodule update --init --recursive
./install.sh
todo_ycm = "YouCompleteMe: nothing"


# show todo
echo todo_vundle
echo todo_pathogen
echo todo_taglist
echo todo_ycm


