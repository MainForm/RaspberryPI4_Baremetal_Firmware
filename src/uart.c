#include "bcm2711_peripheral.h"
#include "gpio.h"
#include "uart.h"

void UART_Initialize(){
    // 14 pin 과 15 pin를 UART의 Tx와 Rx로 사용하기 위한 GPIO 설정
    GPIO_SelectFunction(14,GPIO_FUNC_ALT0);
    GPIO_SelectFunction(15,GPIO_FUNC_ALT0);

    // UART설정을 위해 UART을 비활성화
    REG_32(BCM2711_UART0_CR) = 0x0;

    // Baudrate를 115200으로 설정
    REG_32(BCM2711_UART0_IBRD) = 26;
    REG_32(BCM2711_UART0_FBRD) = 3;

    // Parity bit 사용 안함, Stop bit는 1개, Word 길이는 8bit으로 설정
    REG_32(BCM2711_UART0_LCRH) = UART_WLEN_8BIT;

    // UART의 송신 수신 활성화 및 UART 통신 활성화
    REG_32(BCM2711_UART0_CR) = UART_TXE | UART_RXE | UART_UARTEN;
}

void UART_SendWord(uint8_t data){
    while(REG_32(BCM2711_UART0_FR) & UART_TXFF);

    REG_32(BCM2711_UART0_DR) = data;
}