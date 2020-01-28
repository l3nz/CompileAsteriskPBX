

JANUS_DIR=/opt/janus
TARGET_DIR=/usr/src/


JANUS_TAG=master
JANUS_GIT=https://github.com/meetecho/janus-gateway.git
JANUS_PKG=janus_${JANUS_TAG}

SOFIA_VER=1.12.11
SOFIA_PKG=sofia-sip-${SOFIA_VER}
SOFIA_URL=https://downloads.sourceforge.net/project/sofia-sip/sofia-sip/${SOFIA_VER}/sofia-sip-${SOFIA_VER}.tar.gz

#LIBSRTP_VER=1.5.4
LIBSRTP_VER=2.0.0
LIBSRTP_TGZ=v${LIBSRTP_VER}.tar.gz
LIBSRTP_PKG=libsrtp-${LIBSRTP_VER}
LIBSRTP_URL=https://github.com/cisco/libsrtp/archive/${LIBSRTP_TGZ}

USRSCTP_TAG=master
USRSCTP_GIT=https://github.com/sctplab/usrsctp
USRSCTP_PKG=usrsctp_${USRSCTP_TAG}

# The GitHub mirror is more reliable
LIBWEBSOCK_TAG=master
#LIBWEBSOCK_GIT=https://libwebsockets.org/repo/libwebsockets
LIBWEBSOCK_GIT=https://github.com/warmcat/libwebsockets.git
LIBWEBSOCK_PKG=libwebsockets_${LIBWEBSOCK_TAG}

FFMPEG_TAG=master
FFMPEG_GIT=https://github.com/FFmpeg/FFmpeg.git
FFMPEG_PKG=ffmpeg_${FFMPEG_TAG}

LIBNICE_TAG=master
LIBNICE_GIT=https://github.com/libnice/libnice.git
LIBNICE_PKG=libnice_${LIBNICE_TAG}



DEV_PKG_LIST="pkgconfig \
			git \
			gengetopt \
			libconfig-devel \
			libtool \
			autoconf \
			automake \
			cmake \
			gcc \
			gcc-c++ \
			patch \
			nasm \
			npm \
			wget \
			gtk-doc"
			
RUN_PKG_LIST="libmicrohttpd-devel \
			jansson-devel \
			openssl-devel \
			libsrtp-devel \
			glib2-devel \
			opus-devel \
			libogg-devel \
			libcurl-devel \
			lua-devel \
			luajit-devel \
			lua-json \
			luarocks "

# install dependencies
yum -q makecache
yum install tar epel-release -y 
yum install -y $DEV_PKG_LIST $RUN_PKG_LIST
mkdir -p $TARGET_DIR


#
# Non-packaged deps
#


cd $TARGET_DIR
wget ${SOFIA_URL}
tar zxvf ${SOFIA_PKG}.tar.gz
cd ${SOFIA_PKG}
./configure --libdir=/usr/lib64 
make && make install



cd $TARGET_DIR
rm -rf ${LIBSRTP_TGZ} ${LIBSRTP_PKG}
wget ${LIBSRTP_URL}
tar zxvf ${LIBSRTP_TGZ}
cd ${LIBSRTP_PKG}
./configure --enable-openssl --libdir=/usr/lib64
make shared_library && make install


cd $TARGET_DIR
git clone --branch=${USRSCTP_TAG} ${USRSCTP_GIT} ./${USRSCTP_PKG} 
cd ./${USRSCTP_PKG}
./bootstrap
./configure --libdir=/usr/lib64
make && make install


cd $TARGET_DIR
git clone --branch=${LIBWEBSOCK_TAG} ${LIBWEBSOCK_GIT} ./${LIBWEBSOCK_PKG}
cd ${LIBWEBSOCK_PKG}
mkdir __build__
cd __build__
cmake -DLWS_MAX_SMP=1 \
      -DCMAKE_INSTALL_PREFIX:PATH=/usr \
      -DLIB_SUFFIX=64 \
      -DCMAKE_C_FLAGS="-fpic" \
      ..
make && make install


cd $TARGET_DIR
git clone --branch=${FFMPEG_TAG} ${FFMPEG_GIT} ./${FFMPEG_PKG}
cd ${FFMPEG_PKG}
./configure --disable-programs --libdir=/usr/lib64
make && make install


cd $TARGET_DIR
git clone --branch=${LIBNICE_TAG} ${LIBNICE_GIT} ./${LIBNICE_PKG}
cd ${LIBNICE_PKG}
./autogen.sh
./configure --libdir=/usr/lib64
make && make install

#
# lua deps
#

luarocks install ansicolors


#
# Janus
#

cd $TARGET_DIR
git clone ${JANUS_GIT} ./${JANUS_PKG}
cd ${JANUS_PKG}
./autogen.sh
./configure --prefix=${JANUS_DIR} \
            --enable-data-channels \
            --enable-libsrtp2 \
            --enable-rest \
            --enable-websockets \
            --enable-unix-sockets \
            --enable-turn-rest-api \
            --enable-plugin-lua \
            --enable-plugin-recordplay \
            --enable-plugin-sip \
            --enable-plugin-duktape \
            --enable-all-js-modules \
            --enable-plugin-streaming \
			--enable-plugin-textroom \
			--enable-plugin-videocall \
			--enable-plugin-videoroom \
			--enable-plugin-voicemail \
            --enable-post-processing

make && make install 
make configs

# cd /opt/janus
# ./bin/janus

