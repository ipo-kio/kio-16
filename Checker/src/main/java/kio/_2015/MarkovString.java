package kio._2015;

import java.util.Arrays;

public class MarkovString {

    public static final int MAX_LENGTH = 10240;

    public final char[] symbols = new char[MAX_LENGTH];
    public int length;

    public MarkovString(String initial) {
        length = initial.length();
        System.arraycopy(initial.toCharArray(), 0, symbols, 0, length);
    }

    public boolean equalsToString(String value) {
        if (value.length() != length)
            return false;
        for (int i = 0; i < length; i++)
            if (value.charAt(i) != symbols[i])
                return false;
        return true;
    }

    @Override
    public String toString() {
        return new String(Arrays.copyOf(symbols, length));
    }
}
