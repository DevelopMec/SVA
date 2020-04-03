public without sharing class IngresarIdLlamadaTicket_CONT {
	@AuraEnabled
    public static void setIdLlamada(String idCaso,String idLlamada){
        ID_de_Llamada__c idLl=new ID_de_Llamada__c(Caso__c=idCaso,Name=idLlamada);
        insert idLl;
    }
}