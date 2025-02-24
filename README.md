# ☠️ DeadBoot – The Resilient Multi-Kernel Bootloader

DeadBoot is a **fast, lightweight, and unkillable** bootloader designed to load multiple kernels with style. Inspired by **Deadpool**, this bootloader refuses to crash, mocks bad configurations, and gives you total control over your OS selection. Whether you’re an **OS developer, security researcher, or someone who just loves breaking things**, DeadBoot has got your back.

---

## 🔥 Features

✅ **Multi-Kernel Support** – Select between different OS kernels at boot.  
✅ **BIOS-Based Boot Menu** – Simple keyboard-driven interface.  
✅ **Snarky Error Messages** – Because debugging should be fun.  
✅ **Optimized Kernel Loading** – Handles large kernels dynamically.  
✅ **Cybersecurity Ready** – Perfect for hacking, pentesting, and OS development.  

---

## ⚙️ Environment Setup

Before you can build **DeadBoot**, you need to set up a **cross-compilation toolchain** with **Binutils** and **GCC**.

### **1️⃣ Install Binutils**  
Download Binutils from [GNU FTP](https://ftp.gnu.org/gnu/binutils/) and follow these steps:

```sh
# Extract the binutils archive
tar -xvf binutils-x.y.z.tar.gz

# Navigate to the source directory
cd $HOME/src
mkdir build-binutils
cd build-binutils

# Configure and compile
../binutils-x.y.z/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install


# Extract the GCC archive
Download GCC from here: https://ftp.lip6.fr/pub/gcc/releases/
tar -xvf gcc-x.y.z.tar.gz

# Navigate to the source directory
cd $HOME/src

# Ensure Binutils is correctly installed
which -- $TARGET-as || echo $TARGET-as is not in the PATH

# Create a build directory for GCC
mkdir build-gcc
cd build-gcc

# Configure and compile
../gcc-x.y.z/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers --disable-hosted-libstdcxx
make all-gcc
make all-target-libgcc
make all-target-libstdc++-v3
make install-gcc
make install-target-libgcc
make install-target-libstdc++-v3
```

## ⚔️ Contributing

💀 If DeadBoot crashes your system, it’s your fault, not mine.
💀 If you find a bug, submit a PR or issue, but expect sarcasm in response.
💀 Want to add a feature? Fork it and make something even more ridiculous.
