%{
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
# include "parser.h"

FILE* logFile;
FILE* quadFile = NULL;
extern int yylineno;

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
#define enumType 6

#define identifierKind 1
#define constantKind 2
#define functionKind 3
#define enumKind 4

#define valueMismatch 1
#define constValueMismatch 2
#define ifCondBoolErr 3
#define whileCondBoolErr 4
#define forCondBoolErr 5
#define caseMismatch 6
#define returnMismatch 7
#define funArgMismatch 8


char* typesMap[] = {"void", "int", "float", "boolean", "char", "string", "enum"};

int getType( int i);
int getKind( int i);

int checkKind (int kind);
void setUsed(int i);

/*my functions*/
void addFunctionStruct(char* name, int arges, int label);
int getFunctionLabel(char* name, int arges);
void printQuadLogInt(int);
void printQuadLog(char*);
char* getVariableID(char*);
void pushIdentifier(char*);
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
void printSymbolTable();
void printSymbolTableCSV();
void removeCurrentScope();
void updateSymbolTable(char* name, valueNode* value, int cast);
valueNode* getIDValue(char* name);
int checkArgs(Args* args1, Args* args2);
int functionInTable(char* name, Args* args);
void addFunctionToSymbolTable(char* name, int type, int kind, Args* args);
int getActiveFunctionType();
int getFunctionType(int index);
int checkRepeatNames(EnumList* list, char* name);
int checkEnumIsActive(char* name);	
int checkEnumActiveGlobal(char* name);
valueNode* getEnumValue(char* item, char* enum_name, int index);
valueNode* getEnumValueGlobal(char* item, char* enum_name);
int checkPossibleCast(int type1, int type2);
//----------------------------------------------
struct STNode symbol_table[10000];

int scope = 0;
int idx = 0 ;
int update = 0;
int activeFunctionType = -1;
int switchType = -1;
int loop = 0;
int labelsId = 100;
int isDoWhile = 0;
int forLoopAssignment = 0;
char forLoopAssignmentStr[100];
int functionDeclaration = 0;
char functionDeclarationArguments[100];
struct functionStruct functionStructs[100];
int functionStructsIdx = 0;
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
	struct EnumNode* enum_Node;
	struct EnumList* enum_List;
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
%type <enum_Node> enum_item
%type <enum_List> enum_list

/* Define grammar rules */
%start program

%%
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
program: block_statements    
	;

block_statements : block_statement
		  | block_statements block_statement

block_statement : declaration ';'
		| enum_usage ';'
        | expression ';'		
		| do_while_statement ';' 
		| if_else_statement
		| while_statement 
		| for_statement 
		| switch_statement  
		| function
		| return_statement ';'
        | print_statement ';'
		| assignment ';'
        | CONTINUE ';'
		{
			if(loop == 0)
				printf("error: continue statement not in a loop near line %d\n", yylineno);
		}
		| BREAK ';'
		{
			if(loop == 0)
				printf("error: break statement not in a loop near line %d\n", yylineno);
		}
        ;

block : '{' {scope++;} block_statements '}' {removeCurrentScope(); scope--;}  
	  | {scope++;} block_statement {removeCurrentScope(); scope--;}
	  | '{' '}'
	;

functionBlock: '{' {scope++;} block_statements '}' {removeCurrentScope(); scope--;}  
	  | '{' '}'
	;	

return_statement : RETURN expression 
	{
		if(activeFunctionType == -1)
			printf("error: return statement not in a function near line %d\n", yylineno);
		else {
			int match = checkType(activeFunctionType, $2, returnMismatch);
			if(match == -1) {
				if (checkPossibleCast($2->type, activeFunctionType) == 1) {
					printf("warning: implict casting from %s to %s near line %d\n", typesMap[$2->type], typesMap[activeFunctionType], yylineno);
				}
				else
					printf("error: can't cast from %s to %s near line %d\n", typesMap[$2->type], typesMap[activeFunctionType], yylineno);
			}
		}
		activeFunctionType = -1;
	}	
	| RETURN 
	{
		if(activeFunctionType == -1)
			printf("error: return statement not in a function near line %d\n", yylineno);
		else if(activeFunctionType != typeVoid) 
			printf("error: return type mismatch near line %d\n", yylineno);
		
		activeFunctionType = -1;
		
	}
	;

declaration: variable_declaration 
    | enum_declaration
    ;

variable_declaration: data_type IDENTIFIER  
	{
		if(inTable((char*)$2) != -1)
			// error that the variable has been declared before
			printf("error: Variable %s at line %d has been declared before\n", (char*)$2, yylineno);
		else
			addToSymbolTable((char*)($2),$1,identifierKind, NULL);
	}
	| data_type IDENTIFIER '=' expression
	{
		if(inTable((char*)$2) != -1)
			printf("error: Variable %s at line %d has been declared before\n", (char*)$2, yylineno);
		else if ($4 != NULL && checkType($1,$4,valueMismatch) != -1) {
			addToSymbolTable((char*)($2),$1,identifierKind, $4);
		}
		else if ($4 != NULL && checkType($1,$4,valueMismatch) == -1) {
			if (checkPossibleCast($4->type, $1) == 1) {
				printf("warning: implict casting from %s to %s near line %d\n", typesMap[$4->type], typesMap[$1], yylineno);
				valueNode* p = (valueNode*)malloc(sizeof(valueNode));
				p->type = $1;
				addToSymbolTable((char*)($2),$1,identifierKind, p);
			}
			else
				printf("error: can't cast from %s to %s near line %d\n", typesMap[$4->type], typesMap[$1], yylineno);
		}

	}
	| CONSTANT data_type IDENTIFIER '=' expression      
	{
		if(inTable((char*)$3) != -1)
			printf("error: Constant %s at line %d has been declared before\n", (char*)$3, yylineno);
		else if ($5 != NULL && checkType($2,$5,valueMismatch) != -1) { 
			valueNode* p = $5;
			p->enumName = NULL;
			addToSymbolTable((char*)($3),$2,constantKind, p);
		}
		else if ($5 != NULL && checkType($2,$5,valueMismatch) == -1) {
			if (checkPossibleCast($5->type, $2) == 1) {
				printf("warning: implict casting from %s to %s near line %d\n", typesMap[$5->type], typesMap[$2], yylineno);
				valueNode* p = (valueNode*)malloc(sizeof(valueNode));
				p->type = $2;
				p->enumName = NULL;
				addToSymbolTable((char*)($3),$2,constantKind, p);
			}
			else
				printf("error: can't cast from %s to %s near line %d\n", typesMap[$5->type], typesMap[$2], yylineno);
		}
	}
	;



enum_usage: IDENTIFIER IDENTIFIER '=' IDENTIFIER
	{	
		int index = checkEnumIsActive((char*)$1); 
		if(index == -1) {
			printf("error: There is no Enum with name (%s) at line %d\n", (char*)$1, yylineno);
		}
		else {
			if(inTable((char*)$2) != -1)
				printf("error: This identifier (%s) at line %d has been declared before\n", (char*)$2, yylineno);
			else {
				valueNode* p = getEnumValue((char*)$4, $1, index);
				if(p == NULL)
					printf("error: Enum item (%s) at line %d has not been declared before in Enum (%s)\n", (char*)$4, yylineno, (char*)$1);
				else {
					valueNode* q = (valueNode*)malloc(sizeof(valueNode));
					q->type = p->type;
					q->integer = p->integer;
					q->enumName = (char*)$1;
					addToSymbolTable((char*)($2),typeInteger,constantKind, q);
				}
			}
		}
	}
	;

enum_declaration: ENUM IDENTIFIER '{' enum_list '}'
	{
		if(inTable((char*)$2) != -1)
			printf("error: Enum name (%s) at line %d has been declared before\n", (char*)$2, yylineno);
		else {
			valueNode* p = (valueNode*)malloc(sizeof(valueNode));
			p->type = enumType;
			p->kind = enumKind;
			addToSymbolTable((char*)($2),enumType,enumKind, p);
			// add each name in the list to the symbol table as constants
			EnumList* list = $4;
			int i;
			for(i = 0; i < list->nvals; i++) {
				if(inTable(list->names[i]) != -1)
					printf("error: Enum item (%s) at line %d has been declared before\n", list->names[i], yylineno);
				else {
					valueNode* p = (valueNode*)malloc(sizeof(valueNode));
					p->type = typeInteger;
					p->kind = constantKind;
					p->enumName = $2;
					p->integer = list->values[i];
					addToSymbolTable(list->names[i],typeInteger,constantKind, p);
				}
			}
		}
	}
    ;

enum_list: enum_item
	{
		EnumList* list = (EnumList*)malloc(sizeof(EnumList));
		list->nvals = 1;
		list->names[0] = $1->name;
		list->values[0] = $1->value;
		$$ = list;
	}
	| enum_list ',' enum_item
	{
		EnumList* list = $1;
		EnumNode* node = $3;
		if(checkRepeatNames(list, node->name) == 1)
			printf("error: Enum item (%s) near line %d has been declared before\n", node->name, yylineno);
		else {
			list->nvals++;
			list->names[list->nvals-1] = node->name;
			list->values[list->nvals-1] = node->value;
		}
		$$ = list;
	}
    ;

enum_item: IDENTIFIER '=' INTEGER_TYPE
	{	
		EnumNode* node = (EnumNode*)malloc(sizeof(EnumNode));
		node->name = $1;
		node->value = $3;
		$$ = node;
	}
    ;

assignment : IDENTIFIER '=' expression  
	{
		if(loop == 0) {
			if(inTable($1) == -1)
				printf("error: Variable %s at line %d has not been declared before\n", $1, yylineno);
			else {
				int type = getIDValue($1)->type;
				int match = checkType(type, $3, valueMismatch);
				if($3 != NULL && match == -1) {
					if (checkPossibleCast($3->type, type) == 1) {
						printf("warning: implict casting from %s to %s near line %d\n", typesMap[$3->type], typesMap[type], yylineno);
						updateSymbolTable($1,$3, 1);
					}
					else
						printf("error: can't cast from %s to %s near line %d\n", typesMap[$3->type], typesMap[type], yylineno);
				}
				else if($3 != NULL && match != -1)
					updateSymbolTable($1,$3, 0);  
			}
		}
		else {
			if(inTable($1) == -1)
				printf("error: Variable %s at line %d has not been declared before\n", $1, yylineno);
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
    | IDENTIFIER            {$$ = getIDValue($1); pushIdentifier($1);}
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
	| BOOLEAN_TYPE   { $$ = setValueNode(typeBoolean, &$1); }
	| CHARACTER_TYPE { $$ = setValueNode(typeCharchter, &$1); }
	| STRING_TYPE    { $$ = setValueNode(typeString, &$1); }
	;

data_type: INT { $$ = typeInteger; }
	| FLOAT    { $$ = typeFloat; } 
	| BOOLEAN  { $$ = typeBoolean; } 
	| CHARACTER { $$ = typeCharchter; } 
	| STRING    { $$ = typeString; } 
	;


while_statement: while_declaraction {loop=1;} block {
	loop = 0; 
	printQuadLog("JMP WHILE_BEGIN_"); printQuadLogInt(labelsId); printQuadLog("\n");
	printQuadLog("END_WHILE_"); printQuadLogInt(labelsId); labelsId = labelsId + 10; printQuadLog(":\n");
	}
	;

while_declaraction : 
	{
		if(isDoWhile == 0){
			printQuadLog("WHILE_BEGIN_"); printQuadLogInt(labelsId); printQuadLog(":\n");
		}
	} 
	WHILE 
	{
		if(activeFunctionType == -1)
			printf("error: while/do while statement at line %d not in a function\n", yylineno);
	}  
	'(' logical_expression ')' 
	{
		if(isDoWhile == 0){
			printQuadLog("JZ END_WHILE_"); printQuadLogInt(labelsId); printQuadLog("\n");
		}
	}
	;


  

print_statement : PRINT '(' argument_print ')' 
	{
		if(activeFunctionType == -1)
			printf("error: print statement near line %d not in a function\n", yylineno);
	}
	;
argument_print: argument_print ',' expression
			| expression
			;


for_statement:  for_declaration 
	block 
	{
		printQuadLog(forLoopAssignmentStr);
		forLoopAssignmentStr[0] = '\0';
		printQuadLog("JMP FOR_LOOP_BEGIN_"); printQuadLogInt(labelsId); printQuadLog("\n");
		printQuadLog("END_FOR_LOOP_"); printQuadLogInt(labelsId); printQuadLog(":\n");
		labelsId = labelsId + 10;
	}
	{
		if(activeFunctionType == -1)
			printf("error: for statement near line %d not in a function\n", yylineno);	
	}
	;

for_declaration: FOR '(' {scope++; loop=1;} variable_declaration  ';' for_condition  ';' for_increment ')' {scope--; loop=0;}

		| FOR '(' assignment  ';' for_condition  ';' for_increment ')'
	;

for_condition: 
	{printQuadLog("FOR_LOOP_BEGIN_"); printQuadLogInt(labelsId); printQuadLog(":\n");}
	logical_expression
	{printQuadLog("JZ END_FOR_LOOP_"); printQuadLogInt(labelsId); printQuadLog("\n");}



for_increment: {forLoopAssignment=1;} 
		assignment  
		{forLoopAssignment=0;}

do_while_statement : DO 
					{
						loop = 1; isDoWhile = 1;
						printQuadLog("DO_WHILE_BEGIN_"); printQuadLogInt(labelsId); printQuadLog(":\n");
					} 
					block {loop=0;} while_declaraction
					{
						printQuadLog("JNZ DO_WHILE_BEGIN_"); printQuadLogInt(labelsId); printQuadLog("\n");
						isDoWhile = 0;
						labelsId = labelsId + 10;
					}
			;

switch_statement : SWITCH '('expression')'
			{
				if(activeFunctionType == -1)
					printf("error: switch statement near line %d not in a function\n", yylineno);
				if($3 != NULL)
					switchType = $3->type;
			} 
			'{' case_statement '}' {switchType = -1;}


case_statement : CASE value ':' 
		{
			if(switchType == -1) 
				printf("error: case statement near line %d not in a switch statement or there is an error in switch variable\n", yylineno);
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
			printf("error: Variable %s at line %d has been declared before\n", (char*)$2, yylineno);
		else {
			addToSymbolTable((char*)$2,$1,functionKind, NULL);
			printQuadLog("POPI ");
			printQuadLog($2);
			printQuadLog("\n");
			$$ = $1;
		}
	}
	| data_type IDENTIFIER '=' expression 
	{	
		int check = checkType($1,$4,funArgMismatch);
		if(check != -1) {
			if(inTable((char*)$2) != -1)
				printf("error: Variable %s near line %d has been declared before\n", (char*)$2, yylineno);
			else if ($4 != NULL && checkType($1,$4,valueMismatch) != -1) {
				addToSymbolTable((char*)$2,$1,functionKind, $4);
				$$ = $1;
			}
		}
	}
	;
	
function : 	
		VOID 
		IDENTIFIER  
		'(' 
		{activeFunctionType = typeVoid; functionDeclaration = 1;} 
		arguments

		{ 
			functionDeclaration = 0;
			printQuadLog("\n\nPROC "); 
			printQuadLog($2);
			printQuadLog("_");
			addFunctionStruct((char*)$2, $5->nargs, labelsId);
			printQuadLogInt(labelsId); 
			printQuadLog(":\n");
			labelsId = labelsId + 10;
			printQuadLog(functionDeclarationArguments);
			functionDeclarationArguments[0] = '\0';
		} 

		')'  
		functionBlock
	{
		if(activeFunctionType != -1) {
			printf("error: function %s() near line %d doesn't have return statement\n", (char*)$2, yylineno);
		}
		addFunctionToSymbolTable($2,typeVoid,functionKind, $5);
	}
	|  
		data_type 
		IDENTIFIER  
		'(' 
		{activeFunctionType = $1; functionDeclaration = 1;} 
		arguments
		{ 
			functionDeclaration = 0;
			printQuadLog("\n\nPROC "); 
			printQuadLog($2);
			printQuadLog("_");
			addFunctionStruct((char*)$2, $5->nargs, labelsId);
			printQuadLogInt(labelsId); 
			printQuadLog(":\n");
			labelsId = labelsId + 10;
			printQuadLog(functionDeclarationArguments);
			functionDeclarationArguments[0] = '\0';
		} 
		')'  
		functionBlock 
		{
			if(activeFunctionType != -1) {
				printf("error: function %s() near line %d doesn't have return statement\n", (char*)$2, yylineno);
			}
			addFunctionToSymbolTable($2,$1,functionKind, $5);
		}
	;

function_call: IDENTIFIER '('argument_call')'  
	{
		printQuadLog("CALL ");
		printQuadLog($1);
		printQuadLog("_");
		printQuadLogInt(getFunctionLabel($1,$3->nargs));
		printQuadLog("\n");
		int index = functionInTable((char*)$1, $3);
		if(index == -1)
			printf("error: function %s near line %d has not been declared before\n", (char*)$1, yylineno);
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

if_else_statement: helper_if {printQuadLog("END_IF_"); printQuadLogInt(labelsId); labelsId = labelsId + 10; printQuadLog(":\n");}   %prec IFX 
			| helper_if else_statement {printQuadLog("END_IF_"); printQuadLogInt(labelsId); labelsId = labelsId + 10; printQuadLog(":\n");}

helper_if : if_condition block 
				{
					printQuadLog("JMP END_IF_"); printQuadLogInt(labelsId); printQuadLog("\n");
					printQuadLog("ELSE_"); printQuadLogInt(labelsId); printQuadLog(":\n");
				 }

if_condition : IF {
		if(activeFunctionType == -1)
			printf("error: if statement near line %d not in a function\n", yylineno);
	}  '(' logical_expression ')'  {printQuadLog("JZ ELSE_"); printQuadLogInt(labelsId); printQuadLog("\n");}
	;

else_statement : ELSE block
		   ;


%%
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

//-------------------------------------------------------------------------------------------------
void yyerror(char *s) {
	fprintf(stdout, "%s near line %d\n", s, yylineno);
}


//--------------------------------------------------
/* My functions*/
void printQuadLogInt(int val){
	if(quadFile == NULL){
		quadFile=fopen("quad_log.log","w");
	}
	fprintf(quadFile, "%d",val);
}
void printQuadLog(char* str){
	if(quadFile == NULL){
		quadFile=fopen("quad_log.log","w");
	}
	if(forLoopAssignment == 1){
		strcat(forLoopAssignmentStr,str);
		return;
	}
	if(functionDeclaration == 1){
		strcat(functionDeclarationArguments,str);
		return; 
	}
	fprintf(quadFile, "%s",str);
}

void pushIdentifier(char* iden){
	printQuadLog("PUSHI ");
	printQuadLog(getVariableID(iden));
	printQuadLog("\n");
}
void quadLogValue(int type, void* value){
	printQuadLog("PUSH ");
	char str[40];
	if (type == typeInteger)
		sprintf(str, "%d", *((int *)value));
	else if (type == typeFloat)
		sprintf(str, "%f", *((float *)value));
	else if (type == typeBoolean)
		sprintf(str, "%d", *((int *)value));
	else if (type == typeCharchter)
		sprintf(str, "%c", *((char *)value));
	else
		sprintf(str, "%s", (char*)value);
	printQuadLog(str);
	printQuadLog("\n");
}

void addFunctionStruct(char* name, int arges, int label){
	struct functionStruct fnStrct;
	strcpy(fnStrct.name,name);
	fnStrct.args = arges;
	fnStrct.label = label;
	functionStructs[functionStructsIdx] = fnStrct;
	functionStructsIdx = functionStructsIdx + 1;
}

int getFunctionLabel(char* name, int arges){
	for(int i = 0 ; i < functionStructsIdx; i++){
		if(!strcmp(functionStructs[i].name,name) && arges == functionStructs[i].args)
			return functionStructs[i].label;
	}
	return -1;
}
valueNode* setValueNode(int type, void* value){
	valueNode* p = (valueNode*)malloc(sizeof(valueNode));
	p->type = type;
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
	
	quadLogValue(type,value);
	return p;
}


int checkRepeatNames(EnumList* list, char* name){
	for(int i=0; i<list->nvals; i++){
		if (!strcmp(list->names[i],name))
			return 1;
	}
	return 0;
}

int checkEnumIsActive(char* name){
	for(int i=0; i<idx; i++) {
		if (!strcmp(symbol_table[i].name,name) && symbol_table[i].kind == enumKind && symbol_table[i].scope == scope && symbol_table[i].isUsed == 1)
			return i;
	}
 
	return checkEnumActiveGlobal(name);
}

valueNode* getEnumValueGlobal(char* item, char* enum_name) {
	for(int i=0; i<idx; i++) {
		if (!strcmp(symbol_table[i].name,item) && symbol_table[i].kind == constantKind && !strcmp(symbol_table[i].value->enumName, enum_name) && symbol_table[i].scope < scope) {
			return symbol_table[i].value;
		}
	}

	return NULL;
}

valueNode* getEnumValue(char* item, char* enum_name, int index) {
	for(int i=0; i<idx; i++) {
		if (!strcmp(symbol_table[i].name,item) && symbol_table[i].kind == constantKind && !strcmp(symbol_table[i].value->enumName, enum_name) && symbol_table[i].scope == symbol_table[index].scope) {
			return symbol_table[i].value;
		}
	}
	return getEnumValueGlobal(item, enum_name);
}

int checkEnumActiveGlobal(char* name){
	for(int i=0; i<idx; i++) {
		if (!strcmp(symbol_table[i].name,name) && symbol_table[i].kind == enumKind && symbol_table[i].scope < scope && symbol_table[i].isUsed == 1)
			return i;
	}

	return -1;
}
// this function checks that all the args are of the same type as another args types
// 0 means that the 2 args are not the same
// 1 means that the 2 args are the same
int checkArgs(Args* args1, Args* args2){
	if (args1->nargs == args2->nargs) {
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
		else if(!strcmp(name,symbol_table[i].name) && symbol_table[i].scope == 0 && (symbol_table[i].kind == identifierKind || symbol_table[i].kind == constantKind || symbol_table[i].kind == enumKind)) {
			return i;
		}
	return -1;
}

void addFunctionToSymbolTable(char* name, int type, int kind, Args* args){
	if(scope != 0){
		printf("Error: function %s near line %d must be global\n", name, yylineno);
	}
	else {
		if (functionInTable(name, args) != -1){
			printf("Error: function %s near line %d is already defined\n", name, yylineno);
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
	if(value != NULL && (p.kind == identifierKind || p.kind == constantKind)){
		printQuadLog("POPI ");
		printQuadLog(getVariableID(name));
		printQuadLog("\n");
	}
} 

// this function is only used to check for declaration of variables
// so it only checks that the scopes are the same and the variable is used
int inTable(char* name){
	for (int i =0;i < idx;i++)
		if (!strcmp(name,symbol_table[i].name) && symbol_table[i].scope == scope  && symbol_table[i].isUsed == 1)
			return i;  
	return -1;
} 

int inTableGlobal(char* name){
	for (int i =0;i < idx;i++)
		if (!strcmp(name,symbol_table[i].name) && symbol_table[i].scope < scope  && symbol_table[i].isUsed == 1 && symbol_table[i].kind != functionKind && symbol_table[i].kind != enumKind)
			return i;  
	return -1;
}

char* getVariableID(char* name){
	int maxScope = -1;
	int maxi = -1 ;
	for (int i =0;i < idx;i++)
		if (!strcmp(name,symbol_table[i].name) && symbol_table[i].scope <= scope  && symbol_table[i].isUsed == 1 && symbol_table[i].kind != functionKind && symbol_table[i].kind != enumKind)
			{
				if(symbol_table[i].scope > maxScope){
					maxScope = symbol_table[i].scope;
					maxi = i;
				}
					
			}
	char* str = (char*) malloc (40*sizeof(char));
	sprintf(str,"%d",maxi);
	//TODO: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	return name;
	return str;
}

int checkType(int x , valueNode* y , int errorType){
	if (y != NULL && x != y->type){
		switch (errorType){
			case valueMismatch:
				printf("variable/constant at line %d mismatches with the assigned value\n", yylineno); 
				break; 
			case ifCondBoolErr:
				printf("if condition near line %d must be of type boolean\n", yylineno);  
				break;
			case whileCondBoolErr:
				printf("while condition near line %d must be of type boolean\n", yylineno);  
				break;
			case forCondBoolErr:
				printf("for condition near line %d must be of type boolean\n", yylineno);  
				break;
			case caseMismatch:
				printf("case variable near line %d type must be same as switch variable type\n", yylineno);  
				break;
			case returnMismatch:
				printf("return type at line %d must be the same as function type\n", yylineno);  
				break;
			case funArgMismatch:
				printf("function argument value near line %d must be the same as function argument type\n", yylineno); 
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
			printf("string does not support addition near line %d", yylineno);
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
			printf("string does not support subtraction near line %d", yylineno);
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
			printf("string does not support multiplication near line %d", yylineno);
			break;
		}
	}
}

void modeOperation(valueNode* p, valueNode* val1, valueNode* val2) {
	switch(p->type) {
		case typeInteger: {
			if (val2->integer == 0)
				printf("division by zero at line %d", yylineno); 
			break;
		}
		case typeFloat: {
			printf("Float values do not support mode operation at line %d", yylineno);
			if (val2->floatNumber == 0.0)
				printf("division by zero at line %d", yylineno); 
			break;
		}
		case typeBoolean: {
			printf("Boolean values do not support mode operation at line %d", yylineno);
			break;
		}
		case typeCharchter: 
		  	break;
		case typeString: {
			// error string does not support subtraction
			printf("String values do not support mode operation at line %d", yylineno);
			break;
		}
	}
}

void divideOperation(valueNode* p, valueNode* val1, valueNode* val2) {
	switch(p->type) {
		case typeInteger: {
			if (val2->integer == 0)
				printf("division by zero at line %d", yylineno); 
			break;
		}
		case typeFloat: {
			if (val2->floatNumber == 0.0)
				printf("division by zero at line %d", yylineno); 
			break;
		}
		case typeBoolean: {
			printf("boolean does not support divide operation at line %d", yylineno);
			break;
		}
		case typeCharchter: {
			printf("character does not support divide operation at line %d", yylineno);
			break;
		}
		case typeString: {
			// error string does not support subtraction
			printf("string does not support divide operation at line %d", yylineno);
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
				printQuadLog("ADD\n");
				addOperation(p, par1, par2);
				break;
			}
			case '-': {
				printQuadLog("SUB\n");
				subOperation(p, par1, par2);
				break;
			}
			case '*': {
				printQuadLog("MUL\n");
				multiplyOperation(p, par1, par2);
				break;
			}
			case '%': {
				printQuadLog("MOD\n");
				modeOperation(p, par1, par2);
				break;
			}
			case '/': {
				printQuadLog("DIV\n");
				divideOperation(p, par1, par2);
				break;
			}
			default: {
				printf("operation not supported near line %d", yylineno);
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
			if(strcmp(operation, "==") == 0) 
				printQuadLog("EQ\n");
			else if(strcmp(operation, "!=") == 0) 
				printQuadLog("NEQ\n");
			else if(strcmp(operation, ">") == 0) 
				printQuadLog("GT\n");
			else if(strcmp(operation, "<") == 0) 
				printQuadLog("LT\n");
			else if(strcmp(operation, ">=") == 0) 
				printQuadLog("GE\n");
			else if(strcmp(operation, "<=") == 0) 
				printQuadLog("LE\n");
			break;
		case typeString: {
			if(strcmp(operation, "==") == 0) {
				//result->boolean = (strcmp(val1, val2) == 0);
				printf("Error: cannot compare strings with (==) at line %d\n", yylineno);
			}
			else if(strcmp(operation, "!=") == 0) {
				//result->boolean = (strcmp(val1, val2) != 0);
				printf("Error: cannot compare strings with (!=) at line %d\n", yylineno);
			}
			else if(strcmp(operation, ">") == 0) {
				printf("Error: cannot compare strings with (>) at line %d\n", yylineno);
			}
			else if(strcmp(operation, "<") == 0) {
				printf("Error: cannot compare strings with (<) at line %d\n", yylineno);
			}
			else if(strcmp(operation, ">=") == 0) {
				printf("Error: cannot compare strings with (>=) at line %d\n", yylineno);
			}
			else if(strcmp(operation, "<=") == 0) {
				printf("Error: cannot compare strings with (<=) at line %d\n", yylineno);
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
			printQuadLog("AND\n");
			//p->boolean = par1->boolean && par2->boolean;
		}
		else if(strcmp(operation, "||") == 0) {
			printQuadLog("OR\n");
			//p->boolean = par1->boolean || par2->boolean;
		}
		else if(strcmp(operation, "!") == 0) {
			printQuadLog("NOT\n");
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
			printf("Identifier (%s) at line %d not declared before\n", name, yylineno);
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

// this function checks if there possible cast from type1 to type2
int checkPossibleCast(int type1, int type2) {
	if (type1 == typeInteger) {
		if (type2 == typeFloat || type2 == typeBoolean || type2 == typeCharchter) {
			return 1;
		}
		else
			return 0;
	}
	else if (type1 == typeFloat) {
		if (type2 == typeInteger || type2 == typeBoolean || type2 == typeCharchter) {
			return 1;
		}
		else
			return 0;
	}
	else if (type1 == typeBoolean) {
		if (type2 == typeInteger || type2 == typeFloat || type2 == typeCharchter) {
			return 1;
		}
		else
			return 0;
	}
	else if (type1 == typeCharchter) {
		if (type2 == typeInteger || type2 == typeFloat || type2 == typeBoolean) {
			return 1;
		}
		else
			return 0;
	}
	else if (type1 == typeString) 
		return 0;
	else 
		return 0;
}

void updateSymbolTable(char* name, valueNode* value, int cast) {
	// check that the variable is in the symbol table in the global scope (scope = 0)
	int index = inTable(name);
	if (index == -1) {
		// here the variable is not in the current scope but it may be in the global scope
		index = inTableGlobal(name);
		if (index == -1) {
			printf("variable %s at line %d not declared before\n", name, yylineno);
			return;
		}
	}

	// update the value of the variable
	if(!cast && value != NULL && symbol_table[index].kind != constantKind)
		symbol_table[index].value->type = value->type;
	else if (!cast && value != NULL && symbol_table[index].kind == constantKind)
		printf("Error: cannot assign value to constant variable (%s) at line %d\n", name, yylineno);

	
	// print the symbol table as CSV
	printSymbolTableCSV();
	printQuadLog("POPI ");
	printQuadLog(getVariableID(name));
	printQuadLog("\n");
}

// this function removes all variables with current scope from the symbol table using deallocation 
void removeCurrentScope() {
	int i;
	for (i = 0; i < idx; i++) {
		if (symbol_table[i].scope == scope) {
			symbol_table[i].isUsed = 0;
			//symbol_table[i].value = NULL;
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
	fprintf(logFile, "id,\tname,\tscope,\ttype,\tkind,\tnargs,\targsTypes,\tenum\n");
	int i;
	for (i = 0; i < idx; i++) {
		// print each entry in the symbol table as a comma separated values regardelss of the value
		if(symbol_table[i].kind == functionKind) {
			fprintf(logFile, "%d,\t%s,\t%d,\t\t%d,\t\t%d,\t\t%d,\t", i, symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, symbol_table[i].kind, symbol_table[i].args->nargs);
			fprintf(logFile, "\t[ ");
			for (int j = 0; j < symbol_table[i].args->nargs; j++) {
				fprintf(logFile, "%d, ", symbol_table[i].args->types[j]);
			}
			fprintf(logFile, "], ");
			fprintf(logFile, "\t\tNA\n");
		}
		else if(symbol_table[i].kind == constantKind && symbol_table[i].value != NULL && symbol_table[i].value->enumName != NULL) {
			fprintf(logFile, "%d,\t%s,\t\t%d,\t\t%d,\t\t%d,\t\tNA,\t\tNA,\t\t%s\n", i, symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, symbol_table[i].kind, symbol_table[i].value->enumName);
		}
		else {
			fprintf(logFile, "%d,\t%s,\t\t%d,\t\t%d,\t\t%d,\t\tNA,\t\tNA,\t\t\tNA\n", i, symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, symbol_table[i].kind);
		}

	}
	// print a separator line
	fprintf(logFile, "==================================================\n");

	// Close the log file
	fclose(logFile);
}