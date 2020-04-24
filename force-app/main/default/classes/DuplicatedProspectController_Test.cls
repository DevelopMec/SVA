@isTest public class DuplicatedProspectController_Test {

    @testSetup static void setUpData(){
      //List<Lead> leads = Test.loadData(Lead.sObjectType, 'Leads_Test_Data');
        
        Lead l=new Lead();
        l.Company='PIIXAN ARQUITECTOS SA DE CV';
        l.LastName='VILLARREAL RAMIREZ';	
        l.Status='No contactado';	
        l.LeadSource='Cambaceo';	
        l.CategoriaSolucion__c='Despensa';
        l.NumEmpleados__c='1-25';	
        l.N_mero_de_veh_culos__c='1';	
        l.MobilePhone='1234567890';	
        l.Email='afd@test.com';
        insert l;
    }
    
    @isTest static void buildController (){
        List<Lead> leads = [SELECT Id From LEAD LIMIT 2];

        //calvarez: 22-feb-2017 Obtener Reglas de duplicados, este objeto es visible desde pruebas
        List<DuplicateRule> dr = [SELECT Id FROM DuplicateRule LIMIT 2];
        if(dr != null && dr.size() > 0) {
            //calvarez: 22-feb-2017 Insertar DuplicateRecordSet con Id de DuplicateRule obtenido ne posición cero
            DuplicateRecordSet drs = new DuplicateRecordSet(DuplicateRuleId = dr[0].Id);
            insert drs;

            //calvarez: 22-feb-2017 Insertar DuplicateRecordItem
            List<DuplicateRecordItem> duplicates = new List<DuplicateRecordItem>();
            for(Lead lead_aux: leads) {
                duplicates.add(new DuplicateRecordItem(RecordId = lead_aux.Id, DuplicateRecordSetId = drs.Id));
            }
            insert duplicates;
        }

        for (Lead item: leads)	{
             ApexPages.StandardController sc = new ApexPages.StandardController(item);
             DuplicatedProspectController dpc = new DuplicatedProspectController(sc);
             PageReference pageRef = Page.DuplicatedProspect;        
             pageRef.getParameters().put('id', String.valueOf(item.Id));
             dpc.getRecords();
             DuplicatedProspectController.Wrapper wp = new DuplicatedProspectController.Wrapper();
             Test.setCurrentPage(pageRef);
        }
    }
}