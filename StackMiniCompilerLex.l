%{
#include<stdlib.h>
#include<string.h>
#include<stdio.h>
#include"y.tab.h"

void pushtype(char *s);
void pushbrc(char *s);
void waitelse();
char itoa1(int x);
void toch(int x);

char stackt[50][10];
char stacktype[50][10];
char stackbrc[50][10];
char stacktype2[50][10];
int con=0,con2=0;int l=0;
int elseexist=0,gg,xx,tt=0;
int use=0,we=0,brc=0,scountbrca=0;
char buf[20],stackbr[10];
char varinitial[20],xto[10],ss[10];
int countvar=0;
char valvar[50][10];
int flagdec=0,bracket=0;
int doopen=0,count=0,di,brccount=0;
%}
%option noyywrap

semi [;]
cama [,]
eq [=]
plus [+]
minus [-] 
star [*]
div [/]
eql [==]
grt [>]
low [<]
not [!]
 
%%
"int" {pushtype2("int");flagdec=1; yylval.s=yytext;return INT;}

"float" {pushtype2("float");flagdec=1;yylval.s=yytext;return FLOAT;}

"bool" {pushtype2("bool");flagdec=1;yylval.s=yytext;return BOOL;}

"do" {labelfn(l);l++;doopen=1;pushtype2(yytext);pushtype(yytext);push3(yytext);yylval.s=yytext;return DO;}

"if" {labelfn(l);l++;pushtype(yytext);pushifelse(yytext);push3(yytext);yylval.s=yytext;return IF;}

"while" { labelfn(l);l++;pushtype2(yytext);pushtype(yytext);push3(yytext);yylval.s=yytext;return WHILE;}

"||" {if(bracket==1){brccount++;pushbrc(yytext);push2(yytext);push2("op");} return OR;}

"&&" {if(bracket==1){brccount++;pushbrc(yytext);push2(yytext);push2("op");} return AND;}

"else" {pushtype2(yytext);waitelse();elseexist=1;pushifelse(yytext);pushtype(yytext);yylval.s=yytext;return ELSE;}

[0-9]+ {toch(atoi(yytext));push(xto);yylval.i=atoi(yytext);return NUM;}

{semi} {if(doopen==1)if(bracket==1){pushsemi(yytext);};flagdec=0;strcpy(buf,"");return SEMICOL;}

{cama} { return COMMA;}

"true" {if(bracket==1){push2(yytext);push2("op");}push(yytext);return TRUE;}

"false" {if(bracket==1){push2(yytext);push2("op");}push(yytext);return FALSE;}

[_a-zA-Z][_a-zA-Z0-9]*  {
{
if(bracket==0){
if(flagdec==1){push(yytext);strcpy(varinitial,yytext);return ID;}
 else {push(yytext);yylval.s=yytext;return ID;} 
}
else{push2(yytext);pushbrc(yytext);brccount++;yylval.s=yytext;return ID;}
}
}

{eq} {
if(bracket==1){push2("=");push2("op");}
      return EQ;}

{plus} {count++;countfn(count);if(bracket==1){push2(yytext);brccount++;push2("op");pushbrc(yytext);}return PLUS;}

{minus} {if(bracket==1){count++;countfn(count);push2(yytext);push2("op");pushbrc(yytext);brccount++;}return MINUS;}

{star} {if(bracket==1){count++;countfn(count);push2(yytext);push2("op");pushbrc(yytext);brccount++;}return STAR;}

{div} {if(bracket==1){count++;countfn(count);push2(yytext);push2("op");pushbrc(yytext);brccount++;}return DIV;}

{grt} {if(bracket==1){count++;countfn(count);push2(yytext);push2("op");pushbrc(yytext);brccount++;}return GRT;}

{low} {if(bracket==1){count++;countfn(count);push2(yytext);push2("op");pushbrc(yytext);brccount++;}return LOW;}

{not} {if(bracket==1){count++;countfn(count);push2(yytext);push2("op");pushbrc(yytext);brccount++;}
return NOT;}

"!=" {if(bracket==1){count++;countfn(count);push2(yytext);push2("op");pushbrc(yytext);brccount++;}return NEQ;}

"==" {if(bracket==1){count++;countfn(count);push2(yytext);push2("op");pushbrc(yytext);brccount++;}return EQL;}

"("  {bracket=1;return *yytext;}

")" {bracket=0;return *yytext;}

"{" //{brace(yytext);return *yytext;   }

"}" //{return *yytext;}
%%
 void pushtype(char *s)
{ 
	strcpy(stacktype[con++],s);
}
 
void pushbrc(char *s)
{ 
	strcpy(stackbrc[brc++],s);
}

void waitelse(){ }
 char itoa1(int x){
if(x==0)return '0';
if(x==1)return '1';
if(x==2)return '2';
if(x==3)return '3';
if(x==4)return '4';
if(x==5)return '5';
if(x==6)return '6';
if(x==7)return '7';
if(x==8)return '8';
if(x==9)return '9';
}
void toch(int x){strcpy(xto,"");
if(x==0)strcpy(xto,"0");
if(x==1)strcpy(xto,"1");
if(x==2)strcpy(xto,"2"); 
if(x==3)strcpy(xto,"3"); 
if(x==4)strcpy(xto,"4"); 
if(x==5)strcpy(xto,"5"); 
if(x==6)strcpy(xto,"6"); 
if(x==7)strcpy(xto,"7"); 
if(x==8)strcpy(xto,"8");
if(x==9)strcpy(xto,"9");
if(x>9){
for(gg=0;gg<10;gg++){
if(x!=0){ss[gg]=x%10;x=x/10;tt++; }

}
tt--;
for(xx=0;xx<=tt;xx++){
xto[xx]=itoa1(ss[tt-xx]);  }
 }tt=0;
}