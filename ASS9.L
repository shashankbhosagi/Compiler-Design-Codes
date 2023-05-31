%{
# include<stdio.h>
# include "y.tab.h"
%}
det "this"|"that"|"a"|"the"|"an"|"The"
noun "door"|"hole"|"bird"|"dog"|"kettle"|"birds"|"nests"|"boys"|"TV"|"hamburgers"|"Lois"|"pizza"|"table"|"book"
verb "wants"|"want"|"watch"|"singing"|"live"|"boils"|"barks"|"sleeps"|"sings"|"open"|"saw"|"paint"|"is"|"am"|"are"|"were"|"was"|"be"|"being"|"been"|"do"|"does"|"did"|"will"|"would"|"should"|"can"|"could"|"has"|"have"|"had"|"go"       
preposition "from"|"with"|"on"|"to"|"from"|"behind"|"above"|"below"|"between"|"in"|"out"    
pronoun "she"|"he"|"they"|"I"|"you"|"he"|"she"|"we"|"they"|"You"       
conj ([aA][nN][dD])|([oO][rR])|([bB][uU][tT])
%%
{conj} {return CONJ;}
{det}  {return Det;}
{noun}  {return Noun;}
{verb}   {return Verb;}
{preposition} {return Preposition;}
{pronoun} {return Pronoun;}
"."   {return yytext[0];}
%%
int yywrap()
{
return 1;
}


