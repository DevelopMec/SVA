@isTest 
public class RevisionDireccionControllerTest {
	@isTest 
    static void myUnitTest(){
    	
            Account cta = new Account(Name='cuenta',Calle__c='callejon',Colonia__C='sanlorenzo',CodigoPostal__c='53426',Estado__c='Campeche',Ciudad__C='campeche', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
            insert cta;
            Test.setCurrentPageReference(new PageReference('Page.myPage'));
			System.currentPageReference().getParameters().put('idAccount', cta.Id);
			System.currentPageReference().getParameters().put('indice','0');
            RevisionDireccionController convertir = new RevisionDireccionController();
        	List<Direccion__C> direcciones = convertir.direcciones;
       		 List<SelectOption> comboCiudad = convertir.comboCiudad;
       		 List<SelectOption> comboEstado = convertir.comboEstado;
        	convertir.registro.EstadoSugeridoCheck=true;
        	convertir.registro.CiudadSugeridoCheck=true;
        	convertir.registro.CalleSugeridoCheck=true;
        	convertir.registro.ColoniaSugeridoCheck=true;
        	convertir.registro.CodigoPostalSugeridoCheck=true;
        	convertir.nada();
        	convertir.direcciones=new LIst<Direccion__c>();
        	convertir.direcciones.add(new Direccion__C(Calle__c='sdas',Ciudad__c='dsasa',Estado__c='Campeche',Colonia__C='DAS',CodigoPostal__c='1413'));
        	convertir.llenando();
        	convertir.guardar();
    }
	@isTest 
    static void myUnitLead(){
    	
            Lead cta = new Lead(Phone='1234323232',LastName='sfsaf',LeadSource='Cambaceo',Company='ctc',Calle__c='callejon',Colonia__C='sanlorenzo',CodigoPostal__c='53426',Estado__c='Campeche',Ciudad__C='campeche', NumEmpleados__c = '1-25', Email = 'test@mail.com');
            insert cta;
            Test.setCurrentPageReference(new PageReference('Page.myPage'));
			System.currentPageReference().getParameters().put('idLead', cta.Id);
			System.currentPageReference().getParameters().put('indice','0');
            RevisionDireccionController convertir = new RevisionDireccionController();
        	List<Direccion__C> direcciones = convertir.direcciones;
       		 List<SelectOption> comboCiudad = convertir.comboCiudad;
       		 List<SelectOption> comboEstado = convertir.comboEstado;
        	convertir.registro.EstadoSugeridoCheck=true;
        	convertir.registro.CiudadSugeridoCheck=true;
        	convertir.registro.CalleSugeridoCheck=true;
        	convertir.registro.ColoniaSugeridoCheck=true;
        	convertir.registro.CodigoPostalSugeridoCheck=true;
        	convertir.nada();
        	convertir.direcciones=new LIst<Direccion__c>();
        	convertir.direcciones.add(new Direccion__C(Calle__c='sdas',Ciudad__c='dsasa',Estado__c='Campeche',Colonia__C='DAS',CodigoPostal__c='1413'));
        	convertir.llenando();
        	convertir.guardar();
    }
	@isTest 
    static void contactoTest(){
    	
            Contact cta = new Contact(LastName='sfsaf',Calle__c='callejon',Colonia__C='sanlorenzo',CodigoPostal__c='53426',Estado__c='Campeche',Ciudad__C='campeche', Email = 'test@mail.com');
            insert cta;
            Test.setCurrentPageReference(new PageReference('Page.myPage'));
			System.currentPageReference().getParameters().put('idContact', cta.Id);
			System.currentPageReference().getParameters().put('indice','0');
            RevisionDireccionController convertir = new RevisionDireccionController();
        	List<Direccion__C> direcciones = convertir.direcciones;
       		 List<SelectOption> comboCiudad = convertir.comboCiudad;
       		 List<SelectOption> comboEstado = convertir.comboEstado;
        	convertir.registro.EstadoSugeridoCheck=true;
        	convertir.registro.CiudadSugeridoCheck=true;
        	convertir.registro.CalleSugeridoCheck=true;
        	convertir.registro.ColoniaSugeridoCheck=true;
        	convertir.registro.CodigoPostalSugeridoCheck=true;
        	convertir.nada();
        	convertir.direcciones=new LIst<Direccion__c>();
        	convertir.direcciones.add(new Direccion__C(Calle__c='sdas',Ciudad__c='dsasa',Estado__c='Campeche',Colonia__C='DAS',CodigoPostal__c='1413'));
        	convertir.llenando();
        	convertir.guardar();
        	convertir.getDirecciones();
        	convertir.cambiaCiudad();
        	convertir.cambiaEstado();
        Boolean resul = convertir.registro.getCiudadSugeridoCheck();
        	convertir.registro.setCiudadSugeridoCheck(true);
        	String uno = convertir.ciudadCombo;
        	 uno = convertir.estadoCombo;
    }

}