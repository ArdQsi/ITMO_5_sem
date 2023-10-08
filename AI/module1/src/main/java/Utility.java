import java.util.Map;
import java.util.Scanner;
import java.util.regex.Pattern;

import com.sun.org.apache.xerces.internal.impl.xs.SchemaNamespaceSupport;
import exception.*;
import org.jpl7.Term;

public class Utility {
    private Scanner scanner;

    private final String regex;
    private final Pattern pattern;
    private String line;

    private StringBuilder stringBuilder;

    public Utility() {
        this.regex = "Я [a-zA-Z]*, у меня есть [0-9]+ долларов, что я могу купить на данную сумму\\?";
        this.pattern = Pattern.compile(this.regex);
    }

    public void setScanner(Scanner scanner) {
        this.scanner = scanner;
    }

    //Show the user a program work template
    public void getTemplate() {
        System.out.println("Шаблон для запроса:\n" +
                "Я *, у меня есть ** долларов, что я могу купить на данную сумму?\n" +
                "Вместо * - имя пользователя\n" +
                "Вместо ** - количество денег\n");
    }

    // Read the line and compare with the pattern
    public void readLine() throws TemplateException {
        String line = scanner.nextLine();
        if (checkPattern(line)) {
            this.line = line;
        } else {
            throw new TemplateException();
        }
    }

    //Checking a string for a pattern
    public boolean checkPattern(String line) {
        return pattern.matcher(line).find();
    }

    //Get user name
    public String getName() {
        return line.substring(2, line.indexOf(','));
    }

    //Get amount of money
    public String getMoney() {
        String wordBefore = "есть ";
        String wordAfter = "долларов";
        return line.substring(line.indexOf(wordBefore) + wordBefore.length(), line.indexOf(wordAfter));
    }

    //Get a response to a user's request
    public String getAnswer(Map<String, Term>[] res) {
        this.stringBuilder = new StringBuilder();
        if (res.length == 0) {
            this.stringBuilder.append("Вы не можете ничего купить за данную сумму! Делайте эко-раунд");
        } else {
            this.stringBuilder.append("Вы можете купить следующие оружия: \n");
        }

        for (int i = 0; i < res.length; i++) {
            for (Map.Entry<String, Term> entry : res[i].entrySet()) {
                stringBuilder.append(entry.getValue().toString().replace("'", "") + "\n");
            }
        }
        return stringBuilder.toString();
    }

}
