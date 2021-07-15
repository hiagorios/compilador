package src.token;

public class LogicalOperator extends Token {

    public LogicalOperator(TokenType type, int line, int column) {
        super(type, line, column);
    }

    @Override
    public String toString() {
        return "LogicalOperator{" +
                "type=" + type +
                ", line=" + line +
                ", column=" + column +
                '}';
    }
}
