import exception.TemplateException;
import exception.UnknownPlayerException;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.util.Scanner;


public class MainTest {
    @Test
    public void incorrectTemplateInput() {
        String[] string = {"Я denis, у меня есть 750 монет, что я могу купить на данную сумму?"};

        Assertions.assertThrows(TemplateException.class, () -> App.main(string));
    }

    @Test
    public void incorrectDataInput() {
        String[] string = {"Я WoW, у меня есть 750 долларов, что я могу купить на данную сумму?"};

        Assertions.assertThrows(UnknownPlayerException.class, () -> App.main(string));
    }

    @Test
    public void incorrectTemplateAndDataInput() {
        String[] string = {"Я BoB, у меня есть 750 шейкелей, что я могу себе позволить?"};

        Assertions.assertThrows(TemplateException.class, () -> App.main(string));
    }

    @Test
    public void weaponTerrorist() throws TemplateException, UnknownPlayerException {
        Utility utility = new Utility();
        utility.setScanner(new Scanner("Я shipim, у меня есть 16000 долларов, что я могу купить на данную сумму?"));
        String output = "Вы можете купить следующие оружия: \n" +
                "ak47\n" +
                "p90\n" +
                "nova\n" +
                "awp\n" +
                "ssg 08\n" +
                "desert eagle\n";

        Assertions.assertEquals(App.getRequest(utility), output);
    }

    @Test
    public void weaponCounterTerrorist() throws TemplateException, UnknownPlayerException {
        Utility utility = new Utility();
        utility.setScanner(new Scanner("Я upuzipu, у меня есть 16000 долларов, что я могу купить на данную сумму?"));
        String output = "Вы можете купить следующие оружия: \n" +
                "p90\n" +
                "nova\n" +
                "awp\n" +
                "aug\n" +
                "famas\n" +
                "ssg 08\n" +
                "desert eagle\n";

        Assertions.assertEquals(App.getRequest(utility), output);
    }

    @Test
    public void weaponEqualCost() throws TemplateException, UnknownPlayerException {
        Utility utility = new Utility();
        utility.setScanner(new Scanner("Я denis, у меня есть 750 долларов, что я могу купить на данную сумму?"));
        String output = "Вы можете купить следующие оружия: \n" +
                "desert eagle\n";

        Assertions.assertEquals(App.getRequest(utility), output);
    }

    @Test
    public void noMoney() throws TemplateException, UnknownPlayerException {
        Utility utility = new Utility();
        utility.setScanner(new Scanner("Я Ard, у меня есть 100 долларов, что я могу купить на данную сумму?"));
        String output = "Вы не можете ничего купить за данную сумму! Делайте эко-раунд";

        Assertions.assertEquals(App.getRequest(utility), output);
    }
}
