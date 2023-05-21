%{
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
# include "parser.h"

FILE* logFile;

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
#define functionKind 3

#define valueMismatch 1
#define constValueMismatch 2
#define ifCondBoolErr 3
#define whileCondBoolErr 4
#define forCondBoolErr 5
#define caseMismatch 6
#define returnMismatch 7


int getType( int i);
int getKind( int i);

int checkKind (int kind);
void setUsed(int i);

/*my functions*/
valueNode* setValueNode(int type, void* value);
void addToSymbolTable(char* name , int type, int kind, valueNode* value);
int inTable(char* name);
int inTableGlobal(char* name);
int checkType(int x , valueNode* y , int errorType);
valueNode* Operations (char operation,valueNode* par1, valueNode* par2);
valueNode* logicalOperations(char* operation, valueNode* par1, valueNode* par2);
void comparisonOperations(char* opeartion, valueNode* par1, valueNode* par2, valueNode* result);
void addOperation(valueNode* p, valueNode* val1, valueNode* val2);
void subtractOperation(valueNode* p, valueNode* val1, valueNode* val2);
void multiplyOperation(valueNode* p, valueNode* val1, valueNode* val2);
void divideOperation(valueNode* p, valueNode* val1, valueNode* val2);
void modOperation(valueNode* p, valueNode* val1, valueNode* val2);
valueNode* getIDValue(char* name);
void printSymbolTable();
void printSymbolTableCSV();
void removeCurrentScope();
void updateSymbolTable(char* name, valueNode* value);
valueNode* getIDValue(char* name);
//----------------------------------------------
struct STNode symbol_table[10000];

int scope = 0;
int idx = 0 ;
int update = 0;
%}

/* Define yylval union */
%union {
    int integer_value;
    float float_value;
    char char_value;
    char* string_value;
    int boolean_value;
    char* identifier;
	struct valueNodes* valueNode;
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
%type <valueNode> value expression math_expression logical_expression term factor function_call

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
		| assignment ';'
        | CONTINUE ';'
		| BREAK ';'
        ;

block : '{' {scope++;} block_statements '}' {removeCurrentScope(); scope--;}  
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
			// error that the variable has been declared before
			printf("error: Variable %s has been declared before\n", (char*)$2);
		else
			addToSymbolTable((char*)($2),$1,identifierKind, NULL);
	}
	| data_type IDENTIFIER '=' expression
	{
		if(inTable((char*)$2) != -1)
			printf("error: Variable %s has been declared before\n", (char*)$2);
		else if ($4 != NULL && checkType($1,$4,valueMismatch) != -1); 
			addToSymbolTable((char*)($2),$1,identifierKind, $4);
	}
	| CONSTANT data_type IDENTIFIER '=' expression      
	{
		if(inTable((char*)$3) != -1)
			printf("error: Constant %s has been declared before\n", (char*)$3);
		else if ($5 != NULL && checkType($2,$5,valueMismatch) != -1); 
			addToSymbolTable((char*)($3),$2,constantKind, $5);
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

assignment : IDENTIFIER '=' expression  {updateSymbolTable($1,$3);}
    ; 

expression: math_expression  { $$ = $1;}
	| logical_expression  { $$ = $1;}
	| '(' expression ')' { $$ = $2;}
	| function_call      { $$ = $1;}
	;

// we need to handle negative numbers in math_expression
math_expression:  expression '+' term {$$ = Operations('+', $1, $3); }
	| expression '-' term  		      {$$ = Operations('-', $1, $3); }
	| term                            {$$ = $1;}
	;

term: term '*' factor       {$$ = Operations('*', $1, $3); }
    | term '/' factor       {$$ = Operations('/', $1, $3); }
    | term '%' factor       {$$ = Operations('%', $1, $3); }
    | factor                {$$ = $1;}
    ;

factor: value               {$$ = $1;}
    | IDENTIFIER            {$$ = getIDValue($1);}
    ;

logical_expression:  '!' expression   { $$ = logicalOperations("!", $2, NULL); }
	| expression '<' expression       { $$ = logicalOperations("<", $1, $3); }
	| expression '>' expression       { $$ = logicalOperations(">", $1, $3); }
	| expression GREATER_THAN_OR_EQUAL expression     { $$ = logicalOperations(">=" , $1, $3); }
	| expression LESS_THAN_OR_EQUAL expression        { $$ = logicalOperations("<=", $1, $3); }
	| expression AND expression                       { $$ = logicalOperations("&&", $1, $3); }
	| expression OR expression                        { $$ = logicalOperations("||", $1, $3); }
	| expression EQUAL expression                     { $$ = logicalOperations("==", $1, $3); }
	| expression NOT_EQUAL expression                 { $$ = logicalOperations("!=", $1, $3); }
    ;

value: INTEGER_TYPE  { $$ = setValueNode(typeInteger, &$1); }
	| FLOAT_TYPE     { $$ = setValueNode(typeFloat, &$1); }
	| BOOLEAN_TYPE   { $$ = setValueNode(typeFloat, &$1); }
	| CHARACTER_TYPE { $$ = setValueNode(typeCharchter, &$1); }
	| STRING_TYPE    { $$ = setValueNode(typeString, &$1); }
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

for_declaration: FOR '(' variable_declaration  ';' logical_expression  ';' assignment ')'
				| FOR '(' assignment  ';' logical_expression  ';' assignment ')'
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

//-------------------------------------------------------------------------------------------------
void yyerror(char *s) {
    fprintf(stdout, "%s\n", s);
}


//--------------------------------------------------
/* My functions*/
valueNode* setValueNode(int type, void* value){
	valueNode* p = (valueNode*)malloc(sizeof(valueNode));
	p->type = type;
	//p->kind = constantKind;
	if (type == typeInteger)
		p->integer = *((int *)value);
	else if (type == typeFloat)
		p->floatNumber = *((float *)value);
	else if (type == typeBoolean)
		p->boolean = *((int *)value);
	else if (type == typeCharchter)
		p->character = *((char *)value);
	else
		p->name = (char*)value;
	return p;
}


void addToSymbolTable(char* name , int type, int kind, valueNode* value) { 
	struct STNode p; 
	p.isUsed = 1;
	p.type = type;
	p.kind = kind;
	p.name = name;
	p.scope = scope;
	p.value = value;
	symbol_table[idx++] = p;

	// print the symbol table as CSV
	printSymbolTableCSV();
} 
int inTable(char* name){
	for (int i =0;i < idx;i++)
		if (!strcmp(name,symbol_table[i].name) && symbol_table[i].scope == scope  && symbol_table[i].isUsed == 1)
			return i;  
	return -1;
} 

int inTableGlobal(char* name){
	for (int i =0;i < idx;i++)
		if (!strcmp(name,symbol_table[i].name) && symbol_table[i].scope == 0)
			return i;  
	return -1;
}

int checkType(int x , valueNode* y , int errorType){
	if (y != NULL && x != y->type){
		switch (errorType){
			case valueMismatch:
				yyerror("variable/constant mismatches with the assigned value "); 
				break; 
			case ifCondBoolErr:
				yyerror("if condition  must be of type boolean ");  
				break;
			case whileCondBoolErr:
				yyerror("while condition must be of type boolean ");  
				break;
			case forCondBoolErr:
				yyerror("for condition must be of type boolean ");  
				break;
			case caseMismatch:
				yyerror("case variable type must be same as switch variable type ");  
				break;
			case returnMismatch:
				yyerror("return type must be the same as function type ");  
				break;
		}
		return -1;
	}
	return x;
}

void addOperation(valueNode* p, valueNode* val1, valueNode* val2) {
	switch(p->type) {
		case typeInteger: {
			p->integer = val1->integer + val2->integer;
			break;
		}
		case typeFloat: {
			p->floatNumber = val1->floatNumber + val2->floatNumber;
			break;
		}
		case typeBoolean: {
			p->boolean = val1->boolean + val2->boolean;
			break;
		}
		case typeCharchter: {
			p->character = val1->character + val2->character;
			break;
		}
		case typeString: {
			p->name = (char*)malloc(strlen(val1->name) + strlen(val2->name) + 1);
			strcpy(p->name, val1->name);
			strcat(p->name, val2->name);
			break;
		}
	}
}

void subOperation(valueNode* p, valueNode* val1, valueNode* val2) {
	switch(p->type) {
		case typeInteger: {
			p->integer = val1->integer - val2->integer;
			break;
		}
		case typeFloat: {
			p->floatNumber = val1->floatNumber - val2->floatNumber;
			break;
		}
		case typeBoolean: {
			p->boolean = val1->boolean - val2->boolean;
			break;
		}
		case typeCharchter: {
			p->character = val1->character - val2->character;
			break;
		}
		case typeString: {
			// error string does not support subtraction
			printf("string does not support subtraction");
			break;
		}
	}
}

void multiplyOperation(valueNode* p, valueNode* val1, valueNode* val2) {
	switch(p->type) {
		case typeInteger: {
			p->integer = val1->integer * val2->integer;
			break;
		}
		case typeFloat: {
			p->floatNumber = val1->floatNumber * val2->floatNumber;
			break;
		}
		case typeBoolean: {
			p->boolean = val1->boolean * val2->boolean;
			break;
		}
		case typeCharchter: {
			p->character = val1->character * val2->character;
			break;
		}
		case typeString: {
			// error string does not support subtraction
			printf("string does not support multiplication");
			break;
		}
	}
}

void modeOperation(valueNode* p, valueNode* val1, valueNode* val2) {
	switch(p->type) {
		case typeInteger: {
			p->integer = (val2->integer != 0)? val1->integer % val2->integer : 0;
			if (val2->integer == 0)
				yyerror("division by zero"); 
			break;
		}
		case typeFloat: {
			printf("Float values do not support mode operation");
			p->floatNumber = 0.0;
			if (val2->floatNumber == 0.0)
				yyerror("division by zero"); 
			break;
		}
		case typeBoolean: {
			printf("Boolean values do not support mode operation");
			break;
		}
		case typeCharchter: {
			p->character = val1->character % val2->character;
			break;
		}
		case typeString: {
			// error string does not support subtraction
			printf("String values do not support mode operation");
			break;
		}
	}
}

void divideOperation(valueNode* p, valueNode* val1, valueNode* val2) {
	switch(p->type) {
		case typeInteger: {
			p->integer = (val2->integer != 0)? val1->integer / val2->integer : 0;
			if (val2->integer == 0)
				yyerror("division by zero"); 
			break;
		}
		case typeFloat: {
			p->floatNumber = (val2->floatNumber != 0.0)? val1->floatNumber / val2->floatNumber : 0.0;
			if (val2->floatNumber == 0.0)
				yyerror("division by zero"); 
			break;
		}
		case typeBoolean: {
			printf("boolean does not support divide operation");
			break;
		}
		case typeCharchter: {
			p->character = val1->character / val2->character;
			break;
		}
		case typeString: {
			// error string does not support subtraction
			printf("string does not support divide operation");
			break;
		}
	}
}

valueNode* Operations (char operation,valueNode* par1, valueNode* par2) {
	int type1 = par1->type;
	int type2 = par2->type;
	// check if the two types are the same
	if (checkType(type1, par2, valueMismatch) == type1){
		valueNode* p = (valueNode*)malloc(sizeof(valueNode));
		p->type = type1;
		switch(operation) {
			case '+': {
				addOperation(p, par1, par2);
				break;
			}
			case '-': {
				subOperation(p, par1, par2);
				break;
			}
			case '*': {
				multiplyOperation(p, par1, par2);
				break;
			}
			case '%': {
				modeOperation(p, par1, par2);
				break;
			}
			case '/': {
				divideOperation(p, par1, par2);
				break;
			}
			default: {
				printf("operation not supported");
				break;
			}
		}
		return p;
	}
	return NULL;
	
}

void comparisonOperations(char* operation, valueNode* par1, valueNode* par2, valueNode* result) {

	int type1 = par1->type;
	switch(type1) {
		case typeInteger: {
			int val1 = par1->integer;
			int val2 = par2->integer;
			if(strcmp(operation, "==") == 0) {
				result->boolean = (val1 == val2);
			}
			else if(strcmp(operation, "!=") == 0) {
				result->boolean = (val1 != val2);
			}
			else if(strcmp(operation, ">") == 0) {
				result->boolean = (val1 > val2);
			}
			else if(strcmp(operation, "<") == 0) {
				result->boolean = (val1 < val2);
			}
			else if(strcmp(operation, ">=") == 0) {
				result->boolean = (val1 >= val2);
			}
			else if(strcmp(operation, "<=") == 0) {
				result->boolean = (val1 <= val2);
			}
		}
		case typeFloat: {
			float val1 = par1->floatNumber;
			float val2 = par2->floatNumber;
			if(strcmp(operation, "==") == 0) {
				result->boolean = (val1 == val2);
			}
			else if(strcmp(operation, "!=") == 0) {
				result->boolean = (val1 != val2);
			}
			else if(strcmp(operation, ">") == 0) {
				result->boolean = (val1 > val2);
			}
			else if(strcmp(operation, "<") == 0) {
				result->boolean = (val1 < val2);
			}
			else if(strcmp(operation, ">=") == 0) {
				result->boolean = (val1 >= val2);
			}
			else if(strcmp(operation, "<=") == 0) {
				result->boolean = (val1 <= val2);
			}
		}
		case typeBoolean: {
			int val1 = par1->boolean;
			int val2 = par2->boolean;
			if(strcmp(operation, "==") == 0) {
				result->boolean = (val1 == val2);
			}
			else if(strcmp(operation, "!=") == 0) {
				result->boolean = (val1 != val2);
			}
			else if(strcmp(operation, ">") == 0) {
				result->boolean = (val1 > val2);
			}
			else if(strcmp(operation, "<") == 0) {
				result->boolean = (val1 < val2);
			}
			else if(strcmp(operation, ">=") == 0) {
				result->boolean = (val1 >= val2);
			}
			else if(strcmp(operation, "<=") == 0) {
				result->boolean = (val1 <= val2);
			}
		}
		case typeCharchter: {
			char val1 = par1->character;
			char val2 = par2->character;
			if(strcmp(operation, "==") == 0) {
				result->boolean = (val1 == val2);
			}
			else if(strcmp(operation, "!=") == 0) {
				result->boolean = (val1 != val2);
			}
			else if(strcmp(operation, ">") == 0) {
				result->boolean = (val1 > val2);
			}
			else if(strcmp(operation, "<") == 0) {
				result->boolean = (val1 < val2);
			}
			else if(strcmp(operation, ">=") == 0) {
				result->boolean = (val1 >= val2);
			}
			else if(strcmp(operation, "<=") == 0) {
				result->boolean = (val1 <= val2);
			}
		}
		case typeString: {
			char* val1 = par1->name;
			char* val2 = par2->name;
			if(strcmp(operation, "==") == 0) {
				result->boolean = (strcmp(val1, val2) == 0);
			}
			else if(strcmp(operation, "!=") == 0) {
				result->boolean = (strcmp(val1, val2) != 0);
			}
			else if(strcmp(operation, ">") == 0) {
				result->boolean = 0;
				printf("Error: cannot compare strings with >\n");
			}
			else if(strcmp(operation, "<") == 0) {
				result->boolean = 0;
				printf("Error: cannot compare strings with <\n");
			}
			else if(strcmp(operation, ">=") == 0) {
				result->boolean = 0;
				printf("Error: cannot compare strings with >=\n");
			}
			else if(strcmp(operation, "<=") == 0) {
				result->boolean = 0;
				printf("Error: cannot compare strings with <=\n");
			}
		}
	}
}



valueNode* logicalOperations(char* operation, valueNode* par1, valueNode* par2) {
	int type1 = par1->type;
	int type2 = par2->type;
	// check if the two types are the same
	if (checkType(type1, par2, valueMismatch) == type1){
		valueNode* p = (valueNode*)malloc(sizeof(valueNode));
		p->type = typeBoolean;
		if(strcmp(operation, "&&") == 0) {
			p->boolean = par1->boolean && par2->boolean;
		}
		else if(strcmp(operation, "||") == 0) {
			p->boolean = par1->boolean || par2->boolean;
		}
		else if(strcmp(operation, "!") == 0) {
			p->boolean = !par1->boolean;
		}
		else if(strcmp(operation, "==") == 0) {
			p->boolean = par1->boolean == par2->boolean;
		}
		else if(strcmp(operation, "!=") == 0) {
			p->boolean = par1->boolean != par2->boolean;
		}
		else if(strcmp(operation, "<") == 0) {
			p->boolean = par1->boolean < par2->boolean;
		}
		else if(strcmp(operation, ">") == 0) {
			p->boolean = par1->boolean > par2->boolean;
		}
		else if(strcmp(operation, "<=") == 0) {
			p->boolean = par1->boolean <= par2->boolean;
		}
		else if(strcmp(operation, ">=") == 0) {
			p->boolean = par1->boolean >= par2->boolean;
		}
		return p;
	}
	return NULL;
}

valueNode* getIDValue(char* name) {
	// check that the variable is in the symbol table
	int index = inTable(name);
	if (index == -1) {
		printf("variable %s not declared in this scope", name);
		return NULL;
	}
	// check that the variable is initialized
	if (symbol_table[index].isUsed == 0) {
		yyerror("variable not initialized");
		return NULL;
	}
	// return the value of the variable
	return symbol_table[index].value;
}

void updateSymbolTable(char* name, valueNode* value) {
	// check that the variable is in the symbol table in the global scope (scope = 0)
	int index = inTable(name);
	if (index == -1) {
		// here the variable is not in the current scope but it may be in the global scope
		index = inTableGlobal(name);
		if (index == -1) {
			printf("variable %s not declared", name);
			return;
		}
	}

	// update the value of the variable
	symbol_table[index].value = value;
	
	// print the symbol table as CSV
	printSymbolTableCSV();	

}

// this function removes all variables with current scope from the symbol table using deallocation 
void removeCurrentScope() {
	int i;
	for (i = 0; i < idx; i++) {
		if (symbol_table[i].scope == scope) {
			symbol_table[i].isUsed = 0;
			symbol_table[i].value = NULL;
		}
	}
}

void printSymbolTable() {
	// Open the log file
    logFile = fopen("symbol_table.log", "a");
    if (logFile == NULL) {
        fprintf(stderr, "Error opening log file.\n");
        exit(1);
    }
	update++;
	fprintf(logFile, "Symbol Table version %d:\n", update);
	fprintf(logFile, "====================================================\n");
	int i;
	for (i = 0; i < idx; i++) {
		switch(symbol_table[i].type) {
			case typeInteger: {
				fprintf(logFile, "name: %s, scope: %d, type: %d, value: %d, isUsed: %d\n", symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, symbol_table[i].value->integer, symbol_table[i].isUsed);
				break;
			}
			case typeFloat: {
				fprintf(logFile, "name: %s, scope: %d, type: %d, value: %f, isUsed: %d\n", symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, symbol_table[i].value->floatNumber, symbol_table[i].isUsed);
				break;
			}
			case typeString: {
				fprintf(logFile, "name: %s, scope: %d, type: %d, value: %s, isUsed: %d\n", symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, symbol_table[i].value->name, symbol_table[i].isUsed);
				break;
			}
			case typeBoolean: {
				fprintf(logFile, "name: %s, scope: %d, type: %d, value: %d, isUsed: %d\n", symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, symbol_table[i].value->boolean, symbol_table[i].isUsed);
				break;
			}
			case typeCharchter: {
				fprintf(logFile, "name: %s, scope: %d, type: %d, value: %c, isUsed: %d\n", symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, symbol_table[i].value->character, symbol_table[i].isUsed);
				break;
			}
			default: {
				fprintf(logFile, "name: %s, scope: %d, type: %d, isUsed: %d\n", symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, symbol_table[i].isUsed);
				break;
			}
		}
	}
	fprintf(logFile, "====================================================\n");

	// Close the log file
	fclose(logFile);
}

// this function prints the symbol table in the log file as a comma separated values
void printSymbolTableCSV() {
	// Open the log file
	logFile = fopen("symbol_table.log", "a");
	if (logFile == NULL) {
		fprintf(stderr, "Error opening log file.\n");
		exit(1);
	}
	//update++;
	//fprintf(logFile, "%d,", update);
	// print the fields names
	fprintf(logFile, "name, scope, type, value\n");
	int i;
	for (i = 0; i < idx; i++) {
		switch(symbol_table[i].type) {
			case typeInteger: {
				if(symbol_table[i].value != NULL)
					fprintf(logFile, "%s,%d,%d,%d\n", symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, symbol_table[i].value->integer);
				else
					fprintf(logFile, "%s,%d,%d,%s\n", symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, "garbage");
				break;
			}
			case typeFloat: {
				if(symbol_table[i].value != NULL)
					fprintf(logFile, "%s,%d,%d,%f\n", symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, symbol_table[i].value->floatNumber);
				else
					fprintf(logFile, "%s,%d,%d,%s\n", symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, "garbage");
				break;
			}
			case typeString: {
				if(symbol_table[i].value != NULL)
					fprintf(logFile, "%s,%d,%d,%s\n", symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, symbol_table[i].value->name);
				else
					fprintf(logFile, "%s,%d,%d,%s\n", symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, "garbage");
				break;
			}
			case typeBoolean: {
				if(symbol_table[i].value != NULL)
					fprintf(logFile, "%s,%d,%d,%d\n", symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, symbol_table[i].value->boolean);
				else
					fprintf(logFile, "%s,%d,%d,%s\n", symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, "garbage");
				break;
			}
			case typeCharchter: {
				if(symbol_table[i].value != NULL)
					fprintf(logFile, "%s,%d,%d,%c\n", symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, symbol_table[i].value->character);
				else
					fprintf(logFile, "%s,%d,%d,%s\n", symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, "garbage");
				break;
			}
			default: {
				fprintf(logFile, "%s,%d,%d\n", symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type);
				break;
			}
		}
	}
	// print a separator line
	fprintf(logFile, "==================================================\n");

	// Close the log file
	fclose(logFile);
}