# toolchain
include toolchain.mk

# directories
BUILD_DIR := build
OBJ_DIR := $(BUILD_DIR)/obj
SRC_DIR := src
LIB_DIR := $(SRC_DIR)/lib
BOOT_DIR := $(SRC_DIR)/boot

# source & targets
LIB_SRC := $(wildcard $(LIB_DIR)/*.yu) $(wildcard $(LIB_DIR)/**/*.yu)
LIB_OBJ := $(patsubst $(SRC_DIR)/%.yu, $(OBJ_DIR)/%.o, $(LIB_SRC))
LIB_TARGET := $(BUILD_DIR)/libgee.a
BOOT_SRC := $(wildcard $(BOOT_DIR)/*.yu) $(wildcard $(BOOT_DIR)/*.S)
BOOT_OBJ := $(patsubst $(SRC_DIR)/%.yu, $(OBJ_DIR)/%.o, $(BOOT_SRC))
BOOT_OBJ := $(patsubst $(SRC_DIR)/%.S, $(OBJ_DIR)/%.o, $(BOOT_OBJ))
BOOT_LDS := $(BOOT_DIR)/linker.ld
BOOT_TARGET := $(BUILD_DIR)/boot.bin
KERNEL_SRC := $(wildcard $(SRC_DIR)/*.yu) $(wildcard $(SRC_DIR)/*.S)
KERNEL_OBJ := $(patsubst $(SRC_DIR)/%.yu, $(OBJ_DIR)/%.o, $(KERNEL_SRC))
KERNEL_OBJ := $(patsubst $(SRC_DIR)/%.S, $(OBJ_DIR)/%.o, $(KERNEL_OBJ))
KERNEL_LDS := $(SRC_DIR)/linker.ld
KERNEL_TARGET := $(BUILD_DIR)/geeos.elf


.PHONY: all clean libgee boot kernel

all: libgee boot kernel

clean:
	-rm -rf $(OBJ_DIR)
	-rm $(LIB_TARGET)
	-rm $(BOOT_TARGET)
	-rm $(BOOT_TARGET).*
	-rm $(KERNEL_TARGET)
	-rm $(KERNEL_TARGET).*

libgee: $(BUILD_DIR) $(LIB_TARGET)

boot: $(BUILD_DIR) $(BOOT_TARGET)

kernel: $(BUILD_DIR) $(KERNEL_TARGET)

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

$(LIB_TARGET): $(LIB_OBJ)
	$(AR) $@ $^
	$(RANLIB) $@

$(BOOT_TARGET): $(BOOT_TARGET).elf
	$(OBJC) -j .text -j .data $^ $@
	$(OBJD) $^ > $@.dump

$(BOOT_TARGET).elf: $(BOOT_OBJ) $(BOOT_LDS) $(LIB_TARGET)
	$(LD) -T$(BOOT_LDS) -L$(BUILD_DIR) -lgee -o $@ $(BOOT_OBJ)

$(KERNEL_TARGET): $(KERNEL_OBJ) $(KERNEL_LDS) $(LIB_TARGET)
	$(LD) -T$(KERNEL_LDS) -L$(BUILD_DIR) -lgee -o $@ $(KERNEL_OBJ)
	$(OBJD) $@ > $@.dump

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.yu
	-mkdir -p $(dir $@)
	$(YUC) -I $(SRC_DIR) -o $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	-mkdir -p $(dir $@)
	$(CC) -I$(SRC_DIR) -o $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.S
	-mkdir -p $(dir $@)
	$(CC) -I$(SRC_DIR) -o $@ $^