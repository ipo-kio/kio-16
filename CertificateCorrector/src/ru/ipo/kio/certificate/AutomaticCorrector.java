package ru.ipo.kio.certificate;

import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.json.simple.parser.ParseException;

import java.io.*;

/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 09.05.11
 * Time: 0:51
 */
public class AutomaticCorrector {

    private static final String ALL_CERTIFICATES_PATH = "/home/ilya/Рабочий стол/all_certificates";
    private static final String CORRECTED_INPUT_PATH = "/home/ilya/Рабочий стол/cert-corrections";
    private static final String CORRECTED_CERTIFICATES_PATH = "/home/ilya/Рабочий стол/cert-corrections-output";

    public static void main(String[] args) throws IOException, ParseException {
        new File(CORRECTED_CERTIFICATES_PATH).mkdir();

        File[] inputs = new File(CORRECTED_INPUT_PATH).listFiles(new FilenameFilter() {
            public boolean accept(File dir, String name) {
                return ! name.contains(" ");
            }
        });

        for (File input : inputs) {
            String name = input.getName();
            String login = name.substring(0, name.indexOf("."));
            File oldCertificate = new File(ALL_CERTIFICATES_PATH + "/" + login + ".kio-certificate");
            Certificate certificate = new Certificate(oldCertificate, "UTF-8");
            certificate.setAnketa(loadAnketaFrom(input));
            certificate.save(new File(CORRECTED_CERTIFICATES_PATH + '/' + login + ".kio-certificate"));
        }
    }

    private static JSONObject loadAnketaFrom(File input) throws IOException, ParseException {
        JSONObject obj = (JSONObject) JSONValue.parseWithException(new InputStreamReader(new FileInputStream(input), "UTF-8"));
        return (JSONObject) ((JSONObject) obj.get("kio_base")).get("anketa");
    }

}
