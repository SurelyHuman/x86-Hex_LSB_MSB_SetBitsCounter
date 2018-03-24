;-------------------------------------------------------------------------------
;Seth Lewis
;CIS 330-2F/330L-7F Program 3
;2-23-2018
;
;Program to find the set bits, least significant bit, and most significant bit
;of a user entered 32 bit hexadecimal number
;
;Revision History:
;2-16-18 first attempt added scanning of hex into program and tested carry loop
;2-17-18 added comparison using maximum and minimum values for MSB and LSB
;2-18-18 successful implementation using known test data no_carry loop and main
;loops issues with registers solved all results correct (no zero test)
;2-23-28 zero test performed added initial comparison to jump if user enters
;zero to give correct output program complete
;
;-------------------------------------------------------------------------------

global main

extern printf
extern scanf

section .bss ; uninitialized data

a: resd 1 ; input value

section .rodata ; read only data

prompt: db "Enter a 32 bit hexadecimal number:", 0xA, 0x0
you_entered: db "You entered: %x", 0xA, 0x0
lsb: db "LSB: %d", 0xA, 0x0
msb: db "MSB: %d", 0xA, 0x0
set_bits: db "Bits set: %d", 0xA, 0x0

fmt: db "%x", 0x0

section .text ; executable code

main:

  mov edi, prompt
  mov eax, 0 ; no xmm registers
  call printf

  mov edi, fmt
  mov esi, a
  mov eax, 0
  call scanf

  mov edi, you_entered ; print to verify correctness
  mov esi, [a]
  mov eax, 0
  call printf

  mov esi, [a] ; esi used in place of eax when not using readhex
  mov ebx, 32 ; contains LSB
  mov ebp, 0  ; contains MSB
  mov eax, 0  ; contains number of set bits
  mov ecx, 0  ; contains loop counter

  cmp esi, 0 ; check if user entered zero
  je .zero

.loop:
  sar esi, 1 ; arithmetic bit shift right to preserve sign if needed
  jnc .no_carry ; do not set MSB, LSB, or increasing set bits if no carry flag
  mov ebp, ecx ; loop counter is current MSB
  inc eax ; increment set bits
  cmp ecx, ebx ; compare loop counter to LSB
  jg .no_carry ; if loop counter is greater than LSB do not set LSB
  mov ebx, ecx ; else set LSB to first carry flag

.no_carry:
  inc ecx ; increment loop counter
  cmp ecx, 32 ; compare to max bit length
  je .continue ; if equal jump to end
  jmp .loop ; else jump back to start of loop

.zero:
  mov ebx, 0 ; make sure LSB is zero when zero entered by user

.continue:
  mov edi, set_bits ; print number of set bits
  mov esi, eax ; printed first to avoid erasure
  mov eax, 0
  call printf

  mov edi, lsb ; print LSB
  mov esi, ebx
  mov eax, 0
  call printf

  mov edi, msb ; print MSB
  mov esi, ebp
  mov eax, 0
  call printf

  ret
