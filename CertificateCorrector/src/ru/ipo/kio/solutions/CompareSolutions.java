package ru.ipo.kio.solutions;

import java.io.File;
import java.io.FilenameFilter;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 22.03.13
 * Time: 15:54
 */
public class CompareSolutions {
    public static void main(String[] args) {
        File solsDir = new File("/home/ilya/kio-baks/18 mar final solutions");
        File tmpDir = new File("/home/ilya/kio-baks/18 mar final solutions/tmp");
        File outDir = new File("/home/ilya/kio-baks/18 mar final solutions/merged");

        outDir.mkdirs();

        File[] sols = solsDir.listFiles(new KioFilesFilter());
        File[] tmps = tmpDir.listFiles(new KioFilesFilter());

        Set<String> allSols = new HashSet<String>();
        for (File sol : sols)
            allSols.add(sol.getName());

        for (File tmp : tmps)

    }

    private static class KioFilesFilter implements FilenameFilter {

        public boolean accept(File dir, String name) {
            return name.endsWith("kio-0") || name.endsWith("kio-1") || name.endsWith("kio-2");
        }
    }

//    private copyFile
}

