package lexer.token;

public class DoubleLiteral extends Token {

    public final double value;

    public DoubleLiteral(int line, int column, double value) {
        super(TokenType.DOUBLE_LITERAL, line, column);
        this.value = value;
    }

    @Override
    public String toString() {
        return "DoubleLiteral{" +
                "value=" + value +
                ", line=" + line +
                ", column=" + column +
                '}';
    }
}
