ARCH = armv8-a
MCPU = cortex-a72

TOOLCHAIN_PREFIX = aarch64-linux-gnu
AS = $(TOOLCHAIN_PREFIX)-as
CC = $(TOOLCHAIN_PREFIX)-gcc
LD = $(TOOLCHAIN_PREFIX)-ld
OBJCOPY = $(TOOLCHAIN_PREFIX)-objcopy

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

.PHONY: all clean

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

clean:
	@rm -rf $(BUILD_DIR)
