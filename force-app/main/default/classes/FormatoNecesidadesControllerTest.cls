@isTest
public class FormatoNecesidadesControllerTest {
    @isTest 
    static void myUnitTest(){
        System.debug('inicia prueba');
        lead prospecto = new lead( ProductoInteres__c = 'Combustible', LastName = 'lastNameTest', Company = 'TestCompany', Puesto__c='CEO o Dueño', LeadSource='Web', Status='No Contactado', NumEmpleados__c = '1-25', Email = 'test@mail.com',Phone='1234323232');
        insert prospecto;
        insert new Task(Subject='Llamada de prospección',WhoId=prospecto.Id);
        prospecto.Status='Calificado';
        update prospecto;
		
        Test.setCurrentPageReference(new PageReference('Page.myPage'));
		System.currentPageReference().getParameters().put('id', prospecto.Id);
        
        ApexPages.StandardController std = new ApexPages.StandardController(prospecto);
        FormatoNecesidadesController testNecesidades= new FormatoNecesidadesController(std);
        testNecesidades.regDespensa = new List<Necesidad__c>();
        testNecesidades.valorRadio='Despensa';
        testNecesidades.despensa= true;
        testNecesidades.gasolina= true;
        testNecesidades.mantenimiento= true;
        testNecesidades.restaurante= true;
        testNecesidades.uniforme= true;
        testNecesidades.empresarial= true;
        testNecesidades.incentivos= true;
        testNecesidades.generarNecesidades();
        testNecesidades.selecciona();
        testNecesidades.valorRadio='Despensa';
        testNecesidades.modificaRadioAplica();
        testNecesidades.valorRadio='Combustible';
        testNecesidades.modificaRadioAplica();
        testNecesidades.valorRadio='Mantenimiento';
        testNecesidades.modificaRadioAplica();
        testNecesidades.valorRadio='Ticket Restaurante';
        testNecesidades.modificaRadioAplica();
        testNecesidades.valorRadio='Uniforme';
        testNecesidades.modificaRadioAplica();
        testNecesidades.valorRadio='Regalo';
        testNecesidades.modificaRadioAplica();
        testNecesidades.valorRadio='Empresarial';
        testNecesidades.modificaRadioAplica();
        //PageReference pageRef = Page.Lead;
        //pageRef.getParameters().put('id', String.valueOf(prospecto.Id));
        //Test.startTest();
        //Test.stopTest();
        
    }
    
    @isTest 
    static void myUnitTestTres(){
        System.debug('inicia prueba');
        Account cta = new Account(Name='cuenta', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25',ProductoInteres__c = 'Combustible');
        insert cta; 
        RecordType tipoRegistro = [Select Name,Id from RecordType where Name= 'Despensa' Limit 1];
        Necesidad__c despensa = new Necesidad__c(DisposicionEfectivo__c=true,RecordTypeId=tipoRegistro.Id,cuenta__c=cta.Id);
        insert despensa;
        tipoRegistro = [Select Name,Id from RecordType where Name= 'Combustible' Limit 1];
        despensa = new Necesidad__c(DisposicionEfectivo__c=true,RecordTypeId=tipoRegistro.Id,cuenta__c=cta.Id);
        insert despensa;
        tipoRegistro = [Select Name,Id from RecordType where Name= 'Mantenimiento' Limit 1];
        despensa = new Necesidad__c(DisposicionEfectivo__c=true,RecordTypeId=tipoRegistro.Id,cuenta__c=cta.Id);
        insert despensa;
        tipoRegistro = [Select Name,Id from RecordType where Name= 'Uniforme' Limit 1];
        despensa = new Necesidad__c(DisposicionEfectivo__c=true,RecordTypeId=tipoRegistro.Id,cuenta__c=cta.Id);
        insert despensa;
        tipoRegistro = [Select Name,Id from RecordType where Name= 'Restaurante' Limit 1];
        despensa = new Necesidad__c(DisposicionEfectivo__c=true,RecordTypeId=tipoRegistro.Id,cuenta__c=cta.Id);
        insert despensa;
        tipoRegistro = [Select Name,Id from RecordType where Name= 'Incentivos' Limit 1];
        despensa = new Necesidad__c(DisposicionEfectivo__c=true,RecordTypeId=tipoRegistro.Id,cuenta__c=cta.Id);
        insert despensa;
        tipoRegistro = [Select Name,Id from RecordType where Name= 'Empresarial' Limit 1];
        despensa = new Necesidad__c(DisposicionEfectivo__c=true,RecordTypeId=tipoRegistro.Id,cuenta__c=cta.Id);
        insert despensa;
        Test.setCurrentPageReference(new PageReference('Page.myPage'));
			System.currentPageReference().getParameters().put('IdCuenta', cta.Id);
            apexPages.StandardController std = new apexPages.StandardController(cta);
        
        
        FormatoNecesidadesController testNecesidades= new FormatoNecesidadesController(std);
        testNecesidades.valorRadio='Despensa';
        testNecesidades.despensa= true;
        testNecesidades.gasolina= true;
        testNecesidades.mantenimiento= true;
        testNecesidades.restaurante= true;
        testNecesidades.uniforme= true;
        testNecesidades.empresarial= true;
        testNecesidades.incentivos= true;
        testNecesidades.generarNecesidades();
        testNecesidades.selecciona();
        testNecesidades.valorRadio='Despensa';
        testNecesidades.modificaRadioAplica();
        testNecesidades.valorRadio='Combustible';
        testNecesidades.modificaRadioAplica();
        testNecesidades.valorRadio='Mantenimiento';
        testNecesidades.modificaRadioAplica();
        testNecesidades.valorRadio='Ticket Restaurante';
        testNecesidades.modificaRadioAplica();
        testNecesidades.valorRadio='Uniforme';
        testNecesidades.modificaRadioAplica();
        testNecesidades.valorRadio='Regalo';
        testNecesidades.modificaRadioAplica();
        testNecesidades.valorRadio='Empresarial';
        testNecesidades.modificaRadioAplica();
        //PageReference pageRef = Page.Lead;
        //pageRef.getParameters().put('id', String.valueOf(prospecto.Id));
        //Test.startTest();
        //Test.stopTest();
        
    }
    @isTest 
    static void myUnitTestDos(){
        System.debug('inicia prueba');
        lead prospecto = new lead( ProductoInteres__c = 'Combustible', LastName = 'lastNameTest', Company = 'TestCompany', Puesto__c='CEO o Dueño', LeadSource='Web', Status='No Contactado', NumEmpleados__c = '1-25', Email = 'test@mail.com',Phone='1234323232');
        insert prospecto;
        insert new Task(Subject='Llamada de prospección',WhoId=prospecto.Id);
        prospecto.Status='Calificado';
        update prospecto;
		
        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        
        ApexPages.StandardController std = new ApexPages.StandardController(prospecto);
        FormatoNecesidadesController testNecesidades= new FormatoNecesidadesController(std);
        testNecesidades.regDespensa = new List<Necesidad__c>();
        testNecesidades.valorRadio='Despensa';
        testNecesidades.despensa= true;
        testNecesidades.gasolina= true;
        testNecesidades.mantenimiento= true;
        testNecesidades.restaurante= true;
        testNecesidades.uniforme= true;
        testNecesidades.empresarial= true;
        testNecesidades.incentivos= true;
        testNecesidades.generarNecesidades();
        testNecesidades.selecciona();
        testNecesidades.valorRadio='Despensa';
        testNecesidades.modificaRadioAplica();
        testNecesidades.valorRadio='Combustible';
        testNecesidades.modificaRadioAplica();
        testNecesidades.valorRadio='Mantenimiento';
        testNecesidades.modificaRadioAplica();
        testNecesidades.valorRadio='Ticket Restaurante';
        testNecesidades.modificaRadioAplica();
        testNecesidades.valorRadio='Uniforme';
        testNecesidades.modificaRadioAplica();
        testNecesidades.valorRadio='Regalo';
        testNecesidades.modificaRadioAplica();
        testNecesidades.valorRadio='Empresarial';
        testNecesidades.modificaRadioAplica();
        //PageReference pageRef = Page.Lead;
        //pageRef.getParameters().put('id', String.valueOf(prospecto.Id));
        //Test.startTest();
        //Test.stopTest();
        
    }
    
}