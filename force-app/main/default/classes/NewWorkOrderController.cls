public with sharing class NewWorkOrderController {
    
   // public WorkOrder newWorkOrder {get; set;}
   // public Boolean isEtapaImplementacion {get;set;}
   // public OpportunityLineItem oppLineItem {get;set;}
    //Valor del campo de lista de seleccion Segmento__c en el Objeto User
    //private static final String SMALL = 'Small';
    //*Valor del campo de lista de seleccion Segmento__c en el Objeto User*/
    //private static final String MLK = 'MLK';
    //*Valor del campo de lista de seleccion Etapa en el Objeto OpportunityLineItem*/
    //private static final String IMPLEMENTACION = 'Implementación';
    //*Valor del campo de lista de seleccion Estatus__c en el Objeto WorkOrder*/
    //private static final String PREASIGNACION = 'Preasignación';
    /*Valor del campo de lista de seleccion Estatus__c en el Objeto WorkOrder*/
    //private static final String PROCESO = 'En Proceso';
    
    
    /*Valor Configuracion PERSONALIZADA*/
    //private ID RESPONSABLEPEDIDO;
    /*Valor Configuracion PERSONALIZADA*/
    //private ID IMPLEMENTADOR;
    /*Valor Configuracion PERSONALIZADA*/
   // private ID CAPACITADOR;
    

    /* Autor:  Gerardo Elisiel Martínez Cabral 
     * Objetivo: Constructor de la Visualforce "NewWorkOrder" crea una OT asociada a un producto de oportunidad desde la vista de detalle de un producto de oportunidad 
     * de Orden de Producto
     * Fecha: 13/01/2017
    */
    /*public NewWorkOrderController(){
        Id OportunityProductId = apexpages.currentpage().getparameters().get('id');
        this.newWorkOrder = new WorkOrder();
        
        List<TriggerOpportunityLineItemHandlerConfig__c> config = [SELECT id, Name, Capacitador__c, Implementador__c, ResponsablePedido__c FROM TriggerOpportunityLineItemHandlerConfig__c LIMIT 1];
        if(config!=null && config.size()>0){
            this.RESPONSABLEPEDIDO = (!String.isEmpty(config[0].ResponsablePedido__c)?Id.valueOf(config[0].ResponsablePedido__c):null);
            this.IMPLEMENTADOR = (!String.isEmpty(config[0].ResponsablePedido__c)?Id.valueOf(config[0].Implementador__c):null);
            this.CAPACITADOR = (!String.isEmpty(config[0].Capacitador__c)?Id.valueOf(config[0].Capacitador__c):null);
        }
        
        
        if(OportunityProductId != null){
            
            List<OpportunityLineItem> products = [SELECT Id, Name, Etapa__c, Product2.Name, Product2.Family, Product2.TipoSolucion__c, Opportunity.AccountId, 
                                                  Opportunity.StageName, Opportunity.Owner.Segmento__c, Opportunity.Owner.Email, 
                                                  OpportunityId, TotalPrice,ProductCode FROM OpportunityLineItem WHERE Id = :OportunityProductId LIMIT 1];
            
            if(products!=null && products.size()>0){
                
                oppLineItem = products.get(0);
                if (oppLineItem.Etapa__c==IMPLEMENTACION){
                    this.isEtapaImplementacion = TRUE;
                    
                    newWorkOrder.Oportunidad__c = oppLineItem.OpportunityId;
                    newWorkOrder.Solucion2__c = oppLineItem.Product2.Name; 
                    newWorkOrder.VolumenEmisionMensual2__c = oppLineItem.TotalPrice; 
                    newWorkOrder.Familia2__c = oppLineItem.Product2.Family;
                    newWorkOrder.TipoSolucion2__c = oppLineItem.Product2.TipoSolucion__c;
                    newWorkOrder.MailEjecutivo__c =oppLineItem.Opportunity.Owner.Email;
                    newWorkOrder.AccountId = oppLineItem.Opportunity.AccountId;
                    newWorkOrder.IDProductoOpp__c = String.valueOf(oppLineItem.Id); 
                    newWorkOrder.StartDate =System.now();
                    newWorkOrder.NumProducto__c =oppLineItem.ProductCode;
                    
                    if (oppLineItem.Opportunity.Owner.Segmento__c == SMALL && oppLineItem.Etapa__c == IMPLEMENTACION ){
                        newWorkOrder.Estatus__c = PREASIGNACION;
                        newWorkOrder.ResponsablePedido__c = RESPONSABLEPEDIDO;
                        
                        if (IMPLEMENTADOR !=NULL){
                            newWorkOrder.OwnerId = IMPLEMENTADOR;
                        }
                        
                    }else if(oppLineItem.Opportunity.Owner.Segmento__c == MLK && oppLineItem.Etapa__c == IMPLEMENTACION){
                        
                        newWorkOrder.Estatus__c = PROCESO;
                        if (CAPACITADOR !=NULL){
                            newWorkOrder.OwnerId = CAPACITADOR;
                        }
                    }
                }else{
                    this.isEtapaImplementacion = FALSE;
                    String errorMessage = 'La etapa del producto de la oportunidad es '+oppLineItem.Etapa__c;
                    Apexpages.addMessage(new Apexpages.message(ApexPages.Severity.Error,errorMessage));
                } 
            }
        }
    }

    /* Autor:  Gerardo Elisiel Martínez Cabral 
     * Objetivo: Regresa a la pagina anterior
     * Fecha: 13/01/2017
    */ 
   /* public PageReference cancel(){
        PageReference page = new PageReference('/'+oppLineItem.Id);
        page.setRedirect(true);
        return page;
    } 

    /* Autor:  Gerardo Elisiel Martínez Cabral 
     * Objetivo: inserta la orden de trabajo creada en el constructor
     * Fecha: 13/01/2017
    */   
  /*  public PageReference insertWorkOrder(){
        System.debug('WORK ORDER TO INSERT: '+newWorkOrder);
        WorkOrder[] orders= new List<WorkOrder>{newWorkOrder};
            for (WorkOrder wo: orders){
                
                if (wo.IDProductoOpp__c!=null){
                    
                    Database.SaveResult[] srList = Database.insert(orders, false);
                    
                    for (Database.SaveResult sr : srList) {
                        if (sr.isSuccess()) {
                            PageReference retURL = new PageReference('/'+newWorkOrder.Id);
                            retURL.setRedirect(true);
                            return retURL;
                        }
                        else {
                            String errorMessage= 'Ocurrió el siguiente error: '; // Operation failed, so get all errors                
                            for(Database.Error err : sr.getErrors()) {
                                
                                errorMessage += err.getStatusCode() + ': ' + err.getMessage() ;
                            }
                            Apexpages.addMessage(new Apexpages.message(ApexPages.Severity.Error,errorMessage));
                        }
                    }
                }else{
                    Apexpages.addMessage(new Apexpages.message(ApexPages.Severity.Error,'La orden de trabajo no está vinculada al producto de la oportunidad, por favor vuelva a intentar más tarde'));
                }             
            }
        return null;
    }
    */
}