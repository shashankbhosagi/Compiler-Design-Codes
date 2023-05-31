%{ 
# include<stdio.h>
%}
%token digit
%%
S :S  E '\n' {printf("ans=%d\n",$2);}
  | E '\n' {printf("ans=%d\n",$1);}
  ;
E : E '+' T {$$ = $1+$3;}
  |T
  ;
T : T '*' F {$$ = $1 * $3;}
  | F
  ;
F : '(' E ')' {$$ = $2;}
  | digit
  ;
%%
main()
{
yyparse();
}
int yyerror(char *msg)
{
printf("%s\n",msg);
return 1;
}

yylex()
{
int c;
c=getchar();
while(c==' '||c=='\t');
if(isdigit(c))
{
 yylval = c-'0';
 return digit;
}
return c;
}
