package src.token;

public class IntegerLiteral extends Token {

    public final int value;

    public IntegerLiteral(int line, int column, int value) {
        super(TokenType.INTEGER_LITERAL, line, column);
        this.value = value;
    }

    @Override
    public String toString() {
        return "IntegerLiteral{" +
                "value=" + value +
                ", line=" + line +
                ", column=" + column +
                '}';
    }
}
