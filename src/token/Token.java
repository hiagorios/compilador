package src.token;

public class Token {

    public final TokenType type;
    public final int line;
    public final int column;

    public Token(TokenType type, int line, int column) {
        this.type = type;
        this.line = line;
        this.column = column;
    }

    @Override
    public String toString() {
        return "Token{" +
                "type=" + type +
                ", line=" + line +
                ", column=" + column +
                '}';
    }
}
