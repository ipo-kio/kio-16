package ru.ipo.kio.solutions;

import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

import java.io.*;
import java.util.Collections;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 22.03.13
 * Time: 15:54
 */
public class CompareSolutions {
    public static void main(String[] args) throws Exception {
        File solsDir = new File("/home/ilya/kio-baks/18 mar final solutions");
        File tmpDir = new File("/home/ilya/kio-baks/18 mar final solutions/tmp-process");
        File outDir = new File("/home/ilya/kio-baks/18 mar final solutions/merged");

        outDir.mkdirs();

        String[] sols = solsDir.list(new KioFilesFilter());
        String[] tmps = tmpDir.list(new KioFilesFilter());

        Set<String> allSols = new HashSet<>();
        Collections.addAll(allSols, sols);

        for (String tmp : tmps)
            if (allSols.contains(tmp)) {
                File tmpFile = new File(tmpDir, tmp);
                Map<String, Object> tmpAnketa = extractAnketa(tmpFile);

                File solFile = new File(solsDir, tmp);
                Map<String, Object> solAnketa = extractAnketa(solFile);

                System.out.println("same: " + tmp);
                String cmpFiles = compareFiles(tmpFile, solFile);
                System.out.println("compare files: " + cmpFiles);
                String cmpAnketas = compareAnketas(tmpAnketa, solAnketa);
                System.out.println("compare anketas: " + cmpAnketas);
                String cmpHist = compareHistories(tmpFile, solFile);
                System.out.println("compare histories: " + cmpHist);

                if (!cmpAnketas.equals("same")) {
                    System.out.println(" --> tmp anketa:");
                    printAnketa(tmpAnketa);
                    System.out.println(" --> sol anketa");
                    printAnketa(solAnketa);
                }

                //remove same files
                if (cmpFiles.equals("same files"))
                    tmpFile.delete();

                //remove tmp files with the same anketa and when tmp history is shorter than sol history
                if (cmpAnketas.equals("same") && cmpHist.equals("sol history extends tmp history"))
                    tmpFile.delete();

                //merge tmp files with the same anketa and when sol history is shorter than tmp history
                if (cmpAnketas.equals("same") && cmpHist.equals("tmp history extends sol history"))
                    moveToOut(outDir, tmp, tmpFile, "lh");

                if (cmpAnketas.equals("differ in name"))
                    tmpFile.delete();

                //now there are 3 persons with "sol history extends tmp history"
                if (cmpHist.equals("sol history extends tmp history"))
                    tmpFile.delete();

                //no log: 2 situations: spb-0183-016bk-3.kio-2 - no solution at all, kmr-0024-010b-1.kio-0 - tmp is better
                if (cmpHist.equals("sol has NO LOG"))
                    moveToOut(outDir, tmp, tmpFile, "nl");

                System.out.println("-----------------------------------------------------");
            }

        System.out.println("----------------------SINGLE-------------------------");
        System.out.println("-----------------------------------------------------");

        Set<String> foundElsewhere = new HashSet<String>(){{
            add("len-0015-040bk-28.kio-1");
            add("-0014-055bk-20.kio-2");
            add("spb-0273-026-3.kio-0");
            add("spb-0051-020bk-20.kio-1");
            add("nvs-0010-050-32.kio-0");
            add("-0014-055bk-17.kio-2");
            add("-0014-055bk-21.kio-2");
            add("-0014-055bk-16.kio-2");
            add("len-0015-040bk-29.kio-1");
            add("spb-0149-044bk-28.kio-2");
        }};

        for (String tmp : tmps)
            if (! allSols.contains(tmp)) {
                File tmpFile = new File(tmpDir, tmp);
                Map<String, Object> tmpAnketa = extractAnketa(tmpFile);

                System.out.println("single: " + tmp);

                printAnketa(tmpAnketa);

                System.out.println("-----------------------------------------------------");

                if (foundElsewhere.contains(tmp))
                    tmpFile.delete();
                else
                    moveToOut(outDir, tmp, tmpFile, "sng");
            }
    }

    private static void moveToOut(File outDir, String tmp, File tmpFile, String label) {
        File dest = new File(outDir, tmp);
        File destNew = new File(outDir, "[" + label + "]" + tmp);
        dest.delete();
        if (!tmpFile.renameTo(destNew))
            System.out.println("FAILED TO MOVE FILE");
    }

    private static String compareHistories(File tmpFile, File solFile) throws IOException {
        try (
                InputStreamReader tmpIn = new InputStreamReader(new FileInputStream(tmpFile), "UTF-8");
                InputStreamReader solIn = new InputStreamReader(new FileInputStream(solFile), "UTF-8")
        ) {
            JSONObject tmpObj = (JSONObject) JSONValue.parse(tmpIn);
            JSONObject solObj = (JSONObject) JSONValue.parse(solIn);
            if (((JSONObject) solObj.get("kio_base")).get("log") == null)
                return "sol has NO LOG";
            String tmpHist = (String) ((JSONObject) ((JSONObject) ((JSONObject) tmpObj.get("kio_base")).get("log")).get("data")).get("base64");
            String solHist = (String) ((JSONObject) ((JSONObject) ((JSONObject) solObj.get("kio_base")).get("log")).get("data")).get("base64");

            if (tmpHist.equals(solHist))
                return "same";

            tmpHist = tmpHist.substring(0, tmpHist.length() - 4);
            solHist = solHist.substring(0, solHist.length() - 4);

            if (tmpHist.startsWith(solHist))
                return "tmp history extends sol history";

            if (solHist.startsWith(tmpHist))
                return "sol history extends tmp history";

            return "hitories are incompareble";
        }
    }

    /*
    FOUND AS len-0015-040bk-28.kio-1
    single:  len-0015-040bk-32.kio-1
    Роман Куандыков Рамильевич
    7а
    Kuandykov.roman@mail.ru
    Мбоу Лицей №8
    г.Сосновый Бор, Лен. область, ул. Ленинградская, д. 9 188541

    FOUND AS -0014-055bk-20.kio-2 (Хиль Тимофей Сергеевич)
    single:  -0014-055bk-22.kio-2
    Т Хиль В
    8
    scho5@rambler.ru
    МБОУ СОШ №1
    г. Биробиджан

    FOUND AS spb-0273-026-3.kio-0
    single:  spb-0273-026-1.kio-0
    АЛЕКСАНДР НАРЫЖНЫЙ Игоревич
    10
    milushka_2010@mai.ru
    школа № 556
    197706,г. Санкт-Петербург, Сестрорецк-6,ул.Токарева, д.20

    FOUND AS spb-0051-020bk-20.kio-1 (+)
    single:  spb-0051-020bk-16.kio-1
    КОНСТАНТИН ЗАХАРЦЕВ ВИКТОРОВИЧ
    5в
    kadkorkomp@mail.ru
    ФГКОУ санкт-питербургский кадетский корпус МО РФ
    198504 Санкт-Питербург, Петродворец. ул. суворовская д. 1

    FOUND AS nvs-0010-050-32.kio-0 (+)
    single: nvs-0010-050-33.kio-0
    НИКИТА ЕГОРЕНКО ИЛЬИЧ
    4-А
    e_m_p@mail.ru
    школа №25
    630510, Новосибирская обл., д.п. Кудряшовский, ул. Октябрьская 16а

    FOUND AS -0014-055bk-17.kio-2 (+)
    single:  -0014-055bk-9.kio-2
    Анастасия Козлова Олеговна
    9
    Nastya-kz@mail.ru
    МБОУ СОШ №1
    Пушкина-1 кв.35б 679000

    FOUND AS -0014-055bk-21.kio-2  (+)
    single:  -0014-055bk-10.kio-2
    Юлия Уткина Ефимовна
    9б
    ulenka_xdd@mail.ru
    МБОУ СОШ№1
    а

    FOUND AS -0014-055bk-16.kio-2 (+)
    single:  -0014-055bk-11.kio-2
    Лера Шпиль Антоновна
    9 Б
    lera_pva@mail.ru
    МБОУ СОШ № 1
    ул. Советская, 57 д, кв.5. индекс: 679015

    FOUND AS len-0015-040bk-29.kio-1 (+)
    single:  len-0015-040bk-36.kio-1
    Софья Николаева Алексеевна
    7 "А"
    bubu@sbor.net
    МБОУ''Лицей № 8''
    ул.Ленинградская, д.64

    TRASH single: spb-0149-044bk-28.kio-2
     */

    /*
    can not understand:

    [mrg] svd-0053-025-17.kio-0 //blocks better in tmp, cut better in sol, but anyway all sols are trash
    [mrg] dlr6042-0001-035-3.kio-0 //blocks better in tmp
    [tmp] spb-0005-042-21.kio-0 //tmp is better

    [mrg] spb-0273-026-21.kio-1 //blocks better in sol, cut better in tmp, clock better in tmp
    len-0023-057-46.kio-1 //same
    [mrg] spb-0051-020bk-14.kio-1 //cuts better in tmp, blocks better in sol

    [mrg] prm-0017-003bk-2.kio-2 //cuts better in tmp, blocks better in sol, clocks better in tmp
    [mrg] dlr5709-0001-010-5.kio-2 //cuts better in sol, blocks better in tmp, clocks same
     */

    private static String compareFiles(File tmpFile, File solFile) throws IOException {
        if (tmpFile.length() > solFile.length())
            return "tmp is longer";
        if (tmpFile.length() < solFile.length())
            return "tmp is shorter";

        try (
                BufferedInputStream tmpIn = new BufferedInputStream(new FileInputStream(tmpFile));
                BufferedInputStream solIn = new BufferedInputStream(new FileInputStream(solFile))
        ) {
            while (true) {
                int b1 = tmpIn.read();
                int b2 = solIn.read();
                if (b1 != b2)
                    return "same length but different";
                if (b1 < 0)
                    return "same files";
            }
        }
    }

    private static String compareAnketas(Map<String, Object> tmpAnketa, Map<String, Object> solAnketa) {
        for (String field : new String[]{"name", "surname", "second_name", "email", "inst_name", "address"}) {
            Object tmpField = tmpAnketa.get(field);
            Object solField = solAnketa.get(field);

            if (tmpField instanceof String)
                tmpField = ((String) tmpField).toLowerCase();

            if (solField instanceof String)
                solField = ((String) solField).toLowerCase();

            if (tmpField == null)
                return "null tmp field " + field;

            if (!tmpField.equals(solField))
                return "differ in " + field;
        }

        return "same";
    }

    private static void printAnketa(Map<String, Object> anketa) {
        System.out.println("    " + anketa.get("name") + " " + anketa.get("surname") + " " + anketa.get("second_name"));
        System.out.println("    " + anketa.get("grade"));
        System.out.println("    " + anketa.get("email"));
        System.out.println("    " + anketa.get("inst_name"));
        System.out.println("    " + anketa.get("address"));
    }

    private static Map<String, Object> extractAnketa(File file) throws Exception {
        InputStreamReader in = new InputStreamReader(new FileInputStream(file), "UTF-8");
        JSONObject solution = (JSONObject) JSONValue.parse(in);

        JSONObject anketa = (JSONObject) ((JSONObject) solution.get("kio_base")).get("anketa");

        in.close();

        //noinspection unchecked
        return anketa;
    }

    private static class KioFilesFilter implements FilenameFilter {

        public boolean accept(File dir, String name) {
            return name.endsWith("kio-0") || name.endsWith("kio-1") || name.endsWith("kio-2");
        }
    }

//    private static void copyFile(File fromDir, File toDir, String fname) throws IOException {
//        try (
//                BufferedInputStream in = new BufferedInputStream(new FileInputStream(new File(fromDir, fname)));
//                BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(new File(toDir, fname)))
//        ) {
//            int read;
//            byte[] buf = new byte[4096];
//            while ((read = in.read(buf)) != -1) {
//                out.write(buf, 0, read);
//            }
//        }
//    }

}

