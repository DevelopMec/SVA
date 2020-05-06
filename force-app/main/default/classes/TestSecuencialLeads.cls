@isTest
Private class TestSecuencialLeads {
    @isTest
    static void configurandoLeads(){
        User DesarrolloCTConsulting = [SELECT Id FROM User WHERE Name = 'Desarrollo CTConsulting' LIMIT 1];
        
        System.runAs(DesarrolloCTConsulting){
            Lead LeadDespensaMVF = new Lead();
            LeadDespensaMVF.Company = 'Despensa MVF';
            LeadDespensaMVF.CountryCode = 'MX';
            LeadDespensaMVF.FIrstName = 'Despenson';
            LeadDespensaMVF.LastName = 'MVF';
            LeadDespensaMVF.phone = '0000000001';
            LeadDespensaMVF.email = 'despensa@mvf.com';
            LeadDespensaMVF.Status = 'No contactado';
            LeadDespensaMVF.LeadSource='Cambaceo';
            LeadDespensaMVF.ProductoInteres__c = 'Despensa';
            LeadDespensaMVF.NumEmpleados__c = '1-25';
            LeadDespensaMVF.RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Edenred').getRecordTypeId();
            LeadDespensaMVF.ContadorFamiliaDespensaMVF_Num__c = 1;
            
            insert LeadDespensaMVF;
            
            Lead LeadDespensaNOMVF = new Lead();
            LeadDespensaNOMVF.Company = 'Despensa NO MVF';
            LeadDespensaNOMVF.CountryCode = 'MX';
            LeadDespensaNOMVF.FIrstName = 'Despenson';
            LeadDespensaNOMVF.LastName = 'NO MVF';
            LeadDespensaNOMVF.phone = '0000000002';
            LeadDespensaNOMVF.email = 'despensa@nomvf.com';
            LeadDespensaNOMVF.Status = 'No contactado';
            LeadDespensaNOMVF.ProductoInteres__c = 'Despensa';
            LeadDespensaNOMVF.LeadSource='CPL';
            LeadDespensaNOMVF.SubOrigen__c = 'OCC';
            LeadDespensaNOMVF.NumEmpleados__c = '1-25';
            LeadDespensaNOMVF.RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Edenred').getRecordTypeId();
            LeadDespensaNOMVF.ContadorFamiliaDespensaOA_Num__c = 1;
            
            insert LeadDespensaNOMVF;
            Test.startTest();
            Lead LeadCombustibleMVF = new Lead();
            LeadCombustibleMVF.Company = 'Combustible MVF';
            LeadCombustibleMVF.CountryCode = 'MX';
            LeadCombustibleMVF.FIrstName = 'Combustibleson';
            LeadCombustibleMVF.LastName = 'MVF';
            LeadCombustibleMVF.phone = '0000000003';
            LeadCombustibleMVF.email = 'combustible@mvf.com';
            LeadCombustibleMVF.Status = 'No contactado';
            LeadCombustibleMVF.ProductoInteres__c = 'Combustible';
            LeadCombustibleMVF.LeadSource='CPL';
            LeadCombustibleMVF.SubOrigen__c = 'MVF';
            LeadCombustibleMVF.NumEmpleados__c = '1-25';
            LeadCombustibleMVF.RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Edenred').getRecordTypeId();
            LeadCombustibleMVF.ContadorFamiliaCombustibleMVF_Num__c = 1; 
            
            insert LeadCombustibleMVF;
            
            Lead LeadCombustibleNOMVF = new Lead();
            LeadCombustibleNOMVF.Company = 'Combustible NO MVF';
            LeadCombustibleNOMVF.CountryCode = 'MX';
            LeadCombustibleNOMVF.FIrstName = 'Combustibleson';
            LeadCombustibleNOMVF.LastName = 'NO MVF';
            LeadCombustibleNOMVF.phone = '0000000004';
            LeadCombustibleNOMVF.email = 'combustible@nomvf.com';
            LeadCombustibleNOMVF.Status = 'No contactado';
            LeadCombustibleNOMVF.ProductoInteres__c = 'Combustible';
            LeadCombustibleNOMVF.LeadSource='CPL';
            LeadCombustibleNOMVF.SubOrigen__c = 'OCC';
            LeadCombustibleNOMVF.NumEmpleados__c = '1-25';
            LeadCombustibleNOMVF.RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Edenred').getRecordTypeId();
            LeadCombustibleNOMVF.ContadorFamiliaCombustibleOA_Num__c = 1;
            
            insert LeadCombustibleNOMVF;
            
            Lead LeadViaticosMVF = new Lead();
            LeadViaticosMVF.Company = 'Viaticos MVF';
            LeadViaticosMVF.CountryCode = 'MX';
            LeadViaticosMVF.FIrstName = 'Viaticon';
            LeadViaticosMVF.LastName = 'MVF';
            LeadViaticosMVF.phone = '0000000005';
            LeadViaticosMVF.email = 'viaticos@mvf.com';
            LeadViaticosMVF.Status = 'No contactado';
            LeadViaticosMVF.ProductoInteres__c = 'Empresarial';
            LeadViaticosMVF.LeadSource='CPL';
            LeadViaticosMVF.SubOrigen__c = 'MVF';
            LeadViaticosMVF.NumEmpleados__c = '1-25';
            LeadViaticosMVF.RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Edenred').getRecordTypeId();
            LeadViaticosMVF.ContadorFamiliaViaticosMVF_Num__c = 1; 
            
            insert LeadViaticosMVF;   
            Test.stopTest();
        }
    }
    
    @isTest
    static void configurandoLeads2(){
        User DesarrolloCTConsulting = [SELECT Id FROM User WHERE Name = 'Desarrollo CTConsulting' LIMIT 1];
        
        System.runAs(DesarrolloCTConsulting){
            Lead LeadViaticosNOMVF = new Lead();
            LeadViaticosNOMVF.Company = 'Viaticos NO MVF';
            LeadViaticosNOMVF.CountryCode = 'MX';
            LeadViaticosNOMVF.FIrstName = 'Viaticon';
            LeadViaticosNOMVF.LastName = 'NO MVF';
            LeadViaticosNOMVF.phone = '0000000006';
            LeadViaticosNOMVF.email = 'viaticos@nomvf.com';
            LeadViaticosNOMVF.Status = 'No contactado';
            LeadViaticosNOMVF.ProductoInteres__c = 'Empresarial';
            LeadViaticosNOMVF.LeadSource='CPL';
            LeadViaticosNOMVF.SubOrigen__c = 'OCC';
            LeadViaticosNOMVF.NumEmpleados__c = '1-25';
            LeadViaticosNOMVF.RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Edenred').getRecordTypeId();
            LeadViaticosNOMVF.ContadorFamiliaViaticosOA_Num__c = 1;
            
            insert LeadViaticosNOMVF;
            
            Lead LeadOtrasFamilias = new Lead();
            LeadOtrasFamilias.Company = 'Otras Familias';
            LeadOtrasFamilias.CountryCode = 'MX';
            LeadOtrasFamilias.FIrstName = 'Otra';
            LeadOtrasFamilias.LastName = 'Familia';
            LeadOtrasFamilias.phone = '0000000007';
            LeadOtrasFamilias.email = 'otras@familia.com';
            LeadOtrasFamilias.Status = 'No contactado';
            LeadOtrasFamilias.ProductoInteres__c = 'Regalo';
            LeadOtrasFamilias.NumEmpleados__c = '1-25';
            LeadOtrasFamilias.LeadSource='Cambaceo';
            LeadOtrasFamilias.RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Edenred').getRecordTypeId();
            LeadOtrasFamilias.ContadorFamiliasRestantes_Num__c = 1;
            
            insert LeadOtrasFamilias;
            update LeadOtrasFamilias;
            
            Lead LeadDespensaMVF2 = new Lead();
            LeadDespensaMVF2.Company = 'Despensita MVF';
            LeadDespensaMVF2.CountryCode = 'MX';
            LeadDespensaMVF2.FIrstName = 'Despensita';
            LeadDespensaMVF2.LastName = 'MVF';
            LeadDespensaMVF2.phone = '1000000001';
            LeadDespensaMVF2.email = 'despensita@mvf.com';
            LeadDespensaMVF2.Status = 'No contactado';
            LeadDespensaMVF2.ProductoInteres__c = 'Despensa';
            LeadDespensaMVF2.LeadSource='CPL';
            LeadDespensaMVF2.SubOrigen__c = 'MVF';
            LeadDespensaMVF2.RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Edenred').getRecordTypeId();
            LeadDespensaMVF2.NumEmpleados__c = '1-25';
            
            insert LeadDespensaMVF2;
            Test.startTest();
            Lead LeadDespensaNOMVF2 = new Lead();
            LeadDespensaNOMVF2.Company = 'Desp NO MVF';
            LeadDespensaNOMVF2.CountryCode = 'MX';
            LeadDespensaNOMVF2.FIrstName = 'Desp';
            LeadDespensaNOMVF2.LastName = 'NO MVF';
            LeadDespensaNOMVF2.phone = '2000000002';
            LeadDespensaNOMVF2.email = 'desp@nomvf.com';
            LeadDespensaNOMVF2.Status = 'No contactado';
            LeadDespensaNOMVF2.ProductoInteres__c = 'Despensa';
            LeadDespensaNOMVF2.LeadSource='CPL';
            LeadDespensaNOMVF2.SubOrigen__c = 'OCC';
            LeadDespensaNOMVF2.RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Edenred').getRecordTypeId();
            LeadDespensaNOMVF2.NumEmpleados__c = '1-25';
            
            insert LeadDespensaNOMVF2;
            
            Lead LeadCombustibleMVF2 = new Lead();
            LeadCombustibleMVF2.Company = 'Comb MVF';
            LeadCombustibleMVF2.CountryCode = 'MX';
            LeadCombustibleMVF2.FIrstName = 'Comb';
            LeadCombustibleMVF2.LastName = 'MVF';
            LeadCombustibleMVF2.phone = '3000000003';
            LeadCombustibleMVF2.email = 'comb@mvf.com';
            LeadCombustibleMVF2.Status = 'No contactado';
            LeadCombustibleMVF2.ProductoInteres__c = 'Combustible';
            LeadCombustibleMVF2.LeadSource='CPL';
            LeadCombustibleMVF2.SubOrigen__c = 'MVF';
            LeadCombustibleMVF2.RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Edenred').getRecordTypeId();
            LeadCombustibleMVF2.N_mero_de_veh_culos__c = '1';
            
            
            insert LeadCombustibleMVF2;
            
            
            Test.stopTest();
        }
    }
    @isTest
    static void configurandoLeads3(){
        User DesarrolloCTConsulting = [SELECT Id FROM User WHERE Name = 'Desarrollo CTConsulting' LIMIT 1];
        
        System.runAs(DesarrolloCTConsulting){            
            Test.startTest();
            
            Lead LeadCombustibleNOMVF2 = new Lead();
            LeadCombustibleNOMVF2.Company = 'tible NO MVF';
            LeadCombustibleNOMVF2.CountryCode = 'MX';
            LeadCombustibleNOMVF2.FIrstName = 'tible';
            LeadCombustibleNOMVF2.LastName = 'NO MVF';
            LeadCombustibleNOMVF2.phone = '4000000004';
            LeadCombustibleNOMVF2.email = 'tible@nomvf.com';
            LeadCombustibleNOMVF2.Status = 'No contactado';
            LeadCombustibleNOMVF2.ProductoInteres__c = 'Combustible';
            LeadCombustibleNOMVF2.LeadSource='CPL';
            LeadCombustibleNOMVF2.SubOrigen__c = 'OCC';
            LeadCombustibleNOMVF2.RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Edenred').getRecordTypeId();
            LeadCombustibleNOMVF2.N_mero_de_veh_culos__c = '1';
            
            
            insert LeadCombustibleNOMVF2;
            
            Lead LeadViaticosMVF2 = new Lead();
            LeadViaticosMVF2.Company = 'Viat MVF';
            LeadViaticosMVF2.CountryCode = 'MX';
            LeadViaticosMVF2.FIrstName = 'Viat';
            LeadViaticosMVF2.LastName = 'MVF';
            LeadViaticosMVF2.phone = '5000000005';
            LeadViaticosMVF2.email = 'viat@mvf.com';
            LeadViaticosMVF2.Status = 'No contactado';
            LeadViaticosMVF2.ProductoInteres__c = 'Empresarial';
            LeadViaticosMVF2.SubOrigen__c = 'MVF';
            LeadViaticosMVF2.LeadSource='CPL';
            LeadViaticosMVF2.NumEmpleados__c = '1-25';
            LeadViaticosMVF2.RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Edenred').getRecordTypeId();
            LeadViaticosMVF2.ContadorFamiliaViaticosMVF_Num__c = 1; 
            
            insert LeadViaticosMVF2;
            
            Lead LeadViaticosNOMVF2 = new Lead();
            LeadViaticosNOMVF2.Company = 'cos NO MVF';
            LeadViaticosNOMVF2.CountryCode = 'MX';
            LeadViaticosNOMVF2.FIrstName = 'cos';
            LeadViaticosNOMVF2.LastName = 'NO MVF';
            LeadViaticosNOMVF2.phone = '6000000006';
            LeadViaticosNOMVF2.email = 'cos@nomvf.com';
            LeadViaticosNOMVF2.Status = 'No contactado';
            LeadViaticosNOMVF2.ProductoInteres__c = 'Empresarial';
            LeadViaticosNOMVF2.LeadSource='CPL';
            LeadViaticosNOMVF2.SubOrigen__c = 'OCC';
            LeadViaticosNOMVF2.NumEmpleados__c = '1-25';
            LeadViaticosNOMVF2.RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Edenred').getRecordTypeId();
            LeadViaticosNOMVF2.ContadorFamiliaViaticosOA_Num__c = 1;
            
            insert LeadViaticosNOMVF2;
            
            Lead LeadOtrasFamilias2 = new Lead();
            LeadOtrasFamilias2.Company = 'Otrs Fams';
            LeadOtrasFamilias2.CountryCode = 'MX';
            LeadOtrasFamilias2.FIrstName = 'Otrs';
            LeadOtrasFamilias2.LastName = 'Fams';
            LeadOtrasFamilias2.phone = '7000000007';
            LeadOtrasFamilias2.email = 'otrs@fams.com';
            LeadOtrasFamilias2.LeadSource='Cambaceo';
            LeadOtrasFamilias2.RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Edenred').getRecordTypeId();
            LeadOtrasFamilias2.Status = 'No contactado';
            LeadOtrasFamilias2.ProductoInteres__c = 'Regalo';
            LeadOtrasFamilias2.NumEmpleados__c = '1-25';
            
            insert LeadOtrasFamilias2;
            Test.stopTest();
        }
    }
}