#############################################################
#
# Based on original Makefile (c) by CHERTS <sleuthhound@gmail.com>
#
#############################################################

# ===============================================================
# Note: project is hard coded for Assumes 512K SPI flash
# ===============================================================


# ===============================================================
# Make Verbose messages while compiling
VERBOSE = 0
# ===============================================================
# Project Path definitions
PROJECT_DIR ?=/opt/Espressif/projects/esp8266_ili9341

# ===============================================================
# ESP OPEN SDK path definitions
ROOT_DIR=/opt/Espressif/esp-open-sdk
# Base directory for the compiler
XTENSA_TOOLS_ROOT ?= $(ROOT_DIR)/xtensa-lx106-elf/bin
# base directory of the ESP8266 SDK package, absolute
SDK_BASE	?= $(ROOT_DIR)/sdk
SDK_TOOLS	?= $(SDK_BASE)/tools
#ESPTOOL		?= $(SDK_TOOLS)/esptool.py
ESPTOOL		?= /usr/local/bin/esptool.py
ESPPORT		?= /dev/ttyUSB0

# Export path
export PATH := $(XTENSA_TOOLS_ROOT):$(PATH)

# esptool baud rate 
BAUD=256000
#BAUD=115200

# CPU frequency
F_CPU=80000000UL

# ===============================================================

# ===============================================================
# Build Directory
BUILD_BASE	= build
# name for the target project
TARGET		= demo
# Firmware Directory
FW_BASE		= firmware

# SWAP GPIO4 and GPIO5 on some esp-12 boards have labels reversed
# My board is reversed
SWAP45			:= 1

# ===============================================================
# The settings in this section are related to the flash size of the ESP board
# esptool.py flash arguments for 512K SPI flash
# WARNING ADDR_IROM MUST match settings in LD_SCRIPT!

BIG  = 1
ifdef BIG
	FW_ARGS := -ff 80m -fm qio -fs 32m
	LD_SCRIPT		= eagle.app.v6.new.2048.ld
	# The ipaddress of the module - either fixed or by DHCP
	IPADDR=192.168.200.110
	SIZE := 0x400000
else
	FW_ARGS := -ff 80m -fm qio -fs 4m
	SIZE := 0x80000
	IPADDR=192.168.200.110
	LD_SCRIPT		= eagle.app.v6.new.512.ld
endif

ADDR_IRAM		= 0x00000
ADDR_IROM		= 0x10000
FILE_IRAM		:= $(BUILD_BASE)/region-$(ADDR_IRAM).bin
FILE_IRAM_PAD	:= $(BUILD_BASE)/region-$(ADDR_IRAM)-padded.bin
FILE_IROM		:= $(BUILD_BASE)/region-$(ADDR_IROM).bin
FW				:= $(BUILD_BASE)/firmware.bin

# ===============================================================
# which modules (subdirectories) of the project to include in compiling
MODULES	= esp8266 lib driver display cordic network user

# Project Include Directories
EXTRA_INCDIR    = . user include $(SDK_BASE)/include 

# ===============================================================

# Base compiler flags using during compilation of source files
CFLAGS	= -Os \
	-g \
	-O2 \
	-Wpointer-arith \
	-Wundef \
	-Wl,-EL \
    -fno-inline-functions \
	-nostdlib \
	-mlongcalls \
	-mtext-section-literals  \
	-D__ets__ \
	-DICACHE_FLASH \
	-ffunction-sections \
    -fdata-sections \
	-DF_CPU=$(F_CPU)
	# -Werror \

# linker flags used to generate the main object file
LDFLAGS	= -nostdlib \
	-Wl,--no-check-sections \
	-u call_user_start \
	-Wl,-static \
	-Wl,-gc-sections \
	-Wl,-Map=linkmap \
	-Wl,--cref \
	-Wl,--allow-multiple-definition 

# for cal_dex - exception debugging
LDFLAGS += -Wl,--undefined=_xtos_set_exception_handler -Wl,--wrap=_xtos_set_exception_handler
# ===============================================================
# Project Defines

# ESP8266 specific support
CFLAGS += -DESP8266

# Named address space aliases
#CFLAGS += -DMEMSPACE=ICACHE_FLASH_ATTR
#CFLAGS += -DMEMSPACE_RO=ICACHE_RODATA_ATTR
CFLAGS += -D_GNU_SOURCE

# files should include user_config.h
CFLAGS += -DUSER_CONFIG

# =========================



# =========================
# Run a web server
WEBSERVER = 1

# Web server Debugging
# 0 no WEB debugging
# 1 error only
# 2 connection information
# 4 send/yield task information
# 8 HTML processing
# 16 characters from socket I/O
#WEB_DEBUG = 1+8
WEB_DEBUG = 1

# Maximum number of WEB connections
MAX_CONNECTIONS = 8


# =========================
# printf, sscanf and math IO functions

# Debugging printf function
DEBUG_PRINTF=uart0_printf

SSCANF=1
PRINTF=1
# Floating point support for IO functions
FLOATIO=1

ifdef PRINTF
	#CFLAGS += -DDEFINE_PRINTF
	CFLAGS += -Dprintf=$(DEBUG_PRINTF) 
	MODULES	+= printf
endif

ifdef SSCANF
	MODULES	+= io
    CFLAGS += -DSMALL_SSCANF
endif

ifdef FLOATIO
CFLAGS += -DFLOATIO
endif

# =========================
# FatFS code support
FATFS_SUPPORT = 1

# POSIX FatFS wrappers
POSIX_WRAPPERS=1

ifdef FATFS_SUPPORT
    CFLAGS  += -DFATFS_SUPPORT
FATFS_UTILS_FULL=1
FATFS_DEBUG=1
    CFLAGS  += -DFATFS_DEBUG=$(FATFS_DEBUG)

ifdef SWAP45
	MMC_CS=5
else
	MMC_CS=4
endif

    CFLAGS  += -DMMC_CS=$(MMC_CS)

ifdef POSIX_WRAPPERS
    CFLAGS += -DPOSIX_WRAPPERS
endif
ifdef FATFS_UTILS_FULL
    CFLAGS += -DFATFS_UTILS_FULL
endif
	MODULES	+= fatfs.sup
	MODULES	+= fatfs
	MODULES	+= fatfs/option
	MODULES	+= fatfs.hal
endif

# =========================
# DS1307 I2C real time clock
#RTC = 1

# =========================
# ADF4351 demo
ADF4351 = 1

# =========================
# Yield function support thanks to Arduino Project 
# You should always leave this on
YIELD_TASK = 1

# =========================
# =========================
DISPLAY = 1

ifdef DISPLAY
# ILI9341 Display support
	ILI9341_CS = 15
    CFLAGS  += -DILI9341_CS=$(ILI9341_CS)
ifdef SWAP45
	ADDR_0 = 4
else
	ADDR_0 = 5
endif
    CFLAGS  += -DADDR_0=$(ADDR_0)

# Display Debug messages via serial
ILI9341_DEBUG = 0 

# Display wireframe earth demo in lower right of display
EARTH = 1

# Spinning Cube demo in upper right of display
WIRECUBE = 1

# Circle demo
CIRCLE = 

# Display voltage - only works if DEBUG_STATS = 1
VOLTAGE_TEST = 1

# Display additional status:
# 	interation count for spinning cube
#   heap and connection count
#   connection and wifi status
#   voltage
DEBUG_STATS = 1


# TFT display DEBUG level
ifdef ILI9341_DEBUG
	CFLAGS  += -DILI9341_DEBUG=$(ILI9341_DEBUG)
endif

# ILI9341 Display and FONTS
# Include font specifications - needed with proportional fonts 
	CFLAGS  += -DFONTSPECS 

ifdef DEBUG_STATS
	CFLAGS += -DDEBUG_STATS
endif

ifdef VOLTAGE_TEST
	CFLAGS += -DVOLTAGE_TEST
endif

ifdef WIRECUBE
	MODULES	+= wire
	CFLAGS  += -DWIRECUBE
endif

ifdef CIRCLE
	CFLAGS  += -DCIRCLE
endif

ifdef EARTH
ifndef WIRECUBE
	MODULES	+= wire
endif
	CFLAGS  += -DEARTH
endif


endif  # ifdef DISPLAY
# =========================
# =========================

# TELNET serial bridge demo
//TELNET_SERIAL = 1

# =========================
# NETWORK Client demo
NETWORK_TEST = 1
# Network PORT for server and client
# Displays data on TFT display
TCP_PORT = 31415

# =========================
ifdef TELNET_SERIAL
	CFLAGS += -DTELNET_SERIAL
	MODULES	+= bridge
endif

# =========================
ifdef NETWORK_TEST
	MODULES += server
	CFLAGS  += -DNETWORK_TEST -DTCP_PORT=$(TCP_PORT)
endif

# =========================
ifdef WEBSERVER
	CFLAGS += -DWEBSERVER -DWEB_DEBUG=$(WEB_DEBUG) -DMAX_CONNECTIONS=$(MAX_CONNECTIONS)
	MODULES	+= web
endif



# =========================
ifdef YIELD_TASK
	CFLAGS += -DYIELD_TASK
	MODULES	+= yield
endif

# =========================
ifdef ADF4351
	CFLAGS += -DADF4351

	ADF4351_CS=0
	CFLAGS += -DADF4351_CS=$(ADF4351_CS)

	ADF4351_DEBUG = 1
# Debug options can be combined by adding or oring
# 1 = errors
# 2 = calculation detail
# 4 = register dumps
# Example for everything
#  ADF4351_DEBUG = 1+2+4

	MODULES	+= adf4351
ifdef ADF4351_DEBUG
	CFLAGS += -DADF4351_DEBUG=$(ADF4351_DEBUG)
endif
endif

# UART queues
	CFLAGS += -DUART_QUEUED 
	CFLAGS += -DUART_QUEUED_RX
#	CFLAGS += -DUART_QUEUED_TX

# ===============================================================
# select which tools to use as compiler, librarian and linker
CC		:= $(XTENSA_TOOLS_ROOT)/xtensa-lx106-elf-gcc
NM		:= $(XTENSA_TOOLS_ROOT)/xtensa-lx106-elf-nm
AR		:= $(XTENSA_TOOLS_ROOT)/xtensa-lx106-elf-ar
LD		:= $(XTENSA_TOOLS_ROOT)/xtensa-lx106-elf-gcc
OBJCOPY := $(XTENSA_TOOLS_ROOT)/xtensa-lx106-elf-objcopy
OBJDUMP := $(XTENSA_TOOLS_ROOT)/xtensa-lx106-elf-objdump

# various paths from the SDK used in this project
SDK_LIBDIR	= lib
SDK_LDDIR	= ld
SDK_INCDIR	= include include/json

# V 2 libs
# libcrypto.a
# libssl.a
# libat.a
# libnet80211.a
# libupgrade.a
# libphy.a
# libwpa.a
# libmain.a
# libmesh.a
# libdriver.a
# libespnow.a
# libpp.a
# libairkiss.a
# libjson.a
# libsmartconfig.a
# liblwip_536.a
# libpwm.a
# libgcc.a
# liblwip.a
# libwps.a
# libwpa2.a

LIBS		= gcc hal phy pp net80211 ssl lwip wpa main m

# ===============================================================


compiler.S.cmd=xtensa-lx106-elf-gcc
compiler.S.flags=-c -g -x assembler-with-cpp -MMD 


# ===============================================================

LD_SCRIPT	:= $(addprefix -T$(PROJECT_DIR)/ld/,$(LD_SCRIPT))

# no user configurable options below here
SRC_DIR		:= $(MODULES)
BUILD_DIR	:= $(addprefix $(BUILD_BASE)/,$(MODULES))

SDK_LIBDIR	:= $(addprefix $(SDK_BASE)/,$(SDK_LIBDIR))
SDK_INCDIR	:= $(addprefix -I$(SDK_BASE)/,$(SDK_INCDIR))

SRC			:= $(foreach sdir,$(SRC_DIR),$(wildcard $(sdir)/*.[cS])) 
C_OBJ		:= $(patsubst %.c,%.o,$(SRC))
S_OBJ		:= $(patsubst %.S,%.o,$(C_OBJ))
OBJ		    := $(patsubst %.o,$(BUILD_BASE)/%.o,$(S_OBJ))
LIBS		:= $(addprefix -l,$(LIBS))

APP_AR		:= $(addprefix $(BUILD_BASE)/,$(TARGET).a)
ELF			:= $(addprefix $(BUILD_BASE)/,$(TARGET).elf)

INCDIR	:= $(addprefix -I,$(SRC_DIR))
EXTRA_INCDIR	:= $(addprefix -I,$(EXTRA_INCDIR))
MODULE_INCDIR	:= $(addsuffix /include,$(INCDIR))
# ===============================================================

ifeq ("$(VERBOSE)","1")
	Q := 
	vecho := @true
else
	Q := @
	vecho := @echo
endif

vpath %.c $(SRC_DIR)
vpath %.S $(SRC_DIR)

define compile-objects
$1/%.o: %.S
	$(vecho) "CC $$<"
	$(Q) $(CC) $(INCDIR) $(MODULE_INCDIR) $(EXTRA_INCDIR) $(SDK_INCDIR) $(CFLAGS)  -c -g -x assembler-with-cpp -MMD $$< -o $$@
$1/%.o: %.c
	$(vecho) "CC $$<"
	$(Q) $(CC) $(INCDIR) $(MODULE_INCDIR) $(EXTRA_INCDIR) $(SDK_INCDIR) $(CFLAGS)  -c $$< -o $$@
endef

# ===============================================================
.PHONY: all checkdirs clean

all: support checkdirs $(FW) send

.PHONY: support
support:
	-@$(MAKE) -C cordic/make_cordic all
	-@$(MAKE) -C earth all
	-@$(MAKE) -C fonts all

checkdirs: $(BUILD_DIR) $(FW_BASE)


$(APP_AR): $(OBJ)
	$(vecho) "AR $@"
	$(Q) $(AR) cru $@ $^

$(ELF):	$(APP_AR)
	$(vecho) "LD $@"
	$(Q) $(LD) -L$(SDK_LIBDIR) $(LD_SCRIPT) $(LDFLAGS) -Wl,--start-group $(LIBS) $(APP_AR) -Wl,--end-group -o $@

size:	$(ELF)
	$(vecho) "Section info:"
	-$(Q) memanalyzer.exe $(OBJDUMP) $(ELF)
	-@$(NM) -n -S $(ELF) 2>&1 | grep "_text_start"
	-@$(NM) -n -S $(ELF) 2>&1 | grep "_text_end"
	-@$(NM) -n -S $(ELF) 2>&1 | grep "_irom0_text_start"
	-@$(NM) -n -S $(ELF) 2>&1 | grep "_irom0_text_end"
	-@$(NM) -n -S $(ELF) 2>&1 | grep "_rodata_start"
	-@$(NM) -n -S $(ELF) 2>&1 | grep "_rodata_end"
	-@$(NM) -n -S $(ELF) 2>&1 | grep "_data_start"
	-@$(NM) -n -S $(ELF) 2>&1 | grep "_data_end"
	-@$(NM) -n -S $(ELF) 2>&1 | grep "_bss_start"
	-@$(NM) -n -S $(ELF) 2>&1 | grep "_bss_end"
	-@$(NM) -n -S $(ELF) 2>&1 | grep "_heap_start"
	@#-@$(NM) -n -S $(ELF) 2>&1 | grep "_heap_end"
	-@$(NM) -n -S $(ELF) 2>&1 | grep "_dport0_rodata_start"
	-@$(NM) -n -S $(ELF) 2>&1 | grep "_dport0_rodata_end"
	-@$(NM) -n -S $(ELF) 2>&1 | grep "_dport0_literal_start"
	-@$(NM) -n -S $(ELF) 2>&1 | grep "_dport0_literal_end"
	-@$(NM) -n -S $(ELF) 2>&1 | grep "_dport0_data_start"
	-@$(NM) -n -S $(ELF) 2>&1 | grep "_dport0_data_end"

$(FW):	$(ELF) size
	$(vecho) "Firmware $@"
	$(ESPTOOL) elf2image $(FW_ARGS) $(ELF) -o $(BUILD_BASE)/region-
	$(Q) dd if=$(FILE_IRAM) of=$(FILE_IRAM_PAD) ibs=64K conv=sync 2>&1 >/dev/null
	$(Q) cat $(FILE_IRAM_PAD) $(FILE_IROM) > $(FW)

# =================================================================================================
#  4.1.2. Download Addresses
#  
#  Table 4-2 lists the download addresses for Non-FOTA firmware.
#  
#  Table 4-2. Download Addresses for Non-FOTA Firmware (unit: kB)
#  Binaries 	Download addresses in flash of different capacities
#                                 512                1024                 2048                 4096
#  master_device_key.bin      0x3E000             0x3E000             0x3E0000             0x3E0000
#  esp_init_data_default.bin  0x7C000             0xFC000             0x1FC000             0x3FC000
#  blank.bin                  0x7E000             0xFE000             0x1FE000             0x3FE000
#  eagle.flash.bin            0x00000             0x00000              0x00000              0x00000
#  eagle.irom0text.bin        0x10000             0x10000              0x10000              0x10000
# =================================================================================================



flash: all
	$(ESPTOOL) --port $(ESPPORT)  -b $(BAUD) write_flash  0 $(FW)
	miniterm.py --parity N -e --rts 0 --dtr 0 /dev/ttyUSB0 115200

flashzero: checkdirs
	dd if=/dev/zero of=$(FW_BASE)/zero1.bin bs=1024 count=1024
	$(ESPTOOL) -p $(ESPPORT) -b $(BAUD) write_flash \
		$(flashimageoptions) \
		0x000000 $(FW_BASE)/zero1.bin 
	# 0x000000 $(FW_BASE)/zero1.bin 0x100000 $(FW_BASE)/zero1.bin

.PHONY: testflash
testflash:
	gcc testflash.c -o testflash
	-mkdir tmp
	@echo testing first megabyte
	@echo
	@echo Create megabyte size test file 
	./testflash -s 0x100000 -w tmp/test1w.bin
	@echo Write file to ESP8266
	$(ESPTOOL) -p $(ESPPORT) -b $(BAUD) write_flash \
		$(flashimageoptions) \
		0x000000 tmp/test1w.bin 
	@echo read flash back from ESP8266
	$(ESPTOOL) -p $(ESPPORT) -b $(BAUD) read_flash \
		0x000000 0x100000 tmp/test1r.bin 
	@echo Verify data read back matches what we wrote
	./testflash -s 0x100000 -r tmp/test1r.bin

rebuild: clean all

$(BUILD_DIR):
	$(Q) mkdir -p $@

$(FW_BASE):
	$(Q) mkdir -p $@
	$(Q) mkdir -p $@/upgrade

# ===============================================================
clean:
	-@$(MAKE) -C printf clean
	-@$(MAKE) -C cordic/make_cordic clean
	-@$(MAKE) -C earth clean
	-@$(MAKE) -C fonts clean
	rm -f $(APP_AR)
	rm -rf $(BUILD_DIR)
	rm -rf $(BUILD_BASE)
	rm -rf $(FW_BASE)
	rm -f linkmap
	rm -f log
	rm -f eagle.app.*bin
	rm -f send
	rm -f map.txt
	rm -f testflash
	rm -rf doxygen/*

$(foreach bdir,$(BUILD_DIR),$(eval $(call compile-objects,$(bdir))))

# ===============================================================
# If makefile changes, update doxygens list
DOCDIRS := . $(MODULES) wire earth fonts include cordic/make_cordic

# If makefile changes, maybe the list of sources has changed, so update doxygens list
.PHONY: doxyfile.inc
doxyfile.inc:
	echo "INPUT         =  $(DOCDIRS)" > doxyfile.inc
	echo "FILE_PATTERNS =  *.h *.c *.md" >> doxyfile.inc

.PHONY: doxy
doxy:   doxyfile.inc $(SRCS)
	#export PYTHONPATH=$(PYTHONPATH):/share/embedded/testgen-0.11/extras
	doxygen Doxyfile
# ===============================================================

#Network message sending code

send:	send.c
	gcc send.c -DTCP_PORT=$(TCP_PORT) -o send

sendtest:	send
	./send -i $(IPADDR) -m 'testing\nTest3\nscrolling\ntext and even more text\n1\n3'

gcchelp:
	$(CC) --target-help
