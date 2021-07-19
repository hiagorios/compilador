/* Using GNU Bison 3.7.6  */

%language "Java"

%define api.parser.class {Parser}
%define api.parser.public
%define api.package {src.parser}
%define api.value.type {Token}

%define parse.error verbose

%file-prefix "Parser"

%code imports {
  import java.io.*;
  import src.lexer.YYLexer;
  import src.token.*;
}

%code {
    /* lexer is created in the constructor */
    public Parser(Reader r) {
        yylexer = new YYLexer(r);
    }

    public static void main(String args[]) throws IOException {
        if (args == null || args.length == 0) {
            System.out.println("Please specify a file");
            System.exit(1);
        }
        String file = args[0];
        try {
            Parser yyparser = new Parser(new FileReader(file));
            if (!yyparser.parse()) {
                System.exit(1);
            }
        }
        catch (Exception e) {
            System.out.println("Unexpected exception:");
            e.printStackTrace();
        }
    }
}

/* Keywords */
%token <Token> CLASS_KW "class keyword"
%token <Token> DOUBLE_KW "double keyword"
%token <Token> ELSE_KW "else keyword"
%token <Token> FLOAT_KW "float keyword"
%token <Token> FOR_KW "for keyword"
%token <Token> IF_KW "if keyword"
%token <Token> INT_KW "int keyword"
%token <Token> LONG_KW "long keyword"
%token <Token> NEW_KW "new keyword"
%token <Token> PUBLIC_KW "public keyword"
%token <Token> RETURN_KW "return keyword"
%token <Token> STATIC_KW "static keyword"
%token <Token> THROW_KW "throw keyword"
%token <Token> VOID_KW "void keyword"

/* Operators */
%token <Token> MINUSEQ "-="
%token <Token> MINUSMINUS "--"
%token <Token> PLUSEQ "+="
%token <Token> PLUSPLUS "++"

/* Logical Operators */
%token <Token> EQEQ "=="
%token <Token> GE ">="
%token <Token> LE "<="
%token <Token> NE "!="

/* Java Identifiers */
%token <Token> RT_EXCEPTION "RuntimeException"
%token <Token> STRING_KW "String"

/* Types */
%token <DoubleLiteral> DOUBLE_LITERAL "double literal"
%token <IntegerLiteral> INTEGER_LITERAL "integer literal"
%token <LongLiteral> LONG_LITERAL "long literal"
%token <StringLiteral> STRING_LITERAL "string literal"
%token <Identifier> IDENTIFIER "identifier"

// %nterm <Double> MathExpr

/* Precedencia cresce de cima pra baixo */
%left '-' '+'
%left '*' '/'
%precedence NEGATIVE 

/* Gramática */
%%
Class:
    CLASS_KW IDENTIFIER '{' ClassBody '}' { System.out.println("Parsing finish"); }
;
ClassBody:
    %empty
    | OptScopeModifier MethodDeclaration ClassBody
;
MethodDeclaration:
    IdentifierTyping IDENTIFIER '(' ParamList ')' Block
;
OptScopeModifier:
    %empty
    | PUBLIC_KW STATIC_KW
;
Block:
    '{' StmtList '}'
;
StmtList:
    %empty
    | Stmt StmtList
;
Stmt:
    VariableDeclaration ';'
    | IfStmt
    | ForStmt
    | AssignmentStmt ';'
    | ExprStmt ';'
    | ThrowStmt ';'
    | ReturnStmt ';'
;
VariableDeclaration:
    IdentifierTyping IDENTIFIER OptVariableInitialization OptNestedVariableDeclaration
;
OptNestedVariableDeclaration:
    %empty
    | ',' IDENTIFIER OptVariableInitialization OptNestedVariableDeclaration 
;
OptVariableInitialization:
    %empty
    | AssignmentOperator ExprStmt
;
IfStmt:
    IF_KW '(' LogicalExpr ')' Block OptElse
;
OptElse:
    %empty
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
    NestedIdentifier AssignmentOperator ExprStmt
;
IncrementStmt:
    NestedIdentifier UnaryOperator
    | UnaryOperator NestedIdentifier
;
ThrowStmt: 
    THROW_KW NEW_KW RT_EXCEPTION '(' ArgList ')'
;
ReturnStmt:
    RETURN_KW ExprStmt
;
ExprStmt: 
    MathExpr
    | ClassInstantiation
    | ArrayDeclaration
    | STRING_LITERAL
;
MathExpr: 
    MathExpr '+' MathExpr
    | MathExpr '-' MathExpr
    | MathExpr '*' MathExpr
    | MathExpr '/' MathExpr

    /* Define que a precedência é a mesma definida para NEGATIVE */
    | '-' MathExpr %prec NEGATIVE
    | '(' MathExpr ')'
    /* Casting */
    | '(' DataType ')' MathExpr
    | Evaluable
;
Evaluable:
    MethodInvocation
    | NestedIdentifier
    | Number
;
OptIndexing:
    %empty
    | '[' MathExpr ']' OptIndexing
;
OptMathExpr:
    %empty
    | MathExpr
;
OptArrayLength:
    '[' OptMathExpr ']'
    | '[' OptMathExpr ']' OptArrayLength
;
ClassInstantiation: 
    NEW_KW IDENTIFIER '(' OptArgList ')'
;
ArrayDeclaration:
    NEW_KW DataType OptArrayLength OptArrayInitialization
;
OptArrayInitialization:
    %empty
    | '{' ArgList '}'
;
MethodInvocation: 
    NestedIdentifier '(' OptArgList ')'
;
LogicalExpr:
    MathExpr LogicalOperator MathExpr
;
OptArgList:
    %empty
    | ArgList
;
ParamList:
    IdentifierTyping IDENTIFIER
    | IdentifierTyping IDENTIFIER ',' ParamList
;
ArgList:
    ExprStmt
    | ExprStmt ',' ArgList
;
NestedIdentifier:
    IDENTIFIER OptIndexing
    | IDENTIFIER OptIndexing '.' NestedIdentifier
;
IdentifierTyping:
    DataType OptBrackets
;
OptBrackets:
    %empty
    | '[' ']' OptBrackets
;
DataType:
    DOUBLE_KW
    | FLOAT_KW
    | INT_KW
    | LONG_KW
    | STRING_KW
    | VOID_KW
    | IDENTIFIER
;
Number: 
    LONG_LITERAL
    | INTEGER_LITERAL
    | DOUBLE_LITERAL
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

%%