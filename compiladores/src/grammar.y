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
%token NUM
%left '-' '+'
%left '*' '/'
%left NEG /* negation--unary minus */
%right '^' /* exponentiation */

/* Grammar follows */
/*
Gramática pra converter
<program> -> 'class' <class_name> '{' <class_body> '}'
<class_name> -> <identifier>
<class_body> -> <class_member> <class_body> | E
<class_member> -> <property_declaration> | <method_declaration>

<property_declaration> -> <opt_scope_modifier> <variable_declaration>
<variable_declaration> -> <data_type> <identifier> <opt_variable_initialization> ';'
<opt_variable_initialization> ->

<method_declaration> -> <opt_scope_modifier> <data_type> <identifier> '(' (<param_list> | E) ') {' <stmt_list> '}'
<stmt_list> -> <stmt> <stmt_list> | <stmt> | E
<param_list> -> <param> ',' <param_list> | <param>
<param> -> <data_type> <identifier>
<stmt> -> <variable_declaration> | <if> | <for> | <assignment> | <expr>
<if> -> 'if (' <expr> ') {' <stmt_list> '}' (<else> | E)
<else> -> '{' <stmt_list> '}'
<for> -> 'for (' (<assignment> | E) ';' (<logical_expr> | E) ';' (<expr> | <assignment> | E)  ') {' <stmt_list> '}'
<assignment> ->
<expr> ->
<logical_expr> ->

<identifier> -> <letter> <alfanumeric_list> | <letter>
<alfanumeric_list> -> (<letter> | <digit>) <alfanumeric_list> | <letter> | <digit>
<opt_scope_modifier> -> //pensar no static
<data_type> ->

<letter> ->
<digit> ->
*/

%%
input: /* empty string */
 | input line
 ;

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
%%

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