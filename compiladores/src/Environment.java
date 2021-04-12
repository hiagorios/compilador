import lexer.Word;

import java.util.HashMap;

//Ou escopo
public class Environment {

    private final HashMap<String, Word> words = new HashMap<>();
    protected Environment previous;

    public Environment() {
    }

    public Environment(Environment previous) {
        this.previous = previous;
    }

    public void put(String key, Word word) {
        words.put(key, word);
    }

    public Word get(String key) {
        for (Environment env = this; env != null; env = env.previous) {
            if (env.words.containsKey(key)) {
                return env.words.get(key);
            }
        }
        return null;
    }
}
