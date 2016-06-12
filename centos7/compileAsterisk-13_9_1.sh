#! /bin/bash

DOWNLOAD_URL=http://downloads.asterisk.org/pub/telephony/asterisk
ASTVERSION=asterisk-13.9.1
TARGET_DIR=/usr/src/

DEV_PKG_LIST="automake \
    gcc \
    gcc-c++ \
    ncurses-devel \
    openssl-devel \
    libxml2-devel \
    unixODBC-devel \
    libcurl-devel \
    libogg-devel \
    libvorbis-devel \
    speex-devel \
    net-snmp-devel \
    corosynclib-devel \
    newt-devel \
    popt-devel \
    libtool-ltdl-devel \
    sqlite-devel \
    neon-devel \
    jansson-devel \
    libsrtp-devel \
    pjproject-devel \
    libxslt-devel \
    libuuid-devel \
    gsm-devel \
    gmime-devel \
    iksemel-devel \
    svn"

RUN_PKG_LIST="pjproject jansson neon unixODBC vorbis gmime iksemel"


# install dependencies
yum -q makecache
yum install tar epel-release -y 
yum install -y $DEV_PKG_LIST $RUN_PKG_LIST

# obtain and extract the source
cd $TARGET_DIR
# delete the sources, if already present
rm -rf $TARGET_DIR/$ASTVERSION
# download and untar
wget $DOWNLOAD_URL/$ASTVERSION.tar.gz $TARGET_DIR
tar zxvf $ASTVERSION.tar.gz

# build Asterisk
cd $TARGET_DIR/$ASTVERSION
./configure --libdir=/usr/lib64
cd $TARGET_DIR/$ASTVERSION/menuselect
make menuselect
cd  $TARGET_DIR/$ASTVERSION
make menuselect-tree

./menuselect/menuselect \
    --disable-category MENUSELECT_AGIS \
    --disable-category MENUSELECT_TESTS \
    --enable format_mp3 \
    --enable res_hep \
    --enable res_hep_pjsip \
    --enable res_hep_rtcp \
    --enable res_statsd \
    --enable chan_sip

#    --disable-category MENUSELECT_CORE_SOUNDS \
#    --disable-category MENUSELECT_MOH \
#    --disable-category MENUSELECT_EXTRA_SOUNDS \
#    --disable-category MENUSELECT_ADDONS \
    
# we want mp3's    
./contrib/scripts/get_mp3_source.sh

make
make install
make samples

# clean up

# delete the sources
rm -rf $TARGET_DIR/$ASTVERSION
rm  -f $TARGET_DIR/$ASTVERSION.tar.gz

yum remove -y $DEV_PKG_LIST 
yum autoremove -y 
yum clean all 




