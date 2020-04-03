public class GenerarContratoController {
    public String IdOportunidad{get;set;}
    public String TipoContrato{get;set;}
    public Boolean generar{get;set;}
    public GenerarContratoController(ApexPages.StandardController controller){
        try{
            generar=false;
            Opportunity oportunidad =[Select Id,Producto__r.TipoContrato__C from Opportunity where Id =: controller.getId()];
            IdOportunidad = oportunidad.Id;
            TipoContrato= oportunidad.Producto__r.TipoContrato__c != null ? oportunidad.Producto__r.TipoContrato__c : 'NO';
            if([SELECT Id from TarifaOportunidad__c where oportunidad__c =: IdOportunidad].size()>0){
                generar=true;
            }
        }catch(Exception e){
            System.debug(e.getMessage()+'linea:'+e.getLineNumber());
        }
    }
}