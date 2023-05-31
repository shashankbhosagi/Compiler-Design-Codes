%{
# include<stdio.h>
# include<string.h>

%}
%token id INUM INT CHAR FLOAT DOUBLE PUBLIC PRIVATE STRING BOOLEAN TRUE FALSE ST LONG SHORT CH NUM STATIC FINAL BYTE
%start START
%%

START: D '\n' START
   | D '\n'
 ;
D :D M S F varlist ';' { printf("decl accept\n");}
 |M S F varlist ';' { printf("decl accept\n");}
 ;
M : PUBLIC
  | PRIVATE
  |	
  ;
S : STATIC
  |
   ;
F : FINAL
  |
  ;
varlist:intv
       | boolv
       | stringv
       | charv
       | fldoubv
   ;
intv: IT iv
    | intv ',' iv
    ;
IT : LONG
   | INT
   |SHORT
   | BYTE
   ;
boolv: BOOLEAN bv
     | boolv ',' bv
     ;
stringv: STRING sv
       | stringv ',' sv
       ;
charv : CHAR cv
      | charv ',' cv
      ;
fldoubv: FD fv
      | fldoubv ',' fv
      ;
FD : FLOAT
   | DOUBLE
   ;
fv : ID
   | id '=' NUM
   ;
cv : ID
   |id '=' CH
   ;

sv : ID
   | id '=' ST
  ;
bv : ID
   |id '=' TRUE
   |id '=' FALSE
   ;
iv : ID
   | id '=' INUM
   ;
ID: id
  ;


%%
main()
{
yyparse();
}
int yyerror(char *msg)
{
printf("syntax error\n");
return 1;
}

