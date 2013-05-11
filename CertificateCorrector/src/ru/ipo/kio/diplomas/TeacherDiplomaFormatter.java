package ru.ipo.kio.diplomas;

import com.itextpdf.text.pdf.PdfContentByte;

import java.io.File;

/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 07.05.13
 * Time: 20:43
 */
public class TeacherDiplomaFormatter extends DiplomaFormatter {

    private final int level;
    private final int degree;

    public TeacherDiplomaFormatter(int level, int degree) {
        this.level = level;
        this.degree = degree;
    }

    @Override
    public File getBgImage() {
        return new File("resources/images/Diploma_teacher.png");
    }

    @Override
    public void format(PdfContentByte canvas, String[] csvLine) {
        String name = csvLine[0];
        String school = csvLine[3];

        String place = csvLine[2];

        if (! csvLine[1].trim().equals(""))
            place = csvLine[1] + ", " + place;

        int participants = Integer.parseInt(csvLine[4].trim());

        drawCenteredText(canvas, DiplomaGenerator.NAME_FONT, surname + " " + name, 30, 105);
    }

    @Override
    public boolean accepts(String[] csvLine) {
        return true;
    }
}