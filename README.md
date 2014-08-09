GOAL
----
This project (document) is about a general self-made makefile for ATMEL AVR based development.


INTRODUCTION
------------

I have created this makefile because I was unsatisfied with the auto-generated makefiles can be found on the net.
All of them were too general and complex, hard to follow what they are doing, they are using unintended commands and actions.

This makefile is intended to use only for ATMEL AVR microcontroller based projects.

I use it for command-line development.
Necessary tools:
- editor (e.g.: gVim, Notepad++)
- avr8-gnu-toolchain: C/C++ cross compiler, assembler and linker, C-libraries for developing C/C++ programs
- command line shell (e.g.: Cygwin, Mingw)
- programmer (e.g.: avrdude)

DIRECTORY STRUCTURE
-------------------
The makefile needs the following directory structure:

```
[MyProject]
 |- [sources]
 |   |- main.c
 |   |- main.h
 |   |- othersource.c
 |   |- othersource.h
 |- makefile
```

The *[sources]* directory shall contain all of the *.c* and *.h* files.
Currently the subdirectories are not supported.
The makefile shall be placed into the project root directory.

After compiling and linking the following additional directories and files will be created:

* *[generated]*
  * *.elf*: the binary file
  * *.lst*: the list file
  * *.map*: the mapping file

* *[objects]*
  * *.o*: object files

* *[upload]*
  * *.eep*: the EEPROM data
  * *.hex*: the hex file for flashing
  
COMMANDS LIST
-------------
The makefile provides the following commands:

* **BUILD:** Creates the necessary directories with object, binary, list, mapping, eeprom and hex files.
Does not support the incremental build (no dependency files are generated).

* **CLEAN:** Removes all of the generated directories (*[generated]*, *[objects]*, *[upload]*).

* **ALL:** Performs the **CLEAN** + **BUILD** commands.

* **PROGRAM:** Uploads the *.hex* file into the AVR chip.

* **READFUSE:** Reads back the fuse bits from the AVR chip into individual *.hex* files (high fuse, low fuse, extended fuse) of *[UPLOAD]* directory.

* **READEEPROM:** Reads back the EEPROM content from the AVR chip into a *.hex* file of *[UPLOAD]* directory.
