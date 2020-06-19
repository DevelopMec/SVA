public without sharing class SendDocuSing_CTRL {
	@AuraEnabled
    public static Map<String,String> generarInformacion(String recordId){
        Map<String,String> resp=new Map<String,String>();
        String mensaje='Solo se puede enviar el contrato digital una vez, ahora debes de seguir por el flujo manual”';
        List<dsfs__DocuSign_Status__c> cant=[Select dsfs__Envelope_Status__c from dsfs__DocuSign_Status__c where dsfs__Opportunity__c=:recordId and dsfs__Envelope_Status__c IN ('Enviado','Delivered','Rechazado','Completado','Entregado','Firmado/completado')];
        for(dsfs__DocuSign_Status__c estatus:cant){
            if(estatus.dsfs__Envelope_Status__c=='Completado')
                mensaje='Solo se puede enviar el contrato digital una vez, ahora debes de seguir por el flujo manual';    
        }
        if(!cant.isEmpty()){
           resp.put('status',mensaje);resp.put('msj',mensaje);return resp; 
        }
        
                
        String idDocuSingEnvelope=createDocuSingEnvelope(recordId);
        Quote q;
        try{
            q=[Select Id,IdPDFPropuestaComercial__c,ContactId,Contact.Email,Contact.Name,Opportunity.RecordType.DeveloperName,Opportunity.OwnerId from Quote where IsSyncing=true and OpportunityId=:recordId];
        }catch(Exception e){
            resp.put('status','error');
            resp.put('msj','No existe una cotización generada');
            return resp;
        }
        if(q.Opportunity.OwnerId!=UserInfo.getUserId()){
            resp.put('status','error');
            resp.put('msj','El envío del contrato solo lo puede realizar el propietario de la oportunidad');
            return resp;
        }
        if(q.IdPDFPropuestaComercial__c!=null){
            Negocio__c config=Negocio__c.getInstance();
            String idDocuSingEnvelopeDocument=createDocuSingEnvelopeDocument(idDocuSingEnvelope,q.IdPDFPropuestaComercial__c,'Contrato o Propuesta firmados');        
            String idDocuSingEnvelopeRecipient=createDocuSingEnvelopeRecipient(idDocuSingEnvelope,q.Contact.Email,q.Contact.Name,q.ContactId);
            if(q.Opportunity.RecordType.DeveloperName=='BPfleet'){
                resp.put('templateId',config.TemplateIdBPfleet__c);
            }else{
                resp.put('templateId',config.TemplateIdEdenred__c);
            }
            resp.put('idDoc',idDocuSingEnvelope);
            resp.put('urlDocuSign',config.UrlDocuSign__c);
            resp.put('status','success');
        }else{
            resp.put('status','error');
            resp.put('msj','No se ha generado la propuesta comercial, por favor vaya a la COTIZACIÓN y genere el pdf');
        }
        return resp;
    }
    public static String createDocuSingEnvelope(String idOpp){
		dsfs__EnvelopeConfiguration__c lstconfiguracion=[SELECT id from dsfs__EnvelopeConfiguration__c where name='Edenred' limit 1];
        dsfs__DocuSign_Envelope__c de=new dsfs__DocuSign_Envelope__c(
            dsfs__DocuSign_Email_Subject__c='Documentos pendientes de firma',
            dsfs__DocuSign_Email_Message__c='Le envió esa solicitud de su firma electrónica, revise el documento y fírmelo electrónicamente',
            dsfs__EnvelopeConfiguration__c =lstconfiguracion.id,
            dsfs__Source_Object__c=idOpp);
        insert de;
        return de.Id;
    }
     public static String createDocuSingEnvelopeDocument(String idDsE,String idDoc,String nameDoc){
        dsfs__DocuSign_Envelope_Document__c ded= new dsfs__DocuSign_Envelope_Document__c(
            dsfs__DocuSign_EnvelopeID__c=idDsE,
            dsfs__Extension__c='pdf', 
            //dsfs__SFDocument_Type__c='Attachment', 
            dsfs__External_Document_Id__c=idDoc, 
            dsfs__Document_Name__c=nameDoc);
         insert ded;
         return ded.Id;
    }
     public static String createDocuSingEnvelopeRecipient(String idDsE,String emailSing,String nameSing,String idSing){
        dsfs__DocuSign_Envelope_Recipient__c der=new dsfs__DocuSign_Envelope_Recipient__c(
            dsfs__SignNow__c=false,
            dsfs__SignInPersonName__c=emailSing,
            dsfs__SignInPersonEmail__c=nameSing,
            dsfs__Salesforce_Recipient_Type__c='Contact',
            dsfs__Routing_Order__c=1,
            dsfs__RoleValue__c=1,
            dsfs__RoleName__c='Signer 1',
            dsfs__Recipient_ID__c=1,
            dsfs__Recipient_Email__c=emailSing,
            dsfs__ID_Check__c=false,
            dsfs__DocuSign_Signer_Type__c='Signer',
            dsfs__DocuSign_Signature_Name__c=nameSing,
            dsfs__DocuSign_Recipient_Role__c='Customer 1', 
            dsfs__DocuSign_EnvelopeID__c=idDsE,
            dsfs__DSER_ContactID__c=idSing);
         insert der;
         return der.Id;
    }
}