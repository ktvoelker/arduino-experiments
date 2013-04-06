
DEVICE=/dev/tty.usbmodemfd121

ARDUINO=/Applications/Arduino.app/Contents/Resources/Java

BIN=$(ARDUINO)/hardware/tools/avr/bin
GCC=$(BIN)/avr-gcc
OBJCOPY=$(BIN)/avr-objcopy
DUDE=$(BIN)/avrdude

INCCORE=$(ARDUINO)/hardware/arduino/cores/arduino
INCVAR=$(ARDUINO)/hardware/arduino/variants/standard
INCTOOLS=$(ARDUINO)/hardware/tools/avr/avr/include
OPTS=-Wall -DF_CPU=16000000UL -mmcu=atmega328p
SIZEOPTS=-Os -Wl,--gc-sections -ffunction-sections -fdata-sections

DUDECONF=$(ARDUINO)/hardware/tools/avr/etc/avrdude.conf
DUDEOPTS=-C $(DUDECONF) -c arduino -p m328p -b 115200 -P $(DEVICE) 

.PHONY: all clean flash

PROGRAM=main.hex

SOURCES=$(wildcard *.c)

all: $(PROGRAM)

flash: $(PROGRAM)
	$(DUDE) $(DUDEOPTS) -U flash:w:$(PROGRAM)

%.hex: %.elf
	$(OBJCOPY) -O ihex -R .eeprom $*.elf $*.hex

%.elf: $(SOURCES)
	$(GCC) \
		-isystem $(INCCORE) \
		-isystem $(INCVAR) \
		-isystem $(INCTOOLS) \
		-D __AVR_ATmega328P__ \
		-o $*.elf \
		$(OPTS) \
		$(SIZEOPTS) \
		$(SOURCES) \
		../build/uno.a

clean:
	-rm *.hex *.elf

