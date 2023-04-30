%{
#include <stdlib.h>
#include <string.h>

void yyerror(char *s);

%}

/* Define yylval union */
%union {
    int integer_value;
    float float_value;
    char char_value;
    char* string_value;
    int boolean_value;
    char* identifier;
}

/* Define token types */
%token <integer_value> INTEGER_TYPE
%token <float_value> FLOAT_TYPE
%token <char_value> CHARACTER_TYPE
%token <string_value> STRING_TYPE
%token <boolean_value> BOOLEAN_TYPE
%token <identifier> IDENTIFIER
%token IF ELSE
%token DO WHILE
%token FOR BREAK CONTINUE
%token SWITCH CASE DEFAULT
%token CHARACTER STRING INT FLOAT BOOLEAN CONSTANT
%token VOID RETURN
%token ENUM
%token EQUAL NOT_EQUAL GREATER_THAN_OR_EQUAL LESS_THAN_OR_EQUAL
%token AND OR
%token PRINT

/* Define operator precedence and associativity */
%left ','
%right '='
%left AND
%left OR
%left EQUAL NOT_EQUAL 
%left '<' '>' LESS_THAN_OR_EQUAL GREATER_THAN_OR_EQUAL 
%left '+' '-'
%left '*' '/' '%' 
%right'!' '&' 
%precedence '(' ')' '{' '}'

/* Define grammar rules */
%start program

%%

program: statements    
	;

statements: statement 
	| statements statement 
	;

statement: declaration ';'
    | assignment ';'
    | expression ';'
	| if_statement 
	| do_while_statement ';' 
	| while_statement 
	| for_statement 
	| switch_statement    
	| function  
    | print_statement ';'
    | block    
	;  



declaration: variable_declaration 
    | enum_declaration
    ;

variable_declaration: data_type IDENTIFIER 
	| data_type IDENTIFIER '=' expression
	| CONSTANT data_type IDENTIFIER '=' expression        
	;

enum_declaration: ENUM IDENTIFIER '{' enum_list '}'
    ;

enum_list: enum_item
    | enum_list ',' enum_item
    ;

enum_item: IDENTIFIER '=' INTEGER_TYPE
    | IDENTIFIER
    ;

assignment : IDENTIFIER '=' expression
    ;

expression: math_expression
	| logical_expression 
	| '(' expression_statement ')'
	| function_call
	;

// we need to handle negative numbers in math_expression
math_expression:  expression '+' term
	| expression '-' term
	| term
	;

term: term '*' factor
    | term '/' factor
    | term '%' factor
    | factor
    ;

factor: value 
    | IDENTIFIER
    ;

value: INTEGER_TYPE 
	| FLOAT_TYPE 
	| BOOLEAN_TYPE 
	| CHARACTER_TYPE 
	| STRING_TYPE
	;

data_type: INT
	| FLOAT 
	| BOOLEAN 
	| CHARACTER 
	| STRING
	;
logical_expression:  '!' expression 
	| expression '<' expression 
	| expression '>' expression
	| expression GREATER_THAN_OR_EQUAL expression 
	| expression LESS_THAN_OR_EQUAL expression 
	| expression AND expression
	| expression OR expression
	| expression EQUAL expression
	| expression NOT_EQUAL expression
    ;

while_statement: while_declaraction  loop_block_statement 
	| while_declaraction loop_statement

block : '{' block_statements '}'
	;

block_statements : block_statement
		  | block_statements block_statement

block_statement : declaration ';'
        | assignment ';'
        | expression ';'		
		| if_statement 
		| do_while_statement ';' 
		| while_statement 
		| for_statement 
		| switch_statement  
        | print_statement ';'
        | CONTINUE ';'
		| BREAK ';'
        ;  
		 
// we need to having continue and break inside an if inside a loop
if_statement: if_condition block
	| if_condition block_statement
	;

if_condition : IF '('logical_expression')'
			 ;

else_statement : ELSE block_statement
	       | ELSE block
	       | ';'


















%%






