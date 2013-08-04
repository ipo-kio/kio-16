package ru.ipo.kio.certificate;

import java.io.*;

/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 09.06.13
 * Time: 21:52
 */
public class DoDumbSolutions65 {
    public static void main(String[] args) throws Exception {
        File vurda = new File("CertificateCorrector/resources/65/bolshaya_vurda.csv");
        BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(vurda), "windows-1251"));
        String line;
        int level = 3;
        boolean betweenLevels = true;
        while ((line = in.readLine()) != null) {
            if (line.startsWith(";;;")) {
                if (!betweenLevels)
                    betweenLevels = true;
                continue;
            }
            if (betweenLevels) {
                level --;
                betweenLevels = false;
                continue;
            }

            createSolutionFromLine(level, line);
        }
    }

    private static void createSolutionFromLine(int level, String line) throws Exception {
        String[] data = line.split(";");
        PrintStream out = new PrintStream(new File("CertificateCorrector/resources/65/" + data[0] + ".kio"), "windows-1251");
        out.print(level);
        out.print(';');
        out.println(line);
        out.close();
    }

}
