#***************************************************************************************************
#****** CONFIGURATION
#***************************************************************************************************

# Project name
PROJECT = main

# Controller type
MCU = atmega8

# Optimization switches
OPT  = -Os
OPT += -g -Wall

# Output format. (can be srec, ihex, binary)
FORMAT = ihex

# Compiler flag to set the C Standard level.
#   c89   - "ANSI" C
#   gnu89 - c89 plus GCC extensions
#   c99   - ISO C99 standard (not yet fully implemented)
#   gnu99 - c99 plus GCC extensions
CSTANDARD = gnu99


#***************************************************************************************************
#****** DEFINITIONS
#***************************************************************************************************

#Source file directory
DIR_SRC = sources

# Generated output directory
DIR_BIN = bin
DIR_GEN = generated
DIR_OBJ = objects

# Binary files
BIN = $(DIR_BIN)/$(PROJECT)

# Generated files
GEN = $(DIR_GEN)/$(PROJECT)

# Object files
OBJ = $(patsubst %.c, $(DIR_OBJ)/%.o, $(wildcard *.c))

# Compiler flags definitions
CFLAGS  = -mmcu=$(MCU)
CFLAGS += $(OPT)
CFLAGS += -std=$(CSTANDARD)

# Program and command definitions
CC      = avr-gcc
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
SIZE    = avr-size
RM      = -rm -d -R -f

# Message definition during working
TXT_LINE_LONG       = "================================================================================"
TXT_LINE_SHORT      = "------------------------------"
TXT_BUILD_START     = "BUILD STARTED"
TXT_BUILD_END       = "BUILD FINISHED SUCCESSFULL"
TXT_CLEAN_START     = "CLEAN STARTED"
TXT_CLEAN_END       = "CLEAN FINISHED"
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


#***************************************************************************************************
#****** TARGETS
#***************************************************************************************************
.PHONY: all clean rebuild

rebuild: clean all

all: $(BIN).eep $(BIN).hex
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
	@$(RM) $(DIR_BIN)
	@echo $(TXT_RM_GEN)
	@$(RM) $(DIR_GEN)
	@echo $(TXT_RM_OBJ)
	@$(RM) $(DIR_OBJ)
	@echo
	@echo $(TXT_LINE_LONG)
	@echo $(TXT_CLEAN_END)
	@echo $(TXT_LINE_LONG)
	@echo


#***************************************************************************************************
#****** RULES
#***************************************************************************************************

# Convert: create flash binary output file (.hex) from ELF output file
$(BIN).hex: $(GEN).elf | $(DIR_BIN)
	@echo
	@echo $(TXT_CREATE_HEX)
	@$(OBJCOPY) -j .text -j .data -O $(FORMAT) $< $@
	@echo
	@echo
	@$(SIZE) -C --mcu=$(MCU) $(GEN).elf	

# Convert: create EEPROM output files (.eep) from ELF output file
$(BIN).eep: $(GEN).elf | $(DIR_BIN)
	@echo
	@echo $(TXT_CREATE_EEP)
	@$(OBJCOPY) -j .eeprom --change-section-lma .eeprom=0 -O $(FORMAT) $< $@

# Link: create GNU executable binary file from object files
$(GEN).elf: $(OBJ) | $(DIR_GEN)
	@echo
	@echo $(TXT_CREATE_ELF)
	@$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ 
	@echo $(TXT_CREATE_LST) 
	@$(OBJDUMP) -h -S $@ > $(GEN).lst 
	@echo $(TXT_CREATE_MAP) 
	@$(CC) -g $(CFLAGS) -Wl,-Map,$(GEN).map -o $@ $^
	
# Compile: create object files from C source files
$(DIR_OBJ)/%.o: %.c | $(DIR_OBJ)
	@echo
	@echo $(TXT_LINE_SHORT)
	@echo $(TXT_COMPILE) $<
	@$(CC) $(CFLAGS) -c $< -o $@
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
$(DIR_BIN):
	@mkdir -p $(DIR_BIN)
