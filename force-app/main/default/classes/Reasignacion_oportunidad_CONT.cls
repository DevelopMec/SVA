public without sharing class Reasignacion_oportunidad_CONT {
	@AuraEnabled
    public static List<User> obtenerUsuarios(){
        return [Select Id,Name from User where IsActive=true and Id!=:UserInfo.getUserId() order by Name];
    }
    @AuraEnabled
    public static boolean reasignarOpp(String idOportunidad,String idNuevoPropietario){
        System.debug('::Inicio Reasignar::');
        //responseWrapper resp=new responseWrapper();
        //Campaign cam;
        /*try{
            cam=[Select Id from Campaign where Name='Apadrinados' Limit 1];
        }catch(Exception e){
            System.debug('Error: '+e.getMessage()+', Linea: '+e.getLineNumber());
            resp.status=false;
            resp.mensaje='No existe la campaña Apadrinados para asignar la oportunidad';
            return resp;
        }*/           
        Opportunity opp=[Select Id,Contacto__c,AccountId from Opportunity where Id=:idOportunidad];            
        opp.OwnerId=idNuevoPropietario;
        //opp.CampaignId=cam.Id;
        update opp;
        /*List<ContactShare> linsert=new List<ContactShare>();
        for(Contact con:[Select Id from Contact where AccountId=:opp.AccountId]){
            ContactShare ch=new ContactShare();
            ch.ContactAccessLevel='Edit';
            ch.ContactId=opp.Contacto__c;
            ch.UserOrGroupId=idNuevoPropietario;
            linsert.add(ch);
        }
        insert linsert;*/
        
        AccountShare accSh=new AccountShare();
        accSh.AccountId=opp.AccountId;
        accSh.UserOrGroupId=idNuevoPropietario;
        accSh.AccountAccessLevel='Read';
        accSh.ContactAccessLevel='Edit';
        accSh.OpportunityAccessLevel='None';
        insert accSh;
        
        //resp.status=true;  
        return true;
    }
}