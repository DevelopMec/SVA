public with sharing class PageMessagesController {
	public enum Severity {CONFIRM,INFO,WARN,FATAL,ERROR}
	
	private static List<PageMessage> StaticMessages {
        get { 
            if(StaticMessages == null) StaticMessages = new List<PageMessage>(); 
            return StaticMessages; 
        }
        private set;
    } 
	
	 
	public String CustomPageMessages_ClosableErrorsRenderPlaceHolder {
        get { 
            if(CustomPageMessages_ClosableErrorsRenderPlaceHolder == null) CustomPageMessages_ClosableErrorsRenderPlaceHolder = ''; 
            return CustomPageMessages_ClosableErrorsRenderPlaceHolder; 
        }
        private set;
    } 
 
    public List<PageMessage> getPageMessages() {
        return getMessages();
    }
    
     public class PageMessage {
        private Map<Severity,String> SeverityStrMap = new Map<Severity,String>{
            Severity.CONFIRM => 'confirm',
            Severity.INFO => 'info',
            Severity.WARN => 'warn',
            Severity.FATAL => 'error',
            Severity.ERROR => 'error'
        };
 
        public Severity SeverityLevel { get; set; }
        public String SeverityStr { get; set; }
        public String Message { get; set; }
 
        public PageMessage (Severity theSeverity, String theMessage) {
            this.SeverityLevel = theSeverity;
            this.Message = theMessage;
            this.SeverityStr = SeverityStrMap.get(theSeverity);
        }
    }
    
    public static void addMessage(PageMessage thePageMessage) {
        StaticMessages.add(thePageMessage);
    }
 
    public static List<PageMessage> getMessages(){
        return StaticMessages;
    }
    
	
	
	
}