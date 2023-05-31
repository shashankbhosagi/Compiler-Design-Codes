%{
# include<stdio.h>
# include "y_tab.h"
%}
L [A-Za-z]
D [0-9]
id {L}({L}|{D})*
inum {D}+
ws [ \t\n]+
st "\""(.)*"\""
ch "\'"."\'"
num {D}+(\.{D}+)?([eE][-+]?{D}+)?
%%
{ws} { }
"int" {return INT;}
"byte" {return BYTE;}
{inum}  {return INUM;}
{num}   {return NUM;}
"long" {return LONG;}
"short" {return SHORT;}
"static" {return STATIC;}
"final" {return FINAL;}
"char"  {return CHAR;}
"float" {return FLOAT;}
"double"  {return DOUBLE;}
"public"  {return PUBLIC;}
"private"  {return PRIVATE;}
"String"   {return STRING;}
"boolean"  {return BOOLEAN;}
"true"     {return TRUE;}
"false"   {return FALSE;}
{ch}     {return CH;}
{st}   {return ST;}
{id} {return id;}
.|\n  {return yytext[0];}
%%
int yywrap()
{ return 1;
}
		
  
 