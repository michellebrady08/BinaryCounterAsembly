.cpu cortex-m3      @ Generates Cortex-M3 instructions
.extern __main
.section .text
.align	1
.syntax unified
.thumb

.global check_speed

check_speed:
# Argumento: r5 = speed

    #prologue
        push    {r7} 
        sub     sp, sp, #4 
        add     r7, sp, #0 
        
        ##if speed ==1
        ldr     r1, =0x1
        cmp     r5, r1
        bne     L1
        ldr     r0, =10000
        b       epilogue
L1:     ## if speed==2
        ldr     r1, =0x2
        cmp     r5, r1
        bne     L2
        ldr     r0, =5000
        b       epilogue
L2:     ## if speed==4
        ldr     r1, =0x4
        cmp     r5, r1
        bne     L3
        ldr     r0, =2500
        b       epilogue
L3:     ## if speed==8
        ldr     r1, =0x8
        cmp     r5, r1
        bne     L4
        ldr     r0, =1250
        b       epilogue
L4:     ## else
        ldr     r0, =10000
epilogue:
        adds    r7, r7, #4
        mov     sp, r7
        pop	{r7}
        bx      lr
.size   check_speed, .-check_speed



