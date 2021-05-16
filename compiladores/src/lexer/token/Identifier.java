package lexer.token;

public class Identifier extends Token {

    public final String lexeme;

    public Identifier(int line, int column, String lexeme) {
        super(TokenType.IDENTIFIER, line, column);
        this.lexeme = lexeme;
    }
}