package kio.certificates;

import com.itextpdf.text.Document;
import com.itextpdf.text.Image;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.Utilities;
import com.itextpdf.text.pdf.PdfWriter;
import com.opencsv.CSVReader;
import kio.KioProblemSet;
import kio._2015.KioProblemsSet2015en;
import kio.checker.UserResults;

import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;

public class Generator {

    private Map<String, String> login2name = new HashMap<>();
    private Map<String, String> login2surname = new HashMap<>();
    private Map<String, String> login2school = new HashMap<>();

    public Generator(String fileWithNameSurnameAndSchool) throws IOException {
        try (CSVReader reader = new CSVReader(new FileReader(fileWithNameSurnameAndSchool))) {
            String[] nextLine;
            while ((nextLine = reader.readNext()) != null) {
                String login = nextLine[0];
                String name = nextLine[1];
                String surname = nextLine[2];
                String school = nextLine[4];

                login2name.put(login, name);
                login2surname.put(login, surname);
                login2school.put(login, school);
            }
        }
    }

    public void run(String outputPath, List<UserResults> users) throws Exception {
        Rectangle documentSize = new Rectangle(
                Utilities.millimetersToPoints(210), Utilities.millimetersToPoints(297)
        );
        Document doc = new Document(
                documentSize,
                0, 0, 0, 0
        );

        PdfWriter writer = PdfWriter.getInstance(doc, new FileOutputStream(outputPath));

        Image bgImage = Image.getInstance("th-certificates/Certificate-en.png");

        bgImage.setAbsolutePosition(0, 0);
        bgImage.scaleAbsolute(documentSize.getWidth(), documentSize.getHeight());

        doc.open();

        for (UserResults user : users) {
            KioCertificate certificate = new KioCertificate(user, new KioProblemsSet2015en(), 2015);
            doc.newPage();
            doc.add(bgImage);

            String login = user.getLogin();

            certificate.draw(
                    writer,
                    login2name.get(login),
                    login2surname.get(login),
                    login2school.get(login)
            );
        }

        doc.close();
    }
}
