package ru.ipo.kio.diplomas;

import com.itextpdf.text.pdf.PdfContentByte;

import java.io.File;

/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 07.05.13
 * Time: 20:43
 */
public class OneProblemDiplomaFormatter extends DiplomaFormatter {

    //level 0, cut 811, blocks 801 clock 815
    //level 1, cut 817, blocks 817 clock 817
    //level 2, cut 672, blocks 664 clock 673

    private static final int[][] MAX_SCORES = {{0, 811, 801, 815}, {0, 817, 817, 817}, {0, 672, 664, 673}};
    private static final int[] PROBLEM_CSV_POSITION = {0, 7, 12, 19};
    private static final String[][] PROBLEM_NAME = {null,
            {"Разрезание", "Меньше отходов!", "Оптимальный раскрой"},
            {"Кран", "Кран-автомат", "Погрузка контейнеров"},
            {"Часы", "Часы-ежедневник", "Часы-календарь"}
    };

    private final int level;
    private final int problem;

    public OneProblemDiplomaFormatter(int level, int problem) {
        this.level = level;
        this.problem = problem;
    }

    @Override
    public File getBgImage() {
        return new File("resources/images/Diploma-problem-" + level + ".png");
    }

    @Override
    public void format(PdfContentByte canvas, String[] csvLine) {
        String surname = csvLine[21].toUpperCase();
        String name = csvLine[22].toUpperCase();
        int scores = Integer.parseInt(csvLine[PROBLEM_CSV_POSITION[problem]]);
        String problemName = PROBLEM_NAME[problem][level];
        int maxScores = MAX_SCORES[level][problem];
        String info = String.format("Задача «%s» – %s из %s", problemName, inflectWord(scores, "балл", "балла", "баллов"), inflectWord(maxScores, "возможного", "возможных", "возможных"));

        drawCenteredText(canvas, DiplomaGenerator.NAME_FONT, surname + " " + name, 30, 117);
        drawCenteredText(canvas, DiplomaGenerator.INFO_FONT, info, 11, 109);
    }
}
