package ru.ipo.kio.diplomas;

import com.itextpdf.text.pdf.PdfContentByte;

import java.io.File;

/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 07.05.13
 * Time: 20:43
 */
public class DegreeDiplomaFormatter extends DiplomaFormatter {

    private final int level;
    private final int degree;

    public DegreeDiplomaFormatter(int level, int degree) {
        this.level = level;
        this.degree = degree;
    }

    @Override
    public File getBgImage() {
        String degreeS = "";
        switch (degree) {
            case 1:
            case 2:
            case 3:
                for (int i = 0; i < degree; i++)
                    degreeS += "I";
                break;
            case 4:
                degreeS = "IV";
                break;
            case 5:
                degreeS = "V";
        }

        return new File("resources/images/Diploma_" + degreeS + "_" + level + ".png");
    }

    @Override
    public void format(PdfContentByte canvas, String[] csvLine) {
        String surname = csvLine[21].toUpperCase();
        String name = csvLine[22].toUpperCase();
        if (degree <= 3)
            drawCenteredText(canvas, DiplomaGenerator.NAME_FONT, surname + " " + name, 30, 104);
        else
            drawCenteredText(canvas, DiplomaGenerator.NAME_FONT, surname + " " + name, 30, 113);
    }

    @Override
    public boolean accepts(String[] csvLine) {
        return csvLine[28].trim().equals(degree + "");
    }
}