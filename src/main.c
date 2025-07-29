#include "uart.h"

// 특정 시간동안 멈추기 위한 함수
void delay(volatile int val){
    while(val-- > 0);
}

// 현재 EL 모드를 확인하기 위한 함수
uint32_t getCurrentEL(){
    uint64_t el;
    /* CurrentEL 레지스터를 읽어 el에 저장 */
    asm volatile (
        "mrs %0, CurrentEL\n"
        : "=r" (el)
    );
    return (uint32_t)((el & 0b1100) >> 2);
}

int main(void){
    // UART 초기화
    UART_Initialize(115200);

    while(1){
        switch(getCurrentEL()){
            case 0: // EL0
                UART_SendString("EL0\n");
                break;
            case 1: // EL1
                UART_SendString("EL1\n");
                break;
            case 2: // EL2
                UART_SendString("EL2\n");
                break;
            case 3: // EL3
                UART_SendString("EL3\n");
                break;
            default:
                UART_SendString("Unknown EL\n");
        }
        delay(0x400000);
    }

    return 0;
}