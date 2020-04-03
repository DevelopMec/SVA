public without sharing  class ResumenCuentaController {
    public List<Opportunity> oportunidades{get;set;}    
    public List<Task> actividades{get;set;}
    public List<Task> actividadesOpp{get;set;}
    public List<Event> eventos{get;set;}
    public Account cuenta{get;set;}
    
    public ResumenCuentaController(ApexPages.StandardController controller){
        cuenta=new Account(Id=controller.getId());
         obtenerDatos(controller.getId());
    }

    public void obtenerDatos(String cuenta){
        try{
            // oportunidades=[Select Id,Name,StageName,Owner.Name, CloseDate ,CreatedDate,LASTaCTIVITYDATE
            // from Opportunity where Account.Id =: cuenta ];    

            //Para consultar las etapas de los productos de oportunidad: OpportunityLineItem
            oportunidades=[SELECT  Id,Name,StageName,Owner.Name, CloseDate ,CreatedDate,LastActivityDate,
                                    (
                                        SELECT Etapa__c,
                                            Id,
                                            IsDeleted,
                                            Name,
                                            OpportunityId,
                                            Product2Id,
                                            Product2.Name
                                        FROM OpportunityLineItems
                                        where IsDeleted = FALSE    
                                        ORDER BY Name ASC
                                    )
                                from Opportunity where Account.Id =: cuenta
                                ORDER BY Name ASC ];                 
        }catch(Exception e){
            oportunidades= new List<Opportunity>();
        }
    }
}