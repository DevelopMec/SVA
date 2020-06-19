@isTest
private class EC_CargaDeArchivos_CTRL_TEST {
	
	@isTest static void EC_saveAttachmentExist() {

		List<sObject> objs = new List<sObject>();

        EntidadLegal__c entLegal = new EntidadLegal__c();
        entLegal.Name = 'CUPU800825569';
        entLegal.RazonSocial__c = 'R';

        insert entLegal;
		Attachment attach = new Attachment();    
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('U');
        attach.body = bodyBlob;
        attach.parentId = entLegal.Id;
        insert attach;    
        String bodyContent = attach.body.toString();   
        Test.startTest();
        EC_CargaDeArchivos_CTRL.EC_saveAttachment(entLegal.Id,attach.Name,bodyContent,'CURP__c');
        EC_CargaDeArchivos_CTRL.EC_saveAttachment(entLegal.Id,attach.Name,bodyContent,'CURP__c');
        Test.stopTest();
	}
	@isTest static void EC_deleteAttachment() {
		List<sObject> objs = new List<sObject>();
        EntidadLegal__c entLegal = new EntidadLegal__c();
        entLegal.Name = 'CUPU800825569';
        entLegal.RazonSocial__c = 'R';
        insert entLegal;
		Attachment attach = new Attachment();    
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('U');
        attach.body = bodyBlob;
        attach.parentId = entLegal.Id;
        insert attach;
        Test.startTest();
        EC_CargaDeArchivos_CTRL.EC_deleteAttachment(attach.Id,entLegal.Id,'CURP__c');
        Test.stopTest();

	}

	@isTest static void EC_updateAttachment(){

		EntidadLegal__c entLegal = new EntidadLegal__c();
        entLegal.Name = 'CUPU800825569';
        entLegal.RazonSocial__c = 'R';
        insert entLegal;
		Attachment attach = new Attachment();    
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('U');
        attach.body = bodyBlob;
        attach.parentId = entLegal.Id;
        insert attach;
        String bodyContent = attach.body.toString();
        Test.startTest();
        EC_CargaDeArchivos_CTRL.EC_updateAttachment(attach.Id,bodyContent);
        Test.stopTest();
	}

	@isTest static void EC_getAttachments(){
		EntidadLegal__c entLegal = new EntidadLegal__c();
        entLegal.Name = 'CUPU800825569';
        entLegal.RazonSocial__c = 'R';
        insert entLegal;
		Attachment attach = new Attachment();    
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('U');
        attach.body = bodyBlob;
        attach.parentId = entLegal.Id;
        insert attach;
        Test.startTest();
        EC_CargaDeArchivos_CTRL.EC_getAttachments(entLegal.Id);
        Test.stopTest();
	}

	@isTest static void EC_updateStatus(){

		EntidadLegal__c entLegal = new EntidadLegal__c();
        entLegal.Name = 'CUPU800825569';
        entLegal.RazonSocial__c = 'R';
        insert entLegal;
        Test.startTest();
        EC_CargaDeArchivos_CTRL.EC_updateStatus(entLegal.Id ,'Completa');
        Test.stopTest();
	}

	@isTest static void EC_updateStatusError(){

		EntidadLegal__c entLegal = new EntidadLegal__c();
        entLegal.Name = 'CUPU800825569';
        entLegal.RazonSocial__c = 'R';
        insert entLegal;
        Test.startTest();
        EC_CargaDeArchivos_CTRL.EC_updateStatus(entLegal.Id ,'C');
        Test.stopTest();
	}

	@isTest static void EC_getRelatedAccountInformation(){

		EntidadLegal__c entLegal = new EntidadLegal__c();
        entLegal.Name = 'CUPU800825569';
        entLegal.RazonSocial__c = 'R';
        insert entLegal;
        Test.startTest();
        EC_CargaDeArchivos_CTRL.EC_getRelatedAccountInformation(entLegal.Id);
        Test.stopTest();
	}

	@isTest static void EC_getDocsByTypePerson(){
		Test.startTest();
        TiposDocumento__c tp = new TiposDocumento__c(Name = 'Prueba');
        insert tp;
		EC_CargaDeArchivos_CTRL.EC_getDocsByTypePerson();
		Test.stopTest();
	}

	@isTest static void EC_getForeignContact(){

		Account cuenta = new Account(Name ='Cuenta maestra',NumeroEmpleados__c = '1-25',NumeroVehiculos__c = '1');
		insert cuenta;
		Contact contacto = new Contact();
		contacto.LastName = 'Sola';
		contacto.AccountId = cuenta.Id;
        //Inicio cambio SIGLO
		//contacto.Extranjero__c = true;
        contacto.Nationality__c = 'PERU';
        //Fin cambio SIGLO
		contacto.Funcion__c = 'Representante Legal';
        contacto.Curp__c='BADD110313HCMLNS09';
		insert contacto;
		EntidadLegal__c eL = new EntidadLegal__c();
        eL.Name = 'CUPU800825569';
        eL.RazonSocial__c = 'R';
       // eL.Cuenta__c = cuenta.Id;
        insert eL;
        EntidadCuenta__c eC = new EntidadCuenta__c(Cuenta__c = cuenta.Id, EntidadLegal__c = eL.Id);
        insert eC;
        ContactoEntidad__c cE = new ContactoEntidad__c(Contacto__c = contacto.Id,Entidad_Cuenta__c = eC.Id,EntidadLegal__c = eL.Id);
        insert cE;
		Test.startTest();
		EC_CargaDeArchivos_CTRL.EC_getForeignContact(eL.Id);
		Test.stopTest();
	}

    @isTest static void nuevosMetodosContentDocument() {

        List<sObject> objs = new List<sObject>();

        EntidadLegal__c entLegal = new EntidadLegal__c();
        entLegal.Name = 'CUPU800825569';
        entLegal.RazonSocial__c = 'R';

        insert entLegal;
        Attachment attach = new Attachment();    
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('U');
        attach.body = bodyBlob;
        attach.parentId = entLegal.Id;
        insert attach;    
        String bodyContent = attach.body.toString();

        List<ContentVersion> cvs = new List<ContentVersion>();
        cvs.add(new ContentVersion(Title = 'Curp', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true ));
        cvs.add(new ContentVersion(Title = 'Id. de Cliente', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true ));
        cvs.add(new ContentVersion(Title = 'Registro Patronal', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true ));
        insert cvs;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        //create ContentDocumentLink  record 
        List<ContentDocumentLink> lcdl = new List<ContentDocumentLink>();
        for( ContentDocument cd : documents) {
            lcdl.add(new ContentDocumentLink(LinkedEntityId = entLegal.Id, ContentDocumentId = cd.Id, ShareType = 'V'));
        }
        insert lcdl;

        // EC_saveAttachment2(String elId, String attId, String attachmentName, String elFieldName) {

        Test.startTest();
            EC_CargaDeArchivos_CTRL.EC_saveAttachment2(entLegal.Id, documents[0].Id, cvs[0].Title, 'CURP__c');
            EC_CargaDeArchivos_CTRL.EC_getAttachments2(entLegal.Id);
            EC_CargaDeArchivos_CTRL.EC_deleteAttachment2(documents[0].Id, entLegal.Id, 'CURP__c');
        Test.stopTest();

        

        
    }
	
	
}