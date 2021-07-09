//package lexer;
//
//import java.io.IOException;
//import java.util.HashMap;
//
//// Analisador Léxico
//public class Lexer {
//    int line = 1;
//    private char peek = ' ';
//    private final HashMap<String, Identifier> words = new HashMap<>();
//
//    public Lexer() {
//        reserve(new Identifier(TokenType.TRUE, "true"));
//        reserve(new Identifier(TokenType.FALSE, "false"));
//    }
//
//    public Token scan() throws IOException {
//        readNext();
//        for (; ; readNext()) {
//            if (peek == ' ' || peek == '\t') {
//            } else if (peek == '\n') {
//                line = line + 1;
//            } else break;
//        }
//        if (Character.isDigit(peek)) {
//            int v = 0;
//            do {
//                v = v * 10 + Character.digit(peek, 10); //char to its numeric value
//                readNext();
//            } while (Character.isDigit(peek));
//            return new IntegerLiteral(v);
//        }
//        if (Character.isLetter(peek)) {
//            StringBuffer b = new StringBuffer();
//            do {
//                b.append(peek);
//                readNext();
//            } while (Character.isLetterOrDigit(peek));
//            String s = b.toString();
//            Identifier w = words.get(s);
//            if (w != null) {
//                return w;
//            }
//            w = new Identifier(TokenType.ID, s);
//            reserve(w);
//            return w;
//        }
//        Token t = new Token(peek);
//        peek = ' ';
//        return t;
//    }
//
//    private void readNext() throws IOException {
//        peek = (char) System.in.read();
//    }
//
//    void reserve(Identifier w) {
//        words.put(w.lexeme, w);
//    }
//}
