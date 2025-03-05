[BITS 16]
[ORG 0x7C00]          ; Bootloader starts at 0x7C00 in memory (BIOS loads it here)

; Define segment offsets
CODE_OFFSET      equ 0x8
DATA_OFFSET      equ 0x10
KERNEL_LOAD_SEG  equ 0x1000
KERNEL_START_ADDR equ 0x100000  ; Kernel loads at 1MB

start:
    cli                  ; Disable interrupts
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00       ; Set stack pointer
    sti                  ; Enable interrupts

    ; Load Kernel from disk (BIOS INT 13h)
    mov bx, KERNEL_LOAD_SEG  ; Load kernel at 0x1000:0000
    mov dh, 0x00             ; Head 0
    mov dl, 0x80             ; First Hard disk
    mov ch, 0x00             ; Cylinder 0
    mov cl, 0x02             ; Start from Sector 2
    mov si, 64               ; Load 64 sectors (adjust for kernel size)

disk_read_loop:
    mov ah, 0x02             ; BIOS Read Sector function
    mov al, 1                ; Read 1 Sector at a time
    int 0x13                 ; Call BIOS

    jc disk_read_error       ; If error, jump to error handler

    add bx, 512              ; Move buffer forward by 512 bytes
    inc cl                   ; Move to next sector
    dec si                   ; Decrease sector count
    jnz disk_read_loop       ; Repeat until all sectors are read

    ; Load Global Descriptor Table (GDT)
load_PM:
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp CODE_OFFSET:PModeMain  ; Jump to protected mode

disk_read_error:
    hlt  ; Halt if disk read fails

; --------------- GDT Setup ----------------
gdt_start:
    dq 0x0000000000000000   ; Null Descriptor

    ; Code Segment Descriptor
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10011010b  ; Execute/Read
    db 11001111b
    db 0x00

    ; Data Segment Descriptor
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b  ; Read/Write
    db 11001111b
    db 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; Size of GDT - 1
    dd gdt_start                ; Address of GDT

[BITS 32]
PModeMain:
    mov ax, DATA_OFFSET
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov ss, ax
    mov gs, ax
    mov ebp, 0x9C00
    mov esp, ebp

    ; Enable A20 Line
    in al, 0x92
    or al, 2
    out 0x92, al

    ; Setup Paging and enable Long Mode
    call setup_paging
    jmp CODE_OFFSET:long_mode_start  ; Jump to 64-bit mode

; -------------- Paging Setup (64-bit) ----------------
setup_paging:
    ; Enable PAE (Physical Address Extension)
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    ; Load PML4 address into CR3
    mov eax, PML4_table
    mov cr3, eax

    ; Enable Long Mode (LME)
    mov ecx, 0xC0000080   ; EFER MSR
    rdmsr
    or eax, 1 << 8        ; Set Long Mode Enable (LME)
    wrmsr

    ; Enable Paging
    mov eax, cr0
    or eax, 1 << 31       ; Set PG bit (Paging enable)
    mov cr0, eax

    ret

[BITS 64]
long_mode_start:
    ; Load new GDT (64-bit)
    lgdt [gdt_descriptor]

    ; Set up segment registers
    mov ax, DATA_OFFSET
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Jump to kernel (loaded at 1MB)
    jmp KERNEL_START_ADDR

; ---------------- Page Tables (Moved to .bss Section) ----------------
section .bss
align 4096
PML4_table resq 512
PDPT_table resq 512
PD_table  resq 512
PT_table  resq 512

setup_paging_tables:
    mov rax, PDPT_table
    or rax, 0x3
    mov [PML4_table], rax

    mov rax, PD_table
    or rax, 0x3
    mov [PDPT_table], rax

    mov rax, PT_table
    or rax, 0x3
    mov [PD_table], rax

    mov rax, 0x200000  ; 2MB page
    or rax, 0x83       ; Present + RW + Huge Page
    mov [PT_table], rax

    ret

section .text
times 510 - ($ - $$) db 0  ; Pad to 512 bytes
dw 0xAA55                  ; Boot signature (Required by BIOS)
