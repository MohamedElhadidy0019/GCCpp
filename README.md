# GCCpp
gcc plus plus, a compiler for a C-like language

# Getting ready
1. make sure to have GCC, bison and flex are installed on tour machine
2. clone the repo

# Generate the compiler
1. run **bison -d parser.y**
2. run **lex lexer.l**
3. run **gcc lex.yy.c parser.tab.c**
4. **a.out** file will be generated

# Testing the compiler
1. run **./a.out** and write testcases in the standard I/O (terminal)