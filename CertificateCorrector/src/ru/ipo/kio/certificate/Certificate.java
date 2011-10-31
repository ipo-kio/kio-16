package ru.ipo.kio.certificate;

import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.json.simple.parser.ParseException;

import javax.swing.*;
import java.io.*;

/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 03.05.11
 * Time: 16:04
 */
public class Certificate {

    private File file;
    private final String CERT_FIELD = "json_certificate";

    private String certificateAsString;

    public Certificate(File cert) {
        this.file = cert;
        load();
    }

    public Certificate(File cert, boolean createNew) {
        this.file = cert;
        if (!createNew)
            load();
        else
            createNew("ФАМИЛИЯ", "ИМЯ", "ОТЧЕСТВО", "Должность");
    }

    public Certificate(File file, String surname, String name, String furname, String position) {
        this.file = file;
        createNew(surname, name, furname, position);
    }

    @SuppressWarnings({"unchecked"})
    private void createNew(String surname, String name, String furname, String position) {
        JSONObject cert = new JSONObject();

        JSONObject anketa = new JSONObject();
        anketa.put("surname", surname);
        anketa.put("name", name);
        anketa.put("second_name", furname);

        cert.put("_anketa", anketa);
        cert.put("_is_teacher", true);
        cert.put("_position", position);

        certificateAsString = cert.toJSONString();
    }

    private void load() {
        try {
            JSONObject obj = (JSONObject) JSONValue.parseWithException(new InputStreamReader(new FileInputStream(file), "UTF-8"));
            certificateAsString = (String) obj.get(CERT_FIELD);
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Не удалось прочитать файл " + file);
        }
    }

    public String getCertificateAsString(boolean wrapLines) {
        if (!wrapLines)
            return certificateAsString;

        StringBuilder res = new StringBuilder();
        char prev = 0;
        boolean inside = false;
        for (int i = 0; i < certificateAsString.length(); i++) {
            char c = certificateAsString.charAt(i);
            if (c == '"' && prev != '\\') {
                if (!inside && prev != ':')
                    res.append("\n");
                inside = !inside;
            }
            res.append(c);
            prev = c;
        }

        return res.toString();
    }

    public void save(String text) throws ParseException, IOException {
        //try parse to test if it is a correct certificate
        JSONObject innerCert = (JSONObject) JSONValue.parseWithException(text);

        certificateAsString = innerCert.toJSONString();

        save();
    }

    //wtf rewrite this f.s.
    public void save(File file) throws ParseException, IOException {
        File oldFile = this.file;
        this.file = file;
        save();
        this.file = oldFile;
    }

    @SuppressWarnings({"unchecked"})
    public void save() throws IOException {
        JSONObject cert = new JSONObject();
        cert.put(CERT_FIELD, certificateAsString);
        String SIGN_FIELD = "signature";
        cert.put(SIGN_FIELD, sign(certificateAsString));

        //save data to file
        FileOutputStream out = new FileOutputStream(file);
        out.write(cert.toJSONString().getBytes("UTF-8"));
        out.close();
    }

    private int sign(String s) throws UnsupportedEncodingException {
        byte[] rawBytes = s.getBytes("UTF-8");
        byte[] bytes = new byte[rawBytes.length + 2];
        bytes[0] = (byte) (rawBytes.length / 256);
        bytes[1] = (byte) (rawBytes.length % 256);
        System.arraycopy(rawBytes, 0, bytes, 2, rawBytes.length);

        int res = 0;
        for (byte b : bytes) {
            res *= 19;
            res += b + 256;
            res %= 1299709;
        }
        return res;
    }

    @SuppressWarnings({"unchecked"})
    public void setAnketa(JSONObject anketa) {
        JSONObject cert = (JSONObject) JSONValue.parse(certificateAsString);
        cert.put("_anketa", anketa);
        certificateAsString = cert.toJSONString();
    }
}
