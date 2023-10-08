package exception;

public class UnknownPlayerException extends Exception {
    public UnknownPlayerException(String name) {
        super("В базе знаний не существует пользователя " + name + "! Проверьте имя пользователя!");
    }
}
