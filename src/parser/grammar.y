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

/* Operators */
%token MINUSEQ MINUSMINUS PLUSEQ PLUSPLUS

/* Logical Operators */
%token EQEQ GE LE NE

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
%left EQEQ '=' GE '>' LE '<' NE
%left '-' '+'
%left '*' '/'
%left NEGATIVE

/* Gramática */
%%

Program:
    CLASS_KW IDENTIFIER '{' ClassBody '}'
;
ClassBody:
    /* empty string */
    | OptScopeModifier ClassMember ClassBody
;
ClassMember:
    VariableDeclaration ';'
    | MethodDeclaration
;
MethodDeclaration:
    TypedIdentifier '(' TypedParamList ')' Block
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
    | TypedIdentifier ',' TypedParamList
;
OptArgList:
    /* empty string */
    | ArgList
;
ArgList:
    ExprStmt
    | ExprStmt ',' ArgList
;
Block:
    '{' StmtList '}'
;
StmtList:
    /* empty string */
    | Stmt StmtList
;
Stmt:
    VariableDeclaration ';'
    | IfStmt
    | ForStmt
    | AssignmentStmt ';'
    | ExprStmt ';'
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
    IF_KW '(' LogicalExpr ')' Block OptElse
;
OptElse:
    /* empty string */
    | ELSE_KW Block
;
ForStmt:
    FOR_KW '(' ForAssignment ';' LogicalExpr ';' IncrementStmt ')' Block
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
    Expr '+' Expr
    | Expr '-' Expr
    | Expr '*' Expr
    | Expr '/' Expr
    /* Define que a precedência é a mesma definida para NEGATIVE */
    | '-' Expr %prec NEGATIVE
    | '(' Expr ')'
    | MethodInvocation
    | Number
    | IDENTIFIER
 ;
Instantiation: 
    NEW_KW IDENTIFIER '(' OptArgList ')'
;
MethodInvocation: 
    IDENTIFIER '(' OptArgList ')'
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
    | '<'
    | LE
    | '>'
    | GE
;
AssignmentOperator:
    '='
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
    | '[' ']'
    | '[' ']' '[' ']'
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