@isTest
private class TriggerHandlerTest {
/*	@isTest
    static void hand(){
        
        TriggerHandler instancia = new TriggerHandler();
    }
    
	@isTest 
    static void completo() {
        
            lead prospecto = new lead( ProductoInteres__c = 'ProductoTest', LastName = 'lastNameTest', Company = 'TestCompany', Puesto__c='CEO', LeadSource='Web', Status='Calificado', Email = 'test@mail.com', NumEmpleados__c = '1 - 125');
            insert prospecto;
        
            Contact nuevoContacto = new Contact(LastName='dsda', Email = 'test@mail.com');
            insert nuevoContacto;
        Producto__c producto = new 	Producto__c(Name='sdas,fassa,fsa', Uso__c='sjd;jsda', Subproductos__c='sdas,fassa,fsa');
        insert producto;
        Account cta = new Account(Name='cuenta', NumberOfEmployees = 12, NumeroEmpleados__c = '1 - 125');
        insert cta;
        Opportunity opp = new Opportunity(Name = 'test', StageName = 'test',
                                          Producto__c=producto.Id, UsoProducto__c='1;32', TipoSolucion__c='ddas',
                                          CloseDate=date.today(),Familia__c = 'familiaTest', Account=cta );
        insert opp;
        
        
        
        Event evento= new Event(WhoId=nuevoContacto.Id,whatId=opp.Id,DurationInMinutes=12,ActivityDateTime=Datetime.now());
        insert evento;
        evento.EstatusEvento__c='Realizado';
        upsert evento;
        delete evento;
        delete opp;
        delete cta;
    }
    
	@isTest 
    static void cuenta() {
        
            lead prospecto = new lead( ProductoInteres__c = 'ProductoTest', LastName = 'lastNameTest', Company = 'TestCompany', Puesto__c='CEO', LeadSource='Web', Status='Calificado', Email = 'test@mail.com', NumEmpleados__c = '1 - 125');
            insert prospecto;
        
            Contact nuevoContacto = new Contact(LastName='dsda', Email = 'test@mail.com');
            insert nuevoContacto;
        Producto__c producto = new 	Producto__c(Name='sdas,fassa,fsa', Uso__c='sjd;jsda', Subproductos__c='sdas,fassa,fsa');
        insert producto;
        Account cta = new Account(Name='cuenta', NumberOfEmployees = 12, NumeroEmpleados__c = '1 - 125');
        insert cta;
        Opportunity opp = new Opportunity(Name = 'test', StageName = 'test',
                                          Producto__c=producto.Id, UsoProducto__c='1;32', TipoSolucion__c='ddas',
                                          CloseDate=date.today(),Familia__c = 'familiaTest', Account=cta );
        insert opp;
        
        
        
        Event evento= new Event(WhoId=nuevoContacto.Id,whatId=cta.Id,DurationInMinutes=12,ActivityDateTime=Datetime.now());
        insert evento;
        evento.EstatusEvento__c='Realizado';
        upsert evento;
        delete evento;
        delete opp;
        delete cta;
    }    
	@isTest 
    static void oportunidad() {
        
            lead prospecto = new lead( ProductoInteres__c = 'ProductoTest', LastName = 'lastNameTest', Company = 'TestCompany', Puesto__c='CEO', LeadSource='Web', Status='Calificado', Email = 'test@mail.com', NumEmpleados__c = '1 - 125');
            insert prospecto;
        
            Contact nuevoContacto = new Contact(LastName='dsda', Email = 'test@mail.com');
            insert nuevoContacto;
        Producto__c producto = new 	Producto__c(Name='sdas,fassa,fsa', Uso__c='sjd;jsda', Subproductos__c='sdas,fassa,fsa');
        insert producto;
        Account cta = new Account(Name='cuenta', NumberOfEmployees = 12, NumeroEmpleados__c = '1 - 125');
        insert cta;
        Opportunity opp = new Opportunity(Name = 'test', StageName = 'test',
                                          Producto__c=producto.Id, UsoProducto__c='1;32', TipoSolucion__c='ddas',
                                          CloseDate=date.today(),Familia__c = 'familiaTest', Account=cta );
        insert opp;
        
        update opp;
        
        Event evento= new Event(WhoId=prospecto.Id,DurationInMinutes=12,ActivityDateTime=Datetime.now());
        insert evento;
        evento.EstatusEvento__c='Realizado';
        upsert evento;
        delete evento;
        delete opp;
        delete cta;
    }*/
}