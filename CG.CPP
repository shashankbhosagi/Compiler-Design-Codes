# include<iostream.h>
# include<string.h>
# include<stdlib.h>
# include<process.h>
# include<conio.h>
class node
{
 public: char data;
	 int flag;
	 int r;
	 node *left,*right;
	 int lflag;
	 node()
	 {
	  left=right=NULL;
	  }
	  node(int x)
	  {
	   data=x;
	   left=right=NULL;
	  }
};
class queue
{
 node * Q[20];
 int f,r;
 public:
 queue() { f=r=0;}
 void insert(node *t)
 {
   Q[r++]=t;
  }
  int empty()
  {
   if(f==r)
   return 1;
   return 0;
  }
  node *del()
  {
   if(!empty())
   return Q[f++];
   return NULL;
  }
};
class rstack
{
 char reg[10][4];
 int top;
 public:
 rstack()
 {
   top=-1;
 }
void init(int k,char *name);
 void swap()
 {
  char name[10];
  strcpy(name,reg[top]);
  strcpy(reg[top],reg[top-1]);
  strcpy(reg[top-1],name);
 }
 char *pop()
 {
   return(reg[top--]);
 }
 int topv()
 {
  return top;
  }
 void push(char *tr)
 {
  strcpy(reg[++top],tr);
  }
  char *topd()
  {
   return (reg[top]);
   }
};


class stack
{
 node *data[20];
 int top;
 public:
 stack() {top=-1;}
 int empty()
 {
  if(top==-1)
  return 1;
  return 0;
 }
 void push(node *p)
 {
  data[++top]=p;

  }
  node *pop()
  {
   if(!empty())
   return (data[top--]);
   return NULL;
   }
};
void rstack::init(int k,char *name)
 {                char temp[3];
    for(int i=k-1;i>=0;i--)
    {
       strcpy(reg[++top],name);
       itoa(i,temp,10);
       strcat(reg[top],temp);
    }
    cout<<"regs are ";
    for(i=top;i>=0;i--)
    cout<<reg[i]<<" ";
    cout<<"\n";




 }

class tree
{
 node *root;
 rstack m,tstack;
 int rg;
 public:
 tree(){root=NULL;}
 node *create1();
 void disp(char c);
 void preorder(node *t);
 void inorder(node *t);
 void postorder(node *t);
 void create() {root=create1();}
 void preorder() {preorder(root);}
 void label(node * t);
 void label(){label(root);}
 void gencode(node *t);
 void gencode()
 {
  cout<<"enter regs\n";
  cin>>rg;
  m.init(rg,"R");
  tstack.init(6,"T");

  gencode(root);
  }
 //void nonr_preorder();
// void nonr_inorder();
 void inorder() {inorder(root);}
 int count(node *t);
 int count(){return count(root);}
 void postorder(){postorder(root);}
 void bfs();
 int leaf(){return leaf(root);}
 int leaf(node *T);
 int one_leaf() {return one_leaf(root);}
 int one_leaf(node * T);
 int two_leaf() {return two_leaf(root);}
 int two_leaf(node *t);
};

void tree::disp(char c)
{
  switch(c)
  {
   case '+' : cout<<"ADD ";
   break;
   case '*' :cout<<"MUL  ";
   break;
   case '-':cout<<"SUB ";
   break;
   case '/':cout<<"DIV ";
   break;
  }
  }



void tree::gencode(node *t)
{    char *name,*name1;
/*case 0*/
if(t->r==1&&t->left==NULL&&t->right==NULL)
{
cout<<"MOV "<<t->data<<","<<m.topd()<<"\n";;
}
/*case 1*/
else
if(t->left!=NULL&&t->right->r==0)
{
  gencode(t->left);
  disp(t->data);
  cout<<t->right->data<<" "<<m.topd()<<"\n";
 }
 /*case 2*/
 else
 if((t->left->r<t->right->r)&&(t->left->r<rg))
 {
  // cout<<"case 2\n";
   m.swap();
   gencode(t->right);
   name=m.pop();
  // cout<<"popped reg "<<name<<"\n"<<"top= "<<m.topv()<<"\n";
   gencode(t->left);
   disp(t->data);
   cout<<name<<" " <<","<<m.topd()<<"\n";
   m.push(name);
   m.swap();
   }
 /*case 3*/
  else if((t->right->r<=t->left->r)&& (t->right->r<rg))
  {
//   cout<<"case 3\n";
   gencode(t->left);
   name=m.pop();

//   cout<<"popped reg "<<name<<"\n"<<"top= "<<m.topv();
   gencode(t->right);
   disp(t->data);
   cout<<m.topd()<<","<<name<<"\n";
   m.push(name);
   }
   else
   {
    gencode(t->right);
    name=tstack.pop();
    cout<<"MOV "<<m.topd()<<","<<name<<"\n";
    gencode(t->left);
    disp(t->data);
    cout<<name<<","<<m.topd();
    tstack.push(name);
   }

}


void tree::label(node *t)
{
if(t->left->left==NULL&&t->left->right==NULL)
{
 t->left->r=1;
}
if(t->left->left!=NULL||t->left->right!=NULL)
label(t->left);

 if(t->right->left==NULL&&t->right->right==NULL)
 {
  t->right->r=0;
  }
if(t->right->left!=NULL||t->right->right!=NULL)
label(t->right);
  if(t->left!=NULL&&t->right!=NULL)
  {
    if(t->left->r>t->right->r)
    t->r=t->left->r;
    else if(t->right->r>t->left->r)
    t->r=t->right->r;
    else
    t->r=t->left->r+1;

  }

}

int tree::one_leaf(node *T)
{

  if(T->left==NULL&&T->right!=NULL)
  return 1;
  else
  if(T->left!=NULL&&T->right!=NULL)
  return 1;
  if(T->left==NULL&&T->right==NULL)
  return 0;
  return (one_leaf(T->left)+one_leaf(T->right));
}

int tree::two_leaf(node *T)
{
  if(T==NULL)
  return 0;
  if(T->left!=NULL&&T->right!=NULL)
  return 1+two_leaf(T->left)+two_leaf(T->right);
  return (two_leaf(T->left)+two_leaf(T->right));
}

int tree::leaf(node *T)
{
 if(T==NULL)
 return 0;
 if(T->left==NULL && T->right==NULL)
 return 1;
 return (leaf(T->left)+leaf(T->right));
}

int tree::count(node *t)
{
 if(t==NULL)
 return 0;
 else
 return (1+count(t->left)+count(t->right));
}

node *tree::create1()
{
 node *p;
 char x;
 cout<<"Enter node data\n";
 cin>>x;
 if(x=='Z')
 return NULL;
 else
 {
   p=new node(x);
   cout<<"Enter left child of x "<<x<<endl;
   p->left=create1();
   cout<<"Enter right child of x "<<x<<endl;
   p->right=create1();
 }
 return p;
}

void tree::preorder(node *t)
{
 if(t)
 {
   cout<<t->data<<"\t"<<"(label="<<t->r<<")\t";
   preorder(t->left);
   preorder(t->right);
 }
 }
 void tree::inorder(node *t)
{
 if(t)
 {

   inorder(t->left);
   cout<<t->data<<"\t";
   inorder(t->right);
 }
 }
 void tree::postorder(node *t)
{
 if(t)
 {

   postorder(t->left);
   postorder(t->right);
   cout<<t->data<<"\t";
 }
 }
/*void tree::nonr_preorder()
{
  node *t;
  stack s;
  t=root;
     while(t!=NULL)
    {
     cout<<t->data<<"\t";
     s.push(t);
     t=t->left;
     }
     while(!s.empty())
     {
     t=s.pop();
     t=t->right;
     while(t!=NULL)
    {
     cout<<t->data<<"\t";
     s.push(t);
     t=t->left;
     }
   }
}

void tree::nonr_inorder()
{
  node *t;
  stack s;
  t=root;
     while(t!=NULL)
    { s.push(t);
    // cout<<t->data<<"\t";
     t=t->left;
     }
     while(!s.empty())
     {
     t=s.pop();
     cout<<t->data<<"\t";
     t=t->right;
     while(t!=NULL)
    {
    // cout<<t->data<<"\t";
     s.push(t);
     t=t->left;
     }
   }
}
void tree::nonr_postorder()
{
node *t;
stack s;
t=root;
do
{
while(t!=NULL)
{
 t->flag=0;
 s.push(t);
 t=t->left;
}
t=s.pop();
while(1)
{
if(t->flag==0)
{
 t->flag=1;
 s.push(t);
 t=t->right;
 break;
 }
 else
 {
 cout<<t->data<<"\t";
 if(!s.empty())
 t=s.pop();
 else
 break;
 }
}

}while(!s.empty());

}  */
void tree::bfs()
{
   queue q1;
   node *T,*d;
   T=root;
   if(T)
   {
   q1.insert(T);
   d=new node;
   d->data=' ';
   q1.insert(d);
   T=q1.del();
   while(!q1.empty())
   {
     if(T!=d)
     {
     cout<<T->data<<" ";
    if(T->left!=NULL)
    {
      q1.insert(T->left);
    }
     if(T->right!=NULL)
    {
      q1.insert(T->right);
    }
    }
    else
    {
      cout<<"\n";
      q1.insert(d);
    }
    T=q1.del();
   }
  }
}



void main()
{
tree t;
int choice,n;
char ch;

do
{
 cout<<"******MENU******\n";
 cout<<"case 1:create tree\n";
 cout<<"case 2:preorder\n";
 cout<<"case 3:inorder\n";
 cout<<"case 4:postorder\n";
 cout<<"case 5:count\n";
 cout<<"case 6:leaf\n";
 cout<<"case 7:one_leaf\n";
 cout<<"case 8:two_leaf\n";
 cout<<"case 9:bfs\n";
 cout<<"case 10:label\n";
 cout<<"case 11:gencode\n";
 cout<<"Enter your choice\n";
 cin>>choice;
 switch(choice)
 {
  case 1: t.create();
	 break;
  case 2:t.preorder();
	 break;
  case 3:t.inorder();
	 break;
  case 4:t.postorder();
	 break;
  case 5: n=t.count();
	 cout<<"no. of nodes \t"<<n;
	 break;
  case 6:n=t.leaf();
  cout<<"no of leaf nodes \t"<<n;
	 break;
  case 7:n=t.one_leaf();
    cout<<"no. of nodes with one leaf\n"<<n;
	break;

  case 8:n=t.two_leaf();
	 cout<<"no. of nodes= "<<n;
	 break;
  case 9: t.bfs();
       break;
       case 10:t.label();
       break;
       case 11:t.gencode();
       break;
  default:exit(0);
 }
 cout<<"\nDo you want to continue\n";
 cin>>ch;
 }while(ch=='y');
 getch();
}


