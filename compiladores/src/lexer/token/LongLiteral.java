package lexer.token;

public class LongLiteral extends Token {

    public final long value;

    public LongLiteral(int line, int column, long value) {
        super(TokenType.LONG_LITERAL, line, column);
        this.value = value;
    }
}
