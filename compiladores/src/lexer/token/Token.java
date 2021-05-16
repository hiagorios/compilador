package lexer.token;

public class Token {

    public final int type;
    public final int line;
    public final int column;

    public Token(int type, int line, int column) {
        this.type = type;
        this.line = line;
        this.column = column;
    }
}
