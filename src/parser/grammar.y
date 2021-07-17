/*
BYACC/J = YACC for Java
http://byaccj.sourceforge.net/
==File structure==
DECLARATIONS
%%
ACTIONS
%%
CODE
==Running==
yacc -J -v src/parser/grammar.y
*/

%{
package src.parser;

import java.lang.Math;
import java.io.*;
import src.lexer.Lexer;
import src.token.*;
%}

/* YACC Declarations */

/* Keywords */
%token <Token> CLASS_KW DOUBLE_KW ELSE_KW FLOAT_KW FOR_KW IF_KW IMPORT_KW INT_KW
%token <Token> LONG_KW NEW_KW PUBLIC_KW RETURN_KW STATIC_KW THROW_KW VOID_KW

/* Symbols */
%token <Token> COLON COMMA DOT LBRACE LBRACKET LPARENTH QUEST RBRACE RBRACKET RPARENTH SEMICOLON

/* Operators */
%token <Token> ASTERISK DIV EQ EQEQ GE GT LE LT MINUS MINUSEQ MINUSMINUS NE PLUS PLUSEQ PLUSPLUS

/* Identifiers */
%token <Identifier> RT_EXCEPTION
%token <Identifier> STRING_KW

/* Types */
%type <DoubleLiteral> DOUBLE_LITERAL
%type <IntegerLiteral> INTEGER_LITERAL
%type <LongLiteral> LONG_LITERAL
%type <StringLiteral> STRING_LITERAL
%type <LogicalOperator> LOGICAL_OPERATOR
%type <Operator> OPERATOR
%type <Keyword> KEYWORD
%type <Identifier> IDENTIFIER

%left '-' '+'
%left '*' '/'
%left NEG /* negation--unary minus */
%right '^' /* exponentiation */

/* Gramática */
%%

Program:
    CLASS_KW IDENTIFIER LBRACE ClassBody RBRACE
;
ClassBody:
    /* empty string */
    | OptScopeModifier ClassMember ClassBody
;
ClassMember:
    VariableDeclaration SEMICOLON
    | MethodDeclaration
;

MethodDeclaration:
    TypedIdentifier LPARENTH OptTypedParamList RPARENTH Block
;

/* Modifiers */
OptScopeModifier:
    /* empty string */
    | PUBLIC_KW OptStaticModifier
;
OptStaticModifier: 
    /* empty string */
    | STATIC_KW
;
/* Modifiers */

/* Params and args */
OptTypedParamList:
    /* empty string */
    | TypedIdentifier TypedParamList
;
TypedParamList:
    /* empty string */
    | COMMA TypedIdentifier TypedParamList
;
OptArgList:
    /* empty string */
    | ExprStmt ArgList
;
ArgList:
    /* empty string */
    | COMMA ExprStmt ArgList
;
/* Params and args */

Block:
    LBRACE StmtList RBRACE
;

/* Statements */
StmtList:
    /* empty string */
    | Stmt StmtList
;
Stmt:
    VariableDeclaration SEMICOLON
    | IfStmt
    | ForStmt
    | AssignmentStmt SEMICOLON
    | ExprStmt SEMICOLON
    | ThrowStmt
    | ReturnStmt
;
/* Statements */

VariableDeclaration:
    TypedIdentifier OptVariableInitialization
;
OptVariableInitialization:
    /* empty string */
    | EQ ExprStmt
;

/* If statement */
IfStmt:
    IF_KW LPARENTH LogicalExpr RPARENTH Block OptElse
;
OptElse:
    /* empty string */
    | ELSE_KW Block
;
/* If statement */

/* For statement */
ForStmt:
    FOR_KW LPARENTH ForAssignment SEMICOLON LogicalExpr SEMICOLON ForAfterStmt RPARENTH Block
;
ForAssignment:
    /* empty string */
    | VariableDeclaration
    | AssignmentStmt
;
ForAfterStmt:
    /* empty string */
    | ExprStmt
    | AssignmentStmt
;
/* For statement */

AssignmentStmt:
    IDENTIFIER AssignmentOperator ExprStmt
;
AssignmentOperator:
    EQ
    | PLUSEQ
    | MINUSEQ
;
ThrowStmt: 
    THROW_KW NEW_KW RT_EXCEPTION
;
ReturnStmt:
    RETURN_KW ExprStmt
;
Instantiation: 
    NEW_KW IDENTIFIER LPARENTH ArgList RPARENTH
;
MethodInvocation: 
    IDENTIFIER LPARENTH ArgList RPARENTH
;

/* Expressions */
ExprStmt: 
    LPARENTH ExprStmt RPARENTH Expr
    // instanciação aqui pode ser problematico
    | Instantiation Expr
    | MethodInvocation Expr
    | Number Expr
    | IDENTIFIER Expr
;
Expr: 
    | OPERATOR ExprStmt
;
Number: 
    LONG_LITERAL
    | INTEGER_LITERAL
;
LogicalExpr:
    ExprStmt LogicalOperator ExprStmt
;
LogicalOperator:
    NE
    | EQEQ
    | LT
    | LE
    | GT
    | GE
;
/* Expressions */

TypedIdentifier:
    DataType IDENTIFIER
;
DataType:
    DOUBLE_KW OptBrackets
    | FLOAT_KW OptBrackets
    | INT_KW OptBrackets
    | LONG_KW OptBrackets
    | STRING_KW OptBrackets
    | VOID_KW
;
OptBrackets:
    /* empty string */
    | LBRACKET RBRACKET
    | LBRACKET RBRACKET LBRACKET RBRACKET
;

%%

public static void main(String[] args) {
    Lexer scanner = null;
    String file = args[0];
    try {
        FileInputStream stream = new java.io.FileInputStream(file);
        Reader reader = new java.io.InputStreamReader(stream);
        scanner = new Lexer(reader);
        do {
            System.out.println(scanner.yylex());
        } while (!scanner.isEndOfFile());

    }
    catch (java.io.FileNotFoundException e) {
        System.out.println("File not found : \""+file+"\"");
    }
    catch (java.io.IOException e) {
        System.out.println("IO error scanning file \""+file+"\"");
        System.out.println(e);
    }
    catch (Exception e) {
        System.out.println("Unexpected exception:");
        e.printStackTrace();
    }
}