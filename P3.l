digit	[0-9]
letter	[a-zA-Z]
%{
# include<stdio.h>
%}
%%
{letter}({letter}|{digit})*	    {printf("id: %s\n", yytext);}
\n					{printf("new line\n");}
%%
int main() {
	yylex();
}
int  yywrap(void) { 
return 1; 
}
