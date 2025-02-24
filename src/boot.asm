[BITS 16]
[ORG 0x7c00]


CODE_OFFSET equ 0x8
DATA_oFFSET equ 0x10

KERNEL_LOAD_SEG equ 0x1000

KERNEL_START_ADDR equ 0x100000



start:
    cli                 ;Clear interrupts
    mov ax, 0x00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00      ;stack pointer
    sti                 ;enable interrupts



;Change # 1...Changes made to the KERNEL Load function to add support for bigger KERNEls
;Loading Kernel Dynamically
mov bx, KERNEL_LOAD_SEG     ;Load Kernel at 0x1000:000
mov dh, 0x00                ;Start 0
mov dl, 0x80                ; First Hard disk
mov ch, 0x00                ; Cylinder 0
mov cl, 0x02                ; Start from Sector 2

mov si, 32                  ; Number of sectors to load (Will be adjusted according to the kernel)

disk_read_loop:
    mov ah, 0x02            ; BIOS Read Sector function
    mov al, 1               ; Read 1 Sector at a time
    int 0x13                ; call BIOS

    jc disk_read_error      ; if carry flag set, jump to error handler

    add bx, 512             ; Move buffer forward by 512 bytes
    inc cl                  ; move to next sector
    dec si                  ; Decrease sector count
    jnz disk_read_loop      ; repeat until all sectors are Read


load_PM:
    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or al, 1
    mov cr0, eax
    jmp CODE_OFFSET:PModeMain

disk_read_error:
    hlt


;GDT Implementation
gdt_start:
    dd 0x00000000
    dd 0x00000000


    ; Code Segment Decsriptor
    dw 0xFFFF           ;Limit
    dw 0x0000           ;Base
    db 0x00             ;Base
    db 10011010b        ;Access byte
    db 11001111b        ;Flags in Kbytes


   ; Data Segment Decsriptor
    dw 0xFFFF           ;Limit
    dw 0x0000           ;Base
    db 0x00             ;Base
    db 10010010b        ;Access byte
    db 11001111b        ;Flags in Kbytes
    db 0x00

gdt_end:


gdt_descriptor:
    dw gdt_end - gdt_start -1   ;Size of GDT -1
    dd gdt_start


[BITS 32]
PModeMain:
    mov ax, DATA_oFFSET
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov ss, ax
    mov gs, ax
    mov ebp, 0x9C00
    mov esp, ebp
    in al, 0x92
    or al, 2
    out 0x92, al
    jmp CODE_OFFSET:KERNEL_START_ADDR


times 510 - ($ - $$) db 0
dw 0xAA55               ;Little Endian Notation
