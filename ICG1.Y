%{
# include <string.h>
# include<stdio.h>
# include <math.h>
struct node
{
 int data;
 struct node *next;
};



typedef struct boolexp
{
struct node *truelist;
struct node *falselist;
}BEXP;

struct symtab{
char *name;
double value;
char type[10];
struct node *limit;
int size;
}SYM[20];

struct array{
struct symtab *aname;
char place[10];
int dim;
};

struct lat
{
char place[10];
char offset[10];
};



struct quad
{
char op[10],arg1[20],arg2[20],res[10];
};
struct quad quad[20];

struct dtype
{
char type[10];
int size;
};


struct symtab *install_id(char *);
void disp();
void disp_quad();
struct node *makelist(int i);
struct node *merge(struct node *,struct node *);
void backpatch(struct node *,int);
int i,m;
int tempvar=1;
char s[5]= "t",tempvars[5],s1[20];
struct node *k,*p;
%}
%union
{
struct symtab *p;
char val[10];
int no;
struct boolexp *b;
struct node *nextlist;
struct array *ARAT;
struct lat *tal;
struct dtype *dt;
};
%right '='
%left OR
%left AND
%right NOT
%left RELOP
%left '+' '-'
%left '*' '/'
%right '^'
%right UMINUS
%token <p> id
%type <p> ar iA
%type <ARAT> Elist
%type <tal> L1
%token <val> OR AND NOT RELOP
%token TRUE FALSE
%token IF DO WHILE FOR INT CHAR FLOAT MAIN
%token ELSE
%token <val> NUMBER UOP
%type <val> E
%type <b> BE
%type <no> M
%type <nextlist> S1 S AS IES N  IS WS DWS FS
%type <dt> T V

%%
P: MAIN '(' ')' '{' D S1'}'
 ;
D :D V';'
  | V ';'
  ;
V: T iA    {strcpy($2->type,$1->type);$2->size=$1->size;strcpy($$,$1);}
   | V ',' iA {strcpy($3->type,$1->type);$3->size=$1->size;}
   ;
iA: id
  |id '=' NUMBER  {$1->value=atoi($3); $$=$1;}
  |ar       {$$=$1;}
  ;
ar: id '[' NUMBER ']'  {$1->limit=(struct node *)malloc(sizeof(struct node));
		     k=$1->limit;
		     k->data=atoi($3);
		     k->next=NULL;
		     $$=$1;
		     }
  | ar '[' NUMBER ']'   {

		     k=$1->limit;
		     while(k->next!=NULL)
		     k=k->next;
		     k->next=(struct node *)malloc(sizeof(struct node));
		     p=k->next;
		     p->data=atoi($3);
		     p->next=NULL;
		     }
  ;

T  : INT {strcpy($$->type,"int");$$->size=sizeof(int);}
| CHAR  {strcpy($$->type,"char"); $$->size=sizeof(char);}
|FLOAT  {strcpy($$->type,"float"); $$->size=sizeof(float);}
;
S1: S1 M  S {backpatch($1,$2); }
| S
;
S : AS
  | IES
  | IS
  | WS
  | FS
  | DWS
  ;
FS : FOR '(' INS ';' M BE ';' M MS N')' '{' M S1 N'}'
     {
      backpatch($6->truelist,$13);
      backpatch($14,$8);
      backpatch($10,$5);
      backpatch($15,$8);
      $$=$6->falselist;

     }
     ;
INS: id '=' E        {
		 strcpy(quad[i].op,"=");
		strcpy(quad[i].arg1,$3);
		strcpy(quad[i].arg2,"--");
		strcpy(quad[i].res,$1->name);
		i++;
		}
    | id '=' E ',' INS {
			   strcpy(quad[i].op,"=");
		strcpy(quad[i].arg1,$3);
		strcpy(quad[i].arg2,"--");
		strcpy(quad[i].res,$1->name);
		i++;

		       }
    |
    ;
MS : id UOP      {
			 strcpy(tempvars,"t");
		itoa(tempvar++,s,10);
	     strcat(tempvars,s);
	     strcpy(quad[i].op,$2);
	     strcpy(quad[i].arg1,$1->name);
	     strcpy(quad[i].arg2,"--");
	     strcpy(quad[i].res,tempvars);
	     i++;


			}
|UOP id
{
	strcpy(tempvars,"t");
		itoa(tempvar++,s,10);
	     strcat(tempvars,s);
	     strcpy(quad[i].op,$1);
	     strcpy(quad[i].arg1,$2->name);
	     strcpy(quad[i].arg2,"--");
	     strcpy(quad[i].res,tempvars);
	     i++;
}
|INS
;
IS: IF '(' BE ')' '{'M S1 '}'
   {  $$=(struct node *)malloc(sizeof(struct node));
      backpatch($3->truelist,$6);
      $$=merge($3->falselist,$7);


   }
   ;
WS: WHILE '(' M BE ')' '{' M S1 '}'
 {
    $$=(struct node *)malloc(sizeof(struct node));
      backpatch($4->truelist,$7);
      $$=$4->falselist;
      strcpy(quad[i].op,"--");
     strcpy(quad[i].arg1,"--");
     strcpy(quad[i].arg2,"goto");
     itoa($3,s1,10);
     strcpy(quad[i].res,s1);
     i++;


 }
 ;
DWS: DO '{' M S1 '}' WHILE '('M BE ')' ';'
   {

      $$=(struct node *)malloc(sizeof(struct node));
      backpatch($9->truelist,$3);
      backpatch($4,$8);
      $$=$9->falselist;
   }
   ;
N :   {$$ =(struct node *) malloc(sizeof(struct node));
       $$ = makelist(i);
       strcpy(quad[i].op,"--");
     strcpy(quad[i].arg1,"--");
     strcpy(quad[i].arg2,"goto");
     i++;
     }
IES: IF '(' BE ')' '{'M S1 '}' ELSE N '{' M S1 '}'
     {
	   $$=(struct node *)malloc(sizeof(struct node));
      backpatch($3->truelist,$6);
      backpatch($3->falselist,$12);
      $$=merge($7,merge($10,$13));
      }


	;
AS : L1'='E';' {if(!strcmp($1->offset," "))
		{
		strcpy(quad[i].op,"=");
		strcpy(quad[i].arg1,$3);
		strcpy(quad[i].arg2,"--");
		strcpy(quad[i].res,$1->place);
		}
		else
		{

		 strcpy(quad[i].op,"[]=");
		 strcpy(quad[i].arg1,$1->offset);
		 strcpy(quad[i].arg2,$3);
		 strcpy(quad[i].res,$1->place);


		}
		i++;
		$$=NULL;
		}
  ;
E : E '+' E {strcpy(tempvars,"t");
	     itoa(tempvar++,s,10);
	     strcat(tempvars,s);
	     strcpy(quad[i].op,"+");
	     strcpy(quad[i].arg1,$1);
	     strcpy(quad[i].arg2,$3);
	     strcpy(quad[i].res,tempvars);
	     strcpy($$,quad[i].res);
	     i++;


   }
  | E '-' E {strcpy(tempvars,"t");
		itoa(tempvar++,s,10);
	     strcat(tempvars,s);
	     strcpy(quad[i].op,"-");
	     strcpy(quad[i].arg1,$1);
	     strcpy(quad[i].arg2,$3);
	     strcpy(quad[i].res,tempvars);
	     strcpy($$,quad[i].res);
	     i++;
 }
  | E '*' E {strcpy(tempvars,"t");
	itoa(tempvar++,s,10);
	     strcat(tempvars,s);
	     strcpy(quad[i].op,"*");
	     strcpy(quad[i].arg1,$1);
	     strcpy(quad[i].arg2,$3);
	     strcpy(quad[i].res,tempvars);
	     strcpy($$,quad[i].res);
	     i++;
 }
  | E '/' E {strcpy(tempvars,"t");
		itoa(tempvar++,s,10);
	     strcat(tempvars,s);
	     strcpy(quad[i].op,"/");
	     strcpy(quad[i].arg1,$1);
	     strcpy(quad[i].arg2,$3);
	     strcpy(quad[i].res,tempvars);
	     strcpy($$,quad[i].res);
	     i++;
 }
  | E '^' E {strcpy(tempvars,"t");
		itoa(tempvar++,s,10);
	     strcat(tempvars,s);
	     strcpy(quad[i].op,"^");
	     strcpy(quad[i].arg1,$1);
	     strcpy(quad[i].arg2,$3);
	     strcpy(quad[i].res,tempvars);
	     strcpy($$,quad[i].res);
	     i++;
 }
  |  '-' E %prec UMINUS {strcpy(tempvars,"t");
		itoa(tempvar++,s,10);
	     strcat(tempvars,s);
	     strcpy(quad[i].op,"UMINUS");
	     strcpy(quad[i].arg1,$2);
	     strcpy(quad[i].arg2,"--");
	     strcpy(quad[i].res,tempvars);
	     strcpy($$,quad[i].res);
	     i++;
 }
  | '(' E ')' {strcpy($$ ,$2);}
  |L1  {  if(!strcmp($1->offset," "))
	    strcpy($$,$1->place);
		  else
	  {
	   strcpy(quad[i].op,"=[]");
	   strcpy(quad[i].arg1,$1->place);
	   strcpy(quad[i].arg2,$1->offset);
	   strcpy(tempvars,"t");
	   itoa(tempvar++,s,10);
	   strcat(tempvars,s);
	   strcpy(quad[i].res,tempvars);
	   strcpy($$,tempvars);
	   i++;
	   }

	}

	  |NUMBER {strcpy($$,$1);   }
	  ;





L1 : id { $$=(struct lat *)malloc(sizeof(struct lat));
	  strcpy($$->place,$1->name);
	  strcpy($$->offset," ");}
   | Elist ']'   {$$=(struct lat *)malloc(sizeof(struct lat));

		   strcpy(tempvars,"t");
		itoa(tempvar++,s,10);
		 strcat(tempvars,s);

		  strcpy(quad[i].op,"*");
		  strcpy(quad[i].arg1,$1->place);
		  itoa($1->aname->size,s,10);
		  strcpy(quad[i].arg2,s);
		  strcpy(quad[i].res, tempvars);
		  i++;
		  strcpy($$->offset,tempvars);
		  strcpy(tempvars,"t");
		itoa(tempvar++,s,10);
		strcat(tempvars,s);
		strcpy(quad[i].op, "baeaddr");
		strcpy(quad[i].arg1,$1->aname->name);
		strcpy(quad[i].arg2,"--");
		strcpy(quad[i].res,tempvars);
		strcpy($$->place,tempvars);
		i++;
		}
  ;
Elist: Elist']' '[' E
		  {   $$=(struct array *)malloc(sizeof(struct array));
		       m=$1->dim+1;
		       strcpy(tempvars,"t");
			itoa(tempvar++,s,10);
			strcat(tempvars,s);
			strcpy(quad[i].op,"*");
			strcpy(quad[i].arg1,$1->place);
			itoa(limit($1->aname,m),s,10);
			strcpy(quad[i].arg2,s);
			strcpy(quad[i].res,tempvars);
			i++;
			strcpy(quad[i].op,"+");
			strcpy(quad[i].arg1,tempvars);
			strcpy(quad[i].arg2,$4);
			strcpy(quad[i].res,tempvars);
			i++;
			$$->aname=$1->aname;
			$$->dim=m;
			strcpy($$->place,tempvars);
			}


     | id '[' E

		{ $$=(struct array *)malloc(sizeof(struct array));
		  $$->aname=$1;
		  strcpy($$->place,$3);

		 $$->dim=1;
		 }
     ;









BE : BE OR M BE
     {$$=(BEXP *)malloc(sizeof(BEXP));
     backpatch($1->falselist,$3);
     $$->truelist=merge($1->truelist,$4->truelist);
     $$->falselist=$4->falselist;
     }
  | BE AND M BE
    {
     $$=(BEXP *)malloc(sizeof(BEXP));
     backpatch($1->truelist,$3);
     $$->truelist=$4->truelist;
     $$->falselist=merge($1->falselist,$4->falselist);


    }
  |NOT  BE  {
	    $$=(BEXP *)malloc(sizeof(BEXP));
     $$->truelist=$2->falselist;
     $$->falselist=$2->truelist;

	    }

  |id RELOP id
  {
   $$=(BEXP *)malloc(sizeof(BEXP));
     $$->truelist=makelist(i);
     $$->falselist=makelist(i+1);
     strcpy(quad[i].op,"if");
     strcpy(s1,$1->name);
     strcat(s1,$2);
     strcat(s1,$3->name);
     strcpy(quad[i].arg1,s1);
     strcpy(quad[i].arg2,"goto");
     i++;
     strcpy(quad[i].op,"--");
     strcpy(quad[i].arg1,"--");
     strcpy(quad[i].arg2,"goto");
     i++;


  }
  | TRUE
  {
       $$=(BEXP *)malloc(sizeof(BEXP));
       $$->truelist=makelist(i);
       $$->falselist=NULL;
	 strcpy(quad[i].op,"--");
     strcpy(quad[i].arg1,"--");
     strcpy(quad[i].arg2,"goto");
     i++;
  }
    |FALSE
		{
       $$=(BEXP *)malloc(sizeof(BEXP));
       $$->falselist=makelist(i);
       $$->truelist=NULL;
	 strcpy(quad[i].op,"--");
     strcpy(quad[i].arg1,"--");
     strcpy(quad[i].arg2,"goto");
     i++;
  }
  |'(' BE ')'  {
		 $$=(BEXP *)malloc(sizeof(BEXP));
       $$->truelist=$2->truelist;
       $$->falselist=$2->falselist;
	       }
  ;
M :    {$$=i;}
  ;
%%
main()
{
yyparse();
disp_quad();
}
int yyerror()
{
return 1;
}
struct symtab *install_id(char *s)
{
struct symtab *p;
for(p=SYM;p<&SYM[20];p++)
{
if(p->name && !strcmp(p->name,s))
return p;
if(!p->name)  {

p->name=strdup(s);
return p;
}
}
}

void disp_quad()
{
int j;
printf("srno.\top\targ1\targ2\tres\n");
for(j=0;j<i;j++)
{
 printf("%d\t%s\t%s\t%s\t%s\n",j,quad[j].op,quad[j].arg1,quad[j].arg2,quad[j].res);

}
}

void disp()
{
struct symtab *p;
printf("SYMBOL TABLE\n");
for(p=SYM;p<&SYM[20];p++)
{
if(p->name)
{
printf("%s\t%s\n",p->name,p->type);
if(p->limit)
{
 struct node *k=p->limit;
 while(k!=NULL)

  {printf("limit=%d\n",k->data); k=k->next;}
}

}
}
}

struct node *merge(struct node *l1,struct node *l2)
{
 struct node *p=l1;
 if(l1==NULL)
 {
 return l2;
 }
 if(l2==NULL)
 return l1;
 while(l1->next!=NULL)
 l1=l1->next;
 l1->next=l2;
 return p;
}

struct node *makelist(int j)
{
struct node *p;
p=(struct node *)malloc(sizeof(struct node));
p->data=j;
p->next=NULL;
return p;
}

void backpatch(struct node * l1,int k)
{
char st[10];
itoa(k,st,10);
while(l1!=NULL)
{
strcpy(quad[l1->data].res,st);
l1=l1->next;
}
}


int limit(struct symtab *p,int m)
{
int h=1;
k=p->limit;
while(h!=m)
{
 k=k->next;
 h++;
}
return(k->data);
}

