################################################################################
#
# This makefile is created by SimonG (Gabor Simon)
#
# v20140811_2200
#
################################################################################

#*******************************************************************************
#****** CONFIGURATION
#*******************************************************************************

# Project name
PROJECT = main

# Controller type
MCU = atmega2560

# Optimization level
OPT_LEVEL  = -Os

# Generate debugging information that can be used by avr-gdb.
CFLAGS  = -g

# All warnings are switched on
CFLAGS += -Wall

# Make any unqualfied char type an unsigned char.
# Without this option they default to a signed char.
CFLAGS += -funsigned-char

# Make any unqualified bitfield type unsigned.
# By default they are signed.
CFLAGS += -funsigned-bitfields

# Allocate to an enum type only as many bytes as it needs for the declared
# range of possible values.
# Specifically, the enum type will be equivalent to the smallest integer type
# which has enough room.
CFLAGS += -fshort-enums

# Pack all structure members together without holes.
CFLAGS += -fpack-struct

# Do not include unused function and data
# Generally used with "--gc-sections" linker option.
# This causes each function to be placed into a separate internal
# memory section, which "--gc-sections" can then discard
# if the section (function) is unreferenced.
CFLAGS += -ffunction-sections
CFLAGS += -fdata-sections

# In case of C++, exceptions are not supported.
# Since exceptions are enabled by default in the C++ front-end, they explicitly
# need to be turned off # using "-fno-exceptions" in the compiler options. 
CFLAGS += -fno-exceptions

# Output format. (can be srec, ihex, binary)
FORMAT = ihex

# Compiler flag to set the C Standard level.
#   c89   - "ANSI" C
#   gnu89 - c89 plus GCC extensions
#   c99   - ISO C99 standard (not yet fully implemented)
#   gnu99 - c99 plus GCC extensions
CSTANDARD = gnu99

# Programmer configuration
PROG_TYPE = wiring
PROG_PORT = COM1
PROG_BAUD = 115200


#*******************************************************************************
#****** DEFINITIONS
#*******************************************************************************

#Source file directory
DIR_SRC = sources

# Generated output directories
DIR_UPL = upload
DIR_GEN = generated
DIR_OBJ = objects

# Generated output files
HEX = $(DIR_UPL)/$(PROJECT).hex
EEP = $(DIR_UPL)/$(PROJECT).eep
ELF = $(DIR_GEN)/$(PROJECT).elf
LST = $(DIR_GEN)/$(PROJECT).lst
MAP = $(DIR_GEN)/$(PROJECT).map

# Read files from target
LFUSE = $(DIR_UPL)/lfuse.hex
HFUSE = $(DIR_UPL)/hfuse.hex
EFUSE = $(DIR_UPL)/efuse.hex
EEPROM = $(DIR_UPL)/eeprom.hex

# Generated object files
OBJ = $(patsubst %.c, $(DIR_OBJ)/%.o, $(notdir $(wildcard $(DIR_SRC)/*.c)))

# Compiler flags
CFLAGS_ALL  = -mmcu=$(MCU)
CFLAGS_ALL += $(OPT_LEVEL)
CFLAGS_ALL += $(CFLAGS)
CFLAGS_ALL += -std=$(CSTANDARD)

# Linker flags
LDFLAGS =

# Program and command
CC      = avr-gcc
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
SIZE    = avr-size
PROG    = avrdude
RM      = -rm -d -R -f

# Messages during processing
TXT_LINE_LONG       = "========================================="
TXT_LINE_SHORT      = "------------------------------"
TXT_BUILD_START     = "BUILD STARTED"
TXT_BUILD_END       = "BUILD FINISHED SUCCESSFULL"
TXT_CLEAN_START     = "CLEAN STARTED"
TXT_CLEAN_END       = "CLEAN FINISHED"
TXT_PROGRAM_START   = "PROGRAMMING STARTED"
TXT_PROGRAM_END     = "PROGRAMMING FINISHED"
TXT_COMPILE         = "Compiling: "
TXT_GCC_VERSION     = "AVR-GCC version: "
TXT_RM_BIN          = "Removing binary files..."
TXT_RM_GEN          = "Removing generated files..."
TXT_RM_OBJ          = "Removing object files..."
TXT_CREATE_HEX      = "Creating hex file..."
TXT_CREATE_ELF      = "Creating elf file..."
TXT_CREATE_EEP      = "Creating EEPROM file..."
TXT_CREATE_LST      = "Creating lst file..."
TXT_CREATE_MAP      = "Creating map file..."


#*******************************************************************************
#****** TARGETS
#*******************************************************************************
.PHONY: all clean build program readfuse readeeprom

all: clean build

build: $(LST) $(MAP) $(EEP) $(HEX)
	@echo
	@echo $(TXT_LINE_LONG)
	@echo $(TXT_BUILD_END)
	@echo $(TXT_LINE_LONG)
	@echo

clean:
	@echo
	@echo $(TXT_LINE_LONG)
	@echo $(TXT_CLEAN_START)
	@echo $(TXT_LINE_LONG)
	@echo
	@echo $(TXT_RM_BIN)
	@$(RM) $(DIR_UPL)
	@echo $(TXT_RM_GEN)
	@$(RM) $(DIR_GEN)
	@echo $(TXT_RM_OBJ)
	@$(RM) $(DIR_OBJ)
	@echo
	@echo $(TXT_LINE_LONG)
	@echo $(TXT_CLEAN_END)
	@echo $(TXT_LINE_LONG)
	@echo

program:
	@echo
	@echo $(TXT_LINE_LONG)
	@echo $(TXT_PROGRAM_START)
	@echo $(TXT_LINE_LONG)
	@echo
	@$(PROG) -p $(MCU) -c $(PROG_TYPE) -P $(PROG_PORT) -b $(PROG_BAUD) \
    -D -U flash:w:$(HEX):i
	@echo
	@echo $(TXT_LINE_LONG)
	@echo $(TXT_PROGRAM_END)
	@echo $(TXT_LINE_LONG)
	@echo

readfuse:
	@echo
	@echo $(TXT_LINE_LONG)
	@echo $(TXT_PROGRAM_START)
	@echo $(TXT_LINE_LONG)
	@echo
	@$(PROG) -p $(MCU) -c $(PROG_TYPE) -P $(PROG_PORT) -b $(PROG_BAUD) -D \
    -U lfuse:r:$(LFUSE):h \
    -U hfuse:r:$(HFUSE):h \
    -U efuse:r:$(EFUSE):h
	@echo
	@echo $(TXT_LINE_LONG)
	@echo $(TXT_PROGRAM_END)
	@echo $(TXT_LINE_LONG)
	@echo

readeeprom:
	@echo
	@echo $(TXT_LINE_LONG)
	@echo $(TXT_PROGRAM_START)
	@echo $(TXT_LINE_LONG)
	@echo
	@$(PROG) -p $(MCU) -c $(PROG_TYPE) -P $(PROG_PORT) -b $(PROG_BAUD) \
    -D -U eeprom:r:$(EEPROM):i
	@echo
	@echo $(TXT_LINE_LONG)
	@echo $(TXT_PROGRAM_END)
	@echo $(TXT_LINE_LONG)
	@echo


#*******************************************************************************
#****** RULES
#*******************************************************************************

# Create flash output file (.hex) from binary (.elf) output file
$(HEX): $(ELF) | $(DIR_UPL)
	@echo
	@echo $(TXT_CREATE_HEX)
	@$(OBJCOPY) -j .text -j .data -O $(FORMAT) $< $@
	@echo
	@echo
	@echo
	@$(SIZE) --format=avr --mcu=$(MCU) $<

# Create EEPROM output file (.eep) from binary (.elf) output file
$(EEP): $(ELF) | $(DIR_UPL)
	@echo
	@echo -n $(TXT_CREATE_EEP) 
	@$(OBJCOPY) -j .eeprom --change-section-lma .eeprom=0 -O $(FORMAT) $< $@

# Create extended list file (.lst) from binary (.elf) output file
$(LST): $(ELF) | $(DIR_GEN)
	@echo $(TXT_CREATE_LST) 
	@$(OBJDUMP) -h -S $< > $@ 

# Create mapping output file (.map) from binary (.elf) and
# object (.o) output files
$(MAP): $(ELF) $(OBJ) | $(DIR_GEN)
	@echo $(TXT_CREATE_MAP) 
	@$(CC) $(OPT_LEVEL) -mmcu=$(MCU) -Wl,-Map,$@ -o $^

# Link: create GNU executable binary file (.elf) from object files (.o)
$(ELF): $(OBJ) | $(DIR_GEN)
	@echo
	@echo $(TXT_CREATE_ELF)
	@$(CC) $(OPT_LEVEL),--gc-sections -mmcu=$(MCU) -o $@ $^ 
	
# Compile: create object files from C source files
$(DIR_OBJ)/%.o: $(DIR_SRC)/%.c | $(DIR_OBJ)
	@echo
	@echo $(TXT_LINE_SHORT)
	@echo $(TXT_COMPILE) $<
	@$(CC) $(CFLAGS_ALL) -c $< -o $@
	@echo $(TXT_LINE_SHORT)

# Directory creation for object files
$(DIR_OBJ):
	@echo
	@echo $(TXT_LINE_LONG)
	@echo $(TXT_BUILD_START)
	@echo $(TXT_LINE_LONG)
	@echo -n $(TXT_GCC_VERSION)
	@$(CC) -dumpversion
	@mkdir -p $(DIR_OBJ)

# Directory creation for generated files
$(DIR_GEN):
	@mkdir -p $(DIR_GEN)

# Directory creation for binary FLASH file	
$(DIR_UPL):
	@mkdir -p $(DIR_UPL)