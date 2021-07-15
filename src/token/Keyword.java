package src.token;

public class Keyword extends Token {

    public Keyword(TokenType type, int line, int column) {
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
