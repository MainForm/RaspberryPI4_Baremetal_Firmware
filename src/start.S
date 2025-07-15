// Linker Script에서 사용하기 위해 .global로 _start 선언
.global _start

// GPIO 관련 레지스터의 베이스 주소
.equ GPIO_BASE,         0xFE200000
.equ GPFSEL2,           0x08  // 0xFE200008 = 0x08 + 0xFE200000
.equ GPSET0,            0x1c  // 0xFE20001c = 0x1c + 0xFE200000
.equ GPCLR0,            0x28  // 0xFE200028 = 0x28 + 0xFE200000

.equ GPIO_21_OUTPUT,    0x08  // 0b0000 1000 -> 5~3 bit : 001

.equ GPIOVAL,           0x200000  // 0x200000 == (1 << 21)
 
_start:
	// GPIO_BASE(0xFE200000) 값을 0번 레지스터에 저장
    ldr w0, =GPIO_BASE 

	// GPIO_21_OUTPUT(0x08) 값을 1번 레지스터에 저장
    ldr w1, =GPIO_21_OUTPUT 
    
    // 1번 레지스터의 값(0x08)를 GPFSEL2(0xFE200008 == 0번 레지스터(0xFE200000) + GPFSEL2(0x08))에 저장
    str w1, [x0, #GPFSEL2] 

	// 2번 레지스터에 0x800000을 저장
    // 2번 레지스터을 통해 딜레이 시간을 조절
    ldr w2, =0x800000

loop:
	// 1번 레지스터에 GPIOVAL의 값(0x200000)를 저장
    ldr w1, =GPIOVAL
    // 1번 레지스터의 값(0x200000)를 GPSET0(0xFE20001c == 0번 레지스터(0xFE200000) + GPSET0(0x1c))에 저장
    str w1, [x0, #GPSET0] 

	// 딜레이
    // 10번 레지스터의 값을 0으로 설정
    eor w10, w10, w10
    delay1:
    	// 10번 레지스터의 값을 1증가
        add w10, w10, #1
        // 10번 레지스터와 2번 레지스터의 값이 같은지 비교
        cmp w10, w2
        // 만약 10번 레지스터와 2번 레지스터가 같지 않다면 delay1로 이동
        bne delay1

	// 1번 레지스터에 GPIOVAL의 값(0x200000)를 저장
    ldr w1, =GPIOVAL
    // 1번 레지스터의 값(0x200000)를 GPSET0(0xFE200028 == 0번 레지스터(0xFE200000) + GPCLR0(0x28))에 저장
    str w1, [x0, #GPCLR0]  

    eor w10, w10, w10
    delay2:
        add w10, w10, #1
        cmp w10, w2
        bne delay2
	
    // loop로 이동하여 loop를 무한 반복
    b loop