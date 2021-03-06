TARGET	= ax8817x
OBJS	= ax8817x.o
MDIR	= misc
ifeq ($(KVER),)
KVER	= $(shell uname -r)
endif
KDIR	= /lib/modules/$(KVER)/build
PWD	= $(shell pwd)
ARCH	= $(shell uname -m | sed -e s/i.86/i386/)
DEST 	= /lib/modules/$(KVER)/$(MDIR)
EXTRA_CFLAGS = -DEXPORT_SYMTAB

obj-m	:= $(TARGET).o

default:
	$(MAKE) ARCH=$(ARCH) -C $(KDIR) M=$(PWD) modules

$(TARGET).o: $(OBJS)
	$(LD) $(LD_RFLAG) -r -o $@ $(OBJS)

install:
	[ -d $(DEST) ] || mkdir -p $(DEST) 2>/dev/null
	install -p -m 644 $(TARGET).ko $(DEST)
	/sbin/depmod -a $(KVER)
	grep -wq asix /etc/modprobe.d/blacklist.conf 2>/dev/null || echo "blacklist asix" >> /etc/modprobe.d/blacklist.conf

clean:
	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) clean

.PHONY: modules clean

-include $(KDIR)/Rules.make
