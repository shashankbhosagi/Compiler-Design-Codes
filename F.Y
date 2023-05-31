%{
# include<stdio.h>
%}
%token INT id
%start S1
%%
S1 : S1 S '\n'   {printf("int decl accept");}
   | S '\n'    {printf("int decl accept");}
   ;
S : INT V ';'
  ;
V : V ',' id
  | id
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