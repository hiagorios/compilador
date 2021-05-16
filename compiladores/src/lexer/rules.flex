/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
When consuming its input, the scanner determines the regular expression that matches
the longest portion of the input (longest match rule). If there is more than one regular
expression that matches the longest portion of input (i.e. they all match the same input),
the generated scanner chooses the expression that appears first in the specification.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

import compiladores.lexer.*;

/**
  Classe Lexer para a disciplina de compiladores da Universidade Estadual de Santa Cruz (UESC)
*/
%%

/* Options */
%class Lexer
%public // Torna pública a classe gerada
%debug // Cria um main na classe gerada que espera o nome do arquivo de entrada e imprime mensagens de debug ao parsear
%unicode
%line // Habilita contagem de linhas, através da variável yyline
%column // Habilita contagem de colunas, através da variável yycolumn

/* User code */
%{
  StringBuffer string = new StringBuffer();

  private Token token(int type) {
    return new Token(type, yyline, yycolumn);
  }
  private Keyword keyword(int type) {
    return new Keyword(type, yyline, yycolumn);
  }
  private LogicalOperator logicalOperator(int type) {
    return new LogicalOperator(type, yyline, yycolumn);
  }
  private Operator operator(int type) {
    return new Operator(type, yyline, yycolumn);
  }
  private Identifier identifier(String lexeme) {
    return new Identifier(yyline, yycolumn, lexeme);
  }
  private StringLiteral stringLiteral(String value) {
    return new StringLiteral(yyline, yycolumn, value);
  }
  private IntegerLiteral integerLiteral(int value) {
    return new IntegerLiteral(yyline, yycolumn, value);
  }
  private LongLiteral longLiteral(long value) {
    return new LongLiteral(yyline, yycolumn, value);
  }
%}

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

/* Macros */
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]+
CommentContent       = ( [^*] | \*+ [^/*] )*
Comment = {TraditionalComment} | {EndOfLineComment}
TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}?

Digit = [0-9]
DigitOrUnderscore = [_0-9]
Digits = {Digit} | {Digit} {DigitOrUnderscore}*
IntegerLiteral = {Digits}
LongLiteral = {IntegerLiteral} [Ll]

Identifier = [:jletter:] [:jletterdigit:]*

/* Define um estado, que será uma start condition para algumas expressões */
%state STRING

%%

<YYINITIAL> {
  /* keywords */
  "class"             { return keyword(TokenType.CLASS_KEYWORD); }
  "double"            { return keyword(TokenType.DOUBLE_KEYWORD); }
  "else"              { return keyword(TokenType.ELSE_KEYWORD); }
  "float"             { return keyword(TokenType.FLOAT_KEYWORD); }
  "for"               { return keyword(TokenType.FOR_KEYWORD); }
  "if"                { return keyword(TokenType.IF_KEYWORD); }
  "import"            { return keyword(TokenType.IMPORT_KEYWORD); }
  "int"               { return keyword(TokenType.INT_KEYWORD); }
  "long"              { return keyword(TokenType.LONG_KEYWORD); }
  "new"               { return keyword(TokenType.NEW_KEYWORD); }
  "public"            { return keyword(TokenType.PUBLIC_KEYWORD); }
  "throw"             { return keyword(TokenType.THROW_KEYWORD); }
  "return"            { return keyword(TokenType.RETURN_KEYWORD); }
  "void"              { return keyword(TokenType.VOID_KEYWORD); }
  "static"            { return keyword(TokenType.STATIC_KEYWORD); }
  "RuntimeException"  { return keyword(TokenType.RT_EXCEPTION_KEYWORD); }

  {Identifier}        { return identifier(yytext()); }
  {IntegerLiteral}    { return integerLiteral(yytext()); }
  {LongLiteral}       { return longLiteral(yytext()); }

  /* Caractere aspas duplas = inicio de string. Reseta o buffer de string e muda o estado para STRING */
  \"                  { string.setLength(0); yybegin(STRING); }

  /* Logical operators */
  "!="                { return logicalOperator(TokenType.NE); }
  "=="                { return logicalOperator(TokenType.EQEQ); }
  "<"                 { return logicalOperator(TokenType.LT); }
  "<="                { return logicalOperator(TokenType.LE); }
  ">"                 { return logicalOperator(TokenType.GT); }
  ">="                { return logicalOperator(TokenType.GE); }

  /* Operators */
  "+="                { return operator(TokenType.PLUSEQ); }
  "-="                { return operator(TokenType.MINUSEQ); }
  "++"                { return operator(TokenType.PLUSPLUS); }
  "--"                { return operator(TokenType.MINUSMINUS); }
  "+"                 { return operator(TokenType.PLUS); }
  "-"                 { return operator(TokenType.MINUS); }
  "*"                 { return operator(TokenType.ASTERISK); }
  "/"                 { return operator(TokenType.DIV); }
  "="                 { return operator(TokenType.EQ); }

  "?"                 { return token(TokenType.QUEST); }
  ":"                 { return token(TokenType.COLON); }
  "("                 { return token(TokenType.LPARENTH); }
  ")"                 { return token(TokenType.RPARENTH); }
  "{"                 { return token(TokenType.LBRACE); }
  "}"                 { return token(TokenType.RBRACE); }
  "["                 { return token(TokenType.LBRACKET); }
  "]"                 { return token(TokenType.RBRACKET); }
  ";"                 { return token(TokenType.SEMICOLON); }
  ","                 { return token(TokenType.COMMA); }
  "."                 { return token(TokenType.DOT); }

  /* Comments */
  {Comment}           { /* ignore */ }

  /* Whitespace */
  {WhiteSpace}        { /* ignore */ }
}

<STRING> {
  /* Volta ao estado inicial quando encontra aspas duplas, que é o fechamento da string */
  \"                  { yybegin(YYINITIAL); return stringLiteral(string.toString()); }

  /* Faz match de qualquer coisa que não seja quebra de linha e tal, nem aspas duplas */
  /* E concatena no buffer de string. yytext é o texto lido */
  [^\n\r\"\\]+        { string.append( yytext() ); }
  \\t                 { string.append('\t'); }
  \\n                 { string.append('\n'); }

  \\r                 { string.append('\r'); }
  \\\"                { string.append('\"'); }
  \\                  { string.append('\\'); }
}

/* error fallback: faz match em qualquer estado léxico e de qualquer caractere */
/* Mas como é a última regra e só lê um caractere, só faz match se nenhuma outra fizer */
[^]                   { throw new Error("Illegal character <" + yytext() + ">"); }