# Add support for C11 with GNU extensions.
ccflags-y := -std=gnu11

ifeq ($(KERNELRELEASE),)
	# We are building an out-of-tree module.

	# Point the build system to the kernel object directory. KERNEL_OBJ_DIR is
	# defined in the environment calling make (see scripts/build.sh).
    KERNELDIR ?= $(KERNEL_OBJ_DIR)

    # The current directory is passed to sub-makes as an argument.
    PWD := $(shell pwd)

modules:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

clean:
	find . \
	\! -name 'Makefile' \
	\! -name 'helloworld_bbb_char_driver.c' \
	-delete

.PHONY: modules clean

else
	# This bit executes when make gets called from the kernel build system.
    obj-m := helloworld_bbb_char_driver.o
endif
