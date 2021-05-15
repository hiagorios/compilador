/* JFlex example: partial Java language lexer specification */
  // When consuming its input, the scanner determines the regular expression that matches
  // the longest portion of the input (longest match rule). If there is more than one regular
  // expression that matches the longest portion of input (i.e. they all match the same input),
  // the generated scanner chooses the expression that appears first in the specification.


  //import java_cup.runtime.*;

  // O código antes dos %% será incluído no nível dos imports da classe Lexer gerada
  // Usado basicamente pra imports e esse comentário de documentação pra classe

    /**
     * Classe Lexer para a disciplina de compiladores da Universidade Estadual de Santa Cruz (UESC)
     */
    %%

    // Aqui vem as opções

    %class Lexer
    %public // Torna pública a classe gerada
    %debug // Cria um main na classe gerada que espera o nome do arquivo de entrada e imprime mensagens de debug ao parsear
    //%apiprivate // Torna os métodos da classe gerados pelo JFlex privados (não afeta o UserCode)
    %unicode
    %line // Habilita contagem de linhas, através da variável yyline
    %column // Habilita contagem de colunas, através da variável yycolumn

    // E aqui o código adicional que entrará no corpo do Lexer
    %{
      StringBuffer string = new StringBuffer();

      private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
      }
      private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
      }
    %}

    /* Gramática pra converter
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

    // Macros (tipo constantes) pra não ficar repetindo as regex embaixo
    LineTerminator = \r|\n|\r\n
    InputCharacter = [^\r\n]
    WhiteSpace     = {LineTerminator} | [ \t\f]

    /* comments */
    Comment = {TraditionalComment} | {EndOfLineComment} | {DocumentationComment}

    TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
    // Comment can be the last line of the file, without line terminator.
    EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}?
    DocumentationComment = "/**" {CommentContent} "*"+ "/"
    CommentContent       = ( [^*] | \*+ [^/*] )*

    Identifier = [:jletter:] [:jletterdigit:]*

    DecIntegerLiteral = 0 | [1-9][0-9]*

    %state STRING //define um estado, que será uma start condition para algumas expressões

    %%

    /* keywords */
    <YYINITIAL> "abstract"           { return symbol(sym.ABSTRACT); }
    <YYINITIAL> "boolean"            { return symbol(sym.BOOLEAN); }
    <YYINITIAL> "break"              { return symbol(sym.BREAK); }

    <YYINITIAL> {
      /* identifiers */
      {Identifier}                   { return symbol(sym.IDENTIFIER); }

      /* literals */
      {DecIntegerLiteral}            { return symbol(sym.INTEGER_LITERAL); }

      /* Caractere aspas duplas = inicio de string. Reseta o buffer de string e muda o estado para STRING */
      \"                             { string.setLength(0); yybegin(STRING); }

      /* operators */
      "="                            { return symbol(sym.EQ); }
      "=="                           { return symbol(sym.EQEQ); }
      "+"                            { return symbol(sym.PLUS); }

      /* comments */
      {Comment}                      { /* ignore */ }

      /* whitespace */
      {WhiteSpace}                   { /* ignore */ }
    }

    <STRING> {
      /* Volta ao estado inicial quando encontra aspas duplas, que é o fechamento da string */
      \"                             { yybegin(YYINITIAL);
                                       return symbol(sym.STRING_LITERAL,
                                       string.toString()); }

      /* Faz match de qualquer coisa que não seja quebra de linha e tal, nem aspas duplas */
      /* E concatena no buffer de string. yytext é o texto lido */
      [^\n\r\"\\]+                   { string.append( yytext() ); }
      \\t                            { string.append('\t'); }
      \\n                            { string.append('\n'); }

      \\r                            { string.append('\r'); }
      \\\"                           { string.append('\"'); }
      \\                             { string.append('\\'); }
    }

    /* error fallback: faz match em qualquer estado léxico e de qualquer caractere */
    /* Mas como é a última regra e só lê um caractere, só faz match se nenhuma outra fizer */
    [^]                              { throw new Error("Illegal character <"+
                                                        yytext()+">"); }