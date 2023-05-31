.cpu cortex-m3      @ Generates Cortex-M3 instructions
.extern __main
.section .text
.align	1
.syntax unified
.thumb
.global SysTick_Handler

.include "gpio_map.inc"
# r4 -> holds counter
# r6 -> holds mode

SysTick_Handler:
# NVIC automaticamente apila 8 registros: r0-r3, r12, lr, psr y pc
    # First we check the mode value
        sub     r10, r10, #1
        bx lr   

.size   SysTick_Handler, .-SysTick_Handler

