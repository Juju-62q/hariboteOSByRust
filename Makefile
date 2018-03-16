
.SUFFIXES = .asm .bin .lst .img 

SRCDIR = src

TARGET=haribote.img

.PHONY: run clean

$(TARGET): ipl10.bin haribote.bin
	mformat -f 1440 -C -B ipl10.bin -i $(TARGET)
	mcopy haribote.bin -i $(TARGET) ::


%.bin: $(SRCDIR)/%.asm
	nasm $< -o $@ -l $*.lst

run: $(TARGET)
	qemu-system-i386 -drive format=raw,file=$(TARGET),index=0,if=floppy

clean:
	$(RM) $(TARGET)
	$(RM) *.bin *.lst 

