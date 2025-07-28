#include "bcm2711_peripheral.h"
#include "gpio.h"
#include "uart.h"

void UART_Initialize(uint32_t baudrate){
    // 14 pin 과 15 pin를 UART의 Tx와 Rx로 사용하기 위한 GPIO 설정
    GPIO_SelectFunction(14,GPIO_FUNC_ALT0);
    GPIO_SelectFunction(15,GPIO_FUNC_ALT0);

    // UART설정을 위해 UART을 비활성화
    REG_32(BCM2711_UART0_CR) = 0x0;

    // Baudrate를 설정
    double BRD = (UARTCLK)/(16.0 * baudrate);
    REG_32(BCM2711_UART0_IBRD) = (uint32_t)BRD; // Integer part

    BRD -= (uint32_t)BRD;
    REG_32(BCM2711_UART0_FBRD) = (uint32_t)(BRD * 64.0 + 0.5);

    // Baudrate를 115200으로 설정

    // Parity bit 사용 안함, Stop bit는 1개, Word 길이는 8bit으로 설정
    REG_32(BCM2711_UART0_LCRH) = UART_WLEN_8BIT;

    // UART의 송신 수신 활성화 및 UART 통신 활성화
    REG_32(BCM2711_UART0_CR) = UART_TXE | UART_RXE | UART_UARTEN;
}

void UART_SendWord(uint8_t data){
    // UART Tx 버퍼에 남은 메모리 공간이 있는지 확인
    while(REG_32(BCM2711_UART0_FR) & UART_TXFF);

    // 데이터 송신
    REG_32(BCM2711_UART0_DR) = data;
}

void UART_SendString(const char * str){
    while(*str != '\0'){
        UART_SendWord((uint8_t)*str);

        ++str;
    }
}

uint32_t UART_ReceiveWord(){
    // UART Rx 버퍼 수신 해야할 데이터가 있는 경우
    while(REG_32(BCM2711_UART0_FR) & UART_RXFE);

    // UART Rx 버퍼로 부터 word 길이의 데이터 수신
    uint32_t DataRegValue = REG_32(BCM2711_UART0_DR);
    // 만약 해당 데이터를 수신하는 동안 에러가 발생한 경우
    if(DataRegValue & (UART_OE | UART_BE | UART_PE | UART_FE)){
        // 에러 코드 리턴
        return UART_INVALID_DATA;
    }

    // 정상적으로 수신된 데이터 리턴
    return DataRegValue & UART_DATA;
}