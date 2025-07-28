#ifndef __BCM2711_UART_H__
#define __BCM2711_UART_H__

#include <stdint.h>

// Default UART0 clock
#define UARTCLK               (48000000)

// DR(Data Register) Register bits
#define UART_DATA               (0xFF)

// DR(Data Register) Register bits
#define UART_OE                 (0x01 << 11)
#define UART_BE                 (0x01 << 10)
#define UART_PE                 (0x01 << 9)
#define UART_FE                 (0x01 << 8)
#define UART_DATA               (0xFF)

#define UART_INVALID_DATA       (0xFFFFFFFF)

// CR(Control Register) Register bits
#define UART_RXE                (0x01 << 9)
#define UART_TXE                (0x01 << 8)
#define UART_UARTEN             (0x01)

// FR(Flag Register) Register bits
#define UART_TXFF               (0x01 << 5)
#define UART_RXFE               (0x01 << 4)

// LCRH(Line Control Register) Register bits
#define UART_WLEN_8BIT          (0x03 << 5)

void UART_Initialize(uint32_t baudrate);
void UART_SendWord(uint8_t data);

uint32_t UART_ReceiveWord();

#endif