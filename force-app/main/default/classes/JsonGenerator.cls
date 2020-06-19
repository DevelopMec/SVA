public with sharing class JsonGenerator {

    public class A { 
        String str;
        
        public A(String s) { str = s; }
    }

    static void generateJSONContent() {
        
               system.JSONGenerator gen = system.JSON.createGenerator(true);
       List<EntidadLegal__c>  EntidadList = [SELECT ID, FEA__c,AccountNumber__c,DeedDate__c,KeyNumber__c,Geolocation__c,DeedNumber__c  FROM EntidadLegal__c ];
   	List<Contact> conList = [SELECT ID, firstName, lastName, Phone, Gender__c FROM Contact ];
        
   				gen.writeStartObject();
             gen.writeNumberField('EntityID', 0);
             gen.writeStringField('OrigenSystemType', '');
            gen.writeStringField('PersonTypeID','');
            gen.writeStringField('RelatedPersonType','');
            gen.writeStringField('PersonName', 'NOMBRE EMPRESA SA DE CV');
            gen.writeStringField('PaternalSurname', '');
            gen.writeStringField('MaternalSurname', '');
            gen.writeStringField('FiscalPersonType', '');
            gen.writeStringField('TaxID','');
           // gen.writeDateField('Birthdate', 1983-10-22);
            gen.writeStringField('IsForeignCitizen','' );
            gen.writeStringField('NationalityCountry', '');
            gen.writeNumberField('EconomicActivityCode', 0);
            gen.writeStringField('ProfessionName', '');
             gen.writeNumberField('ClientCode', 5);
            gen.writeStringField('PEP', '');
            gen.writeStringField('Street', '');
/*            "OutsiderNumber": "78",
            "InternalNumber": "2",
            "Suburb": "GRANADA",
            "City": "CIUDAD DE MEXICO",
            "State": "",
            "Country": "MEXICO",
            "ZipCode": "1070",
            "Locality": "99999999",
            "Telephone1": "5514878954",
            "ReferenceID": "0",
            "BirthCountry": "MEXICO",
            "ContractCode": "55488844",
            "CURP": "",
            "Email": "correo@correo.com",
            "WebPage": "www.pagina.com",
            "FEA": "1",
            "MaritalStatusID": "8787",
            "Ocupation": "5555555",
            "EmployeeCode": "30611",
            "WritingNumber": "",
            "WritingDate": "",
            "PositionPEP": "",
            "IsActingBehalfThirdPerson": "",
            "RealOwnerName": "",
            "LocalForexOperationsReason": "",
            "County": "MEXICO",
            "Telephone2": "",
            "Fax": "",
            "OriginResource": "",
            "HasAttorney": "",
            "ImportDate": "",
            "Reference1": "",
            "CheckSum": "2020-04-23"
            "Generic1RiskValueDescriptionString": "C001",
            "Generic2RiskValueDescriptionString": "001",
            "Generic3RiskValueDescriptionString": "001",
            "Generic4RiskValueDescriptionString": "001",
            "Generic5RiskValueDescriptionString": "002",
            "Generic6RiskValueDescriptionString": "001",
            "Generic7RiskValueDescriptionString": "001",
            "Generic8RiskValueDescriptionString": "001",
            "Generic9RiskValueDescriptionString": "",
            "Generic10RiskValueDescriptionString": "",
            "BirthState": "CIUDAD DE MEXICO",
            "IsMale": "0",
            "IsOnDemand": 0
            "Generic11RiskValueDescriptionString": "",
            "Generic12RiskValueDescriptionString": "",
            "Generic13RiskValueDescriptionString": "",
            "Generic14RiskValueDescriptionString": "",
            "Generic15RiskValueDescriptionString": "",
            "Generic16RiskValueDescriptionString": "",
            "Generic17RiskValueDescriptionString": "",
            "Generic18RiskValueDescriptionString": "",
            "Generic19RiskValueDescriptionString": "",
            "Generic20RiskValueDescriptionString": "",
            "Generic21RiskValueDescriptionString": "",
            "Generic22RiskValueDescriptionString": "",
            "Generic23RiskValueDescriptionString": "",
            "Generic24RiskValueDescriptionString": "",
            "Generic25RiskValueDescriptionString": "",
            "SofomCode": "",
            "TaxiIDCounty": "MEXICO",
            "BeneficiaryPct": "0",
            "RelatedPersonAccount": ""
       jsonGen.writeEndObject(); 
*/
 

    }
}