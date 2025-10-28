#!/bin/bash

## Install and Remove conflicting dependencies 

sudo dnf install python3-pip -y
sudo dnf remove python3-requests python-urllib3 -y

## Install LD GOLD 
sudo dnf install gmp-devel mpfr-devel texinfo bison git gcc-c++ -y
mkdir ld.gold && cd ld.gold
git clone --depth 1 git://sourceware.org/git/binutils-gdb.git binutils
mkdir build && cd build
../binutils/configure --enable-gold --enable-plugins --disable-werror
make all-gold
cd gold
make all-am
cd ..
cp gold/ld-new /usr/bin/ld.gold
cd ~
/usr/bin/ld.gold -v

## Install Swift build dependencies
sudo dnf -y install     \
  clang            \
  cmake            \
  curl-devel       \
  gcc-c++          \
  git              \
  glibc-static     \
  libbsd-devel     \
  libedit-devel    \
  libicu-devel     \
  libuuid-devel    \
  libxml2-devel    \
  ncurses-devel    \
  ninja-build      \
  python3-pexpect  \
  pkgconfig        \
  procps-ng        \
  python           \
  python3-devel    \
  python3-six      \
  python3-psutil   \
  python3-pkgconfig \
  rsync            \
  sqlite-devel     \
  swig             \
  tzdata           \
  unzip            \
  uuid-devel       \
  wget             \
  which            \
  zip

mkdir swift-project && cd swift-project   
git clone https://github.com/apple/swift.git swift
cd swift
./utils/update-checkout --clone

## Create an EBS snapshot or an AMI at this point because the above takes ~30 minutes

## Build Instructions 

## Specify the release you want to build
SWIFT_VERSION=6.2

./utils/update-checkout --scheme release/$SWIFT_VERSION

## IMPORTANT : to build a version >= 5.9, you must install swift 5.8 and make sure `swift` is in the PATH

## Building 
# simple build
# ./utils/build-script --release-debuginfo --skip-early-swift-driver
# or 
# build and package
./utils/build-script --preset=buildbot_linux,no_assertions,no_test install_destdir=/tmp installable_package=/tmp/swift-${SWIFT_VERSION}-amazonlinux2023.tar.gz

## Cleaning in between builds
rm -rf ../build
rm -rf /tmp/usr 