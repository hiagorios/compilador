import lexer.Lexer;
import java.io.*;

public class SyntacticAnalyzer {

    public static void main(String[] args) {
        Lexer scanner = null;
        String file = args[1];
        try {
            FileInputStream stream = new java.io.FileInputStream(file);
            Reader reader = new java.io.InputStreamReader(stream);
            scanner = new Lexer(reader);
            do {
                System.out.println(scanner.yylex());
            } while (!scanner.isEndOfFile());

        }
        catch (java.io.FileNotFoundException e) {
            System.out.println("File not found : \""+file+"\"");
        }
        catch (java.io.IOException e) {
            System.out.println("IO error scanning file \""+file+"\"");
            System.out.println(e);
        }
        catch (Exception e) {
            System.out.println("Unexpected exception:");
            e.printStackTrace();
        }
    }
}
