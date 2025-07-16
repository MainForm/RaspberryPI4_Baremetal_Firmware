// Linker Script에서 사용하기 위해 .global로 _start 선언
.global _start

_start:
    // Linker Script에서 __stack_top의 값을 0번 레지스터에 저장
    LDR x0, =__stack_top
    // 0번 레지스터의 값(__stack_top)을 SP(Stack Pointer) 레지스터에 저장
    MOV sp, x0

    // main.c 에 작성한 main 함수로 분기
    BL  main

    B   .