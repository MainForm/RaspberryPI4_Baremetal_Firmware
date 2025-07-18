#ifndef _BCM2711_PERIPHERAL_H
#define _BCM2711_PERIPHERAL_H

// uint32_t를 사용하기 위한 헤더 선언
#include <stdint.h>

// 레지스터 주소에 접근하기 위한 매크로
#define REG_32(SOURCE)          (*((volatile uint32_t*)SOURCE))

// BCM2711 GPIO register definitions
#define BCM2711_GPIO_BASE                   (0xFE200000)
#define BCM2711_GPIO_GPFSEL0                ((volatile uint32_t *)(BCM2711_GPIO_BASE + 0x00))
#define BCM2711_GPIO_GPFSEL1                ((volatile uint32_t *)(BCM2711_GPIO_BASE + 0x04))
#define BCM2711_GPIO_GPFSEL2                ((volatile uint32_t *)(BCM2711_GPIO_BASE + 0x08))
#define BCM2711_GPIO_GPFSEL3                ((volatile uint32_t *)(BCM2711_GPIO_BASE + 0x0C))
#define BCM2711_GPIO_GPFSEL4                ((volatile uint32_t *)(BCM2711_GPIO_BASE + 0x10))
#define BCM2711_GPIO_GPFSEL5                ((volatile uint32_t *)(BCM2711_GPIO_BASE + 0x14))
#define BCM2711_GPIO_GPSET0                 ((volatile uint32_t *)(BCM2711_GPIO_BASE + 0x1C))
#define BCM2711_GPIO_GPSET1                 ((volatile uint32_t *)(BCM2711_GPIO_BASE + 0x20))
#define BCM2711_GPIO_GPCLR0                 ((volatile uint32_t *)(BCM2711_GPIO_BASE + 0x28))
#define BCM2711_GPIO_GPCLR1                 ((volatile uint32_t *)(BCM2711_GPIO_BASE + 0x2C))

// BCM2711 UART0 register definitions
#define BCM2711_UART0_BASE                  (0xFE201000)
#define BCM2711_UART0_DR                    ((volatile uint32_t *)(BCM2711_UART0_BASE + 0x00))
#define BCM2711_UART0_FR                    ((volatile uint32_t *)(BCM2711_UART0_BASE + 0x18))
#define BCM2711_UART0_IBRD                  ((volatile uint32_t *)(BCM2711_UART0_BASE + 0x24))
#define BCM2711_UART0_FBRD                  ((volatile uint32_t *)(BCM2711_UART0_BASE + 0x28))
#define BCM2711_UART0_LCRH                  ((volatile uint32_t *)(BCM2711_UART0_BASE + 0x2C))
#define BCM2711_UART0_CR                    ((volatile uint32_t *)(BCM2711_UART0_BASE + 0x30))
#define BCM2711_UART0_IFLS                  ((volatile uint32_t *)(BCM2711_UART0_BASE + 0x34))
#define BCM2711_UART0_IMSC                  ((volatile uint32_t *)(BCM2711_UART0_BASE + 0x38))
#define BCM2711_UART0_MIS                   ((volatile uint32_t *)(BCM2711_UART0_BASE + 0x40))
#define BCM2711_UART0_ICR                   ((volatile uint32_t *)(BCM2711_UART0_BASE + 0x44))

#endif