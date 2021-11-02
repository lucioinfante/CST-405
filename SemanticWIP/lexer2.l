%option noyywrap

%{
#include <stdio.h>
#include <string.h>

#define YY_DECL int yylex()
#include "parser.tab.h"

int words = 0;
int chars = 0;
int lines = 0;

%}

letter      [a-zA-Z]
digit       [0-9]
ID          {letter}({letter}|{digit})*
delim       [ \t\n]
NUMBER      {digit}+(\.{digit}+)?(E[+\-]?(digit)+)?
ws          {delim}+

%%
"/*"    				{
							int c;
							while((c = input()) != 0) {
								if(c == '*') {
									if((c = input()) == '/')
										break;
									else
										unput(c);
								}
							}
						}
						
"int"	{words++; chars += strlen(yytext);
		 printf("%s : TYPE\n", yytext);
		 yylval.string = strdup(yytext); 
		return TYPE;
		}

"char"	{words++; chars += strlen(yytext);
		 printf("%s : TYPE\n", yytext);
		 yylval.string = strdup(yytext); 
		 return TYPE;
		}
		
"write"	{words++; 
		 chars += strlen(yytext);
		 printf("%s : KEYWORD\n", yytext);
		 yylval.string = strdup(yytext); 
		 return WRITE;
		}

"while"	{words++; 
		 chars += strlen(yytext);
		 printf("%s : KEYWORD\n", yytext);
		 yylval.string = strdup(yytext); 
		 return WHILE;
		}

"else"	{words++; 
		 chars += strlen(yytext);
		 printf("%s : KEYWORD\n", yytext);
		 yylval.string = strdup(yytext); 
		 return ELSE;
		}

"if"	{words++; 
		 chars += strlen(yytext);
		 printf("%s : KEYWORD\n", yytext);
		 yylval.string = strdup(yytext); 
		 return IF;
		}

"void"	{words++; chars += strlen(yytext);
		 printf("%s : TYPE\n", yytext);
		 yylval.string = strdup(yytext); 
		 return VOID;
		}

"return"	{words++; chars += strlen(yytext);
		 printf("%s : RETURN\n", yytext);
		 yylval.string = strdup(yytext); 
		 return RETURN;
		}
		
{ID}	{words++; chars += strlen(yytext);
		 printf("%s : IDENTIFIER\n",yytext);
		 yylval.string = strdup(yytext); 
		 return IDENTIFIER;
		}
			
{NUMBER}	{words++; chars += strlen(yytext);
			  printf("%s : NUMBER\n",yytext);
			  yylval.string = strdup(yytext); 
			  return NUMBER;
			}
			
";"		{chars++;
		 printf("%s : SEMICOLON\n", yytext);
		 yylval.string = strdup(yytext); 
		 return SEMICOLON;
		}
		
"="		{chars++;
		 printf("%s : EQ\n", yytext);
		 yylval.string = strdup(yytext); 
		 return EQ;
		}

"!"		{chars++;
		 printf("%s : EQ\n", yytext);
		 yylval.string = strdup(yytext); 
		 return EXCLAM;
		}

"{"		{chars++;
		 printf("%s : CURLYLEFT\n", yytext);
		 yylval.string = strdup(yytext); 
		 return CURLYLEFT;
		}

"}"		{chars++;
		 printf("%s : CURLYRIGHT\n", yytext);
		 yylval.string = strdup(yytext); 
		 return CURLYRIGHT;
		}

"["		{chars++;
		 printf("%s : BRACKETLEFT\n", yytext);
		 yylval.string = strdup(yytext); 
		 return BRACKETLEFT;
		}

"]"		{chars++;
		 printf("%s : BRACKETRIGHT\n", yytext);
		 yylval.string = strdup(yytext); 
		 return BRACKETRIGHT;
		}

"("		{chars++;
		 printf("%s : ROUNDLEFT\n", yytext);
		 yylval.string = strdup(yytext); 
		 return ROUNDLEFT;
		}

")"		{chars++;
		 printf("%s : ROUNDRIGHT\n", yytext);
		 yylval.string = strdup(yytext); 
		 return ROUNDRIGHT;
		}

","		{chars++;
		 printf("%s : COMMA\n", yytext);
		 yylval.string = strdup(yytext); 
		 return COMMA;
		}

"+"		{chars++;
		 printf("%s : PLUS\n", yytext);
		 yylval.string = strdup(yytext); 
		 return PLUS;
		}

"-"		{chars++;
		 printf("%s : MINUS\n", yytext);
		 yylval.string = strdup(yytext); 
		 return MINUS;
		}

"*"		{chars++;
		 printf("%s : MULTIPLY\n", yytext);
		 yylval.string = strdup(yytext); 
		 return MULTIPLY;
		}

"/"		{chars++;
		 printf("%s : DIVIDE\n", yytext);
		 yylval.string = strdup(yytext); 
		 return DIVIDE;
		}

"<"		{chars++;
		 printf("%s : LESSTHAN\n", yytext);
		 yylval.string = strdup(yytext); 
		 return LESSTHAN;
		}

">"		{chars++;
		 printf("%s : GREATERTHAN\n", yytext);
		 yylval.string = strdup(yytext); 
		 return GREATERTHAN;
		}
		
[\n]	{lines++; chars=0;}
[ \t]	{chars++;}
.		{chars++;
         printf("%s : Unrecognized symbol at line %d char %d\n", yytext,lines,chars);
		}
		

%%