package ru.ipo.kio.diplomas;

import com.itextpdf.text.Element;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.Utilities;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfContentByte;

import java.io.File;

/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 07.05.13
 * Time: 20:18
 */
public abstract class DiplomaFormatter {

    public abstract File getBgImage();
    public abstract void format(PdfContentByte canvas, String[] csvLine);

    public void drawCenteredText(PdfContentByte canvas, BaseFont font, String text, float fontSize, float top) {
        Rectangle pageSize = canvas.getPdfDocument().getPageSize();

        canvas.setFontAndSize(font, fontSize);
//        canvas.setLineWidth(Utilities.millimetersToPoints(0.2f));
//        canvas.setGrayStroke(0.15f);
//        canvas.setTextRenderingMode(PdfContentByte.TEXT_RENDER_MODE_FILL_STROKE);
        canvas.setTextRenderingMode(PdfContentByte.TEXT_RENDER_MODE_FILL_CLIP);
        canvas.showTextAligned(Element.ALIGN_CENTER, text, pageSize.getWidth() / 2, Utilities.millimetersToPoints(top), 0);
    }

    public String inflectWord(int number, String type1, String type2, String type3) {
        int n = Math.abs(number);
        String word = type3;
        int a = n / 10 % 10;
        int b = n % 10;

        if (a != 1)
            if (b == 1)
                word = type1;
            else if (b == 2 || b == 3 || b == 4)
                word = type2;


        return number + " " + word;
    }

    public abstract boolean accepts(String[] csvLine);
}
