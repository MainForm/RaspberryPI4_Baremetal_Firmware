// Linker Script에서 사용하기 위해 .global로 _start 선언
.global _start

_start:
    // Linker Script에서 __stack_top의 값을 0번 레지스터에 저장
    LDR x0, =__stack_top
    // 0번 레지스터의 값(__stack_top)을 SP(Stack Pointer) 레지스터에 저장
    MOV sp, x0

    // Enable the FPU and the SIMD to make it possible to use floating-point
    // The FPU and the SIMD must be set when in the EL1 mode
    MRS     x0, cpacr_el1
    ORR     x0, x0, #(0b11 << 20)
    MSR     cpacr_el1, x0
    ISB

    // Clear the entire BSS section to 0.
    ADR     x1, __bss_start__
    ADR     X2, __bss_end__
    MOV     x0, #0
    clear_bss:
        CMP     x1, X2
        B.HS    done_clear
        STR     x0, [x1], #8
        B       clear_bss
    done_clear:

    // main.c 에 작성한 main 함수로 분기
    BL  main

    B   .