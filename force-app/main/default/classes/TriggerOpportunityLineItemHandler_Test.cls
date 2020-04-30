@IsTest public class TriggerOpportunityLineItemHandler_Test {
    
    @TestSetup static void SetUpData(){
        Account a = new Account(Name='testAccount',NumeroEmpleados__c='1-25', NumeroVehiculos__c  = '1');
        insert a;
 		
        User u1 = [SELECT Id, Name, Segmento__c FROM User WHERE Segmento__c='MLK' AND IsActive = true LIMIT 1];
        User u2 = [SELECT Id, Name, Segmento__c FROM User WHERE Segmento__c='Small' AND IsActive = true LIMIT 1];
      	
        System.assert(u1!=null, 'No se encontró usuario con segmento MLK');
        System.assert(u2!=null, 'No se encontró usuario con segmento Small');
        
        TriggerOpportunityLineItemHandlerConfig__c config = new TriggerOpportunityLineItemHandlerConfig__c(Name='Default',
                                                                 ResponsablePedido__c=u1.Id,
                                                                 Implementador__c=u1.Id,
                                                                 Capacitador__c=u1.Id);
       	insert config;
        
        System.assert(config.Id!=null, 'No se insertó configuración personalizada');

        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 prod = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             isActive = true
        );
        insert prod;
        
        System.assert(prod.id!=null, 'No se encontro insertó un producto');

        
        PricebookEntry pbEntry = new PricebookEntry(
             Pricebook2Id = pricebookId,
             Product2Id = prod.Id,
             UnitPrice = 100.00,
             IsActive = true
        );
        insert pbEntry;
       
        System.assert(prod.id!=null, 'No se encontro insertó la lista de precios');
        
        
        Opportunity opp1 = new Opportunity(Name = 'Prueba', Account = a, StageName = 'Prospecting', CloseDate = System.today(),OwnerId = u1.Id);
		insert opp1;
      
        Opportunity opp2 = new Opportunity(Name = 'Prueba', Account = a, StageName = 'Prospecting', CloseDate = System.today(), OwnerId = u2.Id);
		insert opp2;
        
        System.assert(opp1.id!=null, 'No se encontro insertó una oportunidad');
        System.assert(opp2.id!=null, 'No se encontro insertó una oportunidad');

        OpportunityLineItem popp1 = new OpportunityLineItem(
             OpportunityId = opp1.Id,
             Quantity = 5,
             PricebookEntryId = pbEntry.Id,
             TotalPrice = 5 * pbEntry.UnitPrice,
             Etapa__c = 'Cotización'
        );
        insert popp1;
        
        OpportunityLineItem popp2 = new OpportunityLineItem(
             OpportunityId = opp2.Id,
             Quantity = 5,
             PricebookEntryId = pbEntry.Id,
             TotalPrice = 5 * pbEntry.UnitPrice,
             Etapa__c = 'Cotización'
        );

        insert popp2; 
        System.assert(popp2.id!=null, 'No se encontro insertó un producto de oportunidad');
        System.assert(popp1.id!=null, 'No se encontro insertó un producto de oportunidad');
        
        // WorkOrder order1 = new WorkOrder();
        // order1.Oportunidad__c = opp1.Id;
        // order1.Solucion2__c = String.valueOf(popp1.Name); 
        // order1.VolumenEmisionMensual2__c = popp1.TotalPrice; 
        // order1.Familia2__c = prod.Family;
        // order1.AccountId = a.Id;
        // order1.IDProductoOpp__c =String.valueOf( popp1.Id);
        // order1.StartDate = System.now();
        // insert order1; 
        
        // WorkOrder order2 = new WorkOrder();
        // order2.Oportunidad__c = opp1.Id;
        // order2.Solucion2__c = String.valueOf(popp1.Name); 
        // order2.VolumenEmisionMensual2__c = popp1.TotalPrice; 
        // order2.Familia2__c = prod.Family;
        // order2.AccountId = a.Id;
        // order2.IDProductoOpp__c =String.valueOf( popp2.Id);
        // order2.StartDate = System.now();
        // insert order2; 
    }
    
    @isTest static void PruebaCambioDeEtapaImplementacion (){
        List<OpportunityLineItem> toUpdate = new List<OpportunityLineItem>();
        List<OpportunityLineItem> opps = [SELECT Name, Etapa__c FROM OpportunityLineItem];
        for (OpportunityLineItem item :opps){
            item.Etapa__c = 'Implementación';
            toUpdate.add(item);
        }
        update opps;
    }
    
    @isTest static void PruebaCambioDeEtapaPerdida (){
        List<OpportunityLineItem> toUpdate = new List<OpportunityLineItem>();
        List<OpportunityLineItem> opps = [SELECT Name, Etapa__c FROM OpportunityLineItem];
        for (OpportunityLineItem item :opps){
            item.Etapa__c = 'Perdida';
            toUpdate.add(item);
        }
        update opps;
    }
}