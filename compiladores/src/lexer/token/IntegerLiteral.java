package lexer.token;

public class IntegerLiteral extends Token {

    public final int value;

    public IntegerLiteral(int line, int column, int value) {
        super(TokenType.INTEGER_LITERAL, line, column);
        this.value = value;
    }
}