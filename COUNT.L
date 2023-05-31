%{
int nchar=0,nword=0,nline=0;
%}
%%
\n   {nline++; nchar++;}
[^ \t\n]+  {nword++; nchar+=yyleng;}
.   {nchar++;}
%%
main()
{
yylex();
printf("char count=%d\n",nchar);
printf("word count=%d\n",nword);
printf("line count=%d\n",nline);
}
int yywrap()
{
return 1;
}