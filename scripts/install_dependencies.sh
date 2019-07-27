#!/bin/bash

echo "Step 1.1: install dependencies"
sleep 1
apt-get update
apt-get install  ntp eog emacs gfortran libpng-dev libx11-dev libjpeg-dev libexif-dev git dos2unix sextractor

echo "Step 1.2: goto /usr/src"
sleep 1
cd /usr/src

echo "Step 2.1: download pgplot"
sleep 1
wget -c ftp://ftp.astro.caltech.edu/pub/pgplot/pgplot5.2.tar.gz

echo "Step 2.2: unpack pgplot"
sleep 1
gunzip -c pgplot5.2.tar.gz | tar xvf -

echo "Step 2.3: create pgplot directory"
sleep 1
mkdir -p /usr/src/pgplot-5.2.2

echo "Step 2.4: select drivers"
sleep 1
# Selecting PNDRIV, PSDRIV and XWDRIV
sed -e "s/! PNDRIV/  PNDRIV/g" -e "s/! PSDRIV/  PSDRIV/g" -e "s/! XWDRIV/  XWDRIV/g" pgplot/drivers.list >pgplot-5.2.2/drivers.list

echo "Step 2.5: create makefile"
sleep 1
cd /usr/src/pgplot-5.2.2
../pgplot/makemake ../pgplot linux g77_gcc

echo "Step 2.6: adjusting makefile"
sleep 1
sed -i -e "s/FCOMPL=g77/FCOMPL=gfortran/g" makefile
sed -i -e "s/FFLAGC=-u -Wall -fPIC -O/FFLAGC=-ffixed-form -ffixed-line-length-none -u -Wall -fPIC -O/g" makefile
sed -i -e "s|pndriv.o : ./png.h ./pngconf.h ./zlib.h ./zconf.h|pndriv.o : |g" makefile

echo "Step 2.7: run make"
sleep 1
make
make cpg

echo "Step 2.8: place libraries and header files"
sleep 1
rm -rf /usr/lib/libpgplot.a /usr/lib/libcpgplot.a /usr/lib/libpgplot.so /usr/include/cpgplot.h
ln -s /usr/src/pgplot-5.2.2/libpgplot.a /usr/lib/
ln -s /usr/src/pgplot-5.2.2/libpgplot.so /usr/lib/
ln -s /usr/src/pgplot-5.2.2/libcpgplot.a /usr/lib/
ln -s /usr/src/pgplot-5.2.2/cpgplot.h /usr/include/

echo "Step 2.9: clean up"
sleep 1
rm -rf /usr/src/pgplot5.2.tar.gz /usr/src/pgplot

echo "Step 3.1: download qfits"
sleep 1
cd /usr/src
wget -c ftp://ftp.eso.org/pub/qfits/qfits-5.2.0.tar.gz

echo "Step 3.2: unpack qfits"
sleep 1
gunzip -c qfits-5.2.0.tar.gz | tar xvf -

echo "Step 3.3: fix xmemory.c"
sleep 1
cd /usr/src/qfits-5.2.0
chmod +w src/xmemory.c
sed -i -e "s/swapfd = open(fname, O_RDWR | O_CREAT);/swapfd = open(fname, O_RDWR | O_CREAT, 0644);/g" src/xmemory.c

echo "Step 3.4: configure and make"
sleep 1
./configure
make
make install

echo "Step 3.5: clean up"
sleep 1
rm /usr/src/qfits-5.2.0.tar.gz

echo "Step 4.1: download wcslib-2.9"
sleep 1
cd /usr/src
wget -c "https://drive.google.com/uc?export=download&id=0B-15JZVdjJi4QW0zZmZUM1ZXblU" -O wcslib-2.9.tar
#wget -c http://www.epta.eu.org/~bassa/wcslib-2.9.tar

echo "Step 4.2: unpack wcslib"
sleep 1
tar -xvf wcslib-2.9.tar

echo "Step 4.3: compile wcslib"
sleep 1
cd /usr/src/wcslib-2.9/C/
make clean
rm libwcs_c.a
make

echo "Step 4.4: place libraries and header files"
sleep 1
rm -rf /usr/lib/libwcs_c.a /usr/include/proj.h /usr/include/cel.h
ln -s /usr/src/wcslib-2.9/C/libwcs_c.a /usr/lib/
ln -s /usr/src/wcslib-2.9/C/proj.h /usr/include/
ln -s /usr/src/wcslib-2.9/C/cel.h /usr/include/

echo "Step 4.5: clean up"
sleep 1
rm -rf /usr/src/wcslib-2.9.tar

echo "Step 5.1: download gsl"
sleep 1
cd /usr/src
wget -c ftp://ftp.gnu.org/gnu/gsl/gsl-1.16.tar.gz

echo "Step 5.2: unpack gsl"
sleep 1
gunzip -c gsl-1.16.tar.gz | tar xvf -

echo "Step 5.3: configure, make, make install"
sleep 1
cd /usr/src/gsl-1.16/
./configure
make 
make install

echo "Step 5.4: clean up"
sleep 1
rm -rf /usr/src/gsl-1.16.tar.gz

echo "Step 6.1: set ld.so.conf"
sleep 1
echo "include /etc/ld.so.conf.d/*.conf" >/etc/ld.so.conf
echo "/usr/lib" >>/etc/ld.so.conf
ldconfig

echo "Step 6.1: download fftw"
sleep 1
cd /usr/src
wget http://www.fftw.org/fftw-3.3.4.tar.gz

echo "Step 6.2: unpack fftw"
sleep 1
gunzip -c fftw-3.3.4.tar.gz | tar xvf -

echo "Step 6.3: configure, make,make install"
sleep 1
cd /usr/src/fftw-3.3.4
./configure --enable-float
make 
make install

echo "Step 6.4: clean up"
sleep 1
rm -rf /usr/src/fftw-3.3.4.tar.gz

echo "Done installing dependencies"
