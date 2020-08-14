import java.util.*;

public class Globals {
    public static final Map<Character, Character> complements = new HashMap<>();

    static {
        complements.put('A', 'U');
        complements.put('U', 'A');
        complements.put('G', 'C');
        complements.put('C', 'G');
    }
}