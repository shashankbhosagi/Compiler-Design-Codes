%{
	int counter = 0;
%}
letter	[a-zA-Z]
%%
{letter}+       {fprintf(yyout,"%s a word\n",yytext); counter++;}
%%
main() {
yyin = fopen("A.TXT","r");
yyout =fopen("b.txt","w");
yylex();
fprintf(yyout,"There are total %d words\n",counter);
fclose(yyin);
fclose(yyout);
}
int  yywrap(void) { 
return 1; 
}
