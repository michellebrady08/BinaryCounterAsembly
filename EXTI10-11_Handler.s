.cpu cortex-m3      @ Generates Cortex-M3 instructions
.extern __main
.include "exti_map.inc"
.section .text
.align	1
.syntax unified
.thumb
.global EXTI15_10_Handler

EXTI15_10_Handler:
        ldr r0, =EXTI_BASE
        ldr r0, [r0, EXTI_PR_OFFSET]
        ldr r1, =0x00000400
        cmp r0, r1 
        beq EXTI10_Handler
        ldr r1, =0x00000800
        cmp r0, r1 
        beq EXTI11_Handler
 

EXTI10_Handler:
        ## if(speed != 8)
        mov     r1, r5
        cmp     r1, #8             
        beq     x1   
        ## speed = speed*2          
        lsls    r1, r1, #1
        mov     r5, r1
        b       end
        ## else
x1:
        ## speed = 1;
        mov    r5, #1
end:
        
        ldr     r0, =EXTI_BASE
        ldr     r1, [r0, EXTI_PR_OFFSET]
        orr     r1, r1, 0x400
        str     r1, [r0, EXTI_PR_OFFSET]
        bx      lr 

EXTI11_Handler:
        eor     r6, r6, 1
        and     r6, r6, 0x1
        ldr     r0, =EXTI_BASE
        ldr     r2, [r0, EXTI_PR_OFFSET] 
        orr     r2, r2, 0x800
        str     r2, [r0, EXTI_PR_OFFSET] 
        bx      lr

.size   EXTI15_10_Handler, .-EXTI15_10_Handler

