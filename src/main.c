#include "uart.h"

// 특정 시간동안 멈추기 위한 함수
void delay(volatile int val){
    while(val-- > 0);
}

int main(void){
    char * message = "hello world\n";
    UART_Initialize();

    while(1){
        for(int i = 0;message[i] != '\0';++i){
            UART_SendWord(message[i]);
        }
        delay(0x200000);
    }

    return 0;
}