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

import java.lang.Math;
import java.io.*;
import src.lexer.Lexer;
import src.token.*;
%}

/* YACC Declarations */

/* Keywords */
%token CLASS_KW DOUBLE_KW ELSE_KW FLOAT_KW FOR_KW IF_KW IMPORT_KW INT_KW
%token LONG_KW NEW_KW PUBLIC_KW RETURN_KW STATIC_KW THROW_KW VOID_KW

/* Symbols */
%token COLON COMMA DOT LBRACE LBRACKET LPARENTH QUEST RBRACE RBRACKET RPARENTH SEMICOLON

/* Operators */
%token ASTERISK DIV EQ EQEQ GE GT LE LT MINUS MINUSEQ MINUSMINUS NE PLUS PLUSEQ PLUSPLUS

/* Identifiers */
%token RT_EXCEPTION STRING_KW

/* Types */
%token <obj> DOUBLE_LITERAL
%token <obj> INTEGER_LITERAL
%token <obj> LONG_LITERAL
%token <obj> STRING_LITERAL
%token <obj> IDENTIFIER

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
    | Operator ExprStmt
;
Number: 
    LONG_LITERAL
    | INTEGER_LITERAL
;
LogicalExpr:
    ExprStmt LogicalOperator ExprStmt
;
Operator:
    PLUS
    | MINUS
    | ASTERISK
    | DIV
;
LogicalOperator:
    NE
    | EQEQ
    | LT
    | LE
    | GT
    | GE
;
AssignmentOperator:
    EQ
    | PLUSEQ
    | MINUSEQ
;
UnaryOperator:
    PLUSPLUS
    | MINUSMINUS
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
/* a reference to the lexer object */
private Lexer lexer;

/* setter for token's semantic value */
public void setYylval(ParserVal yylval) {
    this.yylval = yylval;
}

/* interface to the lexer */
private int yylex () {
    int yyl_return = -1;
    try {
        yyl_return = lexer.yylex();
    }
    catch (IOException e) {
        System.err.println("IO error :"+e);
    }
    return yyl_return;
}

/* error reporting */
public void yyerror (String error) {
    System.err.println ("Error: " + error);
}

/* lexer is created in the constructor */
public Parser(Reader r) {
    lexer = new Lexer(r, this);
}

  /* main function to start the parser */
public static void main(String args[]) throws IOException {
    if (args == null || args.length == 0) {
        System.out.println("Please specify a file");
        System.exit(1);
    }
    String file = args[0];
    try {
        // FileInputStream stream = new java.io.FileInputStream(file);
        // Reader reader = new java.io.InputStreamReader(stream);
        // scanner = new Lexer(reader);
        // do {
        //     System.out.println(scanner.yylex());
        // } while (!scanner.isEndOfFile());
        Parser yyparser = new Parser(new FileReader(file));
        yyparser.yyparse();
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