SRC_DIR := src
BUILD_DIR := build
ESP_DIR := esp

TARGET := $(ESP_DIR)/EFI/BOOT/BOOTX64.EFI
OBJECT := $(BUILD_DIR)/main.obj
SOURCE := $(SRC_DIR)/main.asm
IMAGE := $(BUILD_DIR)/esp.img
OVMF_CODE := /usr/share/edk2/x64/OVMF_CODE.4m.fd
OVMF_VARS := $(BUILD_DIR)/OVMF_VARS.fd
OVMF_VARS_TEMPLATE := /usr/share/edk2/x64/OVMF_VARS.4m.fd

ASSEMBLER := nasm
ASSEMBLER_FLAGS := -f win64

MAIN_SYMBOL := start
ARCH := x64

LINKER := lld-link
LINKER_FLAGS := \
	/subsystem:efi_application \
	/entry:$(MAIN_SYMBOL) \
	/machine:$(ARCH) \
	/nodefaultlib

.PHONY: all clean run image

all: $(TARGET)

$(OBJECT): $(SOURCE) | $(BUILD_DIR)
	$(ASSEMBLER) $(ASSEMBLER_FLAGS) $< -o $@

$(TARGET): $(OBJECT) | $(ESP_DIR)/EFI/BOOT
	$(LINKER) $(LINKER_FLAGS) /out:$@ $<

$(BUILD_DIR) $(ESP_DIR)/EFI/BOOT:
	mkdir -p $@

image: $(TARGET) | $(BUILD_DIR)
	dd if=/dev/zero of=$(IMAGE) bs=1M count=64
	mkfs.fat $(IMAGE)
	mmd -i $(IMAGE) ::/EFI
	mmd -i $(IMAGE) ::/EFI/BOOT
	mcopy -i $(IMAGE) $(TARGET) ::/EFI/BOOT/BOOTX64.EFI

run: image
	cp $(OVMF_VARS_TEMPLATE) $(OVMF_VARS)
	qemu-system-x86_64 \
		-machine q35 \
		-m 512M \
		-drive if=pflash,format=raw,readonly=on,file=$(OVMF_CODE) \
		-drive if=pflash,format=raw,file=$(BUILD_DIR)/OVMF_VARS.fd \
		-drive format=raw,file=$(IMAGE)

clean:
	rm -rf $(BUILD_DIR) $(TARGET)
