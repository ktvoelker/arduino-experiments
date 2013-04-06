
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

.PHONY: all clean upload

all: test.hex

upload: test.hex
	$(DUDE) $(DUDEOPTS) -U flash:w:test.hex

test.hex: test.elf
	$(OBJCOPY) -O ihex -R .eeprom test.elf test.hex

test.elf: test.c
	$(GCC) \
		-isystem $(INCCORE) \
		-isystem $(INCVAR) \
		-isystem $(INCTOOLS) \
		-D __AVR_ATmega328P__ \
		-o test.elf \
		$(OPTS) \
		$(SIZEOPTS) \
		test.c \
		core.a

clean:
	rm test.hex test.elf

