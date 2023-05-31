.cpu cortex-m3      @ Generates Cortex-M3 instructions
.include "systick_map.inc"
.extern __main
.section .text
.align	1
.syntax unified
.thumb
.global SysTick_Initialize


# Create funtion frame.

SysTick_Initialize:
        #prologue
        push    {r7} 
        sub     sp, sp, #4 
        add     r7, sp, #0 
# SYSTICK CONFIG
        # Set SysTick_CRL to disable SysTick IRQ and SysTick timer
        ldr     r0, =SYSTICK_BASE
        # Disable SysTick IRQ and SysTick counter, select external clock
        mov     r1, 0x0
        str     r1, [r0, STK_LOAD_OFFSET]
        # Specify the number of clock cycles between two interrupts
        ldr     r5, =1000000                @ Change it based on interrupt interval
        str     r5, [r0, STK_LOAD_OFFSET]   @ Save to SysTick reload register
        # Clear SysTick current value register (SysTick_VAL)
        mov     r1, #0
        str     r1, [r0, STK_VAL_OFFSET]    @ Write 0 to SysTick value register

        # Set SysTick_CRL to enable Systick timer and SysTick interrupt
        ldr     r1, [r0, STK_CTRL_OFFSET]
        orr     r1, r1, 3
        str     r1, [r0, STK_CTRL_OFFSET]

        # epilogue 
        adds    r7, r7, #4
        mov     sp, r7
        pop	{r7}
        bx      lr 

.size   SysTick_Initialize, .-SysTick_Initialize