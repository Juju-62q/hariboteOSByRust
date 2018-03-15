
.SUFFIXES =
.SUFFIXES = .asm .bin .lst .img 

SRCDIR = src

TARGET=haribote.img

.PHONY: run clean

$(TARGET): ipl.bin
	qemu-img create -f raw $(TARGET) 1440k
	mkfs.vfat -F 12 $(TARGET)
	dd if=$< conv=notrunc of=$(TARGET)

%.bin: $(SRCDIR)/%.asm
	nasm $< -o $@ -l $*.lst

run: $(TARGET)
	qemu-system-i386 -drive format=raw,file=$(TARGET),index=0,if=floppy

clean:
	$(RM) $(TARGET)
	$(RM) *.bin *.lst 

