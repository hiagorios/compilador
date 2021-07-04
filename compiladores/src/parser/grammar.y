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
program:
    'class' IDENTIFIER '{' class_body '}'
;
class_body:
    /* empty string */
    | opt_scope_modifier class_member class_body
;
class_member:
    variable_declaration ';'
    | method_declaration
;
variable_declaration:
    typed_identifier opt_variable_initialization
;
opt_variable_initialization:
    /* empty string */
    | '=' expr
;
method_declaration:
    typed_identifier '(' opt_param_list ') {' stmt_list '}'
;
stmt_list:
    /* empty string */
    | stmt stmt_list
;
opt_param_list:
    /* empty string */
    | param_list
;
param_list:
    typed_identifier ',' param_list
    | typed_identifier
;
stmt:
    variable_declaration ';'
    | if
    | for
    | assignment ';'
    | expr ';'
;
if:
    'if' '(' logical_expr ')' '{' stmt_list '}' opt_else
;
opt_else:
    /* empty string */
    | 'else' '{' stmt_list '}'
;
for:
    'for' '(' for_assignment ';' for_test ';' for_after_stmt ') {' stmt_list '}'
;
for_assignment:
    /* empty string */
    | variable_declaration
    | assignment
;
for_test:
    /* empty string */
    | logical_expr
;
for_after_stmt:
    /* empty string */
    | expr
    | assignment
;
assignment:
    IDENTIFIER '=' expr
;
expr:
    '(' expr ')'
    | expr '+' expr
    | expr '-' expr
    | expr '*' expr
    | expr '/' expr
;
logical_expr:
    expr logical_operator expr
    | 'true'
    | 'false'
;
logical_operator:
    '!='
    | '=='
    | '<'
    | '<='
    | '>'
    | '>='
;
typed_identifier:
    data_type IDENTIFIER
;
opt_scope_modifier:
    /* empty string */
    | 'public' opt_static_modifier
    | 'protected' opt_static_modifier
    | 'private' opt_static_modifier
;
opt_static_modifier: 
    /* empty string */
    | 'static'
;
data_type:
    'double'
    | 'float'
    | 'int'
    | 'long'
    | 'void'
    | 'String'
    | 'RuntimeException'
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