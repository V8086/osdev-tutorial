# update and install packages
sudo apt-get update && sudo apt-get upgrade
	
# (optional) remove the daily login message (MOTD)
touch ~/.hushlogin

# install NASM
sudo apt-get install nasm
	
# check that NASM is installed (the output should be like this: `NASM version X.XX.XX`)
nasm -v
	
sudo apt-get install build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo
	
mkdir -p ~/src
cd ~/src
	
# download binutils 2.43 and gcc 12.1.0, then unpack
wget https://ftp.gnu.org/gnu/binutils/binutils-2.43.tar.xz
wget https://ftp.gnu.org/gnu/gcc/gcc-12.1.0/gcc-12.1.0.tar.xz
tar -xJf ./binutils-2.43.tar.xz
tar -xJf ./gcc-12.1.0.tar.xz
cd ../

# set variables
export TARGET=i686-elf	# target arch
export PREFIX="$HOME/opt/cross"	# installation path
export PATH="$PREFIX/bin:$PATH"
	
# write variables to ~/.bashrc so that they are available after exit
echo "export TARGET=$TARGET" >> ~/.bashrc
echo "export PREFIX=\"$HOME/opt/cross\"" >> ~/.bashrc
echo "export PATH=\"\$PREFIX/bin:\$PATH\"" >> ~/.bashrc
	
mkdir -p ~/build
cd ~/build

# compile binutils
mkdir ./build-binutils
cd ./build-binutils
../../src/binutils-2.43/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install
cd ../
	
# compile gcc
mkdir ./build-gcc
cd ./build-gcc
../../src/gcc-12.1.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers --disable-hosted-libstdcxx
make all-gcc
make all-target-libgcc
make all-target-libstdc++-v3
make install-gcc
make install-target-libgcc
make install-target-libstdc++-v3
	
# check that GCC is installed
$TARGET-gcc --version
