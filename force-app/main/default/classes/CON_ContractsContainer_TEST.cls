@isTest
public class CON_ContractsContainer_TEST {
	
	// Property managerName
	@isTest
	static void managerNameTest() {
		CON_ContractsContainer_CTRL cc = new CON_ContractsContainer_CTRL();
		String mnt = cc.managerName;
        Opportunity c=TestDataFactory_TEST.createOpportunity();
        Attachment att=TestDataFactory_TEST.createAttachment(c.Id);
        CON_ContractsContainer_CTRL.getContactosAP(c.Id,'Opportunity');
        CON_ContractsContainer_CTRL.getMotivosDeRechazo();
        CON_ContractsContainer_CTRL.saveLayoutAttachment(att.Id, c.Id, 'pdf', 'cfvgh', 'test');
	}
	
	// strData is empty
	@isTest
    static void guardaContratoTest1() {
		Map<String, Object> mapOppQuoP2PeQli = (Map<String, Object>)TestDataFactory_TEST.createQuoteLineItem();
		QuoteLineItem qli = (QuoteLineItem)mapOppQuoP2PeQli.get('QuoteLineItem');
		String strData = '';
		try {
			Map<String, Object> gc = CON_ContractsContainer_CTRL.guardaContrato(strData);
		} catch (CON_ContractsContainer_CTRL.CustomException ce) {}
	}
	
	// strData hasn't qli
	@isTest
    static void guardaContratoTest2() {
		Map<String, Object> mapOppQuoP2PeQli = (Map<String, Object>)TestDataFactory_TEST.createQuoteLineItem();
		QuoteLineItem qli = (QuoteLineItem)mapOppQuoP2PeQli.get('QuoteLineItem');
		String strData = '{ }';
		Map<String, Object> gc = CON_ContractsContainer_CTRL.guardaContrato(strData);
	}
	
	// strData has a valid qli
	@isTest
    static void guardaContratoTest3() {
		Map<String, Object> mapOppQuoP2PeQli = (Map<String, Object>)TestDataFactory_TEST.createQuoteLineItem();
		QuoteLineItem qli = (QuoteLineItem)mapOppQuoP2PeQli.get('QuoteLineItem');
		String strData = '{ "qli": "' + qli.Id + '" }';
		Map<String, Object> gc = CON_ContractsContainer_CTRL.guardaContrato(strData);
	}
	
	// strData has an invalid qli
	@isTest
    static void guardaContratoTest4() {
		Map<String, Object> mapOppQuoP2PeQli = (Map<String, Object>)TestDataFactory_TEST.createQuoteLineItem();
		QuoteLineItem qli = (QuoteLineItem)mapOppQuoP2PeQli.get('QuoteLineItem');
		String strData = '{ "qli": "" }';
		try {
			Map<String, Object> gc = CON_ContractsContainer_CTRL.guardaContrato(strData);
		} catch (CON_ContractsContainer_CTRL.CustomException ce) {}
	}
	
	// strData has the "finalizar" key
	@isTest
    static void guardaContratoTest5() {
		Map<String, Object> mapOppQuoP2PeQli = (Map<String, Object>)TestDataFactory_TEST.createQuoteLineItem();
		QuoteLineItem qli = (QuoteLineItem)mapOppQuoP2PeQli.get('QuoteLineItem');
		String strData = '{ "qli": "' + qli.Id + '", "finalizar": "finalizar" }';
		Map<String, Object> gc = CON_ContractsContainer_CTRL.guardaContrato(strData);
	}
	
	// The opportunity has a legal representative contact
	@isTest
    static void guardaContratoTest6() {
		Map<String, Object> mapOppQuoP2PeQli = (Map<String, Object>)TestDataFactory_TEST.createQuoteLineItem();
		Contact con = TestDataFactory_TEST.createContact();
		con.Funcion__c = 'Representante Legal';
        con.Curp__c='AAPD940930HGRMNY09';
		update con;
		Opportunity opp = (Opportunity)mapOppQuoP2PeQli.get('Opportunity');
		opp.Contacto__c = con.Id;
		update opp;
		QuoteLineItem qli = (QuoteLineItem)mapOppQuoP2PeQli.get('QuoteLineItem');
		String strData = '{ "qli": "' + qli.Id + '" }';
		Map<String, Object> gc = CON_ContractsContainer_CTRL.guardaContrato(strData);
        CON_ContractsContainer_CTRL.getDireccionesFiscales(opp.AccountId, opp.Id);
	}
	
	// strData has the "oportunidad" key
	@isTest
	static void guardaContratoTest7() {
		Map<String, Object> mapOppQuoP2PeQli = (Map<String, Object>)TestDataFactory_TEST.createQuoteLineItem();
		Opportunity opp = (Opportunity)mapOppQuoP2PeQli.get('Opportunity');
		QuoteLineItem qli = (QuoteLineItem)mapOppQuoP2PeQli.get('QuoteLineItem');
		String strData = '{ "qli": "' + qli.Id + '", "oportunidad": { "Id": "' + opp.Id + '" } }';
		Map<String, Object> gc = CON_ContractsContainer_CTRL.guardaContrato(strData);
	}
	
	// With Contract - Subsidiaries to save and delete
	@isTest
	static void guardaContratoTest8() {
		Map<String, Object> mapOppQuoP2PeQli = (Map<String, Object>)TestDataFactory_TEST.createQuoteLineItem();
		QuoteLineItem qli = (QuoteLineItem)mapOppQuoP2PeQli.get('QuoteLineItem');
		ContratoFilial__c cf1 = new ContratoFilial__c();
		insert cf1;
		ContratoFilial__c cf2 = new ContratoFilial__c();
		insert cf2;
		String strData = '{ "qli": "' + qli.Id + '", "contratoFilial": { "paraGuardar": [{ "Id": "' + cf1.Id + '" }], "paraEliminar": [{ "Id": "' + cf2.Id + '" }] } }';
		Map<String, Object> gc = CON_ContractsContainer_CTRL.guardaContrato(strData);
	}
	
	// query is valid
	@isTest
	static void executeQueryTest1() {
		String query = 'SELECT Id, Name FROM Opportunity LIMIT 1';
		Object listSo = CON_ContractsContainer_CTRL.executeQuery(query);
	}
	
	// query is null
	@isTest
	static void executeQueryTest2() {
		try {
			Object listSo = CON_ContractsContainer_CTRL.executeQuery(null);
		} catch(System.NullPointerException npe) {}
	}
	
	// query is invalid
	@isTest
	static void executeQueryTest3() {
		String query = 'SELECT Id, Name, StageName FROM Contact LIMIT 1';
		try {
			Object listSo = CON_ContractsContainer_CTRL.executeQuery(query);
		} catch(System.QueryException qe) {}
	}
	
	// objs is empty
	@isTest
	static void describeSObjectsTest1() {
		String[] objs = new List<String>();
		Map<String, Object> mapDso = CON_ContractsContainer_CTRL.describeSObjects(objs);
	}
	
	// objs has a valid SObject name
	@isTest
	static void describeSObjectsTest2() {
		String[] objs = new List<String>();
		objs.add('Opportunity');
		Map<String, Object> mapDso = CON_ContractsContainer_CTRL.describeSObjects(objs);
	}
	
	// Calling guardaPDFBase64 with invalid arguments
	@isTest
	static void guardaPDFBase64Test1() {
		Map<String, Object> mapGpdfb64 = CON_ContractsContainer_CTRL.guardaPDFBase64('', '');
	}
	
	// Calling guardaPDFBase64 with valid arguments
	@isTest
	static void guardaPDFBase64Test2() {
		Map<String, Object> mapOppQuoP2PeQli = (Map<String, Object>)TestDataFactory_TEST.createQuoteLineItem();
		QuoteLineItem qli = (QuoteLineItem)mapOppQuoP2PeQli.get('QuoteLineItem');
		Map<String, Object> mapGpdfb64 = CON_ContractsContainer_CTRL.guardaPDFBase64(qli.Id, 'strDataBase64');
	}
	
	// Calling guardaPDFBase64 with an unknown qli Id
	@isTest
	static void guardaPDFBase64Test3() {
		Map<String, Object> mapOppQuoP2PeQli = (Map<String, Object>)TestDataFactory_TEST.createQuoteLineItem();
		QuoteLineItem qli = (QuoteLineItem)mapOppQuoP2PeQli.get('QuoteLineItem');
		Id qliId = qli.Id;
		delete qli;
		Map<String, Object> mapGpdfb64 = CON_ContractsContainer_CTRL.guardaPDFBase64(qliId, 'strDataBase64');
	}
	
	// Calling guardaPDFBase64 with a contract record associated to the quote
	@isTest
	static void guardaPDFBase64Test4() {
		Map<String, Object> mapOppQuoP2PeQli = (Map<String, Object>)TestDataFactory_TEST.createQuoteLineItem();
		Opportunity opp = (Opportunity)mapOppQuoP2PeQli.get('Opportunity');
		Attachment attach = TestDataFactory_TEST.createAttachment(opp.Id);
		Quote quo = (Quote)mapOppQuoP2PeQli.get('Quote');
		QuoteDocument qd = TestDataFactory_TEST.createQuoteDocument(quo.Id, 'attachmentBody');
		quo.IdPDFContrato__c = qd.Id;
		update quo;
		QuoteLineItem qli = (QuoteLineItem)mapOppQuoP2PeQli.get('QuoteLineItem');
		Map<String, Object> mapGpdfb64 = CON_ContractsContainer_CTRL.guardaPDFBase64(qli.Id, 'strDataBase64');
	}
	
	@isTest
    static void executeQueryRATest() {
		String query = 'SELECT Id, Name FROM Opportunity LIMIT 1';
		List<SObject> listSo = CON_ContractsContainer_CTRL.executeQueryRA(query);
	}
	
	@isTest
    static void getContratoTicketCarDataTest() {
		Map<String, Object> mapOppQuoP2PeQli = (Map<String, Object>)TestDataFactory_TEST.createQuoteLineItem();
		QuoteLineItem qli = (QuoteLineItem)mapOppQuoP2PeQli.get('QuoteLineItem');
		List<QuoteLineItem> listQli = CON_ContractsContainer_CTRL.getContratoTicketCarData(qli.Id);
	}
	
	@isTest
    static void getListCamposTest() {
		List<String> listC = CON_ContractsContainer_CTRL.getListCampos(new Opportunity().getSObjectType());
	}
	
	@isTest
    static void getStrCamposTest() {
		String sc = CON_ContractsContainer_CTRL.getStrCampos(new Opportunity().getSObjectType());
	}
	
	// Calling getContrato without a created instance of contract
	@isTest
    static void getContratoTest1() {
		Map<String, Object> mapOppQuoP2PeQli = (Map<String, Object>)TestDataFactory_TEST.createQuoteLineItem();
		QuoteLineItem qli = (QuoteLineItem)mapOppQuoP2PeQli.get('QuoteLineItem');
		Contrato2__c c2 = CON_ContractsContainer_CTRL.getContrato(qli.Id);
	}
	
	// Calling getContrato with a created instance of contract
	@isTest
    static void getContratoTest2() {
		Map<String, Object> mapOppQuoP2PeQli = (Map<String, Object>)TestDataFactory_TEST.createQuoteLineItem();
		QuoteLineItem qli = (QuoteLineItem)mapOppQuoP2PeQli.get('QuoteLineItem');
		Contrato2__c c2 = new Contrato2__c(PartidaPresupuesto__c = qli.Id);
		insert c2;
		Contrato2__c c = CON_ContractsContainer_CTRL.getContrato(qli.Id);
	}
	
	@isTest
    static void upsertSobjectsTest() {
		Opportunity opp = TestDataFactory_TEST.createOpportunity();
		List<Opportunity> listOpp = new List<Opportunity>();
		listOpp.add(opp);
		List<Database.UpsertResult> listDur = CON_ContractsContainer_CTRL.upsertSobjects(listOpp);
	}
	
	// Calling updateContratoADV without a created instance of contract
	@isTest
	static void updateContratoADVTest1() {
		String jsonContrato = '{}';
		String jsonOportunidad = '{}';
		Map<String, String> mapUcadv = CON_ContractsContainer_CTRL.updateContratoADV(jsonContrato, jsonOportunidad);
	}
	
	// Calling updateContratoADV with a created instance of contract
	/*@isTest
	static void updateContratoADVTest2() {
		Contrato2__c c2 = new Contrato2__c();
		insert c2;
		String jsonContrato = '{ "Id": "' + c2.Id + '", "EtapaContrato__c": "Autorizado" }';
		Opportunity opp = TestDataFactory_TEST.createOpportunity();
		String jsonOportunidad = '{ "Id": "' + opp.Id + '" }';
		Map<String, String> mapUcadv = CON_ContractsContainer_CTRL.updateContratoADV(jsonContrato, jsonOportunidad);
	}*/
	
	// Calling updateContratoADV without a created instance of contract
	@isTest
	static void updateContratoADV2Test1() {
		String jsonContrato = '{}';
		String jsonOportunidad = '{}';
		String extras = '{}';
		Map<String, String> mapUcadv = CON_ContractsContainer_CTRL.updateContratoADV2(jsonContrato, jsonOportunidad, extras);
        Map<String, String> mapUcadv2 = CON_ContractsContainer_CTRL.updateContratoAfiliadoADV2(jsonContrato, jsonOportunidad, extras);
	}
	
	// Calling updateContratoADV with a created instance of contract
	/*@isTest
	static void updateContratoAD2VTest2() {
		Contrato2__c c2 = new Contrato2__c();
		insert c2;
		String jsonContrato = '{ "Id": "' + c2.Id + '", "EtapaContrato__c": "Autorizado" }';
		Opportunity opp = TestDataFactory_TEST.createOpportunity();
		String jsonOportunidad = '{ "Id": "' + opp.Id + '" }';
		String extras = '{}';
		Map<String, String> mapUcadv = CON_ContractsContainer_CTRL.updateContratoADV2(jsonContrato, jsonOportunidad, extras);
	}*/
	
	// Calling updateContratoADV with a created instance of contract and a subsidiary
	/*@isTest
	static void updateContratoAD2VTest3() {
		Contrato2__c c2 = new Contrato2__c();
		insert c2;
		String jsonContrato = '{ "Id": "' + c2.Id + '", "EtapaContrato__c": "Autorizado" }';
		Opportunity opp = TestDataFactory_TEST.createOpportunity();
		String jsonOportunidad = '{ "Id": "' + opp.Id + '" }';
		String extras = '[{ "Name": "Sub Test", "CodigoAS400__c": "11-11-12345-124" }]';
		Map<String, String> mapUcadv = CON_ContractsContainer_CTRL.updateContratoADV2(jsonContrato, jsonOportunidad, extras);
        
        CON_ContractsContainer_CTRL.generaXMLExtras( opp.Id, c2.Id, new List<ContratoFilial__c>(), extras );
	}*/
	
	// Calling updateContratoADV with a created instance of contract
	@isTest
	static void updateContratoAD2VTest4() {
		String jsonContrato = '{ "Id": "null", "CodigoAS400__c": "11-11-12345-126", "EtapaContrato__c": "Autorizado" }';
		Opportunity opp = TestDataFactory_TEST.createOpportunity();
		String jsonOportunidad = '{ "Id": "' + opp.Id + '" }';
		String extras = '[{ "Name": "Sub Test", "CodigoAS400": "11-11-12345-125" }]';
		Map<String, String> mapUcadv = CON_ContractsContainer_CTRL.updateContratoADV2(jsonContrato, jsonOportunidad, extras);
	}
	
	// Calling updateOportunidadADV without a created instance of opportunity
	@isTest
	static void updateOportunidadADVTest1() {
		String jsonOportunidad = '{}';
		Map<String, String> mapUcadv = CON_ContractsContainer_CTRL.updateOportunidadADV(jsonOportunidad);
	}
	
	// Calling updateOportunidadADV with a created instance of opportunity
	@isTest
	static void updateOportunidadADVTest2() {
		Opportunity opp = TestDataFactory_TEST.createOpportunity();
		String jsonOportunidad = '{ "Id": "' + opp.Id + '" }';
		Map<String, String> mapUcadv = CON_ContractsContainer_CTRL.updateOportunidadADV(jsonOportunidad);
	}
		
	// Calling updateContratoADV with a created instance of contract
	@isTest
	static void updateContratoADVTest3() {
        test.startTest();
		Map<String, Object> mapOppQuoP2PeQli = (Map<String, Object>)TestDataFactory_TEST.createQuoteLineItem();
		QuoteLineItem qli = (QuoteLineItem)mapOppQuoP2PeQli.get('QuoteLineItem');
		Contrato2__c contrato = new Contrato2__c(PartidaPresupuesto__c = qli.Id,EtapaContrato__c = 'Rechazado para corrección');
		insert contrato;
		String jsonContrato = JSON.serialize(contrato);
		Opportunity opp = TestDataFactory_TEST.createOpportunity();
        opp.FechaFinADV__c = system.today();
        opp.FechaInicioADV__c = system.today();
        opp.NumeroAltaCliente__c = '1234567';
        update opp;
		String jsonOportunidad = JSON.serialize(opp);
		Map<String, String> mapUcadv = CON_ContractsContainer_CTRL.updateContratoADV(jsonContrato, jsonOportunidad);
        test.stopTest();
    }
	@isTest
    static void validateOppAttachmentsTest() {
		Opportunity opp = TestDataFactory_TEST.createOpportunity();
		Map<String, Object> mapOppDocs = (Map<String, Object>)CON_ContractsContainer_CTRL.validateOppAttachments(opp.Id);
	}
	
	// With valid data
	@isTest
	static void saveLayoutTest1() {
		Opportunity opp = TestDataFactory_TEST.createOpportunity();
		Map<String, Object> mapSl = (Map<String, Object>)CON_ContractsContainer_CTRL.saveLayout(null, opp.Id, 'attachName', 'attachBody', '.pdf');
	}
	
	// With an invalid attachBody String
	@isTest
	static void saveLayoutTest2() {
		Opportunity opp = TestDataFactory_TEST.createOpportunity();
		try {
			Map<String, Object> mapSl = (Map<String, Object>)CON_ContractsContainer_CTRL.saveLayout(null, opp.Id, 'attachName', null, '.pdf');
		} catch(System.Exception e) {}
	}
	
	// With a valid attachId
	@isTest
	static void deleteLayoutFACTest1() {
		Opportunity opp = TestDataFactory_TEST.createOpportunity();
		Attachment attach = TestDataFactory_TEST.createAttachment(opp.Id);
		Map<String, Object> mapSl = (Map<String, Object>)CON_ContractsContainer_CTRL.deleteLayoutFAC(attach.Id);
	}
	
	// With an invalid attachId
	@isTest
	static void deleteLayoutFACTest2() {
		try {
			Map<String, Object> mapSl = (Map<String, Object>)CON_ContractsContainer_CTRL.deleteLayoutFAC(null);
		} catch(System.Exception e) {}
	}
	
	// With a valid accId
	@isTest
	static void getLegalEntitiesThroughAccTest1() {
		Account acc = TestDataFactory_TEST.createAccount();
		List<EntidadCuenta__c> listLeta = (List<EntidadCuenta__c>)CON_ContractsContainer_CTRL.getLegalEntitiesThroughAcc(acc.Id);
	}
	
	// With an invalid accId
	@isTest(seeAllData=true)
	static void getLegalEntitiesThroughAccTest2() {
		Opportunity opp = TestDataFactory_TEST.createOpportunity();
		try {
			Map<String, Object> mapLeta = (Map<String, Object>)CON_ContractsContainer_CTRL.getLegalEntitiesThroughAcc(opp.Id);
		} catch(System.Exception e) {}
	}
	
	// Calling with a valid Contract Id
	@isTest
	static void getAccountsStructureFromContractTest1() {
		Map<String, Object> mapOppQuoP2PeQli = (Map<String, Object>)TestDataFactory_TEST.createQuoteLineItem();
		QuoteLineItem qli = (QuoteLineItem)mapOppQuoP2PeQli.get('QuoteLineItem');
		Contrato2__c c2 = new Contrato2__c(PartidaPresupuesto__c = qli.Id);
		insert c2;
		Contrato2__c newC2 = (Contrato2__c)CON_ContractsContainer_CTRL.getAccountsStructureFromContract(c2.Id);
	}
	
	// Calling with an invalid Contract Id
	@isTest
	static void getAccountsStructureFromContractTest2() {
		try {
			Contrato2__c newC2 = (Contrato2__c)CON_ContractsContainer_CTRL.getAccountsStructureFromContract(null);
		} catch(System.Exception e) {}
	}
	
	// Calling with a valid Contract Id
	@isTest
	static void getContractSubsidiariesTest1() {
		Map<String, Object> mapOppQuoP2PeQli = (Map<String, Object>)TestDataFactory_TEST.createQuoteLineItem();
		QuoteLineItem qli = (QuoteLineItem)mapOppQuoP2PeQli.get('QuoteLineItem');
		Contrato2__c c2 = new Contrato2__c(PartidaPresupuesto__c = qli.Id);
		insert c2;
		List<ContratoFilial__c> cf = (List<ContratoFilial__c>)CON_ContractsContainer_CTRL.getContractSubsidiaries(c2.Id);
	}
	
	// Calling with an invalid Contract Id
	@isTest
	static void getContractSubsidiariesTest2() {
            Opportunity opp = TestDataFactory_TEST.createOpportunity();
            try {
                List<ContratoFilial__c> cf = (List<ContratoFilial__c>)CON_ContractsContainer_CTRL.getContractSubsidiaries(opp.Id);
            } catch(System.Exception e) {}
	}
	
	@isTest
	static void getLimitsTest() {
		Map<String, Object> mapGl = CON_ContractsContainer_CTRL.getLimits();
	}
	
	@isTest
	static void saveS400FilialesTest1() {
		ContratoFilial__c cf1 = new ContratoFilial__c();
		insert cf1;
		ContratoFilial__c cf2 = new ContratoFilial__c();
		insert cf2;
		String jsonFiliales = '[{ "Id": "' + cf1.Id + '" }, { "Id": "' + cf2.Id + '" }]';
		String response = CON_ContractsContainer_CTRL.saveS400Filiales(jsonFiliales);
        
        String responsew = CON_ContractsContainer_CTRL.saveS400FilialesAfiliados(jsonFiliales);
		//System.assertNotEquals('Exito al guardar codigos AS400 en filiales', response);
	}
	
	@isTest
	static void saveS400FilialesTest2() {
		String jsonFiliales = '[{ "Id": "" }]';
		try {
			String response = CON_ContractsContainer_CTRL.saveS400Filiales(jsonFiliales);
		} catch(System.Exception e) {}
	}
	
}
