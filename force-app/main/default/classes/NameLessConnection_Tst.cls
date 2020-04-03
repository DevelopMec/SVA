@isTest
public class NameLessConnection_Tst {
    @testSetup
    public static void testSetup(){
        Negocio__c neg=new Negocio__c();
        neg.TokenUrl__c='testToken';
        neg.ClientId__c='548';
        neg.Client_Secret__c='test';
        neg.Grant_type__c='client_credentials';
        neg.scope__c='hana.salesforce'; 
        neg.NameLessRead__c='testNameLess';
        neg.NameLess_ByIdentifie__c='testNameBy';
        insert neg;
        Account acc=new Account(Name='testAccq',CodigoClienteAS400__c='teste');
        insert acc;
        EntidadLegal__c el=new EntidadLegal__c(Name='VAGM1212121K2');
        insert el;
        EntidadCuenta__c ec=new EntidadCuenta__c(Name='VAGM1212121K2',Cuenta__c=acc.Id,EntidadLegal__c=el.Id,RFC_IDExterno__c='test23');
        insert ec;
        ContratoFilial__c cf= new ContratoFilial__c(Entidad_Cuenta__c=ec.Id,CodigoAS400__c='01-01-00001-001');
        insert cf;
    }
	@isTest
    public static void metodo1(){
        Test.startTest();        	
		Test.setMock(HttpCalloutMock.class, new NameLessConnectionMock(1));     
        NameLessConnection.oneExcute('1','18','4567','1');
        Test.stopTest();
    }
    @isTest
    public static void metodo2(){
        ContratoFilial__c cf= [Select Id from ContratoFilial__c where CodigoAS400__c='01-01-00001-001' limit 1];
        delete cf;
        EntidadCuenta__c ec=[Select Id from EntidadCuenta__c where Name='VAGM1212121K2' and RFC_IDExterno__c='test23' limit 1]; 
        delete ec;
        EntidadLegal__c el=[Select Id from EntidadLegal__c where Name='VAGM1212121K2'];
        delete el;
        Account acc=[Select Id from Account where Name='testAccq' and CodigoClienteAS400__c='teste'];
		delete acc;
        Test.startTest();        	
		Test.setMock(HttpCalloutMock.class, new NameLessConnectionMock(2));     
        NameLessConnection.oneExcute('1','18','4567','1');
        Test.stopTest();
    }
    @isTest
    public static void metodo3(){        
        Test.startTest();
        Negocio__c neg=[Select id from Negocio__c where TokenUrl__c='testToken' limit 1];
        update neg;
        Test.setMock(HttpCalloutMock.class, new NameLessConnectionMock(1));
        NameLessConnection.oneExcute('1','18','4567','1');
        Test.stopTest();
    }
    @isTest
    public static void MulesoftTest(){
        MuleSoftJSON.parse('{ "meta": null, "data": { "paging": null, "customer": { "tax_payer_identifier": "test", "tax_kind": null, "product_identifier": "1", "phone": "1234567890", "legal_entity_identifier": null, "legacy": null, "identifier": "1", "groupx": null, "group_identifier": "test", "EntidadLegal": { "attributes": { "type": "EntidadLegal__c" }, "Name": "test" }, "EntidadCuenta": { "attributes": { "type": "EntidadCuenta__c" }, "Name": "testEC", "Cuenta__c": null, "EntidadLegal__c": null }, "customer_type": null, "Cuenta": null, "ContratoFilial": { "attributes": { "type": "ContratoFilial__c" }, "Name": "testCF" }, "contract": null, "contact": null, "commercial_name": "test", "business_name": null, "business_line": null, "branch_identifier": "1", "address": { "zip_code": "11520", "street2": null, "street": "test", "postal_box": null, "municipality": null, "longitude": null, "latitude": null, "internal_number": "test", "district_code": null, "country_ref": null, "city": "CDMX", "building_number": "test", "additional_info": null }, "account": null } }, "dataOnly": { "paging": { "total_records": 2, "page_size": 2, "page_index": 1, "all": null }, "customers": [ { "tax_payer_identifier": "test", "tax_kind": null, "product_identifier": "0", "phone": null, "legal_entity_identifier": null, "legacy": null, "identifier": "0", "groupx": null, "group_identifier": "test", "EntidadLegal": { "attributes": { "type": "EntidadLegal__c" }, "Name": "test0" }, "EntidadCuenta": { "attributes": { "type": "EntidadCuenta__c" }, "Name": "testEC0", "Cuenta__c": null, "EntidadLegal__c": null }, "customer_type": null, "Cuenta": null, "ContratoFilial": { "attributes": { "type": "ContratoFilial__c" }, "Name": "testCF0" }, "contract": null, "contact": null, "commercial_name": null, "business_name": null, "business_line": null, "branch_identifier": "0", "address": null, "account": null }, { "tax_payer_identifier": "test", "tax_kind": null, "product_identifier": "1", "phone": null, "legal_entity_identifier": null, "legacy": null, "identifier": "1", "groupx": null, "group_identifier": "test3", "EntidadLegal": { "attributes": { "type": "EntidadLegal__c" }, "Name": "test1" }, "EntidadCuenta": { "attributes": { "type": "EntidadCuenta__c" }, "Name": "testEC1", "Cuenta__c": null, "EntidadLegal__c": null }, "customer_type": null, "Cuenta": null, "ContratoFilial": { "attributes": { "type": "ContratoFilial__c" }, "Name": "testCF1" }, "contract": null, "contact": null, "commercial_name": null, "business_name": null, "business_line": null, "branch_identifier": "1", "address": { "zip_code": "11520", "street2": null, "street": "test", "postal_box": null, "municipality": null, "longitude": null, "latitude": null, "internal_number": "test", "district_code": null, "country_ref": null, "city": "CDMX", "building_number": "test", "additional_info": null }, "account": null } ] } }');
        /*MuleSoftJSON.cls_customers tem;
        tem=new MuleSoftJSON.cls_customers();
        tem.branch_identifier='1';
        tem.product_identifier='1';
        tem.group_identifier='test';
        tem.identifier='1';
        tem.tax_payer_identifier='test';
        tem.commercial_name='test';
        tem.phone='1234567890';
        MuleSoftJSON.cls_address dir=new MuleSoftJSON.cls_address();
        dir.street='test';
        dir.building_number='test';
        dir.internal_number='test';
        dir.city='CDMX';
        dir.zip_code='11520';
        dir.street2='test';
        dir.postal_box='test';
        dir.district_code='test';
        dir.municipality='test';
        dir.country_ref='test';
        dir.additional_info='test';
        dir.latitude=12;
        dir.longitude=13;
        
        tem.address=dir;
        
        MuleSoftJSON.cls_contact ctc=new MuleSoftJSON.cls_contact();
        ctc.phone='23456789';
        ctc.alternative_phone='34567890';
        ctc.first_name='test';
        ctc.last_name='test';
        ctc.full_name='test';
        ctc.mother_maiden_name='test';
        ctc.typex='test';
        ctc.birth_date='12/12/12';
        ctc.extension_number='test';
        ctc.email='testt@test.com';
        ctc.capture_date='test';
        ctc.modified_date='test';
        ctc.fax='5678';
        ctc.invoice_email='test@test.com';
        tem.contact=ctc;
        Account acc=new Account(Name='testAcc',CodigoClienteAS400__c='test');
        EntidadLegal__c el=new EntidadLegal__c(Name='test');
        ContratoFilial__c cf=new ContratoFilial__c(Name='testCF');
        EntidadCuenta__c ec=new EntidadCuenta__c(Name='testEC',Cuenta__c=acc.Id,EntidadLegal__c=el.Id);          
        tem.EntidadCuenta=ec;
        tem.EntidadLegal=el;
        tem.ContratoFilial=cf;*/
    }
}