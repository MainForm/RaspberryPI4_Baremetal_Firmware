.section .text

// Linker Script에서 사용하기 위해 .global로 _start 선언
.global _start

// 라즈베리파이4는 El2으로 시작함
_start:
    // 임시 스택 포인트 설정
    LDR     x0, =__stack_top
    MOV     sp, x0

    // HCR_EL2: Hypervisor Configuration Register
    // EL1에서 AArch64 모드 허용
    MOV     x0, #(1 << 31)
    MSR     hcr_el2, x0
    ISB

    // EL1에서 사용할 스택 포인터 메모리 설정
    LDR     x0, =__stack_top
    MSR     sp_el1, x0
    ISB

    // SPSR_EL2: Saved Program Status Register for EL2
    // EL1 모드로 진입하기 위해 EL2에서 SPSR_EL2 설정
    MOV     x0, #(0b0101)
    MSR     spsr_el2, x0
    ISB

    // ELR_EL2: Exception Link
    LDR     x0, =prev_main
    MSR     elr_el2, x0
    ISB

    // 위 설정한 내용을 토대로 EL2에서 EL1으로 전환
    ERET


.global prev_main
prev_main:
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

halt:
    wfe
    B   halt
