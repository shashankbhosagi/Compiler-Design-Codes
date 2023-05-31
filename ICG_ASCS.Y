%{
# include<stdio.h>
#include<string.h>
# include <stdlib.h>
void itoa1(int a,int k);
struct symtab{
 char *name;
double value;
}SYM[20];
struct symtab *install_id(char *s);
void display_sym();
struct node *makelist(int d);
struct node *merge(struct node *p1,struct node *p2);
void backpatch(struct node *p1,int k);
typedef struct quadruple{
char op[10];
char arg1[10];
char arg2[10];
char res[10];
}QUAD;
QUAD Q[30];
void display_quad();
int i=1;
int tempvar=1;
char temp[10],st[10];
struct node{
 int data;
struct node *next;
};
struct battr{
struct node *truelist;
struct node *falselist;
};
%}
%union{
struct symtab *p;
char v[10];
int sno;
struct node *nextlist;
struct battr *BAT;
}
%token <p> id
%token <v> num
%token OR AND NOT TRUE FALSE WHILE
%token IF
%token ELSE
%token <v> RELOP
%left OR
%left AND
%nonassoc NOT
%left RELOP
%right '='
%left '+' '-'
%left '*' '/'
%right '^'
%nonassoc UMINUS
%type<v> E
%type <sno> M
%type <nextlist> S OS IS AS N IES WS
%type <BAT> BE
%%
S :S M OS {backpatch($1,$2); $$=$3;}
 |OS
;
OS:AS {$$ = NULL;}
  |IS
  |IES
  |WS

;
IS : IF '(' BE ')' '{' M S '}' { $$ = (struct node *) malloc(sizeof(struct node));
backpatch($3->truelist,$6); $$ = merge($3->falselist,$7);}
;
IES: IF '(' BE ')' '{'M S '}'  ELSE '{'N M S '}' { $$= (struct node *) malloc(sizeof(struct node));
		backpatch($3->truelist,$6);
		backpatch($3->falselist,$12);
		$$ = merge($7,merge($11,$13));
	}
;
WS : WHILE '(' M BE ')' '{' M S '}' {$$ = (struct node *) malloc(sizeof(struct node));
				backpatch($4->truelist,	$7);
				backpatch($8,$3);
				$$=$4->falselist;
				strcpy(Q[i].op," ");
		   strcpy(Q[i].arg1," ");
			strcpy(Q[i].arg2,"goto");
		      //	printf("value of m=%d\n",$3);
			 itoa1($3,10);

		   strcpy(Q[i].res,st);
			i++;

}
M :   {$$ =i;}
  ;
N : { $$= (struct node *) malloc(sizeof(struct node));
	$$ =makelist(i);strcpy(Q[i].op," ");
		   strcpy(Q[i].arg1," ");
			strcpy(Q[i].arg2,"goto");
		   strcpy(Q[i].res," ");
			i++;	 	}
;

BE : BE OR M BE { $$ =(struct battr *) malloc(sizeof(struct battr));
		backpatch($1->falselist,$3);
		$$->falselist=$4->falselist;
		$$->truelist=merge($1->truelist,$4->truelist);
		}
   | BE AND M BE {$$ =(struct battr *) malloc(sizeof(struct battr));
		backpatch($1->truelist,$3);
		$$->truelist=$4->truelist;
		$$->falselist=merge($1->falselist,$4->falselist);
		}
   | NOT BE	{$$ =(struct battr *) malloc(sizeof(struct battr));
	$$->falselist=$2->falselist;$$->truelist=$2->truelist;}

   | E RELOP E {$$ =(struct battr *) malloc(sizeof(struct battr));
		  $$->truelist=makelist(i);
		   $$->falselist=makelist(i+1);
		   strcpy(Q[i].op,"if");
		   strcpy(Q[i].arg1,$1);
		   strcat(Q[i].arg1,$2);
		   strcat(Q[i].arg1,$3);
		   strcpy(Q[i].arg2,"goto");
		   strcpy(Q[i].res," ");
			i++;
		   strcpy(Q[i].op," ");
		   strcpy(Q[i].arg1," ");
			strcpy(Q[i].arg2,"goto");
		   strcpy(Q[i].res," ");
			i++;	 	}
    |'(' BE ')' {$$ =(struct battr *) malloc(sizeof(struct battr));
		  $$->truelist=$2->truelist;
		   $$->falselist=$2->falselist;}
    | TRUE {$$ =(struct battr *) malloc(sizeof(struct battr));
		  $$->truelist=makelist(i);
		   $$->falselist=NULL;
		strcpy(Q[i].op," ");
		   strcpy(Q[i].arg1," ");
			strcpy(Q[i].arg2,"goto");
		   strcpy(Q[i].res," ");
			i++;
		}
    |FALSE {$$ =(struct battr *) malloc(sizeof(struct battr));
		  $$->truelist=NULL;
		   $$->falselist=makelist(i);
		strcpy(Q[i].op," ");
		   strcpy(Q[i].arg1," ");
			strcpy(Q[i].arg2,"goto");
		   strcpy(Q[i].res," ");
			i++;}
     ;
AS: id '=' E ';' {strcpy(Q[i].op,"=");
		 strcpy(Q[i].arg1,$3);
		 strcpy(Q[i].arg2," ");
		 strcpy(Q[i].res,$1->name);
		 $$=NULL;i++;  }
  ;
E : E '+' E {strcpy($$,insert_quad("+",$1,$3,i));i++; }
  | E '-' E {strcpy($$ , insert_quad("-",$1,$3,i));i++; }
   | E '*' E {strcpy($$ , insert_quad("*",$1,$3,i));i++; }
| E '/' E {strcpy($$ , insert_quad("/",$1,$3,i));i++; }
| E '^' E {strcpy($$ , insert_quad("^",$1,$3,i));i++; }
| '-' E {strcpy($$ , insert_quad("UMINUS",$2," ",i));i++; }
|id {strcpy($$,$1->name);}
|num {strcpy($$,$1);}
  ;
%%
char * insert_quad(char op[10],char arg1[10],char arg2[10],int j)
{
char s[10];
strcpy(Q[j].op,op);
strcpy(Q[j].arg1,arg1);
strcpy(Q[j].arg2,arg2);
strcpy(temp,"t");
itoa1(tempvar++,10);
strcat(temp,st);
strcpy(Q[j].res,temp);
return temp;
}
int yyerror(char *s)
{
printf("error =%s\n",s);
return 1;
}
main()
{
yyparse();
display_quad();
display_sym();
}
struct symtab *install_id(char *s)
{
struct symtab *p;
for(p=SYM;p<&SYM[20];p++)
{
if(p->name&&!strcmp(p->name,s))
return p;
else
if(!p->name)
{
p->name=strdup(s);
return p;
}
}
}
void display_sym()
{
struct symtab *p;
printf("symbol name           value\n");
for(p=SYM;p<&SYM[20];p++)
{
if(p->name)
printf("%s\t%lf\n",p->name,p->value);
}
}

void itoa1(int t,int b)
{
int j=0,k;
char m[10];

while(t!=0)
{
m[j]=t%b+48;
t=t/b;
j++;
}
m[j]='\0';

j=0;
for(k=strlen(m)-1;k>=0;k--)
st[j++]=m[k];
st[j]='\0';
//printf("value of temp var =%s\n",st);
}

void display_quad()
{int j;
printf("sno\top\targ1\targ2\tres\n");
for(j=1;j<i;j++)
printf("%d\t%s\t%s\t%s\t%s\n",j,Q[j].op,Q[j].arg1,Q[j].arg2,Q[j].res);
}

struct node *makelist(int d)
{
struct node *t;
t=(struct node *) malloc (sizeof(struct node));
t->data = d;
t->next=NULL;
return t;
}

struct node *merge(struct node *p1,struct node *p2)
{
struct node *k;
if(p1==NULL)
return p2;
else
if(p2==NULL)
return p1;
else
{
k=p1;
while(k->next!=NULL)
k=k->next;
k->next=p2;
return p1;
}
}

void backpatch(struct node *p1,int k)
{
while(p1!=NULL)
{
itoa1(k,10);
strcpy(Q[p1->data].res,st);
p1=p1->next;

}
}


