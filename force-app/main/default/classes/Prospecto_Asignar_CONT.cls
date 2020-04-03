public class Prospecto_Asignar_CONT {

     @AuraEnabled
    public static String Asignar(string vId){ 
    
        try{
            System.debug ('id ' + vId);
       Lead prospecto = [Select id, OwnerId, RecordTypeId From Lead where id =: vId];
       string tipo = Schema.SObjectType.Lead.getRecordTypeInfosById().get(prospecto.RecordTypeId).getname();
     
       Negocio__c config = [Select Prospecto_Asignacion_TicketCar__c, Prospecto_Asignacion_Benefits__c From Negocio__c];        
       
            System.debug('Prospecto_Asignacion_TicketCar__c ' + config.Prospecto_Asignacion_TicketCar__c);
        	
        User usuario = new User();
        if (tipo == 'Ticket Car'){
            usuario = [Select id from User where UserName =: config.Prospecto_Asignacion_TicketCar__c];
        }
        if (tipo == 'Benefits'){
        	usuario = [Select id from User where UserName =: config.Prospecto_Asignacion_Benefits__c];    
        }
        
         
       prospecto.OwnerId = usuario.Id;
       update prospecto;
         return '';
            }
        catch(Exception e){
            System.debug('error '+ e);
             return e.getMessage();
        }
       
    }

}