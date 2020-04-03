public with sharing class ModificarOportunidadController {
    
     public  Opportunity oportunidad {get;set;}
     public ModificarOportunidadController(apexPages.StandardController std){
     	oportunidad = [SELECT Id,Name,isClosed,isWon FROM Opportunity WHERE ID =:  std.getId()];
     }
     
     public PageReference redirigirModificable(){
     	PageReference pr = null;
     	Negocio__c negocio = Negocio__c.getInstance();
		Boolean modifica = negocio.ModificarOportunidadCerrada__c;
		if((oportunidad.isClosed || oportunidad.isWon) && !modifica){
     		pr = null;
     		oportunidad.addError('No puede modificar la oportunidad en esta etapa');
     		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No puede modificar la oportunidad en esta etapa'));
		}else{
			pr = new PageReference('/'+oportunidad.Id+'/e?retURL='+oportunidad.Id + '&nooverride=1');
     		pr.setRedirect(true);
		}
     	return pr;
     }
}