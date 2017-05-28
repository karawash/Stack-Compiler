%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
void push(char *s);
void forif();
void forwhile();
void fordo();
void fordouse();
void gen_code1(char type,char *arg1,char *arg2);
        char stack[50][10],stacktype2[50][10];  char stacksemi[50][10];
        char stack2[50][10];char ifelse[50][10];
	char stack3[50][10];char close[50][10];
        int scount=0,scount2=0,scount3=0,closing=0;
	int tcount=0,ifelsecount=0,semicount=0,doend=0;
        int countvar2=0,ce=0,di=0,stypecount=0;
	int i[5];int r;int s;char c[10];char d[5];
	int j,l,v,letter=0,label=0,ww[10],ff[10],dd[10],f1=0,w1=0,in1=0;
	int stacklabel[30],stackcount[30];
	int ecount=0,pi=0,foundelse=0,hoho=0,inc=0,inc1,scountbrac=0;
        char str[10],typ[30],br[30];
        char x[10],y[10],z[10],mtype[10];
        int d1=0,num=0,douse,d2=0;
%}

%union{
char *s;
int   i;
char c;
float f;};

%start prog  
%token  <i>  NUM  
%token <s> FLOAT INT BOOL
%token <c> SEMICOL 
%token <c>COMMA 
%token <s> TRUE FALSE
%token <s> ID 
%token <s>IF  WHILE DO
%nonassoc  <c>EQ
%nonassoc  <c>NOT 
%nonassoc  <c>EQL
%nonassoc  <c>GRT
%nonassoc  <c>LOW
%nonassoc  <c>NEQ
%nonassoc  <c> OR
%nonassoc  <c> AND
%left  <c>PLUS  
%left  <c>MINUS
%left  <c> STAR  
%left  <c> DIV

%type  <s>   exp prog id_assign inst decl_list inst_list id_assign_list type
%type  <s> exp1 exp2 exp3 exp4 exp5 exp6 exp7 exp8 exp9 exp10 
%nonassoc IFX
%nonassoc ELSE
%%
prog : decl_list  
      | decl_list inst  
      ;

decl_list : decl_list decl 
       |  {printf("");}
;

decl : type id_assign_list SEMICOL  
    ;

id_assign_list : id_assign_list COMMA id_assign  
      | id_assign   
      ;

id_assign : ID    {strcpy(mtype,stacktype2[stypecount-1]); printf("%s %s ;\n",mtype,stack[--scount]);}
      | ID EQ exp             { printf("%s %s;\n%s =  %s;\n",stacktype2[stypecount-1],stack[scount-1],stack[scount-1],stack[--scount] );}
;

type :  INT          
      | FLOAT     
      | BOOL
      ; 


inst_list :inst 
| inst_list  SEMICOL inst  
         
;

inst :  ID EQ exp  {scount--;printf("%s=var%d_0;\n",stack[--scount],countvar2);
 }
      
        |{d1=1;} IF '('exp ')' {forif();d1=0;}  inst_list   {printf("l%d;\n",ww[w1]);}
      
        |{d1=1;} WHILE '('exp ')' {forwhile();d1=0;}  inst {printf("GOTO label%d;\nl%d;\n",ww[--w1]+1,ww[--w1]+1);}
      
        |DO {fordo();d2=1; }  inst_list  WHILE  '('exp ')' 
      
	|ELSE { printf("GOTO l%d;\nl%d;\n",ww[w1]+1,ww[w1]);}  inst {printf("l%d;\n",ww[w1]+1);}
      
	| '{'inst_list '}'
;

 

exp : exp1
      | exp2  
      | exp3 
      | exp4
      | exp5
      | exp6
      | exp7
      | exp8
      | exp9
      | exp10
      | MINUS exp{num++;}
      | NOT exp {num++;}
      | ID
      | NUM {num++;}
      ;

exp1 :exp OR exp{
      if(d1==0){   gen_code1('5',stack[--scount],stack[--scount]);push("var");}}
;
exp2 : exp AND exp {
      if(d1==0) gen_code1('6',stack[--scount],stack[--scount]);push("var");} 
;
exp3 :exp PLUS exp  { 
        if(d1==0){gen_code1('1',stack[--scount],stack[--scount]);push("var");}  }
;
exp4 :exp MINUS exp {
         
       if(d1==0){ 
       gen_code1('2',stack[--scount],stack[--scount]);push("var");} }
;
exp5 :exp STAR exp  {
        if(d1==0){gen_code1('3',stack[--scount],stack[--scount]);push("var");} }
;
exp6 :exp DIV exp   {
        if(d1==0){ gen_code1('4',stack[--scount],stack[--scount]);push("var");} }

;
exp7 :exp EQL exp   {
        if(d1==0){ gen_code1('7',stack[--scount],stack[--scount]);push("var");} }
;
exp8 :exp GRT exp   {
        if(d1==0){ gen_code1('8',stack[--scount],stack[--scount]);push("var");} }
;
exp9 :exp LOW exp   {
        if(d1==0){  gen_code1('9',stack[--scount],stack[--scount]);push("var");} }
;
exp10:exp NEQ exp   {
        if(d1==0){ gen_code1('a',stack[--scount],stack[--scount]);push("var");} }
;
//check : TRUE | FALSE ;
  
%%



void push(char *s)
{ 
	strcpy(stack[scount++],s);
}

void pushtype2(char *s)
{ 
	strcpy(stacktype2[stypecount++],s);
}

void pushifelse(char *s)
{ 
	strcpy(ifelse[ifelsecount++],s);
}

void push2(char *s)
{ 
	strcpy(stack2[scount2++],s);
}

void push3(char *s)
{ 
	strcpy(stack3[scount3++],s);
}

void brace(char *s)
{ 
	strcpy(close[closing++],s);
}

void pushsemi(char *s)
{ 
	strcpy(stacksemi[semicount++],s);
}

void labelfn(int s)
{ 
	stacklabel[label++]=s;
}

void countfn(int s)
{ 
	stackcount[countvar2++]=s;
}

void popclose(){
--closing;
}

void forif(){ 
ww[w1]=label;w1++;
printf("var%d_0;\nvar%d_0=",countvar2,countvar2);
        for(di=0;di<=scount2-1;di++){ 
              if(strcmp(stack2[di],"op")==0||strcmp(stack2[di],"dig")==0)
                 {    di++; if(strcmp(stack2[di],stack2[di-2])!=0)printf("%s",stack2[di]);} 
              else{ if(strcmp(stack2[di],stack2[di-2])!=0)printf("%s",stack2[di]); } 
                                  }
         printf(";\nif(!var%d_0)then GOTO l%d\n",countvar2,label-1);
scount3=0;scount2=0;scountbrac=0;
}

void forwhile(){
if(d2==0){ 
ww[w1]=label;w1++;
hoho=scount3;
printf("l%d;\n",label); 
printf("var%d_0;\nvar%d_0=",countvar2,countvar2);
        for(di=0;di<=scount2-1;di++){ 
              if(strcmp(stack2[di],"op")==0||strcmp(stack2[di],"dig")==0)
                 {    di++; if(strcmp(stack2[di],stack2[di-2])!=0)printf("%s",stack2[di]);} 
              else{ if(strcmp(stack2[di],stack2[di-2])!=0)printf("%s",stack2[di]); } 
                                  }
         printf(";\nif(!var%d_0)then GOTO l%d\n",countvar2,label+1);
scount3=0;scount2=0;scountbrac=0;
 
}
else{printf("var%d_0;\nvar%d_0=",countvar2,countvar2);
        for(di=0;di<=scount2-1;di++){ 
              if(strcmp(stack2[di],"op")==0||strcmp(stack2[di],"dig")==0)
                 {    di++; if(strcmp(stack2[di],stack2[di-2])!=0)printf("%s",stack2[di]);} 
              else{ if(strcmp(stack2[di],stack2[di-2])!=0)printf("%s",stack2[di]); } 
                                  }
         printf(";\nif(var%d_0)then GOTO l%d\n",countvar2,douse);
scountbrac=0;scount3=0;scount2=0;d2=0;}
}

void fordo(){ ww[w1]=label;w1++;douse=ww[w1];
printf("l%d;\n",ww[w1]);
 }

 

 void gen_code1(char type,char *arg1,char *arg2)
{

	switch(type)
	{
		case '1':
                        printf("var%d_0;\nvar%d_0 = %s",countvar2,countvar2,arg1);
                        if(strcmp(arg1,"var")==0)
                            if(strcmp(arg2,"var")==0)
                                printf("%d_0 + %s%d_0;\n",countvar2-1,arg2,countvar2-2);
                            else
                                printf("%d_0 + %s;\n",countvar2-1,arg2);
			else if(strcmp(arg2,"var")==0)
                        printf(" + %s%d_0;\n",arg2,countvar2-1);
                        else
                        printf(" + %s;\n",arg2);
                        countvar2++;
			break;
                        
		case '2':
			printf("var%d_0;\nvar%d_0 = %s",countvar2,countvar2,arg1);
                        if(strcmp(arg1,"var")==0)
                            if(strcmp(arg2,"var")==0)
                                printf("%d_0 - %s%d_0;\n",countvar2-1,arg2,countvar2-2);
                            else
                                printf("%d_0 - %s;\n",countvar2-1,arg2);
			else if(strcmp(arg2,"var")==0)
                        printf(" - %s%d_0;\n",arg2,countvar2-1);
                        else
                        printf(" - %s;\n",arg2);
                        countvar2++;
			break;
		case '3':
			printf("var%d_0;\nvar%d_0 = %s",countvar2,countvar2,arg1);
                        if(strcmp(arg1,"var")==0)
                            if(strcmp(arg2,"var")==0)
                                printf("%d_0 * %s%d_0;\n",countvar2-1,arg2,countvar2-2);
                            else
                                printf("%d_0 * %s;\n",countvar2-1,arg2);
			else if(strcmp(arg2,"var")==0)
                        printf(" * %s%d_0;\n",arg2,countvar2-1);
                        else
                        printf(" * %s;\n",arg2);
                        countvar2++;
			break;
		case '4':
			printf("var%d_0;\nvar%d_0 = %s",countvar2,countvar2,arg1);
                        if(strcmp(arg1,"var")==0)
                            if(strcmp(arg2,"var")==0)
                                printf("%d_0 / %s%d_0;\n",countvar2-1,arg2,countvar2-2);
                            else
                                printf("%d_0 / %s;\n",countvar2-1,arg2);
			else if(strcmp(arg2,"var")==0)
                        printf(" / %s%d_0;\n",arg2,countvar2-1);
                        else
                        printf(" / %s;\n",arg2);
                        countvar2++;
			break;
                case '5':
                        printf("var%d_0;\nvar%d_0 = %s",countvar2,countvar2,arg1);
                        if(strcmp(arg1,"var")==0)
                            if(strcmp(arg2,"var")==0)
                                printf("%d_0 || %s%d_0;\n",countvar2-1,arg2,countvar2-2);
                            else
                                printf("%d_0 || %s;\n",countvar2-1,arg2);
			else if(strcmp(arg2,"var")==0)
                        printf(" || %s%d_0;\n",arg2,countvar2-1);
                        else
                        printf(" || %s;\n",arg2);
                        countvar2++;
			break;
                case '6':
                        printf("var%d_0;\nvar%d_0 = %s",countvar2,countvar2,arg1);
                        if(strcmp(arg1,"var")==0)
                            if(strcmp(arg2,"var")==0)
                                printf("%d_0 && %s%d_0;\n",countvar2-1,arg2,countvar2-2);
                            else
                                printf("%d_0 && %s;\n",countvar2-1,arg2);
			else if(strcmp(arg2,"var")==0)
                        printf(" && %s%d_0;\n",arg2,countvar2-1);
                        else
                        printf(" && %s;\n",arg2);
                        countvar2++;
			break;
		case '7':
			printf("var%d_0;\nvar%d_0 = %s",countvar2,countvar2,arg1);
                        if(strcmp(arg1,"var")==0)
                            if(strcmp(arg2,"var")==0)
                                printf("%d_0 == %s%d_0;\n",countvar2-1,arg2,countvar2-2);
                            else
                                printf("%d_0 == %s;\n",countvar2-1,arg2);
			else if(strcmp(arg2,"var")==0)
                        printf(" == %s%d_0;\n",arg2,countvar2-1);
                        else
                        printf(" == %s;\n",arg2);
                        countvar2++;
			break;
		case '8':
			printf("var%d_0;\nvar%d_0 = %s",countvar2,countvar2,arg1);
                        if(strcmp(arg1,"var")==0)
                            if(strcmp(arg2,"var")==0)
                                printf("%d_0 > %s%d_0;\n",countvar2-1,arg2,countvar2-2);
                            else
                                printf("%d_0 > %s;\n",countvar2-1,arg2);
			else if(strcmp(arg2,"var")==0)
                        printf(" > %s%d_0;\n",arg2,countvar2-1);
                        else
                        printf(" > %s;\n",arg2);
                        countvar2++;
			break;
                case '9':
			printf("var%d_0;\nvar%d_0 = %s",countvar2,countvar2,arg1);
                        if(strcmp(arg1,"var")==0)
                            if(strcmp(arg2,"var")==0)
                                printf("%d_0 < %s%d_0;\n",countvar2-1,arg2,countvar2-2);
                            else
                                printf("%d_0 < %s;\n",countvar2-1,arg2);
			else if(strcmp(arg2,"var")==0)
                        printf(" < %s%d_0;\n",arg2,countvar2-1);
                        else
                        printf(" < %s;\n",arg2);
                        countvar2++;
			break;	
                case 'a':
			printf("var%d_0;\nvar%d_0 = %s",countvar2,countvar2,arg1);
                        if(strcmp(arg1,"var")==0)
                            if(strcmp(arg2,"var")==0)
                                printf("%d_0 ! %s%d_0;\n",countvar2-1,arg2,countvar2-2);
                            else
                                printf("%d_0 ! %s;\n",countvar2-1,arg2);
			else if(strcmp(arg2,"var")==0)
                        printf(" ! %s%d_0;\n",arg2,countvar2-1);
                        else
                        printf(" ! %s;\n",arg2);
                        countvar2++;
			break;
 }
}
 yyerror(char *s)
{
         printf("%s\n",s); 
	ecount++;
}
 
int main(int argc,char *argv[]){
 
return yyparse();}
 