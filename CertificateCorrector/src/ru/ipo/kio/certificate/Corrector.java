package ru.ipo.kio.certificate;

import org.json.simple.parser.ParseException;

import javax.swing.*;
import javax.swing.event.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.Arrays;
import java.util.Comparator;

/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 03.05.11
 * Time: 14:05
 */
public class Corrector extends JFrame implements ListSelectionListener, ActionListener {

    private final String EXTENSION = ".kio-certificate";

    private JList files = new JList();
    private JButton save = new JButton("Сохранить");
    private JButton create = new JButton("Создать");
    private JButton selectDir = new JButton("Выбрать директорию");
    private JTextArea input = new JTextArea();
    private File[] certs;
    private Certificate currentCertificate = null;

    public void valueChanged(ListSelectionEvent e) {
        String selectedValue = (String) files.getSelectedValue();
        if (selectedValue == null)
            return;
        //find certificate
        for (File cert : certs)
            if (cert.getName().equals(selectedValue + EXTENSION)) {
                currentCertificate = new Certificate(cert, "windows-1251");
                input.setText(currentCertificate.getCertificateAsString(true));
                save.setEnabled(false);
                return;
            }
    }

    public void actionPerformed(ActionEvent e) {
        if (e.getSource() == save) {

            if (JOptionPane.showConfirmDialog(this, "Подтвердите сохранение сертификата") == JOptionPane.YES_OPTION)
                try {
                    currentCertificate.save(input.getText());
                    save.setEnabled(false);
                } catch (ParseException ex) {
                    int pos = ex.getPosition();
                    JOptionPane.showMessageDialog(this, "Ошибка в синтаксисе в позиции:" + pos);
                    input.moveCaretPosition(pos);
                    input.requestFocusInWindow();
                } catch (IOException ex) {
                    JOptionPane.showMessageDialog(this, "Не удалось сохранить файл.");
                }
        } else if (e.getSource() == selectDir) {
            JFileChooser fc = new JFileChooser();
            if (fc.showOpenDialog(this) != JFileChooser.APPROVE_OPTION)
                return;

            certs = fc.getCurrentDirectory().listFiles(new FilenameFilter() {
                public boolean accept(File dir, String name) {
                    return name.endsWith(EXTENSION);
                }
            });
            updateCertsDir();
        } else if (e.getSource() == create) {
            String login = JOptionPane.showInputDialog(this, "Введите логин учителя");
            if (login == null)
                return;
            //find in certs
            for (File cert : certs) {
                if (cert.getName().equals(login + EXTENSION)) {
                    JOptionPane.showMessageDialog(this, "Сертификат для этого логина уже существует");
                    return;
                }
            }

            File cert = new File(login + EXTENSION);
            Certificate certificate = new Certificate(cert, true, "windows-1251");
            try {
                certificate.save(certificate.getCertificateAsString(true));
            } catch (ParseException ex) {
                //do nothing impossible
            } catch (IOException ex) {
                JOptionPane.showMessageDialog(this, "Не удалось создать файл");
                return;
            }

            certs = Arrays.copyOf(certs, certs.length + 1);
            certs[certs.length - 1] = cert;
            updateCertsDir();
            files.setSelectedValue(login, true);
        }
    }

    private void updateCertsDir() {
        sortCerts();
        ListModel theModel = files.getModel();
        files.setModel(new DefaultListModel()); //TODO remove the hack. Need to redraw elements in list
        files.setModel(theModel);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                new Corrector();
            }
        });
    }

    public Corrector() {
        //load certificates
        certs = new File(".").listFiles(new FilenameFilter() {
            public boolean accept(File dir, String name) {
                return name.endsWith(EXTENSION);
            }
        });
        sortCerts();

        putControls();

        setSize(800, 600);
        setVisible(true);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
    }

    private void sortCerts() {
        Arrays.sort(certs, new Comparator<File>() {
            public int compare(File o1, File o2) {
                return o1.getName().compareTo(o2.getName());
            }
        });
    }

    private void putControls() {
        setLayout(new BorderLayout());
        add(new JScrollPane(files), BorderLayout.WEST);
        add(new JScrollPane(input), BorderLayout.CENTER);

        JPanel bottom = new JPanel(new GridLayout(1, 3));
        add(bottom, BorderLayout.SOUTH);

        bottom.add(create);
        bottom.add(save);
        bottom.add(selectDir);

        save.setEnabled(false);
        save.addActionListener(this);

        input.getDocument().addDocumentListener(new DocumentListener() {
            public void insertUpdate(DocumentEvent e) {
                modified();
            }

            public void removeUpdate(DocumentEvent e) {
                modified();
            }

            public void changedUpdate(DocumentEvent e) {
                modified();
            }

            private void modified() {
                save.setEnabled(true);
            }

        });
        input.setFont(input.getFont().deriveFont(16.0f));

        files.addListSelectionListener(this);
        files.setModel(new ListModel() {
            public int getSize() {
                return certs.length;
            }

            public Object getElementAt(int index) {
                String name = certs[index].getName();
                return name.substring(0, name.length() - EXTENSION.length());
            }

            public void addListDataListener(ListDataListener l) {
                //do nothing
            }

            public void removeListDataListener(ListDataListener l) {
                //do nothing
            }
        });

        create.addActionListener(this);
        selectDir.addActionListener(this);
    }
}
