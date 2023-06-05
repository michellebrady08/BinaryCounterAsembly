.cpu cortex-m3      @ Generates Cortex-M3 instructions
.extern __main
.include "exti_map.inc"
.include "nvic_reg_map.inc"
.section .text
.align	1
.syntax unified
.thumb
.global EXTI0_3_Handler

EXTI0_3_Handler:
    ldr     r0, =EXTI_BASE
    ldr     r0, [r0, EXTI_PR_OFFSET]
    ldr     r1, =0x1
    cmp     r0, r1                  @ if EXTI 0 bit is set
    beq     EXTI0_Handler
    ldr     r1, =0x8                @ if EXTI 3 bit is set
    cmp     r0, r1
    beq     EXTI3_Handler
    bx      lr

// If button 0 is pressed we speed the systick interrupt frequency
.size   EXTI0_3_Handler, .-EXTI0_3_Handler

.section .text
.align	1
.syntax unified
.thumb
.global EXTI0_Handler
EXTI0_Handler:
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
        orr     r1, r1, 0x40
        str     r1, [r0, EXTI_PR_OFFSET]
        bx      lr

 .size   EXTI0_Handler, .-EXTI0_Handler

# r6 -> holds mode 
.section .text
.align	1
.syntax unified
.thumb
.global EXTI3_Handler
EXTI3_Handler:

        ## if (mode!=0)
        mov     r1, r6
        eor     r1, r1, 1
        and     r1, r1, 0x1  
        mov     r6, r1
        ldr     r0, =EXTI_BASE
        ldr     r2, [r0, EXTI_PR_OFFSET]
        orr     r2, r2, 0x200             @ Clear the EXTI3 pending flag
        str     r2, [r0, EXTI_PR_OFFSET]
 
        bx      lr 

.size   EXTI3_Handler, .-EXTI3_Handler


