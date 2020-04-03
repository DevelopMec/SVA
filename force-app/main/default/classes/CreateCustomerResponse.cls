public class CreateCustomerResponse {
    public ErrorDTO meta{get;set;}
    public OperationDTO data{get;set;}
    public class ErrorDTO{
        public String Status{get;set;}
        public List<mensajesDTO> messages{get;set;}
    }
    public class mensajesDTO{
        public String text{get;set;}
        public String code{get;set;}
        public String level{get;set;}
    }
    public class OperationDTO{
        public String folio{get;set;}
        public String process_date{get;set;}
        public String espada_code{get;set;}
        public String user_ref{get;set;}
    }
}