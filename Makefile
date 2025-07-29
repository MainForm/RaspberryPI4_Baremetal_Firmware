ARCH = armv8-a
MCPU = cortex-a72

TOOLCHAIN_PREFIX = aarch64-none-elf
AS = $(TOOLCHAIN_PREFIX)-as
CC = $(TOOLCHAIN_PREFIX)-gcc
LD = $(TOOLCHAIN_PREFIX)-ld
GDB = $(TOOLCHAIN_PREFIX)-gdb
OBJCOPY = $(TOOLCHAIN_PREFIX)-objcopy

QEMU := qemu-system-aarch64
QEMU_FLAG := -nographic
QEMU_RAM_SIZE := 2G
QEMU_MACHINE_NAME := raspi4b
QEMU_DEBUG_FLAG := -S -gdb tcp::1234,ipv4

LD_SCRIPT = linker.ld

INCLUDE_DIRS = -Iinclude

ASFLAG = -c -g
CFLAG  = -c -g -Wall

BUILD_DIR = build

SRC_DIR = src

AS_SRCS = $(shell find $(SRC_DIR) -name '*.S')
AS_OBJS = $(AS_SRCS:$(SRC_DIR)/%.S=$(BUILD_DIR)/%.os)

C_SRCS = $(shell find $(SRC_DIR) -name '*.c')
C_OBJS = $(C_SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)

TARGET = image
ELF_FILE = kernel.elf

FIRMWARE_DIR = firmware

.PHONY: all clean qemu_run

all: $(TARGET)

$(TARGET): $(ELF_FILE)
	@mkdir -p $(BUILD_DIR)/output
	$(OBJCOPY) -O binary $(BUILD_DIR)/$< $(BUILD_DIR)/output/$@
	cp $(FIRMWARE_DIR)/* $(BUILD_DIR)/output/

$(ELF_FILE): $(AS_OBJS) $(C_OBJS)
	@mkdir -p $(BUILD_DIR)
	$(LD) -T $(LD_SCRIPT) -o $(BUILD_DIR)/$@ $^

$(AS_OBJS): $(BUILD_DIR)/%.os: $(SRC_DIR)/%.S
	@mkdir -p $(dir $@)
	$(CC) -march=$(ARCH) -mcpu=$(MCPU) $(ASFLAG) $(INCLUDE_DIRS) -o $@ $<

$(C_OBJS): $(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) -march=$(ARCH) -mcpu=$(MCPU) $(CFLAG) $(INCLUDE_DIRS) -o $@ $<

qemu_run: $(TARGET)
	$(QEMU) -M $(QEMU_MACHINE_NAME) -m $(QEMU_RAM_SIZE) -kernel $(BUILD_DIR)/output/$(TARGET) $(QEMU_FLAG)

qemu_debug: $(TARGET)
	$(QEMU) -M $(QEMU_MACHINE_NAME) -m $(QEMU_RAM_SIZE) -kernel $(BUILD_DIR)/output/$(TARGET) $(QEMU_FLAG) $(QEMU_DEBUG_FLAG)

gdb:
	$(GDB) -ex "file $(BUILD_DIR)/$(ELF_FILE)" 	\
		-ex "target remote localhost:1234"	\
		-ex "layout asm"					\
		-ex "layout regs"					\
		-ex "break _start"					\
		-ex "continue"

clean:
	@rm -rf $(BUILD_DIR)
