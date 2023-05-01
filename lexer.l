%{
    #include<stdlib.h> 
    #include <string.h> 
    #include "parser.tab.h"
    void yyerror(char *s);
    int yylex();
%}

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

\"[^"]*\"                                   yylval.string_value=strdup(yytext+1); yylval.string_value[strlen(yytext)-1]='\0'; return STRING_TYPE;

[a-zA-Z\_][0-9a-zA-Z\_]*                    yylval.identifier=strdup(yytext); return IDENTIFIER;

\/\*[^*]*\*\/                                               ; // ignore comments

[ \t\n]+                                                    ; // ignore whitespace

.                                                           yyerror("Unknown character");

%%


int yywrap(void) {
    return 1;
}