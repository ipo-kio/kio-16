package ru.ipo.kio.diplomas;

import au.com.bytecode.opencsv.CSVWriter;

import java.io.*;

/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 07.05.13
 * Time: 23:16
 */
public class ReadTeachers {

    public static void main(String[] args) throws Exception {
        BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream("resources/teachers.txt"), "UTF-8"));

        CSVWriter out = new CSVWriter(new OutputStreamWriter(new FileOutputStream("resources/teachers.csv"), "windows-1251"), ';', '"');

        out.writeNext(new String[]{"fio", "region", "city", "school", "participants"});

        String line;
        while ((line = in.readLine()) != null) {
            String[] items = line.split(",");

            if (items.length != 4 && items.length != 5) {
                System.out.println(line);
                continue;
            }

            boolean hasRegion = items.length == 5;
            String fio = items[0];
            String region = hasRegion ? items[1] : "";
            String city = hasRegion ? items[2] : items[1];
            String school = hasRegion ? items[3] : items[2];
            String participants = hasRegion ? items[4] : items[3];

            out.writeNext(new String[]{fio.trim(), region.trim(), city.trim(), school.trim(), participants.trim()});
        }

        out.close();
        in.close();
    }

}
