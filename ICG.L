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
"call" {return CALL;}
"true" {return TRUE;}
"false" {return FALSE;}
"begin" {return BEGIN;}
"end" {return END;}
"++"|"--" {strcpy(yylval.val,yytext);return UOP;}
{relop} {strcpy(yylval.val,yytext);return RELOP;}
{id} {yylval.p=install_id(yytext); return id;}
{num} {strcpy(yylval.val,yytext); return NUM;}
. {return yytext[0];}
%%
int yywrap()
{
return 1;
}