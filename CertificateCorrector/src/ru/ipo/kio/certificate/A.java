package ru.ipo.kio.certificate;

/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 23.05.13
 * Time: 10:35
 */
public class A {

    public static void main(String[] args) {
        int N = 10;
        int num = pow(3, N);
        int aaa = 0;
        int abc = 0;
        for (int x = 0; x < num; x++) {
            String s = Integer.toString(x, 3);
            while (s.length() < N)
                s = "0" + s;

            if (s.contains("000"))
                aaa++;
            if (s.contains("012"))
                abc++;
        }

        System.out.println(num);
        System.out.println(aaa);
        System.out.println(abc);
    }

    public static int pow(int a, int deg) {
        int res = 1;
        for (int i = 0; i < deg; i++)
            res *= a;
        return res;
    }

}
