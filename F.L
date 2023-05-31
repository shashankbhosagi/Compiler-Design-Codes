%{
# include<stdio.h>
# include "y_tab.h"
%}
%%
"int"  {return INT;}
[A-Za-z][A-Za-z0-9]*  {return id;}
[,;]    {return yytext[0];}

%%
int yywrap()
{
return 1;
}
