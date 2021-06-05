package lexer.token;

public class Operator extends Token {

    public Operator(int type, int line, int column) {
        super(type, line, column);
    }

    @Override
    public String toString() {
        return "Operator{" +
                "type=" + type +
                ", line=" + line +
                ", column=" + column +
                '}';
    }
}
