%{
# include <stdio.h>
# include "y_tab.h"
%}
l [A-Za-z]
d [0-9]
id {l}({l}|{d})*
num {d}+(\.{d}+)?
relop "<"|"<="|">"|">="|"!="
%%
"||" {return OR;}
"&&" {return AND;}
{relop} {strcpy(yylval.v,yytext);return RELOP;}
"if"  {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"true"  {return TRUE;}
"false" {return FALSE;}
{id} {yylval.p=install_id(yytext);return id;}
{num} {strcpy(yylval.v,yytext); return num;}
[-+*/^=;(){}] {return yytext[0];}
.|\n {}
%%
int yywrap()
{
return 1;} 