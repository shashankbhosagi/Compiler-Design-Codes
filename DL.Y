%{
# include<stdio.h>
# include<conio.h>
# include<string.h>
# include<alloc.h>


struct node *makelist(int i);

void dispsym();
void disp(struct node *next);
int width(char *s);
int limit(char *s,int l);



struct symtab{
char *name;
char type[10];
double value;
struct node *limit;
int width;
}SYM[20];


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
struct arr_val
{
char place[10],offset[10];
};
struct array
{
char aname[10],place[10];
int ndim;
};
struct decl
{
char type[10];
int width;
};
struct node *r;
%}

%union{
char val[10];
int sno;
struct symtab *p;
struct node *nextlist;
struct battri *bat;
struct decl *de;
struct arr_val *a_val;
struct array *arr;
};
%token<val> NUM
%token CHAR FLOAT MAIN INTEGER
%token<p> id


%type<de> T1
%type<de> L1
%type<p> VD IN
%%
D:D DEC
 |DEC
 ;
DEC:L1 ';'
  ;
T1:INTEGER {$$=(struct decl *) malloc (sizeof(struct decl));
	   strcpy($$->type,"integer");
	   $$->width=2;
	  // printf("dfsdfs");
	   }
 | CHAR {$$=(struct decl *) malloc (sizeof(struct decl));
	   strcpy($$->type,"char");
	   $$->width=1;
	  // printf("dfsdfs");
	   }
 | FLOAT {$$=(struct decl *) malloc (sizeof(struct decl));
	   strcpy($$->type,"float");
	   $$->width=4;
	  // printf("dfsdfs");
	   }

 ;
L1:L1 ',' VD  {$$=$1;
	   strcpy($3->type,$1->type);
	   $3->width=$1->width;
	   }
  |T1 VD   {$$=$1;
	   strcpy($2->type,$1->type);
	   $2->width=$1->width;
	   }
  ;
VD :id
   |id'='NUM {$1->value=atoi($3);}
   |IN
   ;
IN:IN'['NUM']'   {       r=$$->limit;
			while(r->next!=NULL)
			r=r->next;
			r->next=makelist(atoi($3));
		 }
   |id'['NUM']'   {$1->limit=makelist(atoi($3));
		   $$=$1;}

   ;




%%
main()
{
yyparse();

dispsym();
}

int limit(char *s,int l)

{
struct symtab *p;
struct node *t;
int g=1;
 for(p=SYM;p<&SYM[20];p++)
 {
  if((p->name) &&(!strcmp(p->name,s)))
  {
  t=p->limit;
  while(g<l)
  {
   t=t->next;
   g++;
  }
   return t->number;
    }
  }
  }


int width(char *s)
{
struct symtab *p;
 for(p=SYM;p<&SYM[20];p++)
 {
  if((p->name) &&(!strcmp(p->name,s)))
  return (p->width);
 }
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
struct node *t;
printf("symbol table\n");
printf("name\tvalue\ttypr\twidth\tlimit\n");
for(j=0;j<20;j++)
{ if(SYM[j].name)
  {
  printf("%s\t%lf\t%s\t%d\t",SYM[j].name,SYM[j].value,SYM[j].type,SYM[j].width);
  t=SYM[j].limit;
  while(t)
  {
   printf("%d\t",t->number);
   t=t->next;
   }
   printf("\n");
 }
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
