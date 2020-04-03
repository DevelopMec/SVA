public class ActualizaSegmento {
 @AuraEnabled
    public static String ActualizarSegmento(Id vId) {
        System.debug('vId '+ vId);

        BatchSegmentoComerciales b = new BatchSegmentoComerciales();
        List <Account> data = [SELECT Id, NumeroEmpleados__c, Segmento3__c, CodigoClienteAS400__c FROM Account WHERE id =: vId ];
		b.execute(null, data);
        
        return 'OK';
    }
}