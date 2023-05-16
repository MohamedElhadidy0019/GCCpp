#!/bin/bash

# run Bison
bison -d parser.y

# run Flex
flex lexer.l

# compile
gcc parser.tab.c lex.yy.c

# run the output file
./a.out testcases.txt