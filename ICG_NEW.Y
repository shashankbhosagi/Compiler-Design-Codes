%{
# include<stdio.h>
# include<conio.h>
# include<string.h>
# include<alloc.h>

struct node *merge(struct node *p1,struct node *p2);
void backpatch(struct node *t,int i);
struct node *makelist(int i);
void dispquad();
void dispsym();
void disp(struct node *next);

struct QUAD{
char op[10];
char arg1[10];
char arg2[10];
char res[10];
};

struct symtab{
char *name;
char type[10];
double value;
}SYM[20];

struct QUAD quad[20];
/****for procedure call*/
char queue[20][10];
int front=0;

int i=0,g;
int tempvar=1;
char temp[5];

struct node{
int number;
struct node *next;
};
struct battri{
struct node *truelist,*falselist;
};
%}

%union{
char val[10];
struct symtab *p;
struct node *nextlist;
int sno;
struct battri *bat;
}
%token<val> NUM RELOP LOP
%token WHILE DO UOP BEGIN END TRUE FALSE OR AND NOT IF ELSE FOR CALL
%token<p> id
%right '='
%left OR
%left AND
%nonassoc NOT
%left RELOP
%left '+' '-'
%left '*' '/'
%right '^'
%nonassoc UMINUS
%type<val> E
%type<sno> M
%type<bat> BE
%type<nextlist> L S WS AS IFS IFES N FORS
%start S
%%
L:L M S {
	backpatch($1,$2);
	$$=$3;}

 |S    {$$=$1;}
 ;
S:AS   {$$=NULL;}
  |WS   {$$=$1; }
  |BEGIN L END    {$$=$2;}
  |IFS
  |IFES
  |FORS
  |FUN
  ;
IFS:IF'('BE')''{'M S '}' {
			  backpatch($3->truelist,$6);
			  $$ =merge($3->falselist,$7);
			 }
    ;
IFES:IF'('BE')''{'M S '}' N ELSE '{'M S '}'
			{
			 backpatch($3->truelist,$6);
			 backpatch($3->falselist,$12);
			 $$=merge($7,merge($9,$13));
			 }
    ;
FORS: FOR'('IS';'M BE';'M IS N')''{'M S '}'
     {
       backpatch($6->truelist,$13);
       backpatch($14,$8);
       backpatch($10,$5);
       $$=$6->falselist;
       strcpy(quad[i].op,"goto");
	itoa($8,temp,10);
	strcpy(quad[i].arg1,temp);
	i++;
      }
   ;

IS:IS','T
  |T
  ;
T:id'='E   {
		strcpy(quad[i].arg1,$3);
	   strcpy(quad[i].arg2,"-");
	   strcpy(quad[i].op,"=");
	   strcpy(quad[i].res,$1->name);
	    i++;
	    }
  ;



WS: WHILE'('M BE')''{'M S '}' {
			backpatch($4->truelist,$7);
				backpatch($8,$3);
				$$=$4->falselist;

				strcpy(quad[i].op,"goto");
				itoa($3,temp,10);
				strcpy(quad[i].arg1,temp);
				i++;
			      }

   ;
M:    {$$=i;}
  ;
 N: 	     {$$=makelist(i);
	      strcpy(quad[i].op,"goto");
	      strcpy(quad[i].arg1,"-");
	      strcpy(quad[i].arg2," ");
	      strcpy(quad[i].res," ");
	      i++;
	      }
 ;


AS:id'='E';'{
	     strcpy(quad[i].arg1,$3);
	   strcpy(quad[i].arg2,"-");
	   strcpy(quad[i].op,"=");
	   strcpy(quad[i].res,$1->name);
	     i++;
	     $$=NULL;
	    }
  ;

FUN:CALL id'('Elist')'{
		     for(g=0;g<front;g++)
		     {
		      strcpy(quad[i].op,"param");
		      strcpy(quad[i].arg1,queue[g]);
		      i++;
		     }
		      strcpy(quad[i].op,"call");
		      strcpy(quad[i].arg1,$2->name);
		      strcpy(quad[i].arg2,",");
		      itoa(front,temp,10);
		      strcpy(quad[i].res,temp);
		      i++;
		     }
   ;
Elist:Elist','E { strcpy(queue[front++],$3);}
    |E		{strcpy(queue[front++],$1);}
    ;
BE:E RELOP E {$$=(struct battri *) malloc(sizeof(struct battri));
	      $$->truelist=makelist(i);
	      $$->falselist=makelist(i+1);

	      strcpy(quad[i].op,"if");
	      strcpy(quad[i].arg2,"goto");
	      strcpy(quad[i].res,"-");
	      strcpy(temp,$1);
	      strcat(temp,$2);
	      strcat(temp,$3);
	      strcpy(quad[i].arg1,temp);
	      i++;
	      strcpy(quad[i].op,"goto");
	      strcpy(quad[i].arg1,"-");
	      strcpy(quad[i].arg2," ");
	      strcpy(quad[i].res," ");
	      i++;
 //	      printf("false=%d\ttrue=%d\n",$$->falselist->number,$$->truelist->number);
	      }
   |BE OR M BE {      $$=(struct battri *) malloc(sizeof(struct battri));

		backpatch($1->falselist,$3);
		$$->truelist=merge($1->truelist,$4->truelist);

		$$->falselist=$4->falselist;
		}
  |BE AND M BE { $$=(struct battri *) malloc(sizeof(struct battri));

		backpatch($1->truelist,$3);
		$$->truelist=$4->truelist;
		$$->falselist=merge($1->falselist,$4->falselist);
   //		disp($$->falselist);
		}
  |NOT BE {     $$=(struct battri *) malloc(sizeof(struct battri));
		$$->truelist=$2->falselist;
	     $$->falselist=$2->truelist;
	    }
  |'('BE')' {   $$=(struct battri *) malloc(sizeof(struct battri));
		$$->truelist=$2->truelist;
	     $$->falselist=$2->falselist;
	     }
  |TRUE {$$=(struct battri *) malloc(sizeof(struct battri));
	$$->truelist=makelist(i);
	 $$->falselist=NULL;
		strcpy(quad[i].op,"goto");
	      strcpy(quad[i].arg1,"-");
	      strcpy(quad[i].arg2," ");
	      strcpy(quad[i].res," ");
	      i++;
	   }
  |FALSE {      $$=(struct battri *) malloc(sizeof(struct battri));
		$$->falselist=makelist(i);
	 $$->truelist=NULL;
		strcpy(quad[i].op,"goto");
	      strcpy(quad[i].arg1,"-");
	      strcpy(quad[i].arg2," ");
	      strcpy(quad[i].res," ");
	      i++;
	   }
    ;
E:E'+'E {strcpy(quad[i].arg1,$1);
	   strcpy(quad[i].arg2,$3);
	   strcpy(quad[i].op,"+");
	   strcpy(quad[i].res,"t");
	   itoa(tempvar++,temp,10);
	   strcat(quad[i].res,temp);
	   strcpy($$,quad[i++].res);
	   }
 |E'-'E {strcpy(quad[i].arg1,$1);
	   strcpy(quad[i].arg2,$3);
	   strcpy(quad[i].op,"-");
	   strcpy(quad[i].res,"t");
	   itoa(tempvar++,temp,10);
	   strcat(quad[i].res,temp);
	   strcpy($$,quad[i++].res);

	    }
 |E'*'E {strcpy(quad[i].arg1,$1);
	   strcpy(quad[i].arg2,$3);
	   strcpy(quad[i].op,"*");
	   strcpy(quad[i].res,"t");
	   itoa(tempvar++,temp,10);
	   strcat(quad[i].res,temp);
	   strcpy($$,quad[i++].res);
	   }
 |E'/'E  {
	 strcpy(quad[i].arg1,$1);
	   strcpy(quad[i].arg2,$3);
	   strcpy(quad[i].op,"/");
	   strcpy(quad[i].res,"t");
	   itoa(tempvar++,temp,10);
	   strcat(quad[i].res,temp);
	   strcpy($$,quad[i++].res);
	}
 |E '^' E {  strcpy(quad[i].arg1,$1);
	   strcpy(quad[i].arg2,$3);
	   strcpy(quad[i].op,"^");
	   strcpy(quad[i].res,"t");
	   itoa(tempvar++,temp,10);
	   strcat(quad[i].res,temp);
	   strcpy($$,quad[i++].res);
	  }
 |'-'E %prec UMINUS {  strcpy(quad[i].arg2,$2);
	   strcpy(quad[i].arg2,"-");
	   strcpy(quad[i].op,"UMINUS");
	   strcpy(quad[i].res,"t");
	   itoa(tempvar++,temp,10);
	   strcat(quad[i].res,temp);
	   strcpy($$,quad[i++].res);
			}
 |'('E')' {strcpy($$,$2);}
 |NUM
 |id {strcpy($$,$1->name);}
 ;
%%

main()
{
yyparse();
dispquad();
}
int yyerror()
{
return 1;
}

void dispquad()
{
int j,k;
printf("index\top\targ1\targ2\tresult\n");
for(j=0;j<i;j++)
{
printf("%d\t%s\t%s\t%s\t%s\n",j,quad[j].op,quad[j].arg1,quad[j].arg2,quad[j].res);
}
}

struct symtab *install_id(char *s)
{
 struct symtab *p;
 for(p=SYM;p<&SYM[20];p++)
 {
  if((p->name) &&(!strcmp(p->name,s)))
  return p;
  else
  {
   if(!p->name)
   {
     p->name=strdup(s);
     return p;
   }
   }
  }
}
void dispsym()
{
int j;
printf("symbol table\n");
for(j=0;j<20;j++)
{ if(SYM[j].name)
  printf("%s\t%lf\n",SYM[j].name,SYM[j].value);
}
}

struct node *makelist(int k)
{
struct node *temp;
temp = (struct node *)malloc(sizeof(struct node));
temp->number=k;
temp->next = NULL;
return temp;
}

void disp(struct node *next)
{
struct node *a;
a=next;
while(a!=NULL)
{
printf("list=%d\t",a->number);
a=a->next;
}
printf("\n");
}

void backpatch(struct node *t,int k)
{
struct node *l;
l=t;
while(l!=NULL)
{
itoa(k,temp,10);
if(!strcmp(quad[l->number].res,"-"))
{strcpy(quad[l->number].res,temp);}
else if(!strcmp(quad[l->number].arg1,"-"))
{
strcpy(quad[l->number].arg1,temp);
}
l=l->next;
}
}

struct node *merge(struct node *p1,struct node *p2)
{
struct node *k;
k=p1;
while(k->next!=NULL)
k=k->next;
k->next=p2;
return p1;
}

