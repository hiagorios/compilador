package lexer.token;

public class StringLiteral extends Token {

    public final String value;

    public StringLiteral(int line, int column, String value) {
        super(TokenType.STRING_LITERAL, line, column);
        this.value = value;
    }

    @Override
    public String toString() {
        return "StringLiteral{" +
                "value='" + value + '\'' +
                ", line=" + line +
                ", column=" + column +
                '}';
    }
}
