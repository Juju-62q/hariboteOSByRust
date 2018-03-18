
.SUFFIXES = .asm .bin .lst .img 

BUILDDIR = build
SRCDIR = src

TARGET=haribote.img

.PHONY: run clean install

install:
	@mkdir -p $(BUILDDIR) 
	@make $(TARGET)

$(TARGET): $(BUILDDIR)/ipl10.bin $(BUILDDIR)/haribote.bin
	mformat -f 1440 -C -B $< -i $(TARGET)
	mcopy $(filter-out $<,$^) -i $(TARGET) ::


$(BUILDDIR)/%.bin: $(SRCDIR)/%.asm
	nasm $< -o $@ -l $(BUILDDIR)/$*.lst

run:
	@make install
	qemu-system-i386 -drive format=raw,file=$(TARGET),index=0,if=floppy

clean:
	$(RM) $(TARGET)
	$(RM) -r $(BUILDDIR)

