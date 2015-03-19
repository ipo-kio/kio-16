package kio.checker;

import org.jopendocument.dom.spreadsheet.Sheet;
import org.jopendocument.dom.spreadsheet.SpreadSheet;

import javax.swing.table.DefaultTableModel;
import java.io.File;
import java.io.IOException;
import java.util.*;

public class Table {

    public static void saveToFile(File file, Table... tables) throws IOException {
        SpreadSheet ss = SpreadSheet.create(tables.length, 1, 1);
        int tableId = 0;
        for (Table table : tables) {
            Sheet sh = ss.getSheet(tableId);
            sh.setName(table.pageName);

            sh.setColumnCount(1 + table.fields.size());
            sh.setRowCount(1 + table.values.size());

            sh.setValueAt(table.idFieldName, 0, 0);
            int colId = 1;
            for (String field : table.fields) {
                sh.setValueAt(field, colId, 0);
                colId++;
            }

            int rowId = 1;
            for (Map.Entry<String, Map<String, Object>> entry : table.values.entrySet()) {
                String id = entry.getKey();
                Map<String, Object> fieldValues = entry.getValue();

                sh.setValueAt(id, 0, rowId);

                colId = 1;
                for (String field : table.fields) {
                    sh.setValueAt(fieldValues.get(field), colId, rowId);
                    colId++;
                }

                rowId++;
            }

            tableId ++;
        }

        ss.saveAs(file);
    }

    private String pageName;
    private String idFieldName;
    private Set<String> fields = new LinkedHashSet<>();
    private Map<String, Map<String, Object>> values = new LinkedHashMap<>(); //id -> field -> value

    public Table(String pageName, String idFieldName) {
        this.pageName = pageName;
        this.idFieldName = idFieldName;
    }

    public void set(String id, String field, String value) {
        ensureFieldExists(field);

        Map<String, Object> field2value = values.get(id);
        if (field2value == null) {
            field2value = new HashMap<>();
            values.put(id, field2value);
        }

        field2value.put(field, value);
    }

    private void ensureFieldExists(String field) {
        if (!fields.contains(field))
            fields.add(field);
    }

    public void saveToFile(File file) throws IOException {
        DefaultTableModel model = getModelForPage();
        SpreadSheet ss = SpreadSheet.createEmpty(model);
        ss.getFirstSheet().setName(pageName);

        ss.saveAs(file);
    }

    private DefaultTableModel getModelForPage() {
        DefaultTableModel model = new DefaultTableModel(values.size(), 1 + fields.size());

        LinkedList<String> ll = new LinkedList<>(fields);
        ll.add(0, idFieldName);
        model.setColumnIdentifiers(ll.toArray());

        int rowIndex = 0;
        for (Map.Entry<String, Map<String, Object>> valuesEntry : values.entrySet()) {
            String id = valuesEntry.getKey();
            Map<String, Object> valuesLine = valuesEntry.getValue();

            model.setValueAt(id, rowIndex, 0);

            int colIndex = 0;
            for (String field : fields) {
                model.setValueAt(valuesLine.get(field), rowIndex, colIndex);
                colIndex++;
            }

            rowIndex++;
        }
        return model;
    }
}
