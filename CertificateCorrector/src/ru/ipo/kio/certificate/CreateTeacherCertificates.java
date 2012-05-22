package ru.ipo.kio.certificate;

import org.w3c.dom.*;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.*;
import java.util.ArrayList;

/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 08.05.11
 * Time: 23:40
 */
public class CreateTeacherCertificates {

    public static String VINTAGE;

    public static void main(String[] args) throws ParserConfigurationException, IOException, SAXException {
        VINTAGE = "sdf";
        String TEACHER_CERTS_OUTPUT = "/home/ilya/programming/kio-12/solutions/teachers/teacher certs";
        String TEACHERS_TABLE = "/home/ilya/programming/kio-12/solutions/teachers/teachers_clean.xml";

        new File(TEACHER_CERTS_OUTPUT).mkdir();
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = dbf.newDocumentBuilder();
        Document document = builder.parse(new File(TEACHERS_TABLE));

        NodeList k11_reg_users = document.getDocumentElement().getElementsByTagName("k12_reg_users");
        for (int i = 0; i < k11_reg_users.getLength(); i++) {
            Element teacher = (Element) k11_reg_users.item(i);
            String login = getContents(teacher.getElementsByTagName("login").item(0));
            String surname = getContents(teacher.getElementsByTagName("surname").item(0));
            String name = getContents(teacher.getElementsByTagName("_name").item(0));
            String furname = getContents(teacher.getElementsByTagName("patronymic").item(0));

            System.out.println("processing " + login);

            String position = getPosition(teacher);

            Certificate certificate = new Certificate(
                    new File(TEACHER_CERTS_OUTPUT + "/" + login + ".kio-certificate"),
                    surname,
                    name,
                    furname,
                    position,
                    "windows-1251");
            certificate.save();
        }
    }

    private static String getPosition(Element teacher) {
        //return "";
        /*
            1	школа
 	 	 	2	гимназия
 	 	 	3	лицей
 	 	 	4	колледж
 	 	 	5	другое
         */

        /*
        1	город	г.
 	 	 	2	село	с.
 	 	 	3	деревня	дер.
 	 	 	4	поселок	пос.
 	 	 	5	другое
         */

        ArrayList<String> data = new ArrayList<String>();

        //try add school name
        NodeList school_names = teacher.getElementsByTagName("sc_name");
        if (school_names.getLength() == 0) {
            String schoolDescription = getSchoolDescription(teacher);
            if (schoolDescription != null)
                data.add(schoolDescription);
        } else
            data.add(getContents(school_names.item(0)));

        //try add city name
        NodeList cityList = teacher.getElementsByTagName("city");
        String city = getContents(cityList.item(0));
        NodeList cityTypeList = teacher.getElementsByTagName("city_type");
        String cityType = getContents(cityTypeList.item(0));
        NodeList regionList = teacher.getElementsByTagName("fullname");
        String regionFullName = getContents(regionList.item(0));

        String cityFullName;
        if ("1".equals(cityType))
            cityFullName = "г.";
        else if ("2".equals(cityType))
            cityFullName = "с.";
        else if ("3".equals(cityType))
            cityFullName = "дер.";
        else if ("4".equals(cityType))
            cityFullName = "пос.";
        else
            cityFullName = null;

        if (cityFullName != null) {
            cityFullName += " " + city;
            data.add(cityFullName);
        }

        if (regionFullName != null && !regionFullName.equals(city) && cityFullName != null)
            data.add(regionFullName);

        String result = "";
        for (String d : data) {
            /*if (i > 0)*/
            result += "\n";
            result += d;
        }
        System.out.println(data.size());
        if (data.size() <= 1)
            System.out.println("------------------------------------------------");
        return result;
    }

    private static String getSchoolDescription(Element teacher) {
        //get school type + number
        NodeList schoolType = teacher.getElementsByTagName("type");
        if (schoolType.getLength() == 0)
            return null;
        String type = getContents(schoolType.item(0));
        String result;
        if (type.equals("1"))
            result = "Школа";
        else if (type.equals("2"))
            result = "Гимназия";
        else if (type.equals("3"))
            result = "Лицей";
        else if (type.equals("4"))
            result = "Колледж";
        else
            return null;
        result += " №";

        NodeList schoolNumber = teacher.getElementsByTagName("number");
        if (schoolNumber.getLength() == 0)
            return null;

        result += getContents(schoolNumber.item(0));

        return result;
    }

    private static String getContents(Node node) {
        if (node == null || node.getFirstChild() == null)
            return null;
        return ((CharacterData) node.getFirstChild()).getData();
    }
    /*
SELECT user.login, user._name, user.surname, user.furname, user.school_type, user.school_num, user.school_name, addr.city, addr.city_type, reg.fullname, reg.type
FROM `k11_reg_users` AS user
LEFT JOIN `k11_addresses` AS addr
ON user.school_addr=addr.id
LEFT JOIN `k11_regions_list` as reg
ON addr.region=reg.id
WHERE user.rol_id=4 AND user.is_active=1
     */

}
