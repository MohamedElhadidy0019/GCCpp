%{
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
# include "parser.h"

void yyerror(char *s);
int yylex();
int yyparse();

/* defining constants for data types*/
#define typeVoid 0
#define typeInteger 1
#define typeFloat 2
#define typeBoolean 3
#define typeCharchter 4
#define typeString 5
#define identifierKind 1
#define constantKind 2
#define constantValueKind 5
#define functionKind 3

void addToSymbolTable(char* name , int type, int kind);
int inTable(char* name);
int getType( int i);
int getKind( int i);
int checkType(int x , int y , int errorType);
int checkKind (int kind);
void setUsed(int i);
int Operations (char operation,int par1, int par2,int setPar, int setMulLvl);
void opr(int oper, int nops, ...);
int ex(struct nodeTypeTag *p) ; 
void addValue(void* value , int type);
void addToOperation (char operation, char* par1, char* par2);

struct nodeTypeTag symbol_table[10000];
struct valueNodes values[10000];
int scope = 0;
int scope_inc = 1;
int idx = 0 ;
int valueIdxInsert = 0;
int valueIdx = 0; 
int par = 2;
int addSubLvl = 0;
int mulDivLvl = 0;
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

/*rules types*/ 
%type <integer_value> data_type
%type <integer_value> value

/* Define grammar rules */
%start program

%%

program: block_statements    
	;

block_statements : block_statement
		  | block_statements block_statement

block_statement : declaration ';'
        | expression ';'		
		| do_while_statement ';' 
		| if_condition block_statement    %prec IFX 
		| if_condition block              %prec IFX
		| if_condition block_statement else_statement
		| if_condition block else_statement
		| while_statement 
		| for_statement 
		| switch_statement  
		| function
		| return_statement ';'
        | print_statement ';'
        | CONTINUE ';'
		| BREAK ';'
        ;

block : '{' block_statements '}'
	  | '{' '}'
	;

return_statement : RETURN expression
	| RETURN 
	;

declaration: variable_declaration 
    | enum_declaration
    ;

variable_declaration: data_type IDENTIFIER  
	{
		if(inTable((char*)$2) != -1)
			yyerror("this variable has been declared before");
		else
			addToSymbolTable((char*)($2),$1,identifierKind);
	}
	| data_type IDENTIFIER '=' expression
	{
		valueIdx = valueIdxInsert - 1;
		if(inTable((char*)$2) != -1)
			yyerror("this variable has been declared before");
		//checkType($1,$4,1); 
		addToSymbolTable((char*)($2),$1,identifierKind);
		//addToOperation('=', (char*)($2), "$");
		//mulDivLvl = 0;
		//par = 2;
	}
	| CONSTANT data_type IDENTIFIER '=' expression      
	{
		valueIdx = valueIdxInsert - 1;
		if(inTable((char*)$3) != -1)
			yyerror("this variable has been declared before");
		//checkType($2,$5,1); 
		addToSymbolTable((char*)($3),$2,identifierKind);
		//addToOperation('=', (char*)($2), "$");
		//mulDivLvl = 0;
		//par = 2;
	}  
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
	| assignment
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

value: INTEGER_TYPE  { addValue(&($1),typeInteger);$$ = typeInteger; }
	| FLOAT_TYPE     { addValue(&($1),typeFloat);$$ = typeFloat; }
	| BOOLEAN_TYPE   { addValue(&($1),typeBoolean);$$ = typeBoolean; }
	| CHARACTER_TYPE { addValue(&($1),typeCharchter);$$ = typeCharchter; }
	| STRING_TYPE    { addValue(&($1),typeString);$$ = typeString; }
	;

data_type: INT { $$ = typeInteger; }
	| FLOAT    { $$ = typeFloat; } 
	| BOOLEAN  { $$ = typeBoolean; } 
	| CHARACTER { $$ = typeCharchter; } 
	| STRING    { $$ = typeString; } 
	;


while_statement: while_declaraction  block 
	| while_declaraction block_statement

while_declaraction : WHILE '(' logical_expression ')' 
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
				| FOR '(' assignment  ';' logical_expression  ';' expression ')'
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

void addToSymbolTable(char* name , int type, int kind) { 
	struct nodeTypeTag p; 
	p.isUsed = 0;
	p.type = type;
	p.kind = kind;
	p.name = name;
	p.scope = scope;
	symbol_table[idx++] = p;
} 
int inTable(char* name){
	for (int i =0;i < idx;i++)
		if (symbol_table[i].kind!=4 && !strcmp(name,symbol_table[i].name) && symbol_table[i].scope == scope)
			return i;  
	return -1;
} 
int getType(int i){
	if (i == -1)
		return -1;       
	return symbol_table[i].type;
}
int getKind(int i){
	return symbol_table[i].kind;
}
void setUsed(int i){
	symbol_table[i].isUsed = 1;
}
int checkType(int x , int y , int errorType){
	if (x == -1)
		return y;
	else if (y == -1)
		return x;
	else if (x != y){
		switch (errorType){
			case 1:
				yyerror("variable type missmatches with the assigned value "); 
				break; 
			case 2:
				yyerror("constant type missmatches with the assigned value ");  
				break;
			case 3:
				yyerror("if condition  must be of type boolean ");  
				break;
			case 4:
				yyerror("while condition must be of type boolean ");  
				break;
			case 5:
				yyerror("for condition must be of type boolean ");  
				break;
			case 6:
				yyerror("case variable type must be same as switch variable type ");  
				break;
			case 7:
				yyerror("return type must be the same as function type ");  
				break;
		}
		return -1;
	}
	return x;
}
int checkKind (int kind){
	if (kind == 2)
		yyerror("constant cannot be modified");  
	if (kind == 3)
		yyerror("function cannot be modified");  
	return kind;
}

void addValue(void* value , int type){
	struct valueNodes p;
	p.type = type;
	p.used = 0;
	if (type == typeInteger)
		p.integer = *((int *)value);
	else if (type == typeFloat)
		p.floatNumber = *((float *)value);
	else if (type == typeBoolean)
		p.boolean = *((int *)value);
	else if (type == typeCharchter)
		p.character = *((char *)value);
	else
		p.name = (char*)value;
	values[valueIdxInsert++] = p;
}