package lexer;

public class Word extends Token {

    public final String lexeme;

    public Word(int type, String lexeme) {
        super(type);
        this.lexeme = lexeme;
    }
}
