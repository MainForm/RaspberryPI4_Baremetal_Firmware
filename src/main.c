#include "uart.h"

// 특정 시간동안 멈추기 위한 함수
void delay(volatile int val){
    while(val-- > 0);
}

int main(void){
    uint32_t recvData;

    // UART 초기화
    UART_Initialize();

    while(1){
        // UART로 데이터 수신
        recvData = UART_ReceiveWord();

        // 데이터 수신 중 에러가 발생하면 다음 데이터 수신
        if(recvData == UART_INVALID_DATA){
            continue;
        }

        // 데이터 다시 송신
        UART_SendWord((uint8_t)recvData);
    }

    return 0;
}