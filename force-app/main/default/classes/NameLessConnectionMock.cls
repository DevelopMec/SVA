@isTest
global class NameLessConnectionMock implements HttpCalloutMock {
    public Integer indicador{get;set;}
    
    public NameLessConnectionMock(Integer ind){
        this.indicador=ind;
    }
    global HTTPResponse respond(HTTPRequest req) {
        MuleSoftJSON.cls_customers [] liD=getCustomer();
        MuleSoftJSON.cls_data clsd=new MuleSoftJSON.cls_data();
        clsd.customers=liD;
        clsd.paging=getPaging();
        
        MuleSoftJSON.cls_dataOnly clsdO=new MuleSoftJSON.cls_dataOnly();
        clsdO.customer=getCustom();
        
        MuleSoftJSON ml=new MuleSoftJSON();
        ml.data=clsd;
        ml.dataOnly=clsdO;
        //System.debug('::JSON:::'+JSON.serialize(ml));
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        Map<String,Object> ma=new Map<String,Object>{'access_token'=>'testResp'};
            if(req.getEndpoint().contains('testToken')){
                res.setBody(JSON.serialize(ma));
            }else if(req.getEndpoint().contains('testNameLess')){                
                res.setBody(JSON.serialize(ml));
            }else if(req.getEndpoint().contains('testNameBy')){
                if(indicador==1){
                    res.setBody('{ "meta": null, "data": { "paging": null, "customer": { "tax_payer_identifier": "test", "tax_kind": null, "product_identifier": "1", "phone": "1234567890", "legal_entity_identifier": null, "legacy": null, "identifier": "1", "groupx": null, "group_identifier": "test", "EntidadLegal": { "attributes": { "type": "EntidadLegal__c" }, "Name": "test" }, "EntidadCuenta": { "attributes": { "type": "EntidadCuenta__c" }, "Name": "testEC", "Cuenta__c": null, "EntidadLegal__c": null }, "customer_type": null, "Cuenta": null, "ContratoFilial": { "attributes": { "type": "ContratoFilial__c" }, "Name": "testCF" }, "contract": null, "contact": null, "commercial_name": "test", "business_name": null, "business_line": null, "branch_identifier": "1", "address": { "zip_code": "11520", "street2": null, "street": "test", "postal_box": null, "municipality": null, "longitude": null, "latitude": null, "internal_number": "test", "district_code": null, "country_ref": null, "city": "CDMX", "building_number": "test", "additional_info": null }, "account": null } }, "dataOnly": { "paging": { "total_records": 2, "page_size": 2, "page_index": 1, "all": null }, "customers": [ { "tax_payer_identifier": "test", "tax_kind": null, "product_identifier": "0", "phone": null, "legal_entity_identifier": null, "legacy": null, "identifier": "0", "groupx": null, "group_identifier": "test", "EntidadLegal": { "attributes": { "type": "EntidadLegal__c" }, "Name": "test0" }, "EntidadCuenta": { "attributes": { "type": "EntidadCuenta__c" }, "Name": "testEC0", "Cuenta__c": null, "EntidadLegal__c": null }, "customer_type": null, "Cuenta": null, "ContratoFilial": { "attributes": { "type": "ContratoFilial__c" }, "Name": "testCF0" }, "contract": null, "contact": null, "commercial_name": null, "business_name": null, "business_line": null, "branch_identifier": "0", "address": null, "account": null }, { "tax_payer_identifier": "test", "tax_kind": null, "product_identifier": "1", "phone": null, "legal_entity_identifier": null, "legacy": null, "identifier": "1", "groupx": null, "group_identifier": "test3", "EntidadLegal": { "attributes": { "type": "EntidadLegal__c" }, "Name": "test1" }, "EntidadCuenta": { "attributes": { "type": "EntidadCuenta__c" }, "Name": "testEC1", "Cuenta__c": null, "EntidadLegal__c": null }, "customer_type": null, "Cuenta": null, "ContratoFilial": { "attributes": { "type": "ContratoFilial__c" }, "Name": "testCF1" }, "contract": null, "contact": null, "commercial_name": null, "business_name": null, "business_line": null, "branch_identifier": "1", "address": { "zip_code": "11520", "street2": null, "street": "test", "postal_box": null, "municipality": null, "longitude": null, "latitude": null, "internal_number": "test", "district_code": null, "country_ref": null, "city": "CDMX", "building_number": "test", "additional_info": null }, "account": null } ] } }');
                }else{
                    res.setBody('{ "meta": null, "data": { "paging": null, "customer": { "tax_payer_identifier": "test", "tax_kind": null, "product_identifier": "1", "phone": "1234567890", "legal_entity_identifier": null, "legacy": null, "identifier": "1", "groupx": null, "group_identifier": "test", "EntidadLegal": null, "EntidadCuenta": { "attributes": { "type": "EntidadCuenta__c" }, "Name": "testEC", "Cuenta__c": null, "EntidadLegal__c": null }, "customer_type": null, "Cuenta": null, "ContratoFilial": { "attributes": { "type": "ContratoFilial__c" }, "Name": "testCF" }, "contract": null, "contact": null, "commercial_name": "test", "business_name": null, "business_line": null, "branch_identifier": "1", "address": { "zip_code": "11520", "street2": null, "street": "test", "postal_box": null, "municipality": null, "longitude": null, "latitude": null, "internal_number": "test", "district_code": null, "country_ref": null, "city": "CDMX", "building_number": "test", "additional_info": null }, "account": null } }, "dataOnly": { "paging": { "total_records": 2, "page_size": 2, "page_index": 1, "all": null }, "customers": [ { "tax_payer_identifier": "test", "tax_kind": null, "product_identifier": "0", "phone": null, "legal_entity_identifier": null, "legacy": null, "identifier": "0", "groupx": null, "group_identifier": "test", "EntidadLegal": null, "Name": "test0" , "EntidadCuenta": { "attributes": { "type": "EntidadCuenta__c" }, "Name": "testEC0", "Cuenta__c": null, "EntidadLegal__c": null }, "customer_type": null, "Cuenta": null, "ContratoFilial": { "attributes": { "type": "ContratoFilial__c" }, "Name": "testCF0" }, "contract": null, "contact": null, "commercial_name": null, "business_name": null, "business_line": null, "branch_identifier": "0", "address": null, "account": null }, { "tax_payer_identifier": "test", "tax_kind": null, "product_identifier": "1", "phone": null, "legal_entity_identifier": null, "legacy": null, "identifier": "1", "groupx": null, "group_identifier": "test3", "EntidadLegal": null, "Name": "test1" , "EntidadCuenta": { "attributes": { "type": "EntidadCuenta__c" }, "Name": "testEC1", "Cuenta__c": null, "EntidadLegal__c": null }, "customer_type": null, "Cuenta": null, "ContratoFilial": { "attributes": { "type": "ContratoFilial__c" }, "Name": "testCF1" }, "contract": null, "contact": null, "commercial_name": null, "business_name": null, "business_line": null, "branch_identifier": "1", "address": { "zip_code": "11520", "street2": null, "street": "test", "postal_box": null, "municipality": null, "longitude": null, "latitude": null, "internal_number": "test", "district_code": null, "country_ref": null, "city": "CDMX", "building_number": "test", "additional_info": null }, "account": null } ] } }');
                }
                
            }
        
        res.setStatusCode(200);
        return res;
    }
    public List<MuleSoftJSON.cls_customers> getCustomer(){        
        MuleSoftJSON.cls_customers tem;
        List<MuleSoftJSON.cls_customers> ltem=new List<MuleSoftJSON.cls_customers>(); 
        for(Integer i=0;i<2;i++){
            tem=new MuleSoftJSON.cls_customers();
            tem.branch_identifier=''+i;
            tem.product_identifier=''+i;
            tem.group_identifier= i==0?'test':''+i;
            tem.identifier=''+i;
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
            Account acc=new Account(Name='testAcc'+i,CodigoClienteAS400__c='test'+i);
            //insert acc;
            EntidadLegal__c el=new EntidadLegal__c(Name='test'+i);
            //insert el;
            ContratoFilial__c cf=new ContratoFilial__c(Name='testCF'+i);
            //insert cf;
            EntidadCuenta__c ec=new EntidadCuenta__c(Name='testEC'+i,Cuenta__c=acc.Id,EntidadLegal__c=el.Id);
            //insert ec;       
            //tem.Cuenta=acc;            
            tem.EntidadCuenta=ec;
            tem.EntidadLegal=indicador==1 ? el : null;
            tem.ContratoFilial=indicador==1 ? cf : null;
            ltem.add(tem);
        }
        return ltem;
    }
    public MuleSoftJSON.cls_paging getPaging(){
        MuleSoftJSON.cls_paging res=new MuleSoftJSON.cls_paging();
        res.page_index=1;
        res.page_size=2;
        res.total_records=2;
        return res;
    }
    
    public MuleSoftJSON.cls_customers getCustom(){        
        MuleSoftJSON.cls_customers tem=new MuleSoftJSON.cls_customers();
        tem.branch_identifier='1';
        tem.product_identifier='1';
        tem.group_identifier='test';
        tem.identifier='1';
        tem.tax_payer_identifier='test';
        Account acc=new Account(Name='testAcc',CodigoClienteAS400__c='test');
        //insert acc;
        EntidadLegal__c el=new EntidadLegal__c(Name='test');
        //insert el;
        ContratoFilial__c cf=new ContratoFilial__c(Name='testCF');
        //insert cf;
        EntidadCuenta__c ec=new EntidadCuenta__c(Name='testEC',Cuenta__c=acc.Id,EntidadLegal__c=el.Id);
        //insert ec;       
        //tem.Cuenta=acc;            
        tem.EntidadCuenta=ec;
        tem.EntidadLegal=indicador==1 ? el : null;
        tem.ContratoFilial=cf;
        return tem;
    }
}