
// 32bit을 저장하기 위한 자료형 선언
typedef unsigned int uint32_t;

// BCM2711 GPIO 레지스터 주소
#define BCM2711_GPIO_BASE       (0xFE200000)
#define BCM2711_GPIO_GPFSEL2    (BCM2711_GPIO_BASE + 0x08)
#define BCM2711_GPIO_GPSET0     (BCM2711_GPIO_BASE + 0x1C)
#define BCM2711_GPIO_GPCLR0     (BCM2711_GPIO_BASE + 0x28)

// 레지스터 주소에 접근하기 위한 매크로
#define REG_32(SOURCE)          (*((volatile uint32_t*)SOURCE))

// 특정 시간동안 멈추기 위한 함수
void delay(volatile int val){
    while(val-- > 0);
}

int main(void){
    // GPFSEL2 레지스터에서 5~3번 레지스터를 0b001로 설정하여 21 Pin를 Output으로 설정
    REG_32(BCM2711_GPIO_GPFSEL2) |= 0x01 << 3;

    while(1){
        // GPSET0에서 21번 bit를 1로 설정, 21 Pin를 High로 출력
        REG_32(BCM2711_GPIO_GPSET0) |= (0x01 << 21);
        // 적당한 시간 동안 딜레이
        delay(0x200000);

        // GPCLR0에서 21번 bit를 1로 설정, 21 Pin를 Low로 출력
        REG_32(BCM2711_GPIO_GPCLR0) |= (0x01 << 21);
        delay(0x200000);
    }

    return 0;
}