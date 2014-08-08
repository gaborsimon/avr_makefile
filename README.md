avr_makefile
============

------------
INTRODUCTION
------------

General self-made makefile for ATMEL AVR based development.

I have created this makefile because I was unsatisfied with the auto-generated makefiles can be found on the net.
All of them were too general and complex, hard to follow what they are doing, using unintended commands and actions.

This makefile is intended to use only for ATMEL AVR microcontroller based projects.

I use it for command-line development.
Necessary tools:
- editor (e.g.: gVim, Notepad++)
- avr8-gnu-toolchain: C/C++ cross compiler, assembler and linker, C-libraries for developing C/C++ programs
- command line shell (e.g.: Cygwin, Mingw)
- programmer (e.g.: avrdude)



-------------------
DIRECTORY STRUCTURE
-------------------

The makefile needs the following directory structure:

[MyProjectName]
  - [sources]
    - main.c
    - main.h
    - othersource.c
    - othersource.h
  - makefile

The [sources] directory shall contain all of the .c and .h files.
Currently the subdirectories are not supported.
The makefile shall be placed into the project root directory.

After compiling and linking the following additional directories and files will be created:

[generated]
  - .elf (the binary file)
  - .lst (the list file)
  - .map (the mapping file)

[objects]
  - .o (object files)

[upload]
  - .eep (the EEPROM data)
  - .hex (the hex file for flashing)
  


-------------------
COMMANDS
-------------------

The makefile provides commands for the following:

(A) BUILD: Creates the necessary directories with object, binary, list, mapping, eeprom and hex files

(B) CLEAN: Removes all of the generated directories ([generated], [objects], [upload]).

(C) ALL: Performs the CLEAN after the BUILD commands.

(D) PROGRAM: Uploads the .hex file into the AVR ship.

(E) READFUSE: Reads back the fuse bits from the AVR chip into individual .hex files (high fuse, low fuse, extended fuse) of [UPLOAD] directory.

(E) READEEPROM: Reads back the EEPROM content from the AVR chip into a .hex files of [UPLOAD] directory.
