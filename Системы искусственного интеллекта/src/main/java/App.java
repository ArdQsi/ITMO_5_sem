
import java.util.Map;
import java.util.Scanner;

import exception.*;
import org.jpl7.*;


public class App {

    public static void main(String[] args) throws TemplateException, UnknownPlayerException {
        Utility utility = new Utility();
        if (args.length == 0) {
            utility.setScanner(new Scanner(System.in));
            utility.getTemplate();
            System.out.println(App.getRequest(utility));
        } else {
            utility.setScanner(new Scanner(args[0]));
            System.out.println(App.getRequest(utility));
        }
    }


    public static String getRequest(Utility utility) throws TemplateException, UnknownPlayerException {

        //Initializing query
        Query query = new Query("consult('kb.pl')");
        query.hasSolution();

        utility.readLine();

        query = new Query(new Compound("player", new Term[]{new Atom(utility.getName().toLowerCase())}));
        //checking the username for correctness
        if (!query.hasSolution()) {
            throw new UnknownPlayerException(utility.getName());
        }


        query = new Query("buy_weapon(" + utility.getName().toLowerCase() + ", Weapon, " + utility.getMoney() + ")");
        Map<String, Term>[] res = query.allSolutions();

        return utility.getAnswer(res);
    }
}
