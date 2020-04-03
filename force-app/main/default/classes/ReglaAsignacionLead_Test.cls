@isTest
public class ReglaAsignacionLead_Test {
    
    private static User usuarioIntegracion = [SELECT Id, Name FROM User WHERE Name = 'Desarrollo CTConsulting'];
    private static List<Lead> insertLeads = new List<Lead>(); 
    
    @testSetup static void SetUpData(){
        setCustomSetting();
        setUsers();
    }
    
    
    private static void setUsers(){
        User uAdmin = [SELECT Id FROM User WHERE UserRole.DeveloperName = 'CRM_Manager' AND Profile.Name='Administrador del Sistema' AND IsActive = true ORDER BY Name LIMIT 1];
        System.runAs(uAdmin){
        	UserRole role = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName IN ('Ejecutivo_Telesales_Outbound')];
        	Profile prof = [SELECT Id, Name FROM Profile WHERE Name = 'Ventas'];
        	User usrtoAssign = new User(Segmento__c = 'Small', UserRoleId = role.Id, FirstName = 'Ejecutivo', LastName = 'Viaticos', Email = 'ejecutivos@viaticos.com', Username = 'ejecutivos@viaticos.com' + System.currentTimeMillis(), CompanyName = 'Edenred', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id, Asignaciones_PL__c = 'Prospectos', FiltroAsignacion_MSPL__c = 'Lead_SmallAyudaSocial;Lead_SmallBeneficios;Lead_SmallCombustible;Lead_SmallMantenimiento;Lead_SmallViaticos');
            insert usrtoAssign;
            System.debug(usrtoAssign);
        }
    }
    
    private static void setCustomSetting(){
        List<ContadorRegistros_CS__c> contador = new List<ContadorRegistros_CS__c>();
        contador.add(new ContadorRegistros_CS__c(Name = 'Lead_SmallAyudaSocial'  , NumeroRegistro__c = 0));
        contador.add(new ContadorRegistros_CS__c(Name = 'Lead_SmallBeneficios'   , NumeroRegistro__c = 0));
        contador.add(new ContadorRegistros_CS__c(Name = 'Lead_SmallCombustible'  , NumeroRegistro__c = 0));
        contador.add(new ContadorRegistros_CS__c(Name = 'Lead_SmallMantenimiento', NumeroRegistro__c = 0));
        contador.add(new ContadorRegistros_CS__c(Name = 'Lead_SmallViaticos'     , NumeroRegistro__c = 0));
        insert contador;
    }
    
    @isTest
    static void creacionLead(){
        System.runAs(usuarioIntegracion){

            insertLeads.add(new Lead(Country='Mexico',LeadSource='Cambaceo',Company = 'Empresarial', FirstName = 'Daniel', LastName = 'Primero', Phone = '5531649874', email = 'daniel@primero.com', NumEmpleados__c = '51-125', CategoriaSolucion__c = 'Empresarial')); 
            insertLeads.add(new Lead(Country='Mexico',LeadSource='Cambaceo',Company = 'Combustible', FirstName = 'Daniel', LastName = 'Segundo', Phone = '4789401355', email = 'daniel@segundo.com', NumEmpleados__c = '51-125',  CategoriaSolucion__c = 'Combustible'));
            insertLeads.add(new Lead(Country='Mexico',LeadSource='Cambaceo',Company = 'Beneficios', FirstName = 'Daniel', LastName = 'Tercero', Phone = '1547812315', email = 'daniel@tercero.com', NumEmpleados__c = '51-125',  CategoriaSolucion__c = 'Vestimenta'));
            insertLeads.add(new Lead(Country='Mexico',LeadSource='Cambaceo',Company = 'Regalo', FirstName = 'Daniel', LastName = 'Cuarto', Phone = '9989405355', email = 'daniel@cuarto.com', NumEmpleados__c = '51-125',  CategoriaSolucion__c = 'Regalo'));
            insertLeads.add(new Lead(Country='Mexico',LeadSource='Cambaceo',Company = 'Ayuda Social', FirstName = 'Daniel', LastName = 'Quinto', Phone = '8889405355', email = 'daniel@quinto.com', NumEmpleados__c = '51-125',  CategoriaSolucion__c = 'Ayuda Social'));
            insertLeads.add(new Lead(Country='Mexico',LeadSource='Cambaceo',Company = 'Mantenimiento', FirstName = 'Daniel', LastName = 'Sexto', Phone = '8123469815', email = 'daniel@sexto.com', NumEmpleados__c = '51-125',  CategoriaSolucion__c = 'Mantenimiento'));
            insertLeads.add(new Lead(Country='Mexico',LeadSource='Cambaceo',Company = 'Despensa', FirstName = 'Daniel', LastName = 'septimo', Phone = '8123469813', email = 'daniel@septimo.com', NumEmpleados__c = '51-125',  CategoriaSolucion__c = 'Despensa', Maquilador__c = 'Walmart'));
            insertLeads.add(new Lead(Country='Mexico',LeadSource='Cambaceo',Company = 'Despensa', FirstName = 'Daniel', LastName = 'octavo', Phone = '8123469812', email = 'daniel@octavo.com', NumEmpleados__c = '51-125',  CategoriaSolucion__c = 'Despensa', Maquilador__c = 'Chedraui'));
            insertLeads.add(new Lead(Country='Chile',LeadSource='Cambaceo',Company = 'Combustible', FirstName = 'Daniel', LastName = 'noveno', Phone = '8889405335', email = 'daniel@noveno.com', NumEmpleados__c = '51-125',  CategoriaSolucion__c = 'Combustible', Maquilador__c = 'BP Fleet'));
            insertLeads.add(new Lead(Country='Uruguay',LeadSource='Cambaceo',Company = 'Regalo', FirstName = 'Daniel', LastName = 'decimo', Phone = '8889405310', email = 'daniel@decimo.com', NumEmpleados__c = '51-125',  CategoriaSolucion__c = 'Regalo', Maquilador__c = 'G500 FLEET'));
            
            try {
            	insert insertLeads;
            } catch (Exception e) {
                System.debug('Exception ' + e);
            }
            
            Task t = new Task( Subject = 'Donni', Status = 'New', Priority = 'Normal', WhoId = insertLeads.get(1).Id);
            insert t;
            
            insertLeads.get(1).Status = 'Calificado';
            
            try {
            	update insertLeads.get(1);
            } catch (Exception e) {
                System.debug('Exception ' + e);
            }
            
            Database.LeadConvert prospectoConvertido = new Database.LeadConvert();
            prospectoConvertido.setLeadId(insertLeads.get(1).Id);
            
            LeadStatus estatusConversion = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            prospectoConvertido.setConvertedStatus(estatusConversion.MasterLabel);
            
            //Database.convertLead(prospectoConvertido);
        }
    }
}