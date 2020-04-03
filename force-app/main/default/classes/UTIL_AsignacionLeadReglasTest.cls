@isTest
private class UTIL_AsignacionLeadReglasTest {

	/**
        * @author: Carlos Álvarez
        * @description: Método de prueba para clases UTIL_AsignacionLeadReglas.doProcess y TriggerDuplicateRecordItemHandler.afterInsert
        * @date: 17-01-2017
        * @param: 
        * @return void
    */
    @isTest( SeeAlldata = true )
    static void doProcess() {
        
        //calvarez: Inserción de nuevos Leads, se disparará método UTIL_AsignacionLeadReglas.doProcess desde TriggerLeadHandler.doProcess
        List<Lead> leads = new List<Lead>();
        leads.add(new Lead(CategoriaSolucion__c='Combustible',Phone='1234565434',LeadSource='Cambaceo',LastName = 'Prueba 3', Company = 'Company 3', NumEmpleados__c = '1-25', N_mero_de_veh_culos__c = '1-5', EstadoHubSpot__c = 'Durango', Email = 'prueba@mail.com'));

        leads.add(new Lead(CategoriaSolucion__c='Combustible',Phone='1234565435',LeadSource='Cambaceo',LastName = 'Prueba 5', Company = 'Company 5', N_mero_de_veh_culos__c = '1-5', EstadoHubSpot__c = 'Durango', Email = 'prueba@mail.com'));

        leads.add(new Lead(CategoriaSolucion__c='Combustible',LeadSource='Cambaceo',LastName= 'Prueba CAS', Company= 'Prueba CAS', Country= 'United States', CountryCode= 'US', Phone= '4423118378',  Email= 'mailcas@mail.com', DoNotCall= false, NumEmpleados__c= '1-25', N_mero_de_veh_culos__c= '1-5', ProductoInteres2__c= 'Ticket Car 3.0'));

        leads.add(new Lead(CategoriaSolucion__c='Combustible',LeadSource='Cambaceo',LastName= 'Prueba CAS2', Company= 'Prueba CAS 2', Country= 'United States', CountryCode= 'US', Phone= '4423118378',  Email= 'mailcas@mail.com', DoNotCall= false, NumEmpleados__c= '1-25', N_mero_de_veh_culos__c= '1-5',  ProductoInteres2__c= 'Ticket Car 3.0'));
        insert leads;

        //calvarez: Obtener Reglas de duplicados, este objeto es visible desde pruebas
        List<DuplicateRule> dr = [SELECT Id FROM DuplicateRule LIMIT 2];
        if(dr != null && dr.size() > 0) {
        	//calvarez: Insertar DuplicateRecordSet con Id de DuplicateRule obtenido ne posición cero
            DuplicateRecordSet drs = new DuplicateRecordSet(DuplicateRuleId = dr[0].Id);
            insert drs;

        	//calvarez: Insertar DuplicateRecordItem para ejecutar método TriggerDuplicateRecordItemHandler.afterInsert
            List<DuplicateRecordItem> duplicates = new List<DuplicateRecordItem>();
            for(Lead lead_aux: leads) {
                duplicates.add(new DuplicateRecordItem(RecordId = lead_aux.Id, DuplicateRecordSetId = drs.Id));
            }
            insert duplicates;
        }
    }


}