package exception;

public class TemplateException extends Exception{
    public TemplateException(){
        super("Не соотвествует шаблону! Перепроверьте предложение");
    }
}
