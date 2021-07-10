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
yacc.linux -J grammar.y
*/

%{
import java.lang.Math;
import java.io.*;
import java.util.StringTokenizer;
%}

/* YACC Declarations */
%token <DoubleLiteral> DOUBLE_LITERAL
%token <Identifier> IDENTIFIER
%token <IntegerLiteral> INTEGER_LITERAL
%token <Keyword> KEYWORD
%token <LogicalOperator> LOGICAL_OPERATOR
%token <LongLiteral> LONG_LITERAL
%token <Operator> OPERATOR
%token <StringLiteral> STRING_LITERAL
%token <Token> TOKEN

%left '-' '+'
%left '*' '/'
%left NEG /* negation--unary minus */
%right '^' /* exponentiation */
/*
"!="
"=="
"<" 
"<="
">" 
">="
"+="
"-="
"++"
"--"
"+" 
"-" 
"*" 
"/" 
"=" 
"?"
":"
"("
")"
"{"
"}"
"["
"]"
";"
","
"."
*/

/* Gramática */
%%

Program:
    'class' IDENTIFIER '{' ClassBody '}'
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
    TypedIdentifier '(' OptTypedParamList ') {' StmtList '}'
;

/* Modifiers */
OptScopeModifier:
    /* empty string */
    | 'public' OptStaticModifier
    | 'protected' OptStaticModifier
    | 'private' OptStaticModifier
;
OptStaticModifier: 
    /* empty string */
    | 'static'
;
/* Modifiers */

/* Params and args */
OptTypedParamList:
    /* empty string */
    | TypedIdentifier TypedParamList
;
TypedParamList:
    /* empty string */
    | ',' TypedIdentifier TypedParamList
;
OptArgList:
    /* empty string */
    | ExprStmt ArgList
;
ArgList:
    /* empty string */
    | ',' ExprStmt ArgList
;
/* Params and args */

/* Statements */
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
/* Statements */

VariableDeclaration:
    TypedIdentifier OptVariableInitialization
;
OptVariableInitialization:
    /* empty string */
    | '=' ExprStmt
;

/* If statement */
IfStmt:
    'if' '(' LogicalExpr ')' '{' StmtList '}' OptElse
;
OptElse:
    /* empty string */
    | 'else' '{' StmtList '}'
;
/* If statement */

/* For statement */
ForStmt:
    'for' '(' ForAssignment ';' LogicalExpr ';' ForAfterStmt ') {' StmtList '}'
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
    '='
    | '+='
    | '-='
    | '*='
    | '/='
;
ThrowStmt: 
    'throw' 'new' 'RuntimeException'
;
Instantiation: 
    'new' IDENTIFIER '(' ArgList ')'
;
MethodInvocation: 
    IDENTIFIER '(' ArgList ')'
;

/* Expressions */
ExprStmt: 
    '(' ExprStmt ')' Expr
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
    | 'true'
    | 'false'
;
LogicalOperator:
    '!='
    | '=='
    | '<'
    | '<='
    | '>'
    | '>='
;
/* Expressions */

TypedIdentifier:
    DataType IDENTIFIER
;
DataType:
    'double' OptBrackets
    | 'float' OptBrackets
    | 'int' OptBrackets
    | 'long' OptBrackets
    | 'String' OptBrackets
    | 'void'
;
OptBrackets:
    /* empty string */
    | '[' ']'
    | '[' '] ' '[' ']'
;

%%
/*
line: '\n'
 | exp '\n' { System.out.println(" " + $1.dval + " "); }
 ;

exp: NUM { $$ = $1; }
 | exp '+' exp { $$ = new ParserVal($1.dval + $3.dval); }
 | exp '-' exp { $$ = new ParserVal($1.dval - $3.dval); }
 | exp '*' exp { $$ = new ParserVal($1.dval * $3.dval); }
 | exp '/' exp { $$ = new ParserVal($1.dval / $3.dval); }
 | '-' exp %prec NEG { $$ = new ParserVal(-$2.dval); }
 | exp '^' exp { $$ = new ParserVal(Math.pow($1.dval, $3.dval)); }
 | '(' exp ')' { $$ = $2; }
 ;

exp:  NUM                { $$ = $1;         }
    | exp '+' exp        { $$ = $1 + $3;    }
    | exp '-' exp        { $$ = $1 - $3;    }
    | exp '*' exp        { $$ = $1 * $3;    }
    | exp '/' exp        { $$ = $1 / $3;    }
    | '-' exp  %prec NEG { $$ = -$2;        }
    | exp '^' exp        { $$ = Math.pow($1, $3); }
    | '(' exp ')'        { $$ = $2;         }
*/

String ins;
StringTokenizer st;

void yyerror(String s)
{
 System.out.println("par:"+s);
}

boolean newline;
int yylex()
{
String s;
int tok;
Double d;
 //System.out.print("yylex ");
 if (!st.hasMoreTokens())
 if (!newline)
 {
 newline=true;
 return '\n'; //So we look like classic YACC example
 }
 else
 return 0;
 s = st.nextToken();
 //System.out.println("tok:"+s);
 try
 {
 d = Double.valueOf(s);/*this may fail*/
 yylval = new ParserVal(d.doubleValue()); //SEE BELOW
 tok = NUM;
 }
 catch (Exception e)
 {
 tok = s.charAt(0);/*if not float, return char*/
 }
 return tok;
}

void dotest()
{
BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
 System.out.println("BYACC/J Calculator Demo");
 System.out.println("Note: Since this example uses the StringTokenizer");
 System.out.println("for simplicity, you will need to separate the items");
 System.out.println("with spaces, i.e.: '( 3 + 5 ) * 2'");
 while (true)
 {
 System.out.print("expression:");
 try
 {
 ins = in.readLine();
 }
 catch (Exception e)
 {
 }
 st = new StringTokenizer(ins);
 newline=false;
 yyparse();
 }
}

public static void main(String args[])
{
 Parser par = new Parser(false);
 par.dotest();
}