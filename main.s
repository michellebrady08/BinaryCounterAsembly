
.thumb              @ Assembles using thumb mode
.cpu cortex-m3      @ Generates Cortex-M3 instructions
.syntax unified

.include "ivt.s"
.include "gpio_map.inc"
.include "rcc_map.inc"
.include "scb_map.inc"
.include "afio_map.inc"
.include "exti_map.inc"
.include "nvic_reg_map.inc"
.include "systick_map.inc"

.extern check_speed
.extern SysTick_Handler
.extern delay
.extern EXTI0_3_Handler
#.extern EXTI0_Handler

.section .text
.align 1
.syntax unified
.thumb

.global __main

# r4 -> counter
# r5 -> Speed
# r6 -> mode

__main:

        push	{r7, lr}                                @ create frame
	sub	sp, sp, #8
	add	r7, sp, #0  

        # enabling clock in port B
        ldr     r0, =RCC_BASE                      @ move 0x40021018 to r0
        mov     r3, 0x8                                @ loads 8 in r1 to enable clock in port B (IOPB bit)
        str     r3, [r0, RCC_APB2ENR_OFFSET]                                @ M[RCC_APB2ENR] gets 8

        b       EXTIx_Initialize
        b       SysTick_Initialize

        # set pin 8-15 as digital output
        ldr     r0, =GPIOB_BASE                      @ moves address of GPIOB_CRH register to r0
        ldr     r3, =0x33333333                         @ PB15 output push-pull, max speed 50 MHz
        str     r3, [r0, GPIOx_CRH_OFFSET]                                @ M[GPIOB_CRH] gets 

        # set pin 6-7 as digital input and pin 0 and 3 as digital input
        ldr     r3, =0x33448448                         @ PB0: input
        str     r3, [r0, GPIOx_CRL_OFFSET]
        # conf
        mov     r3, #0
        str     r3, [r0, GPIOx_ODR_OFFSET]

        ldr     r4, =0x0                              @ counter initial value 
        ldr     r5, =0x2
        ldr     r6, =0x0
        

loop:
        ## Delay = check_speed();
        bl       check_speed
        mov     r10, r0
        ## if mode ==0;
        ldr     r1, =0
        cmp     r6, r1
        bne     _sub
        add     r4, r4, #1          @ Increment the value by 1 (or adjust as needed)
        b       _show
        ## else
_sub:   
        sub     r4, r4, #1
        ## Output (counter);
_show:  mov     r1, r4
        lsls    r1, r1, #6
        ldr     r0, =GPIOB_BASE
        str     r1, [r0, GPIOx_ODR_OFFSET]
        ## wait (delay);
        bl       delay 

        b       loop


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

EXTIx_Initialize:
        #prologue
        push    {r7} 
        sub     sp, sp, #4 
        add     r7, sp, #0 
      

        #SELECT PB.3 AS THE TRIGGER SOURCE OF EXTI 3
        ldr     r0, =AFIO_BASE
        eor     r1, r1
        str     r1, [r0, AFIO_EXTICR1_OFFSET]

        #DISABLE RISING EDGE TRIGGER FOR EXTI 0 and 3
        ldr     r0, =EXTI_BASE
        eor     r1, r1               
        str     r1, [r0, EXTI_FTST_OFFSET]
        #DISABLE FALLING EDGE TRIGGER FOR EXTI 0 and 3
        ldr     r1, =9
        str     r1, [r0, EXTI_FTST_OFFSET]
        str     r1, [r0, EXTI_IMR_OFFSET]

        #ENABLE EXTI 0 and 3 INTERUPT
        ldr     r0, =NVIC_BASE
        orr     r1, r1, #576                    @ store a 1 on the enable bit for the exti interrupt 3
        str     r1, [r0, NVIC_ISER0_OFFSET] 
        # epilogue 
        adds    r7, r7, #4
        mov     sp, r7
        pop	{r7}
        bx      lr 
        
