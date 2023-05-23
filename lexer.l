%{
    #include<stdlib.h> 
    #include <string.h> 
    #include "parser.tab.h"
    void yyerror(char *s);
    int yylex();
    extern FILE* quadFile;
    
    extern FILE* yyin;
%}

%option yylineno  

%%


if          return IF;
else        return ELSE;

do          return DO;
while       return WHILE; 

for         return FOR;
break       return BREAK; 
continue    return CONTINUE;

switch      return SWITCH;
case        return CASE;
default     return DEFAULT;

char        return CHARACTER;
string      return STRING;
int         return INT;
float       return FLOAT;
bool        return BOOLEAN;
const       return CONSTANT;

void        return VOID;
return      return RETURN;

enum        return ENUM;


"=="          return EQUAL;
"!="          return NOT_EQUAL;
">="          return GREATER_THAN_OR_EQUAL;
"<="          return LESS_THAN_OR_EQUAL;




"&&"          return AND;
"||"          return OR;

"print"       return PRINT;



[-+*/%<>!{}&(),:;=]                         return *yytext; 

true                                        yylval.boolean_value=1; return BOOLEAN_TYPE;
false                                       yylval.boolean_value=0; return BOOLEAN_TYPE;

[0-9]+                                      yylval.integer_value=atoi(yytext); return INTEGER_TYPE;
[0-9]*\.[0-9]+                              yylval.float_value=atof(yytext); return FLOAT_TYPE;

['][a-zA-Z][']                              yylval.char_value=yytext[1]; return CHARACTER_TYPE;

\"[^"]*\"                                   yylval.string_value=strdup(yytext+1); yylval.string_value[strlen(yytext)-2]='\0'; return STRING_TYPE;

[a-zA-Z\_][0-9a-zA-Z\_]*                    yylval.identifier=strdup(yytext); return IDENTIFIER;

\/\*[^*]*\*\/                                               ; // ignore comments

[ \t\n]+                                                    ; // ignore whitespace

.                                                           yyerror("Unknown character");

%%


int yywrap(void) {
    return 1;
}

int main(int argc, char* argv[]) {
    FILE* inputFile;

    // Check if a file name is provided as a command-line argument
    if (argc < 2) {
        fprintf(stderr, "Error: No input file provided.\n");
        return 1;
    }

    // Open the input file for reading
    inputFile = fopen(argv[1], "r");
    if (inputFile == NULL) {
        fprintf(stderr, "Error: Failed to open input file.\n");
        return 1;
    }

    // Set the input file for the parser to read from
    yyin = inputFile;

    // clear the symbol table log file
    FILE* symbolTableFile = fopen("symbol_table.log", "w");
    fclose(symbolTableFile);

    /* FILE* quadFile=fopen("quad_log.log","w"); */
    // Call the parser
    yyparse();

    // Close the input file
    fclose(inputFile);
    fclose(quadFile);

    return 0;
}
