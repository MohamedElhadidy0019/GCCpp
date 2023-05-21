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
#define funArgMismatch 8


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
int checkArgs(Args* args1, Args* args2);
int functionInTable(char* name, Args* args);
void addFunctionToSymbolTable(char* name, int type, int kind, Args* args);
int getActiveFunctionType();
int getFunctionType(int index);
//----------------------------------------------
struct STNode symbol_table[10000];

int scope = 0;
int idx = 0 ;
int update = 0;
int activeFunctionType = -1;
int switchType = -1;
int loop = 0;
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
	struct Args* fnArgs;
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
%type <integer_value> data_type argument
%type <valueNode> value expression math_expression logical_expression term factor function_call
%type <fnArgs> arguments argument_call

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
		| if_condition block              %prec IFX
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
	  | {scope++;} block_statement {removeCurrentScope(); scope--;}
	  | '{' '}'
	;

return_statement : RETURN expression 
	{
		if(activeFunctionType == -1)
			printf("error: return statement not in a function\n");
		else
			checkType(activeFunctionType, $2, returnMismatch);
	}	
	| RETURN 
	{
		if(activeFunctionType == -1)
			printf("error: return statement not in a function\n");
		else if(activeFunctionType != typeVoid)
			printf("error: return type mismatch\n");
	}
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

assignment : IDENTIFIER '=' expression  
	{
		if(loop == 0)
			updateSymbolTable($1,$3);
		else {
			if(inTable($1) == -1)
				printf("error: Variable %s has not been declared before\n", $1);
			else {
				int type = getIDValue($1)->type;
				checkType(type, $3, valueMismatch);  
			}
		}
	}
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
	;

while_declaraction : WHILE 	{
		if(activeFunctionType == -1)
			printf("error: while/do while statement not in a function\n");
	}  '(' logical_expression ')'
	;


  

print_statement : PRINT '(' argument_print ')'
	;
argument_print: argument_print ',' expression
			| expression
			;


for_statement: for_declaration block 
	{
		if(activeFunctionType == -1)
			printf("error: for statement not in a function\n");	
	}
	;

for_declaration: FOR '(' {scope++; loop=1;} variable_declaration  ';' logical_expression  ';' assignment ')' {scope--; loop=0;}

		| FOR '(' assignment  ';' logical_expression  ';' assignment ')'
	;

do_while_statement : DO  block while_declaraction
			;

switch_statement : SWITCH '('expression')'
			{
				if(activeFunctionType == -1)
					printf("error: switch statement not in a function\n");
				if($3 != NULL)
					switchType = $3->type;
			} 
			'{' case_statement '}' {switchType = -1;}


case_statement : CASE value ':' 
		{
			if(switchType == -1) 
				printf("error: case statement not in a switch statement\n");
			else {
				checkType(switchType, $2, caseMismatch);
			}
			
		} block case_statement 
		| DEFAULT ':' block 
		| %empty
		;


arguments: arguments ',' argument 
	{
		Args* args = (Args*)$1;
		args->types[args->nargs] = $3;
		args->nargs++;
		$$ = args;
	}
	| argument  
	{
	 	Args* args = (Args*)malloc(sizeof(Args));
		args->types[0] = $1;
		args->nargs = 1;
		$$ = args;
	}
	| %empty {Args* args = (Args*)malloc(sizeof(Args)); args->nargs = 0; $$ = args;}
	;
	

argument : data_type IDENTIFIER 
	{
		if(inTable((char*)$2) != -1)
			printf("error: Variable %s has been declared before\n", (char*)$2);
		else {
			addToSymbolTable((char*)$2,$1,functionKind, NULL);
			$$ = $1;
		}
	}
	| data_type IDENTIFIER '=' expression 
	{	
		int check = checkType($1,$4,funArgMismatch);
		if(check != -1) {
			if(inTable((char*)$2) != -1)
				printf("error: Variable %s has been declared before\n", (char*)$2);
			else if ($4 != NULL && checkType($1,$4,valueMismatch) != -1) {
				addToSymbolTable((char*)$2,$1,functionKind, $4);
				$$ = $1;
			}
		}
	}
	;
	
function : VOID IDENTIFIER  '(' {activeFunctionType = typeVoid;} arguments')'  block  {activeFunctionType = -1; addFunctionToSymbolTable($2,typeVoid,functionKind, $5);}
	|  data_type IDENTIFIER  '(' {activeFunctionType = $1;} arguments')'  block  {activeFunctionType = -1; addFunctionToSymbolTable($2,$1,functionKind, $5);}
	;

function_call: IDENTIFIER '('argument_call')'  
	{
		int index = functionInTable((char*)$1, $3);
		if(index == -1)
			printf("error: function %s has not been declared before\n", (char*)$1);
		else {
			valueNode* val = (valueNode*)malloc(sizeof(valueNode));
			val->type = getFunctionType(index);
			$$ = val;
		}
	}
	;

argument_call: argument_call ',' expression  
			{
				Args* args = (Args*)$1;
				if($3 != NULL) {
					args->types[args->nargs] = $3->type;
					args->nargs++;
					$$ = args;	
				}
				else {
					args->nargs = 0;
					$$ = args;
				}
			}
			| expression  
			{
				Args* args = (Args*)malloc(sizeof(Args));
				if($1 != NULL) {
					args->types[0] = $1->type;
					args->nargs = 1;
					$$ = args;	
				}
				else {
					args->nargs = 0;
					$$ = args;
				}
			}
			| %empty {Args* args = (Args*)malloc(sizeof(Args)); args->nargs = 0; $$ = args;}
			;



if_condition : IF {
		if(activeFunctionType == -1)
			printf("error: if statement not in a function\n");
	}  '(' logical_expression ')'         
	;

else_statement : ELSE block      
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


// this function checks that all the args are of the same type as another args types
// 0 means that the 2 args are not the same
// 1 means that the 2 args are the same
int checkArgs(Args* args1, Args* args2){
	if (args1->nargs != args2->nargs) {
		for(int i=0; i<args1->nargs; i++){
			if (args1->types[i] != args2->types[i])
				return 0;
		}
		return 1;
	}
	else
		return 0;

}
int getFunctionType(int index){
	return symbol_table[index].type;
}
int functionInTable(char* name, Args* args){
	for (int i =0;i < idx;i++)
		if (!strcmp(name,symbol_table[i].name) && symbol_table[i].scope == 0 && symbol_table[i].kind == functionKind && checkArgs(args, symbol_table[i].args) == 1) {
			return i;  
		}
		else if(!strcmp(name,symbol_table[i].name) && symbol_table[i].scope == 0 && (symbol_table[i].kind == identifierKind || symbol_table[i].kind == constantKind)) {
			return i;
		}
	return -1;
}

void addFunctionToSymbolTable(char* name, int type, int kind, Args* args){
	if(scope != 0){
		printf("Error: function %s  must be global\n", name);
	}
	else {
		if (functionInTable(name, args) != -1){
			printf("Error: function %s is already defined\n", name);
		}
		else{
			struct STNode p;
			p.isUsed = 1;
			p.type = type;
			p.kind = kind;
			p.name = name;
			p.scope = scope;
			p.args = args;
			symbol_table[idx++] = p;
			// print the symbol table as CSV
			printSymbolTableCSV();
		}
	}

}

void addToSymbolTable(char* name , int type, int kind, valueNode* value) { 
	struct STNode p; 
	p.isUsed = 1;
	p.type = type;
	p.name = name;
	if(kind == functionKind) {
		p.scope = 1;
		p.kind = identifierKind;
	}
	else {
		p.scope = scope;
		p.kind = kind;
	}
	if(value == NULL) {
		valueNode* v = (valueNode*)malloc(sizeof(valueNode));
		v->type = type;
		v->kind = kind;
		p.value = v;
	}
	else
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
		if (!strcmp(name,symbol_table[i].name) && symbol_table[i].scope < scope  && symbol_table[i].isUsed == 1)
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
			case funArgMismatch:
				yyerror("function argument value must be the same as function argument type "); 
				break;
		}
		return -1;
	}
	return x;
}

void addOperation(valueNode* p, valueNode* val1, valueNode* val2) {
	switch(p->type) {
		case typeInteger: 
		case typeFloat:
		case typeBoolean:
		case typeCharchter:
			break;
		case typeString: {
			// error string does not support addition
			printf("string does not support addition");
			break;
		}
	}
}

void subOperation(valueNode* p, valueNode* val1, valueNode* val2) {
	switch(p->type) {
		case typeInteger: 
		case typeFloat: 
		case typeBoolean: 
		case typeCharchter:
			break;
		case typeString: {
			// error string does not support subtraction
			printf("string does not support subtraction");
			break;
		}
	}
}

void multiplyOperation(valueNode* p, valueNode* val1, valueNode* val2) {
	switch(p->type) {
		case typeInteger:
		case typeFloat:
		case typeBoolean:
		case typeCharchter:
			break;
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
			if (val2->integer == 0)
				yyerror("division by zero"); 
			break;
		}
		case typeFloat: {
			printf("Float values do not support mode operation");
			if (val2->floatNumber == 0.0)
				yyerror("division by zero"); 
			break;
		}
		case typeBoolean: {
			printf("Boolean values do not support mode operation");
			break;
		}
		case typeCharchter: 
		  	break;
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
			if (val2->integer == 0)
				yyerror("division by zero"); 
			break;
		}
		case typeFloat: {
			if (val2->floatNumber == 0.0)
				yyerror("division by zero"); 
			break;
		}
		case typeBoolean: {
			printf("boolean does not support divide operation");
			break;
		}
		case typeCharchter: {
			printf("character does not support divide operation");
			break;
		}
		case typeString: {
			// error string does not support subtraction
			printf("string does not support divide operation");
			break;
		}
	}
}


// TODO: Don't forget to generate Quadruples for each operation
valueNode* Operations (char operation,valueNode* par1, valueNode* par2) {
	if(par1 == NULL || par2 == NULL)
		return NULL;
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

// TODO: Don't forget to generate Quadruples for each operation
void comparisonOperations(char* operation, valueNode* par1, valueNode* par2, valueNode* result) {

	int type1 = par1->type;
	switch(type1) {
		case typeInteger: 
		case typeFloat: 
		case typeBoolean: 
		case typeCharchter:
			// generate Quadruples
			break;
		case typeString: {
			if(strcmp(operation, "==") == 0) {
				//result->boolean = (strcmp(val1, val2) == 0);
				printf("Error: cannot compare strings with ==\n");
			}
			else if(strcmp(operation, "!=") == 0) {
				//result->boolean = (strcmp(val1, val2) != 0);
				printf("Error: cannot compare strings with !=\n");
			}
			else if(strcmp(operation, ">") == 0) {
				printf("Error: cannot compare strings with >\n");
			}
			else if(strcmp(operation, "<") == 0) {
				printf("Error: cannot compare strings with <\n");
			}
			else if(strcmp(operation, ">=") == 0) {
				printf("Error: cannot compare strings with >=\n");
			}
			else if(strcmp(operation, "<=") == 0) {
				printf("Error: cannot compare strings with <=\n");
			}
		}
	}
}



valueNode* logicalOperations(char* operation, valueNode* par1, valueNode* par2) {
	
	if((par2 == NULL && strcmp(operation, "!") != 0) || par1 == NULL) {
		return NULL;
	}
	int type1 = par1->type;
	int type2 = par2->type;
	// check if the two types are the same
	if (checkType(type1, par2, valueMismatch) == type1){
		valueNode* p = (valueNode*)malloc(sizeof(valueNode));
		p->type = typeBoolean;
		if(strcmp(operation, "&&") == 0) {
			//p->boolean = par1->boolean && par2->boolean;
		}
		else if(strcmp(operation, "||") == 0) {
			//p->boolean = par1->boolean || par2->boolean;
		}
		else if(strcmp(operation, "!") == 0) {
			//p->boolean = !par1->boolean;
		}
		else {
			comparisonOperations(operation, par1, par2, p);
		}
		return p;
	}
	return NULL;
}

valueNode* getIDValue(char* name) {
	// check that the variable is in the symbol table
	int index = inTable(name);
	if (index == -1) {
		// the variable is not in the current scope but it may be in the global scope
		index = inTableGlobal(name);
		if (index == -1) {
			printf("variable %s not declared\n", name);
			return NULL;
		}
		else {
			// return the value of the variable
			return symbol_table[index].value;
		}
	}
	else {
		// return the value of the variable
		return symbol_table[index].value;
	}
}

int getActiveFunctionType() {
	for (int i = 0; i < idx; i++) {
		if (symbol_table[i].isUsed == 1 && symbol_table[i].kind == functionKind) {
			return symbol_table[i].type;
		}
	}
	return -1;
}

void updateSymbolTable(char* name, valueNode* value) {
	// check that the variable is in the symbol table in the global scope (scope = 0)
	int index = inTable(name);
	if (index == -1) {
		// here the variable is not in the current scope but it may be in the global scope
		index = inTableGlobal(name);
		if (index == -1) {
			printf("variable %s not declared\n", name);
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
	fprintf(logFile, "name, scope, type, kind\n");
	int i;
	for (i = 0; i < idx; i++) {
		// print each entry in the symbol table as a comma separated values regardelss of the value
		fprintf(logFile, "%s, %d, %d, %d\n", symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, symbol_table[i].kind);
	}
	// print a separator line
	fprintf(logFile, "==================================================\n");

	// Close the log file
	fclose(logFile);
}