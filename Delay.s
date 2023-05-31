.cpu cortex-m3      @ Generates Cortex-M3 instructions
.extern __main
.section .text
.align	1
.syntax unified
.thumb

.global delay

# Argumento: r0 = TimeDelay
delay:
    #prologue
        push    {r7} 
        sub     sp, sp, #4 
        add     r7, sp, #0 
        #str     r0, [r7]
        #ldr     r10, [r7]
        mov     r10, r0 
delay_loop:
        cmp     r10, #0
        bne     delay_loop
    #epilogue
        adds    r7, r7, #4
        mov     sp, r7
        pop	{r7}
        bx      lr

