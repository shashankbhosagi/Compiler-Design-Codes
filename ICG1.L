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
"||" {return OR;}
"&&" {return AND;}
"!" {return NOT;}
"if"  {return IF;}
"else" {return ELSE;}
"do" {return DO;}
"while" {return WHILE;}
"for" {return FOR;}
"int" {return INT;}
"char" {return CHAR;}
"float"  {return FLOAT;}
"main" {return MAIN;}
"++"|"--" {strcpy(yylval.val,yytext);return UOP;}
{relop} {strcpy(yylval.val,yytext);return RELOP;}
{id} {yylval.p=install_id(yytext); return id;}
{num} {strcpy(yylval.val,yytext); return NUMBER;}
. {return yytext[0];}
%%
int yywrap()
{
return 1;
}