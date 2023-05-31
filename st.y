%{
# include<stdio.h>
%}
%start S1
%token id NUM OR AND NOT relop TRUE FALSE INC DEC IF ELSE DO WHILE FOR
%right '='
%left '+' '-'
%left '*' '/'
%right '^'
%nonassoc Uminus
%left OR
%left AND
%nonassoc NOT
%%
S1 : S1 S  
  | S
  ;
S : AS ';' {printf("Assignment statement accept\n");}
| IFS    {printf("If statement accept\n");}
|IFES    {printf("If Else statement accept\n");}
|WS      {printf("While statement accept\n");}
|DWS      {printf("Do while statement accept\n");}
|FORS     {printf("For statement accept\n");}     
;
AS : id '=' E 
   ;
E : E'+'E
   | E'-'E
   | E'/'E    
   | E'*'E
   | E'^'E
   | '-' E %prec Uminus     
   | id 
   | NUM
   ;  
IFS: IF '(' BE ')' '{' S '}'
   ;
BE : BE OR BE 
   | BE AND BE
   | NOT BE 
   | id relop id 
   | TRUE
   | FALSE
   ; 
IFES: IF '(' BE ')' '{' S '}' ELSE '{' S '}'
    ;
WS: WHILE'('BE')''{'S'}'
  ;
DWS: DO '{' S '}' WHILE '(' BE ')'
   ;
FORS: FOR'('IS';'BE';'MS')''{' S '}'
    ;
IS: AS 
   |IS','AS 
   ;
MS : IS 
   | id INC
   | INC id
   | id DEC
   | DEC id
   ;   
 
  
%%
void main()   
{
yyparse();
}
int yyerror()
{
}