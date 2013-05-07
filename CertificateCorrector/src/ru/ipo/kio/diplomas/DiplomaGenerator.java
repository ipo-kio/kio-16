package ru.ipo.kio.diplomas;

import au.com.bytecode.opencsv.CSVReader;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfWriter;

import java.io.*;

/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 07.05.13
 * Time: 17:47
 */
public class DiplomaGenerator {

    public static final BaseFont NAME_FONT;
    public static final BaseFont INFO_FONT;

    static {
        try {
            NAME_FONT = BaseFont.createFont("resources/images/AmbassadoreType.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            INFO_FONT = BaseFont.createFont("resources/images/arial_bold.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        } catch (Exception e) {
            throw new IllegalArgumentException();
        }
    }

    public static void main(String[] args) throws Exception {
        //generate one problem diploma
        for (int level = 0; level <= 2; level++)
            for (int problem = 1; problem <= 3; problem ++) {
                String numberPrefix = "KIO-01-" + level + problem + "-"; //01 - diplomas for separate problems
                File csvInput = new File("resources/kio-results-" + level + "-" + problem + ".csv");
                File pdfOutput = new File("resources/pdf/kio-results-" + level + "-" + problem + ".pdf");
                outputDiplomas(csvInput, pdfOutput, new OneProblemDiplomaFormatter(level, problem), numberPrefix);
            }
    }

    private static void outputDiplomas(File csvInput, File outputPdf, DiplomaFormatter formatter, String numberPrefix) throws IOException, DocumentException {
        Document doc = null;
        try {
            doc = new Document(
                    new Rectangle(
                            Utilities.millimetersToPoints(210), Utilities.millimetersToPoints(297)
                    ),
                    0, 0, 0, 0
            );
            PdfWriter writer = PdfWriter.getInstance(doc, new FileOutputStream(outputPdf));

            Image bgImage = Image.getInstance(formatter.getBgImage().getAbsolutePath());
            bgImage.setAbsolutePosition(0, 0);
            bgImage.scaleAbsolute(Utilities.millimetersToPoints(210), Utilities.millimetersToPoints(297));

            doc.open();

            CSVReader reader = new CSVReader(new InputStreamReader(new FileInputStream(csvInput), "windows-1251"), ';', '"', 1);
            String[] csvLine;
            int diplomaIndex = 2;
            while ((csvLine = reader.readNext()) != null) {
                doc.newPage();
                doc.add(bgImage);

                PdfContentByte canvas = writer.getDirectContent();

                String diplomaNumber = numberPrefix + makeDigits(3, diplomaIndex);

                canvas.saveState();
                canvas.beginText();

                formatter.format(canvas, csvLine);
                formatter.drawCenteredText(canvas, INFO_FONT, "Диплом №" + diplomaNumber, 11, 6);

                canvas.endText();
                canvas.restoreState();

                diplomaIndex ++;
            }

            doc.close();
        } finally {
            if (doc != null)
                doc.close();
        }

    }

    private static String makeDigits(int length, int number) {
        String result = Integer.toString(number);
        while (result.length() < length)
            result = "0" + result;
        return result;
    }

}