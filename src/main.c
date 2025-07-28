#include "uart.h"

// 특정 시간동안 멈추기 위한 함수
void delay(volatile int val){
    while(val-- > 0);
}

int test;

int main(void){
    uint32_t recvData;

    // UART 초기화
    UART_Initialize(115200);

    while(1){
        if(test == 0){
            UART_SendWord('0');
        }
        else{
            UART_SendWord('1');
        }
        UART_SendWord('\n');
        delay(0x400000);
    }

    return 0;
}