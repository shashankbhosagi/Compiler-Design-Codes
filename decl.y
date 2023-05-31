%{
# include<stdio.h>
%}
%start S
%token id INT INUM
%%
S : S DL  {printf("Declaration accept\n");}
  | DL   {printf("Declaration accept\n");}
  ;
DL : INTV ';'
   ;
INTV : INT IV
     ;
IV : I 
   | IV ',' id 	 
   | IV ',' id '=' INUM
   | id '=' INUM 
   ; 
I: id
  ;
%%
void main()
{
  yyparse();
}
int yyerror(char *msg)
{
printf("%s\n",msg);
}

