%{
    #include<stdlib.h> 
    #include <string.h> 
    #include "parser.tab.h"
    void yyerror(char *s);
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



"=="          return EQUAL;
"!="          return NOT_EQUAL;
">="          return GREATER_THAN_OR_EQUAL;
"<="          return LESS_THAN_OR_EQUAL;




"&&"          return AND;
"||"          return OR;




[-+*/%<>!{}&(),:;=]                         return *yytext; 

true                                        yylval=1; return BOOLEAN_TYPE;
false                                       yylval=0; return BOOLEAN_TYPE;

[0-9]+                                      yylval=atoi(yytext); return INTEGER_TYPE;
[0-9]*\.[0-9]+                              yylval=atof(yytext); return FLOAT_TYPE;

['][a-zA-Z][']                              yylval=yytext[1]; return CHARACTER_TYPE;

\"[^"]*\"                                   return STRING_TYPE; //TODO: need to handel yyval here

[a-zA-Z\_][0-9a-zA-Z\_]*                    return IDENTIFIER;  //TODO: need to handel yyval here

\/\*[^*]*\*\/                                               ; // ignore comments

[ \t\n]+                                                    ; // ignore whitespace

.                                                           yyerror("Unknown character");

%%


int yywrap(void) {
    return 1;
}