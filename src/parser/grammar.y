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
%token ASTERISK DIV EQ MINUS MINUSEQ MINUSMINUS PLUS PLUSEQ PLUSPLUS

/* Logical Operators */
%token EQEQ GE GT LE LT NE

/* Java Identifiers */
%token RT_EXCEPTION STRING_KW

/* Types */
%token <obj> DOUBLE_LITERAL
%token <obj> INTEGER_LITERAL
%token <obj> LONG_LITERAL
%token <obj> STRING_LITERAL
%token <obj> IDENTIFIER

// %type <dval> Expr
// %type <dval> Number

/* Precedencia cresce de cima pra baixo */
%left EQEQ EQ GE GT LE LT NE
%left MINUS PLUS
%left ASTERISK DIV
%left NEGATIVE

/* Precedencias não associativas */
%nonassoc LOWER
%nonassoc GREATER

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
    TypedIdentifier LPARENTH TypedParamList RPARENTH Block
;
OptScopeModifier:
    /* empty string */
    | PUBLIC_KW OptStaticModifier
;
OptStaticModifier: 
    /* empty string */
    | STATIC_KW
;
TypedParamList:
    TypedIdentifier
    | TypedIdentifier COMMA TypedParamList
;
OptArgList:
    /* empty string */
    | ArgList
;
ArgList:
    ExprStmt
    | ExprStmt COMMA ArgList
;
Block:
    LBRACE StmtList RBRACE
;
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
VariableDeclaration:
    TypedIdentifier OptVariableInitialization
;
OptVariableInitialization:
    /* empty string */
    | AssignmentOperator ExprStmt
;
IfStmt:
    IF_KW LPARENTH LogicalExpr RPARENTH Block OptElse
;
OptElse:
    /* empty string */
    | ELSE_KW Block
;
ForStmt:
    FOR_KW LPARENTH ForAssignment SEMICOLON LogicalExpr SEMICOLON IncrementStmt RPARENTH Block
;
ForAssignment:
    VariableDeclaration
    | AssignmentStmt
;
AssignmentStmt:
    IDENTIFIER AssignmentOperator ExprStmt
;
IncrementStmt:
    IDENTIFIER UnaryOperator
    | UnaryOperator IDENTIFIER
;
ThrowStmt: 
    THROW_KW NEW_KW RT_EXCEPTION
;
ReturnStmt:
    RETURN_KW ExprStmt
;
ExprStmt: 
    Expr
    | Instantiation
;
Expr: 
    Expr PLUS Expr
    | Expr MINUS Expr
    | Expr ASTERISK Expr
    | Expr DIV Expr
    /* Define que a precedência é a mesma definida para NEGATIVE */
    | MINUS Expr %prec NEGATIVE
    | LPARENTH Expr RPARENTH
    | MethodInvocation
    | Number
    | IDENTIFIER %prec LOWER
 ;
Instantiation: 
    NEW_KW IDENTIFIER LPARENTH OptArgList RPARENTH
;
MethodInvocation: 
    IDENTIFIER LPARENTH OptArgList RPARENTH %prec GREATER
;
Number: 
    LONG_LITERAL
    | INTEGER_LITERAL
    | DOUBLE_LITERAL
;
LogicalExpr:
    Expr LogicalOperator Expr
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