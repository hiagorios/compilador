package src.lexer;

import src.token.*;
import src.parser.Parser;

/**
  Classe YYLexer para a disciplina de compiladores da Universidade Estadual de Santa Cruz (UESC)
  JFlex 1.8.2
*/
%%

/* Options */
%class YYLexer
%public // Torna pública a classe gerada
%unicode
%int
%line // Habilita contagem de linhas, através da variável yyline
%implements Parser.Lexer
%column // Habilita contagem de colunas, através da variável yycolumn

/* User code */
%{
  /* Semantic value of the lookahead.  */
  Token yylval = null;
  
  StringBuffer string = new StringBuffer();

  public boolean isEndOfFile() {
      return zzAtEOF;
  }

  /* setter for token's semantic value */
  void setYylval(Token yylval) {
      this.yylval = yylval;
  }

  @Override
  public Token getLVal() {
      return yylval;
  }

  /* error reporting */
  @Override
  public void yyerror(String msg) {
    System.err.println("Error: " + msg + " at line " + (yyline + 1) + " column " + (yycolumn+1));
  }

  private Token keyword(TokenType type) {
    return new Keyword(type, yyline+1, yycolumn);
  }
  private Token logicalOperator(TokenType type) {
    return new LogicalOperator(type, yyline+1, yycolumn);
  }
  private Token operator(TokenType type) {
    return new Operator(type, yyline+1, yycolumn);
  }
  private Token identifier(String lexeme) {
    return new Identifier(yyline+1, yycolumn, lexeme);
  }
  private Token stringLiteral(String value) {
    return new StringLiteral(yyline+1, yycolumn, value);
  }
  private Token integerLiteral(int value) {
    return new IntegerLiteral(yyline+1, yycolumn, value);
  }
  private Token longLiteral(long value) {
    return new LongLiteral(yyline+1, yycolumn, value);
  }
  private Token doubleLiteral(double value) {
      return new DoubleLiteral(yyline+1, yycolumn, value);
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
  "class"             { setYylval(keyword(TokenType.CLASS_KW));
                        return CLASS_KW; }
  "double"            { setYylval(keyword(TokenType.DOUBLE_KW));
                        return DOUBLE_KW; }
  "else"              { setYylval(keyword(TokenType.ELSE_KW));
                        return ELSE_KW; }
  "float"             { setYylval(keyword(TokenType.FLOAT_KW));
                        return FLOAT_KW; }
  "for"               { setYylval(keyword(TokenType.FOR_KW));
                        return FOR_KW; }
  "if"                { setYylval(keyword(TokenType.IF_KW));
                        return IF_KW; }
  "int"               { setYylval(keyword(TokenType.INT_KW));
                        return INT_KW; }
  "long"              { setYylval(keyword(TokenType.LONG_KW));
                        return LONG_KW; }
  "new"               { setYylval(keyword(TokenType.NEW_KW));
                        return NEW_KW; }
  "public"            { setYylval(keyword(TokenType.PUBLIC_KW));
                        return PUBLIC_KW; }
  "return"            { setYylval(keyword(TokenType.RETURN_KW));
                        return RETURN_KW; }
  "static"            { setYylval(keyword(TokenType.STATIC_KW));
                        return STATIC_KW; }
  "throw"             { setYylval(keyword(TokenType.THROW_KW));
                        return THROW_KW; }
  "void"              { setYylval(keyword(TokenType.VOID_KW));
                        return VOID_KW; }

  /* Java identifiers */
  "RuntimeException"  { setYylval(keyword(TokenType.RT_EXCEPTION));
                        return RT_EXCEPTION; }
  "String"            { setYylval(keyword(TokenType.STRING_KW));
                        return STRING_KW; }

  {Identifier}        { setYylval(identifier(yytext()));
                        return IDENTIFIER; }
  {IntegerLiteral}    { setYylval(integerLiteral(Integer.parseInt(yytext()))); 
                        return INTEGER_LITERAL; }
  {LongLiteral}       { setYylval(longLiteral(Long.parseLong(yytext().substring(0,yylength()-1))));
                        return LONG_LITERAL; }
  {DoubleLiteral}     { setYylval(doubleLiteral(Double.parseDouble(yytext())));
                        return DOUBLE_LITERAL; }

  /* Caractere aspas duplas = inicio de string. Reseta o buffer de string e muda o estado para STRING */
  \"                  { string.setLength(0); yybegin(STRING); }

  /* Logical operators */
  "!="                { setYylval(logicalOperator(TokenType.NE));
                        return NE; }
  "=="                { setYylval(logicalOperator(TokenType.EQEQ));
                        return EQEQ; }
  "<"                 { setYylval(logicalOperator(TokenType.LT));
                        return (int) yycharat(0); }
  "<="                { setYylval(logicalOperator(TokenType.LE));
                        return LE; }
  ">"                 { setYylval(logicalOperator(TokenType.GT));
                        return (int) yycharat(0); }
  ">="                { setYylval(logicalOperator(TokenType.GE));
                        return GE; }

  /* Operators */
  "+="                { setYylval(operator(TokenType.PLUSEQ));
                        return PLUSEQ; }
  "-="                { setYylval(operator(TokenType.MINUSEQ));
                        return MINUSEQ; }
  "++"                { setYylval(operator(TokenType.PLUSPLUS));
                        return PLUSPLUS; }
  "--"                { setYylval(operator(TokenType.MINUSMINUS));
                        return MINUSMINUS; }
  "+" |
  "-" |
  "*" |
  "/" |
  "=" |
  
  /* Symbols */
  "(" |
  ")" |
  "{" |
  "}" |
  "[" |
  "]" |
  ";" |
  "," |
  "."                 { return (int) yycharat(0); }

  /* Comments */
  {Comment}           { /* ignore */ }

  /* Whitespace */
  {WhiteSpace}        { /* ignore */ }
}

<STRING> {
  /* Volta ao estado inicial quando encontra aspas duplas, que é o fechamento da string */
  \"                  { yybegin(YYINITIAL);
                        setYylval(stringLiteral(string.toString()));
                        return STRING_LITERAL; }

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
[^]                   { throw new Error("Lexical error in <" + yytext() + ">, line " + yyline + " column " + yycolumn); }