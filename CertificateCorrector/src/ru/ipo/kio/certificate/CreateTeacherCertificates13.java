package ru.ipo.kio.certificate;

import org.w3c.dom.CharacterData;
import org.w3c.dom.*;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 08.05.11
 * Time: 23:40
 */
public class CreateTeacherCertificates13 {

    public static String VINTAGE;

    public static void main(String[] args) throws ParserConfigurationException, IOException, SAXException {
        VINTAGE = "sdf";
        String TEACHER_CERTS_OUTPUT = "resources/teacher-certs";
        String TEACHERS_TABLE = "resources/teachers.xml";

        new File(TEACHER_CERTS_OUTPUT).mkdirs();
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = dbf.newDocumentBuilder();
        Document document = builder.parse(new File(TEACHERS_TABLE));

        NodeList k11_reg_users = document.getDocumentElement().getElementsByTagName("row");
        for (int i = 0; i < k11_reg_users.getLength(); i++) {
            Element teacher = (Element) k11_reg_users.item(i);
            String login = getContents(teacher.getElementsByTagName("login").item(0));
            String surname = getContents(teacher.getElementsByTagName("surname").item(0));
            String name = getContents(teacher.getElementsByTagName("name").item(0));
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

        ArrayList<String> data = new ArrayList<>();

        //try add school name
        NodeList school_type = teacher.getElementsByTagName("sch_type");
        String school_type_value = getContents(school_type.item(0));
        if (school_type_value != null && !school_type_value.equals("") && !school_type_value.equals("0")) {
            String schoolDescription = getSchoolDescription(teacher);
            if (schoolDescription != null)
                data.add(schoolDescription);
        }

        //try add city name
        NodeList cityList = teacher.getElementsByTagName("city_name");
        String city = getContents(cityList.item(0));
        NodeList cityTypeList = teacher.getElementsByTagName("city_type");
        String cityType = getContents(cityTypeList.item(0));
        NodeList regionList = teacher.getElementsByTagName("reg_name");
        String regionFullName = getContents(regionList.item(0));

        String cityFullName;
        if (cityType == null)
            cityFullName = null;
        else
            switch (cityType) {
                case "1":
                    cityFullName = "г.";
                    break;
                case "2":
                    cityFullName = "с.";
                    break;
                case "3":
                    cityFullName = "дер.";
                    break;
                case "4":
                    cityFullName = "пос.";
                    break;
                default:
                    cityFullName = null;
                    break;
            }

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
        System.out.print(data.size());
        System.out.println(result);
        if (data.size() <= 1)
            System.out.println("------------------------------------------------");
        System.out.println();
        return result;
    }

    private static String getSchoolDescription(Element teacher) {
        //get school type + number
        NodeList schoolType = teacher.getElementsByTagName("sch_type");
        if (schoolType.getLength() == 0)
            return null;
        String type = getContents(schoolType.item(0));
        String result;
        switch (type) {
            case "1":
                result = "Школа";
                break;
            case "2":
                result = "Гимназия";
                break;
            case "3":
                result = "Лицей";
                break;
            case "4":
                result = "Колледж";
                break;
            default:
                return null;
        }
        result += " №";

        NodeList schoolNumber = teacher.getElementsByTagName("sch_number");
        if (schoolNumber.getLength() == 0)
            return null;

        String schNumberVal = getContents(schoolNumber.item(0));

        if (schNumberVal.equals("0"))
            result = getContents(teacher.getElementsByTagName("sch_name").item(0));
        else
            result += schNumberVal;

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
