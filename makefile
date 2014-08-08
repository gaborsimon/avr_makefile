####################################################################################################
#
# This makefile is created by SimonG (Gabor Simon)
#
# v20140730_1550
#
####################################################################################################

#***************************************************************************************************
#****** CONFIGURATION
#***************************************************************************************************

# Project name
PROJECT = main

# Controller type
MCU = atmega2560

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
DIR_SRC = src

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

# Generated object files
OBJ = $(patsubst %.c, $(DIR_OBJ)/%.o, $(notdir $(wildcard $(DIR_SRC)/*.c)))

# Compiler flags
CFLAGS  = -mmcu=$(MCU)
CFLAGS += $(OPT)
CFLAGS += -std=$(CSTANDARD)

# Linker flags
LDFLAGS =

# Program and command
CC      = avr-gcc
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
SIZE    = avr-size
RM      = -rm -d -R -f

# Messages during processing
TXT_LINE_LONG       = "========================================="
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

all: $(LST) $(MAP) $(EEP) $(HEX)
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


#***************************************************************************************************
#****** RULES
#***************************************************************************************************

# Create flash output file (.hex) from binary (.elf) output file
$(HEX): $(ELF) | $(DIR_UPL)
	@echo
	@echo $(TXT_CREATE_HEX)
	@$(OBJCOPY) -j .text -j .data -O $(FORMAT) $< $@
	@echo
	@echo
	@echo
	@$(SIZE) -C --mcu=$(MCU) $<

# Create EEPROM output file (.eep) from binary (.elf) output file
$(EEP): $(ELF) | $(DIR_UPL)
	@echo
	@echo -n $(TXT_CREATE_EEP) 
	@$(OBJCOPY) -j .eeprom --change-section-lma .eeprom=0 -O $(FORMAT) $< $@

# Create list output file (.lst) from binary (.elf) output file
$(LST): $(ELF) | $(DIR_GEN)
	@echo $(TXT_CREATE_LST) 
	@$(OBJDUMP) -h -S $< > $@ 

# Create mapping output file (.map) from binary (.elf) and object (.o) output files
$(MAP): $(ELF) $(OBJ) | $(DIR_GEN)
	@echo $(TXT_CREATE_MAP) 
	@$(CC) -g $(CFLAGS) -Wl,-Map,$@ -o $^

# Link: create GNU executable binary file (.elf) from object files (.o)
$(ELF): $(OBJ) | $(DIR_GEN)
	@echo
	@echo $(TXT_CREATE_ELF)
	@$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ 
	
# Compile: create object files from C source files
$(DIR_OBJ)/%.o: $(DIR_SRC)/%.c | $(DIR_OBJ)
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
$(DIR_UPL):
	@mkdir -p $(DIR_UPL)