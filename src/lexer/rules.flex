/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
When consuming its input, the scanner determines the regular expression that matches
the longest portion of the input (longest match rule). If there is more than one regular
expression that matches the longest portion of input (i.e. they all match the same input),
the generated scanner chooses the expression that appears first in the specification.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
package src.lexer;

import src.token.*;
import src.parser.Parser;
import src.parser.ParserVal;

/**
  Classe Lexer para a disciplina de compiladores da Universidade Estadual de Santa Cruz (UESC)
  Exemplo de uso: java Lexer.class compiladores/src/Weierstrass.java
*/
%%

/* Usage: jflex rules.flex */

/* Options */
%class Lexer
%byaccj
%public // Torna pública a classe gerada
//%debug // Cria um main na classe gerada que espera o nome do arquivo de entrada e imprime mensagens de debug ao parsear
%unicode
%line // Habilita contagem de linhas, através da variável yyline
%column // Habilita contagem de colunas, através da variável yycolumn
//%type Token

/* User code */
%{

  /* store a reference to the parser object */
  private Parser yyparser;

  /* constructor taking an additional parser object */
  public Lexer(java.io.Reader r, Parser yyparser) {
    this(r);
    this.yyparser = yyparser;
  }

  StringBuffer string = new StringBuffer();

  public boolean isEndOfFile() {
      return zzAtEOF;
  }

  private ParserVal keyword(TokenType type) {
    return new ParserVal(new Keyword(type, yyline+1, yycolumn));
  }
  private ParserVal logicalOperator(TokenType type) {
    return new ParserVal(new LogicalOperator(type, yyline+1, yycolumn));
  }
  private ParserVal operator(TokenType type) {
    return new ParserVal(new Operator(type, yyline+1, yycolumn));
  }
  private ParserVal identifier(String lexeme) {
    return new ParserVal(new Identifier(yyline+1, yycolumn, lexeme));
  }
  private ParserVal stringLiteral(String value) {
    return new ParserVal(new StringLiteral(yyline+1, yycolumn, value));
  }
  private ParserVal integerLiteral(int value) {
    return new ParserVal(new IntegerLiteral(yyline+1, yycolumn, value));
  }
  private ParserVal longLiteral(long value) {
    return new ParserVal(new LongLiteral(yyline+1, yycolumn, value));
  }
  private ParserVal doubleLiteral(double value) {
      return new ParserVal(new DoubleLiteral(yyline+1, yycolumn, value));
  }
%}

/* Macros */
LineBreak = \r|\n|\r\n
InputChar = [^\r\n]
WhiteSpace     = {LineBreak} | [ \t\f]+
Comment     = "//" {InputChar}* {LineBreak}?

Digit = [0-9]
Digits = {Digit}+
Exponent = [eE] [+-]? [0-9]+
IntegerLiteral = {Digits}
LongLiteral = {Digits} [Ll]
DoubleLiteral = {Digits} {Exponent}? | {Digits} \. {Digits} {Exponent}?

Identifier = [:jletter:] [:jletterdigit:]*

/* Define um estado, que será uma start condition para algumas expressões */
%state STRING

%%

<YYINITIAL> {
  /* keywords */
  "class"             { return yyparser.CLASS_KW; }
  "double"            { return yyparser.DOUBLE_KW; }
  "else"              { return yyparser.ELSE_KW; }
  "float"             { return yyparser.FLOAT_KW; }
  "for"               { return yyparser.FOR_KW; }
  "if"                { return yyparser.IF_KW; }
  "import"            { return yyparser.IMPORT_KW; }
  "int"               { return yyparser.INT_KW; }
  "long"              { return yyparser.LONG_KW; }
  "new"               { return yyparser.NEW_KW; }
  "public"            { return yyparser.PUBLIC_KW; }
  "return"            { return yyparser.RETURN_KW; }
  "static"            { return yyparser.STATIC_KW; }
  "throw"             { return yyparser.THROW_KW; }
  "void"              { return yyparser.VOID_KW; }

  /* Java identifiers */
  "RuntimeException"  { return yyparser.RT_EXCEPTION; }
  "String"            { return yyparser.STRING_KW; }

  {Identifier}        { yyparser.setYylval(identifier(yytext()));
                        return yyparser.IDENTIFIER; }
  {IntegerLiteral}    { yyparser.setYylval(integerLiteral(Integer.parseInt(yytext()))); 
                        return yyparser.INTEGER_LITERAL; }
  {LongLiteral}       { yyparser.setYylval(longLiteral(Long.parseLong(yytext().substring(0,yylength()-1))));
                        return yyparser.LONG_LITERAL; }
  {DoubleLiteral}     { yyparser.setYylval(doubleLiteral(Double.parseDouble(yytext())));
                        return yyparser.DOUBLE_LITERAL; }

  /* Caractere aspas duplas = inicio de string. Reseta o buffer de string e muda o estado para STRING */
  \"                  { string.setLength(0); yybegin(STRING); }

  /* Logical operators */
  "!="                { return yyparser.NE; }
  "=="                { return yyparser.EQEQ; }
  "<"                 { return yyparser.LT; }
  "<="                { return yyparser.LE; }
  ">"                 { return yyparser.GT; }
  ">="                { return yyparser.GE; }

  /* Operators */
  "+="                { return yyparser.PLUSEQ; }
  "-="                { return yyparser.MINUSEQ; }
  "++"                { return yyparser.PLUSPLUS; }
  "--"                { return yyparser.MINUSMINUS; }
  "+"                 { return yyparser.PLUS; }
  "-"                 { return yyparser.MINUS; }
  "*"                 { return yyparser.ASTERISK; }
  "/"                 { return yyparser.DIV; }
  "="                 { return yyparser.EQ; }

  "?"                 { return yyparser.QUEST; }
  ":"                 { return yyparser.COLON; }
  "("                 { return yyparser.LPARENTH; }
  ")"                 { return yyparser.RPARENTH; }
  "{"                 { return yyparser.LBRACE; }
  "}"                 { return yyparser.RBRACE; }
  "["                 { return yyparser.LBRACKET; }
  "]"                 { return yyparser.RBRACKET; }
  ";"                 { return yyparser.SEMICOLON; }
  ","                 { return yyparser.COMMA; }
  "."                 { return yyparser.DOT; }

  /* Comments */
  {Comment}           { /* ignore */ }

  /* Whitespace */
  {WhiteSpace}        { /* ignore */ }
}

<STRING> {
  /* Volta ao estado inicial quando encontra aspas duplas, que é o fechamento da string */
  \"                  { yybegin(YYINITIAL);
                        yyparser.setYylval(stringLiteral(string.toString()));
                        return yyparser.STRING_LITERAL; }

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
[^]                   { throw new Error("Syntax error in <" + yytext() + ">, line " + yyline + " column " + yycolumn); }