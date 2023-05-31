
%{
# include<stdio.h>
# include "y_tab.h"
%}
letter [A-Za-z]
digit [0-9]
id  {letter}({letter}|{digit})*
num {digit}+(\.{digit}+)?
relop "<"|"<="|">"|">="|"!="
%%
[ \t\n]+ { }

"int" {return INTEGER;}
"char" {return CHAR;}
"float"  {return FLOAT;}
"main" {return MAIN;}

{id} {yylval.p=install_id(yytext); return id;}
{num} {strcpy(yylval.val,yytext); return NUM;}
. {return yytext[0];}
%%
int yywrap()
{
return 1;
}