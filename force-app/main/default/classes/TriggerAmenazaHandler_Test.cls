/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @change	13/03/2020 	Improve coverage. Add setup and updateThreat methods.
* @change	30/03/2020 	Improve coverage. Add validateBUTest methods.
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
@isTest
public without sharing class TriggerAmenazaHandler_Test {
    
    @testSetup static void setup() {
        User uAdmin = [SELECT Id FROM User WHERE UserRole.DeveloperName = 'CRM_Manager' AND (Profile.Name='Administrador del sistema' OR Profile.Name='System Administrator')  AND IsActive = true ORDER BY Name LIMIT 1];
        //Profile prof = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' LIMIT 1];
        
        System.runAs(uAdmin){
            Id accrecor = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Edenred').getRecordTypeId();    
            Account account = new Account(
                Name = 'PRUEBA FLUJO',
                Type = 'Prospecto',
                RecordTypeId = accrecor,
                BillingCountry = 'Mexico',
                BillingCountryCode = 'MX',
                ShippingCountry = 'Mexico',
                ShippingCountryCode = 'MX',
                Phone = '1234567890',
                Calle__c = 'RODOLFO',
                Ciudad__c = 'Ciudad de México',
                CodigoClienteAS400__c = '12345',
                CodigoPostal__c = '11520',
                Colonia__c = 'Ampliacion Granada',
                DelegacionMunicipioFiscal__c = 'Miguel Hidalgo',
                Estado__c = 'Ciudad de México',
                NumeroExterior__c = '123',
                Sector__c = 'Privado',
                ClienteComplejo__c = false,
                NumeroEmpleados__c = '1-25',
                Nombre_Grupo_AS400__c = 'FREEWAY',
                RegimenFiscal__c = false,
                Giro__c = 'Comercio al por mayor',
                Subgiro__c = 'Com. al por mayor de camiones y de partes y refacciones nuevas',
                esConversionLead_Checkbox__c = false,
                Estatus_actualizacion__c = 'No contactado',
                UpdatedLastOrder__c = false);
            insert account;
            
            Contact contact = new Contact(
                AccountId = account.Id,
                LastName = 'America',
                FirstName = 'Capitan',
                Salutation = 'Sra.',
                OtherCountry = 'Mexico',
                OtherCountryCode = 'MX',
                MailingCountry = 'Mexico',
                MailingCountryCode = 'MX',
                Phone = '1234567890',
                Email = 'sinay.perez@edenred.com',
                OwnerId = '005610000015qIXAAY',
                HasOptedOutOfEmail = false,
                HasOptedOutOfFax = false,
                DoNotCall = false,
                Activo__c = true,
                CopiarDireccionCuenta__c = false,
                Extranjero__c = false,
                Funcion__c = 'Representante Legal',
                Curp__c = 'PEGD911226MMCRYN04',
                FM3__c = false,
                isCurp__c = false,
                legal_id__c = false);
            insert contact;
            
            Id ELrecor = Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByDeveloperName().get('Persona_Fisica').getRecordTypeId();
            EntidadLegal__c entidadlegal = new EntidadLegal__c(
                Name = 'PEGD121212E34',
                RecordTypeId = ELrecor,
                ActaConstitutivaCliente__c = false,
                AltaSHCP__c = false,
                CURP__c = false,
                Calle__c = 'RODOLFO',
                CodigoPostal__c = '11520',
                Colonia__c = 'Ampliacion Granada',
                ComprobanteDomicilioCliente__c = false,
                //Cuenta__c = account.Id,
                DelegacionMunicipioFiscal__c = 'Miguel Hidalgo',
                Direccion_Cuenta__c = false,
                Estado__c = 'Ciudad de México',
                Estatus__c = 'Completa',
                FM3__c = false,
                IdentificacionOficialCliente__c = false,
                NumeroExterior__c = '123',
                PoderNotarial__c = false,
                RazonSocial__c = 'FILIAL 1 AVENGERS',
                RegistroPatronal__c = false,
                RFCDoc__c = false,
                CargaInicial__c = false);
            insert entidadlegal;
            
            EntidadCuenta__c entidadcuenta = new EntidadCuenta__c(
                Name = 'PEGD121212E34',
                Cuenta__c = account.Id,
                EntidadLegal__c = entidadlegal.id,
                RFC_IDExterno__c = 'PEGD121212E34',
                isActive__c = false);
            insert entidadcuenta;
        }
    }
    
    @isTest
    static void metodoPrueba() {
        User uAdmin = [SELECT Id FROM User WHERE UserRole.DeveloperName = 'CRM_Manager' AND (Profile.Name='Administrador del sistema' OR Profile.Name='System Administrator') AND IsActive = true ORDER BY Name LIMIT 1];
        Account acc = [SELECT Id, (SELECT Id FROM Contacts) FROM Account];
        EntidadCuenta__c entidadCuenta = [SELECT Id FROM EntidadCuenta__c];
        
        System.runAs(uAdmin){
            List<Amenaza__c> amenazas = new List<Amenaza__c>();
            Amenaza__c amenaza = new Amenaza__c(
                Type_of_threat__c = 'Atrición Total',
                Cuenta__c = acc.Id,
                Contacto__c = acc.Contacts[0].Id,
                Competidor__c = 'Amex',
                Descripcion__c = 'prueba',
                Estatus__c = 'Realizada',
                Familia__c = 'Ayuda Social',
                FechaAtricion__c = system.today(),
                Motivo__c = 'Autoconsumo',
                EntidadCuenta_RB__c = entidadCuenta.Id);
            amenazas.add(amenaza);
            
            Amenaza__c amenaza2 = new Amenaza__c(
                Type_of_threat__c = 'Atrición Total',
                Cuenta__c = acc.Id,
                Contacto__c = acc.Contacts[0].Id,
                Competidor__c = 'Amex',
                Descripcion__c = 'prueba',
                Estatus__c = 'En atención',
                Familia__c = 'Ayuda Social',
                FechaAtricion__c = system.today(),
                Motivo__c = 'Autoconsumo',
                EntidadCuenta_RB__c = entidadCuenta.id);
            amenazas.add(amenaza2);
            Test.startTest();
            	insert amenazas;
            Test.stopTest();
        }
    }
    
    //Coverage to validateRFCSolcionAssignment method.
    @isTest
    static void updateThreat() {
        User uAdmin = [SELECT Id FROM User WHERE UserRole.DeveloperName = 'CRM_Manager' AND (Profile.Name='Administrador del sistema' OR Profile.Name='System Administrator') AND IsActive = true ORDER BY Name LIMIT 1];
        Account acc = [SELECT Id, (SELECT Id FROM Contacts) FROM Account];
        EntidadCuenta__c entidadCuenta = [SELECT Id FROM EntidadCuenta__c];
        
        System.runAs(uAdmin){
            Amenaza__c amenaza = new Amenaza__c(
                Type_of_threat__c = 'Atrición Total',
                Cuenta__c = acc.Id,
                Contacto__c = acc.Contacts[0].Id,
                Competidor__c = 'Amex',
                Descripcion__c = 'prueba',
                Estatus__c = 'Realizada',
                Familia__c = 'Ayuda Social',
                FechaAtricion__c = system.today(),
                Motivo__c = 'Autoconsumo',
                EntidadCuenta_RB__c = entidadCuenta.Id);
            insert amenaza;
            amenaza.Familia__c = 'Combustible';
            Test.startTest();
            	update amenaza;
            Test.stopTest();
            Amenaza__c amenazaActualizada = [SELECT Familia__c FROM Amenaza__c WHERE Id =: amenaza.Id];
            System.assertEquals('Combustible', amenazaActualizada.Familia__c, 'The threat was successfully updated.');
        }
    }
    
    @isTest
    static void validateBUTest(){
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' OR Name = 'System Administrator' LIMIT 1];
        List<User> testUsers = new List<User>();
        User user1 = new User(LastName = 'last', Email = 'usertestadmin@amamama.com', Username = 'usertestadmin@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        User user2 = new User(LastName = 'last2', Email = 'usertestadmin2@amamama.com', Username = 'usertestadmin2@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias2', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
        testUsers.add(user1);
        testUsers.add(user2);
        insert testUsers;
        System.runAs(user1){
            List<sObject> objs = new List<sObject>();
                        
            Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
            
            EntidadLegal__c el = new EntidadLegal__c(RFC__c = 'MRDE294817A7A', Name = 'MRDE294817A7A');
            
            Product2 prod = new Product2(Family = 'Vestimenta', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ticket Car 3.0', ProductCode = '30', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta', IsActive = true);
            
            objs.add(acc);
            objs.add(el);
            objs.add(prod);
            insert objs;
            
            EntidadCuenta__c ec = new EntidadCuenta__c(Cuenta__c = acc.Id, Name = 'MRDE294817A7A', EntidadLegal__c = el.Id);
            insert ec;
            ContratoFilial__c contrato = new ContratoFilial__c(OwnerId = user2.Id, Producto__c = prod.Id, CodigoAS400__c = '123', Name = '123' , Entidad_Cuenta__c = ec.Id, IsPrime__c = true);
            insert contrato ;
            
            Amenaza__c threat = new Amenaza__c(
                Type_of_threat__c = 'Atrición Total',
                Cuenta__c = acc.Id,
                Competidor__c = 'Amex',
                Descripcion__c = 'prueba',
                Estatus__c = 'En atención',
                Familia__c = 'Ayuda Social',
                FechaAtricion__c = system.today(),
                Motivo__c = 'Autoconsumo',
                EntidadCuenta_RB__c = ec.id);
                      
            String errorMessage = '';
            Test.startTest();
            try {
                insert threat;
            } catch(Exception e) {
                errorMessage = e.getMessage();
            }
            Test.stopTest();
            System.assert(errorMessage.contains('Ya existe un ejecutivo asignado para ese RFC en esa solución.'));
        }
    }
}