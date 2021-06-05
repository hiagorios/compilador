package lexer.token;

public class Keyword extends Token {

    public Keyword(int type, int line, int column) {
        super(type, line, column);
    }

    @Override
    public String toString() {
        return "Keyword{" +
                "type=" + type +
                ", line=" + line +
                ", column=" + column +
                '}';
    }
}
