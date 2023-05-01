%{
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

void yyerror(char *s);
int yylex();
int yyparse();

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

%nonassoc IFX
%nonassoc ELSE
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
	| do_while_statement ';' 
	| if_condition block_statement  %prec IFX
	| if_condition block            %prec IFX        // if () else
	| if_condition block_statement else_statement
	| if_condition block else_statement
	| while_statement 
	| for_statement 
	| switch_statement    
	| function  
	| return_statement ';'
    | print_statement ';'
    | block    
	;  


return_statement : RETURN expression
	| RETURN 
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
	| '(' expression ')'
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

while_statement: while_declaraction  block 
	| while_declaraction block_statement

while_declaraction : WHILE '(' logical_expression ')' 
	;


block : '{' block_statements '}'
	;

block_statements : block_statement
		  | block_statements block_statement

block_statement : declaration ';'
        | assignment ';'
        | expression ';'		
		| do_while_statement ';' 
		| if_condition block_statement    %prec IFX             // |if(true) x=5; else| x=6;
		| if_condition block              %prec IFX
		| if_condition block_statement else_statement
		| if_condition block else_statement
		| while_statement 
		| for_statement 
		| switch_statement  
		| return_statement ';'
        | print_statement ';'
        | CONTINUE ';'
		| BREAK ';'
        ;  

print_statement : PRINT '(' argument_print ')'
	;
argument_print: argument_print ',' expression
			| expression
			;


for_statement: for_declaration  block 
	| for_declaration block_statement
	;

for_declaration: FOR '(' variable_declaration  ';' logical_expression  ';' expression ')'
	            | FOR '(' variable_declaration  ';' logical_expression  ';' assignment ')'
	;

do_while_statement : DO  block while_declaraction
		    | DO  block_statement while_declaraction
			;

switch_statement : SWITCH '('expression')' '{' case_statement '}'


case_statement : CASE value ':' block case_statement 
		| DEFAULT ':' block 
		| %empty
		;


arguments: arguments ',' argument 
	| argument 
	| %empty
	;

argument : data_type IDENTIFIER
	| data_type IDENTIFIER '=' expression
	;
	
function : VOID IDENTIFIER '(' arguments')'  block 
	|  data_type IDENTIFIER  '(' arguments')'  block 
	;

function_call: IDENTIFIER '('argument_call')' 
	;

argument_call: argument_call ',' expression
			| expression
			| %empty
			;



// we need to having continue and break inside an if inside a loop
if_condition : IF '(' logical_expression ')'         
	;

else_statement : ELSE block
	       | ELSE block_statement         
		   ;

%%

void yyerror(char *s) {
    fprintf(stdout, "%s\n", s);
}

int main(void) {
	return yyparse();
}

