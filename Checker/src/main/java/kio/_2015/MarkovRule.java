package kio._2015;

public class MarkovRule {

    private static String extractLeft(String description) {
        int pos = description.indexOf(':');
        String left = description.substring(0, pos);
        if ("S".equals(left))
            left = "";
        return left;
    }

    private static String extractRight(String description) {
        int pos = description.indexOf(':');
        String right = description.substring(pos + 1);
        if ("X".equals(right))
            right = "";
        return right;
    }

    private final char[] left;
    private final char[] right;
    private final int delta;

    public MarkovRule(String left, String right) {
        this.left = left.toCharArray();
        this.right = right.toCharArray();

        this.delta = right.length() - left.length();
    }

    public MarkovRule(String description) {
        this(extractLeft(description), extractRight(description));
    }

    public boolean apply(MarkovString string) {
        if (left.length == 0) {
            substitute(string, 0);
            return true;
        }

        //search entrance
        int lastStart = string.length - left.length;
        char[] symbols = string.symbols;
        start:
        for (int start = 0; start <= lastStart; start++) {
            for (int i = 0; i < left.length; i++)
                if (left[i] != symbols[start +  i])
                    continue start;
            substitute(string, start);
            return true;
        }

        return false;
    }

    private void substitute(MarkovString string, int index) {
        if (string.length + delta > MarkovString.MAX_LENGTH)
            throw new IllegalStateException("Markov line becomes too long");

        int moveFromIndex = index + left.length;
        int moveToIndex = index + right.length;

        if (moveFromIndex != moveToIndex)
            System.arraycopy(string.symbols, moveFromIndex, string.symbols, moveToIndex, string.length - moveFromIndex);

        System.arraycopy(right, 0, string.symbols, index, right.length);
        string.length += delta;
    }

    public String toString() {
        return new String(left) + " -> " + new String(right);
    }
}
