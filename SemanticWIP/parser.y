%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "symbolTable.h"
#include "AST.h"
#include "IRcode.h"

extern int yylex();
extern int yyparse();
extern FILE* yyin;
FILE * IRcode;

void yyerror(const char* s);
char currentScope[50]; // "global" or the name of the function
int semanticCheckPassed = 1; // flags to record correctness of semantic checks
%}

%union {
	int number;
	char character;
	char* string;
	struct AST* ast;
}

%token <string> TYPE
%token <string> IDENTIFIER
%token <string> IF
%token <string> WHILE
%token <string> ELSE
%token <string> VOID
%token <char> SEMICOLON
%token <char> EQ
%token <char> EXCLAM
%token <char> CURLYLEFT
%token <char> CURLYRIGHT
%token <char> BRACKETLEFT
%token <char> BRACKETRIGHT
%token <char> ROUNDLEFT
%token <char> ROUNDRIGHT
%token <char> COMMA
%token <char> PLUS
%token <char> MINUS
%token <char> MULTIPLY
%token <char> DIVIDE
%token <char> LESSTHAN
%token <char> GREATERTHAN
%token <number> NUMBER
%token WRITE
%token RETURN


%printer { fprintf(yyoutput, "%s", $$); } IDENTIFIER;
%printer { fprintf(yyoutput, "%d", $$); } NUMBER;

%type <ast> Program DeclList Decl VarDecl AltVarDecl FunctCont FunctDecl Braced Conditional RemainderList Remainder Stmt StmtList Variable CallCont FunctCall Operation Con Expr

%start Program

%%

Program: DeclList  { $$ = $1;
					 printf("\n--- Abstract Syntax Tree ---\n\n");
					 printAST($$,0);
					}
;

DeclList:	Decl DeclList	{ $1->left = $2;
							  $$ = $1;
							  // currentScope = "global";
							}
	| Decl	{ $$ = $1; }
;

Decl:	VarDecl
	| FunctDecl
	| StmtList
;

VarDecl:	TYPE IDENTIFIER SEMICOLON	{ printf("\n RECOGNIZED RULE: Variable declaration %s\n", $2);
									// Symbol Table
									symTabAccess();
									int inSymTab = found($2, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $2, inSymTab);
									
									if (inSymTab == 0) 
										addItem($2, "Var", $1,0, currentScope);
									else
										printf("SEMANTIC ERROR: Var %s is already in the symbol table", $2);
									showSymTable();
									
								  // ---- SEMANTIC ACTIONS by PARSER ----
								    $$ = AST_Type("Type",$1,$2);
									printf("-----------> %s", $$->LHS);
								}
	| TYPE IDENTIFIER BRACKETLEFT NUMBER BRACKETRIGHT SEMICOLON	{ printf("\n RECOGNIZED RULE: Variable declaration %s\n", $2);
									// Symbol Table
									symTabAccess();
									int inSymTab = found($2, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $2, inSymTab);
									
									if (inSymTab == 0) 
										addItem($2, "Var", $1,0, currentScope);
									else
										printf("SEMANTIC ERROR: Var %s is already in the symbol table", $2);
									showSymTable();
									
								  // ---- SEMANTIC ACTIONS by PARSER ----
								    $$ = AST_Type("Type",$1,$2);
									printf("-----------> %s", $$->LHS);
								}
	| TYPE IDENTIFIER BRACKETLEFT IDENTIFIER BRACKETRIGHT SEMICOLON	{ printf("\n RECOGNIZED RULE: Variable declaration %s\n", $2);
									// Symbol Table
									symTabAccess();
									int inSymTab = found($2, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $2, inSymTab);
									
									if (inSymTab == 0) 
										addItem($2, "Var", $1,0, currentScope);
									else
										printf("SEMANTIC ERROR: Var %s is already in the symbol table", $2);
									showSymTable();
									
								  // ---- SEMANTIC ACTIONS by PARSER ----
								    $$ = AST_Type("Type",$1,$2);
									printf("-----------> %s", $$->LHS);
								}
	| TYPE IDENTIFIER BRACKETLEFT BRACKETRIGHT SEMICOLON { printf("\n RECOGNIZED RULE: Variable declaration %s\n", $2);
									// Symbol Table
									symTabAccess();
									int inSymTab = found($2, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $2, inSymTab);
									
									if (inSymTab == 0) 
										addItem($2, "Var", $1,0, currentScope);
									else
										printf("SEMANTIC ERROR: Var %s is already in the symbol table", $2);
									showSymTable();
									
								  // ---- SEMANTIC ACTIONS by PARSER ----
								    $$ = AST_Type("Type",$1,$2);
									printf("-----------> %s", $$->LHS);
								}
;

AltVarDecl:	TYPE IDENTIFIER	{ printf("\n RECOGNIZED RULE: Variable declaration %s\n", $2);
									// Symbol Table
									symTabAccess();
									int inSymTab = found($2, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $2, inSymTab);
									
									if (inSymTab == 0) 
										addItem($2, "Var", $1,0, currentScope);
									
								  // ---- SEMANTIC ACTIONS by PARSER ----
								    $$ = AST_Type("Type",$1,$2);
									printf("-----------> %s", $$->LHS);
								}
	| TYPE IDENTIFIER BRACKETLEFT NUMBER BRACKETRIGHT	{ printf("\n RECOGNIZED RULE: Variable declaration %s\n", $2);
									// Symbol Table
									symTabAccess();
									int inSymTab = found($2, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $2, inSymTab);
									
									if (inSymTab == 0)
										addItem($2, "Var", $1,0, currentScope);
									
								  // ---- SEMANTIC ACTIONS by PARSER ----
								    $$ = AST_Type("Type",$1,$2);
									printf("-----------> %s", $$->LHS);
								}
	| TYPE IDENTIFIER BRACKETLEFT BRACKETRIGHT	{ printf("\n RECOGNIZED RULE: Variable declaration %s\n", $2);
									// Symbol Table
									symTabAccess();
									int inSymTab = found($2, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $2, inSymTab);
									
									if (inSymTab == 0) 
										addItem($2, "Var", $1,0, currentScope);
									
								  // ---- SEMANTIC ACTIONS by PARSER ----
								    $$ = AST_Type("Type",$1,$2);
									printf("-----------> %s", $$->LHS);
								}
;

FunctCont:	AltVarDecl COMMA FunctCont
	| AltVarDecl
;

FunctDecl:	TYPE IDENTIFIER ROUNDLEFT FunctCont ROUNDRIGHT Braced	{ printf("\n RECOGNIZED RULE: Function declaration %s\n", $2);
									// currentScope = $2;
									// Symbol Table
									symTabAccess();
									int inSymTab = found($2, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $2, inSymTab);
									
									if (inSymTab == 0) 
										addItem($2, "Funct", $1,0, currentScope);
									else
										printf("SEMANTIC ERROR: Funct %s is already in the symbol table", $2);
									showSymTable();
									
								  // ---- SEMANTIC ACTIONS by PARSER ----
								    $$ = AST_Type("Type",$1,$2);
									printf("-----------> %s", $$->LHS);
								}
	|TYPE IDENTIFIER ROUNDLEFT VOID ROUNDRIGHT Braced	{ printf("\n RECOGNIZED RULE: Function declaration %s\n", $2);
									// currentScope = $2;
									// Symbol Table
									symTabAccess();
									int inSymTab = found($2, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $2, inSymTab);
									
									if (inSymTab == 0) 
										addItem($2, "Funct", $1,0, currentScope);
									else
										printf("SEMANTIC ERROR: Funct %s is already in the symbol table", $2);
									showSymTable();
									
								  // ---- SEMANTIC ACTIONS by PARSER ----
								    $$ = AST_Type("Type",$1,$2);
									printf("-----------> %s", $$->LHS);
								}
	|TYPE IDENTIFIER ROUNDLEFT ROUNDRIGHT Braced	{ printf("\n RECOGNIZED RULE: Function declaration %s\n", $2);
									// currentScope = $2;
									// Symbol Table
									symTabAccess();
									int inSymTab = found($2, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $2, inSymTab);
									
									if (inSymTab == 0) 
										addItem($2, "Funct", $1,0, currentScope);
									else
										printf("SEMANTIC ERROR: Funct %s is already in the symbol table", $2);
									showSymTable();
									
								  // ---- SEMANTIC ACTIONS by PARSER ----
								    $$ = AST_Type("Type",$1,$2);
									printf("-----------> %s", $$->LHS);
								}
	| VOID IDENTIFIER ROUNDLEFT FunctCont ROUNDRIGHT Braced	{ printf("\n RECOGNIZED RULE: Function declaration %s\n", $2);
									// currentScope = $2;
									// Symbol Table
									symTabAccess();
									int inSymTab = found($2, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $2, inSymTab);
									
									if (inSymTab == 0) 
										addItem($2, "Funct", $1,0, currentScope);
									else
										printf("SEMANTIC ERROR: Funct %s is already in the symbol table", $2);
									showSymTable();
									
								  // ---- SEMANTIC ACTIONS by PARSER ----
								    $$ = AST_Type("Type",$1,$2);
									printf("-----------> %s", $$->LHS);
								}
	| VOID IDENTIFIER ROUNDLEFT VOID ROUNDRIGHT Braced	{ printf("\n RECOGNIZED RULE: Function declaration %s\n", $2);
									// currentScope = $2;
									// Symbol Table
									symTabAccess();
									int inSymTab = found($2, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $2, inSymTab);
									
									if (inSymTab == 0) 
										addItem($2, "Funct", $1,0, currentScope);
									else
										printf("SEMANTIC ERROR: Funct %s is already in the symbol table", $2);
									showSymTable();
									
								  // ---- SEMANTIC ACTIONS by PARSER ----
								    $$ = AST_Type("Type",$1,$2);
									printf("-----------> %s", $$->LHS);
								}
	| VOID IDENTIFIER ROUNDLEFT ROUNDRIGHT Braced	{ printf("\n RECOGNIZED RULE: Function declaration %s\n", $2);
									// currentScope = $2;
									// Symbol Table
									symTabAccess();
									int inSymTab = found($2, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $2, inSymTab);
									
									if (inSymTab == 0) 
										addItem($2, "Funct", $1,0, currentScope);
									else
										printf("SEMANTIC ERROR: Funct %s is already in the symbol table", $2);
									showSymTable();
									
								  // ---- SEMANTIC ACTIONS by PARSER ----
								    $$ = AST_Type("Type",$1,$2);
									printf("-----------> %s", $$->LHS);
								}
;

Braced:	CURLYLEFT RemainderList CURLYRIGHT
;

Conditional:	WHILE ROUNDLEFT Con ROUNDRIGHT Braced { printf("\n RECOGNIZED RULE: Conditional statement\n"); }
	| IF ROUNDLEFT Con ROUNDRIGHT Braced { printf("\n RECOGNIZED RULE: Conditional statement\n"); }
	| IF ROUNDLEFT Con ROUNDRIGHT Braced ELSE Conditional { printf("\n RECOGNIZED RULE: Conditional statement\n"); }
	| IF ROUNDLEFT Con ROUNDRIGHT Braced ELSE Braced { printf("\n RECOGNIZED RULE: Conditional statement\n"); }
;

RemainderList:	Remainder RemainderList
	| Remainder

Remainder:	Expr SEMICOLON
	| VarDecl
	| Conditional
	| RETURN Variable SEMICOLON
;

StmtList:	
	| Stmt StmtList
;

Stmt:	SEMICOLON
	| Expr SEMICOLON	{$$ = $1;}
	| VarDecl
;

Variable: IDENTIFIER	{ printf("\n VARIABLE REFERENCE: %s referenced\n", $1);
									// Symbol Table
									symTabAccess();
									int inSymTab = found($1, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $1, inSymTab);
									
									if (inSymTab == 0) 
										printf("SEMANTIC ERROR: Var %s is not declared", $1);
									showSymTable();
								}
	| IDENTIFIER BRACKETLEFT BRACKETRIGHT	{ printf("\n VARIABLE REFERENCE: %s referenced\n", $1);
									// Symbol Table
									symTabAccess();
									int inSymTab = found($1, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $1, inSymTab);
									
									if (inSymTab == 0) 
										printf("SEMANTIC ERROR: Var %s is not declared", $1);
									showSymTable();
								}
	| IDENTIFIER BRACKETLEFT NUMBER BRACKETRIGHT	{ printf("\n VARIABLE REFERENCE: %s referenced\n", $1);
									// Symbol Table
									symTabAccess();
									int inSymTab = found($1, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $1, inSymTab);
									
									if (inSymTab == 0) 
										printf("SEMANTIC ERROR: Var %s is not declared", $1);
									showSymTable();
								}
	| IDENTIFIER BRACKETLEFT Variable BRACKETRIGHT	{ printf("\n VARIABLE REFERENCE: %s referenced\n", $1);
									// Symbol Table
									symTabAccess();
									int inSymTab = found($1, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $1, inSymTab);
									
									if (inSymTab == 0) 
										printf("SEMANTIC ERROR: Var %s is not declared", $1);
									showSymTable();
								}
;

CallCont:	Variable COMMA CallCont
	| Variable
	| NUMBER
	| NUMBER COMMA CallCont
;

FunctCall: IDENTIFIER ROUNDLEFT CallCont ROUNDRIGHT	{ printf("\n RECOGNIZED RULE: Function call %s\n", $1);
									// Symbol Table
									symTabAccess();
									int inSymTab = found($1, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $1, inSymTab);
									
									if (inSymTab == 0) 
										printf("SEMANTIC ERROR: Funct %s is not declared", $1);
									showSymTable();
								}
	| IDENTIFIER ROUNDLEFT ROUNDRIGHT	{ printf("\n RECOGNIZED RULE: Function call %s\n", $1);
									// Symbol Table
									symTabAccess();
									int inSymTab = found($1, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $1, inSymTab);
									
									if (inSymTab == 0) 
										printf("SEMANTIC ERROR: Funct %s is not declared", $1);
									showSymTable();
								}
;

Operation:	Variable	{ printf("\n RECOGNIZED RULE: Operation statement\n"); }
	| NUMBER	{ printf("\n RECOGNIZED RULE: Operation statement\n"); }
	| FunctCall	{ printf("\n RECOGNIZED RULE: Operation statement\n"); }
	| Variable PLUS Operation
	| NUMBER PLUS Operation
	| FunctCall PLUS Operation
	| Variable MINUS Operation
	| NUMBER MINUS Operation
	| FunctCall MINUS Operation
	| Variable MULTIPLY Operation
	| NUMBER MULTIPLY Operation
	| FunctCall MULTIPLY Operation
	| Variable DIVIDE Operation
	| NUMBER DIVIDE Operation
	| FunctCall DIVIDE Operation
;

Con:	Operation LESSTHAN Operation
	| Operation GREATERTHAN Operation
	| Operation EQ Operation
	| Operation EXCLAM EQ Operation
	| Variable
;

Expr:	Variable { printf("\n RECOGNIZED RULE: Simplest expression\n"); }
	| Variable EQ Operation { printf("\n RECOGNIZED RULE: Assignment statement\n");}
	| Operation
	| WRITE IDENTIFIER 	{ printf("\n RECOGNIZED RULE: WRITE statement\n");
					$$ = AST_Write("write",$2,"");
					
					// ---- SEMANTIC ANALYSIS ACTIONS ---- //  

					// Check if identifiers have been declared
					    if(found($2, currentScope) != 1) {
							printf("SEMANTIC ERROR: Variable %s has NOT been declared in scope %s \n", $2, currentScope);
							semanticCheckPassed = 0;
						}

					if (semanticCheckPassed == 1) {
							printf("\n\nRule is semantically correct!\n\n");

							// ---- EMIT IR 3-ADDRESS CODE ---- //
							
							// The IR code is printed to a separate 
							
							emitWriteId($2);
						}
				}

%%

int main(int argc, char**argv)
{
/*
	#ifdef YYDEBUG
		yydebug = 1;
	#endif
*/
	printf("Compiler started. \n\n");
	
	if (argc > 1){
	  if(!(yyin = fopen(argv[1], "r")))
          {
		perror(argv[1]);
		return(1);
	  }
	}
	yyparse();
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
