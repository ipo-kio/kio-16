package kio.certificates;

import com.fasterxml.jackson.databind.JsonNode;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Utilities;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfWriter;
import kio.Attempt;
import kio.KioParameter;
import kio.KioProblemSet;
import kio.checker.ProblemResult;
import kio.checker.UserResults;

import java.io.File;
import java.io.IOException;
import java.util.List;

public class KioCertificate {

    public static final String PLUGIN_NAME = "KioDiplomas";
    public static final File R_FONT_FILE = new File("th-certificates/AmbassadoreType.ttf");
    public static BaseFont DEFAULT_FONT_R;
    public static final File I_FONT_FILE = new File("th-certificates/AmbassadoreType Italic.ttf");
    public static BaseFont DEFAULT_FONT_I;
    public static final File R_RESULTS_FONT_FILE = new File("th-certificates/Arial-R.ttf");
    public static BaseFont RESULTS_FONT_R;
    public static final File B_RESULTS_FONT_FILE = new File("th-certificates/Arial-B.ttf");
    public static BaseFont RESULTS_FONT_B;

    private final UserResults user;
    private final KioProblemSet problemSet;
    private final int year;

    static {
        try {
            DEFAULT_FONT_R = BaseFont.createFont(R_FONT_FILE.getAbsolutePath(), BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            DEFAULT_FONT_I = BaseFont.createFont(I_FONT_FILE.getAbsolutePath(), BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            RESULTS_FONT_R = BaseFont.createFont(R_RESULTS_FONT_FILE.getAbsolutePath(), BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            RESULTS_FONT_B = BaseFont.createFont(B_RESULTS_FONT_FILE.getAbsolutePath(), BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        } catch (DocumentException | IOException e) {
            System.out.println("Error in font initialization");
        }
    }

    public KioCertificate(UserResults user, KioProblemSet problemSet, int year) {
        this.user = user;
        this.problemSet = problemSet;
        this.year = year;
    }

    public String bgPath() {
        return "th-certificates/Certificate.png";
    }

    public boolean isHonored() {
        return true;
    }

    private String getLevelAsString() {
        switch (user.getLevel()) {
            case 0:
                return "0";
            case 1:
                return "I";
            case 2:
                return "II";
        }
        return "0";
    }

    public static String surnameName(String name, String surname) {
        return String.format("%s %s", surname, name).toUpperCase();
    }

    public static void drawUserFrom(PdfContentByte canvas, UserResults user, float y0, String name, String surname, String school) {
        String schoolLine = school;

        if (schoolLine == null)
            schoolLine = "";

        schoolLine = schoolLine.replaceAll("  ", " ").replaceAll("[\n\r]+", " ");

        canvas.setFontAndSize(DEFAULT_FONT_R, 12);
        canvas.showTextAligned(Element.ALIGN_CENTER, schoolLine, Utilities.millimetersToPoints(105), Utilities.millimetersToPoints(y0), 0);
//        canvas.showTextAligned(Element.ALIGN_CENTER, addressLine, Utilities.millimetersToPoints(105), Utilities.millimetersToPoints(y0 - 5), 0);
    }

    private int getScoresForProblem(String pid) {
        return user.getProblemResult(pid).getScores();
    }

    private String ordinal(int number) {
        switch (number % 10) {
            case 1:
                return number + "st";
            case 2:
                return number + "nd";
            case 3:
                return number + "rd";
            default:
                return number + "th";
        }
    }

    private boolean hasAtLeastOneSolution() {
        for (String pid : problemSet.getProblemIds(user.getLevel()))
            if (getScoresForProblem(pid) != 0)
                return true;

        return false;
    }

    public void draw(PdfWriter writer, String name, String surname, String school) {
        PdfContentByte canvas = writer.getDirectContent();
        canvas.saveState();
        canvas.beginText();

        canvas.setTextRenderingMode(PdfContentByte.TEXT_RENDER_MODE_FILL_CLIP);

        canvas.setFontAndSize(DEFAULT_FONT_R, 24);
        canvas.showTextAligned(Element.ALIGN_CENTER, surnameName(name, surname), Utilities.millimetersToPoints(105), Utilities.millimetersToPoints(161), 0);

        drawUserFrom(canvas, user, 156, name, surname, school);

        canvas.setFontAndSize(DEFAULT_FONT_R, 17);
        canvas.showTextAligned(Element.ALIGN_CENTER, "Saint Petersburg " + year, Utilities.millimetersToPoints(105), Utilities.millimetersToPoints(3), 0);

        if (hasAtLeastOneSolution()) {
            /*
            String levelInfo = "and took in the ranking ( " + getLevelAsString() + " level )";
            canvas.showTextAligned(Element.ALIGN_LEFT, levelInfo, Utilities.millimetersToPoints(60), Utilities.millimetersToPoints(124), 0);

            int level = getLevel();
            String placeInfo = String.format("%s place of %s", getResult("rank"), factory.getParticipantsByLevels().get(level));
            canvas.showTextAligned(Element.ALIGN_CENTER, placeInfo, Utilities.millimetersToPoints(105), Utilities.millimetersToPoints(117), 0);
            */

            outputProblemsResult(canvas);
        }

        canvas.endText();
        canvas.restoreState();
    }

    private void outputProblemsResult(PdfContentByte canvas) {
        canvas.setFontAndSize(RESULTS_FONT_B, 11);

        float y0 = 111;
        float lineSkip = 4.7f;
        float x0 = 19;
        float x1 = 141;

        int level = user.getLevel();

        for (String pid : problemSet.getProblemIds(level)) {
            String title = String.format("Result in problem \"%s\"", problemSet.getProblemName(level, pid));
            canvas.showTextAligned(Element.ALIGN_LEFT, title, Utilities.millimetersToPoints(x0), Utilities.millimetersToPoints(y0), 0);

            List<KioParameter> fields = problemSet.getParams(level, pid);
            String[] fieldsValues = new String[fields.size()];
            for (int i = 0; i < fields.size(); i++) {
                String field = fields.get(i).getId();
                fieldsValues[i] = getResult(pid, field);
            }

            int rank = user.getProblemResult(pid).getRank();
            int scores = user.getProblemResult(pid).getScores();

            String resultsFormat = problemSet.getCertificatePattern(level, pid);
            String resultsText = String.format(resultsFormat, (Object[]) fieldsValues);
            if (!resultsText.contains("\n"))
                resultsText = String.format("%s place\n(%s)", ordinal(rank), resultsText);
            else
                resultsText = String.format("%s place (%s)", ordinal(rank), resultsText);

            if (scores == 0)
                resultsText = "-";

            int breakIndex = resultsText.indexOf('\n');
            String line1 = breakIndex < 0 ? resultsText : resultsText.substring(0, breakIndex);
            String line2 = breakIndex < 0 ? "" : resultsText.substring(breakIndex + 1);


            canvas.showTextAligned(Element.ALIGN_LEFT, line1, Utilities.millimetersToPoints(x1), Utilities.millimetersToPoints(y0), 0);
            canvas.showTextAligned(Element.ALIGN_LEFT, line2, Utilities.millimetersToPoints(x1), Utilities.millimetersToPoints(y0 - lineSkip), 0);

            y0 -= 2.3 * lineSkip;
        }
    }

    private String getResult(String pid, String field) {
        ProblemResult problemResult = user.getProblemResult(pid);
        Attempt a = problemResult.getBelievedAttempt();
        if (a == null)
            return "-";

        JsonNode result = a.getResult();

        if (result == null) {
            System.out.println("WARNING! null result: " + user.getLogin());
            return "-";
        }

        return result.get(field).asText();
    }
}
