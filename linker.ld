ENTRY(_start)

SECTIONS
{
    . = 0x80000;

    .text : { 
        *(.text*) 
    }

    .rodata : { 
        *(.rodata*) 
    }

    .data : { 
        *(.data*) 
    }

    .bss : { 
        __bss_start__ = .;
        *(.bss*) *(COMMON) 
        __bss_end__ = .;
    }

    /* ALIGN(16)으로 스택 섹션의 시작 주소를 16Byte의 배수로 설정 */
    .stack : ALIGN(16) {
        /*  __stack_bottom :  스택의 마지막 주소 */
        __stack_bottom = .;
        /* stack의 크기 : 64Kb */
        . = . + (64K);
        /*  __stack_top :  스택의 시작 주소 */
        __stack_top = .;
    }
}