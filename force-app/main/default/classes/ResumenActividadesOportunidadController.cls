public without sharing class ResumenActividadesOportunidadController { 
    public List<Task> actividades{get;set;} 
    public List<Event> eventos{get;set;}
    public List<Opportunity> cuenta{get;set;}   
     public String cuentaId{get;set;}   
 
    public ResumenActividadesOportunidadController() {

        obtenerDatos(ApexPages.currentPage().getParameters().get('Id'));               
    }

    public void obtenerDatos(String opp){        
        try{  
            cuenta=[Select Account.Id from Opportunity where id=:opp];
            cuentaId=cuenta[0].Account.Id;
            actividades = [Select Id,Subject,Description,Status,CreatedDate  from Task where whatId =: opp ORDER BY CreatedDate DESC];
            eventos = [Select Id,Subject,Description,EventSubtype,CreatedDate  from Event where whatId =: opp ORDER BY CreatedDate DESC limit 20];

        }catch(Exception e){
             System.Debug('estoy en el catch'+ e.getMessage() );
        }
    }
}