
##
# Defaults for user-defined variables
##

LANG ?= C
LIB ?= false

ifeq "$(LIB)" "true"
OUTPUT ?= main.elf
else
OUTPUT ?= main.hex
endif

LIBS ?=
SOURCES ?=
CFLAGS ?=

##
# Internals
##

DEVICE=/dev/tty.usbmodemfd121

ARDUINO=/Applications/Arduino.app/Contents/Resources/Java

BIN=$(ARDUINO)/hardware/tools/avr/bin
CC=$(BIN)/avr-gcc
CXX=$(BIN)/avr-g++
ifeq "$(LANG)" "CXX"
COMPILER=$(CXX)
else
COMPILER=$(CC)
endif
OBJCOPY=$(BIN)/avr-objcopy
DUDE=$(BIN)/avrdude

INCCORE=$(ARDUINO)/hardware/arduino/cores/arduino
INCVAR=$(ARDUINO)/hardware/arduino/variants/standard
INCTOOLS=$(ARDUINO)/hardware/tools/avr/avr/include
CFLAGS += -Wall -DF_CPU=16000000UL -mmcu=atmega328p -DARDUINO=104
ifeq "$(LIB)" "true"
CFLAGS += -c
endif
CFLAGS += -Os -Wl,--gc-sections -ffunction-sections -fdata-sections

DUDECONF=$(ARDUINO)/hardware/tools/avr/etc/avrdude.conf
DUDEOPTS=-C $(DUDECONF) -c arduino -p m328p -b 115200 -P $(DEVICE) 

.PHONY: all clean flash

SOURCES += $(wildcard *.c *.cpp)
ifeq "$(LIB)" "false"
LIBS += ../build/uno.elf
endif

all: $(OUTPUT)

ifeq "$(LIB)" "false"
flash: $(OUTPUT)
	$(DUDE) $(DUDEOPTS) -U flash:w:$(OUTPUT)

%.hex: %.elf
	$(OBJCOPY) -O ihex -R .eeprom $*.elf $(OUTPUT)
endif

%.elf: $(SOURCES)
	$(COMPILER) \
		-I $(INCCORE) \
		-I $(INCVAR) \
		-I $(INCTOOLS) \
		-D __AVR_ATmega328P__ \
		-o $*.elf \
		$(CFLAGS) \
		$(SOURCES) \
		$(LIBS)

clean:
	-rm *.hex *.elf

