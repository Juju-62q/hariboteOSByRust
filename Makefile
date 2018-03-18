
.SUFFIXES = .asm .bin .lst .img .sys

BUILDDIR = build
SRCDIR = src

TARGET=haribote.img

.PHONY: run clean install

install:
	@mkdir -p $(BUILDDIR) 
	@make $(TARGET)

$(TARGET): $(BUILDDIR)/ipl10.bin $(BUILDDIR)/haribote.sys
	mformat -f 1440 -C -B $< -i $(TARGET)
	mcopy $(filter-out $<,$^) -i $(TARGET) ::

$(BUILDDIR)/haribote.sys: $(BUILDDIR)/asmhead.bin $(BUILDDIR)/bootpack.bin
	cat $^ > $@

$(BUILDDIR)/%.bin: $(SRCDIR)/%.rs
	rustc --target=i686-unknown-linux-gnu --crate-type=staticlib --emit=obj -C lto -C no-prepopulate-passes -Z verbose -Z no-landing-pads -o $(BUILDDIR)/$*.o $<
	i686-unknown-linux-gnu-ld -v -nostdlib -Tdata=0x00310000 $(BUILDDIR)/$*.o -T $(SRCDIR)/kernel.ld -o $@

$(BUILDDIR)/%.bin: $(SRCDIR)/%.asm
	nasm $< -o $@ -l $(BUILDDIR)/$*.lst

run:
	@make install
	qemu-system-i386 -drive format=raw,file=$(TARGET),index=0,if=floppy

clean:
	$(RM) $(TARGET)
	$(RM) -r $(BUILDDIR)

