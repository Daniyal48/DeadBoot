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

## 🚀 How It Works

1. DeadBoot loads from the **MBR (Master Boot Record)**.  
2. Displays a **menu** where you can choose a kernel.  
3. Reads the selected **kernel from disk** and loads it into memory.  
4. Switches to **Protected Mode** and hands over execution.  

It's **fast, flexible, and refuses to die** (unlike your system after a bad kernel update).  

---

## 📦 Installation

### **1️⃣ Build DeadBoot**
You'll need **NASM** and **QEMU** (or a real machine if you're feeling brave).  

```sh
nasm -f bin deadboot.asm -o deadboot.img
