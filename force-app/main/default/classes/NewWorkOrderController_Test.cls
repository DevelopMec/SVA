@isTest public class NewWorkOrderController_Test {

   /* 
    @testSetup static void setUpData(){
        
        Account a = new Account(Name='testAccount',NumeroEmpleados__c='1 - 125', NumeroVehiculos__c  = '1-50');
        insert a; 
 		
        User u1 = [SELECT Id,Name,Segmento__c,Username,LastName,Email,Alias,CommunityNickname,ProfileId  FROM User WHERE Segmento__c ='MLK' LIMIT 1];
      	
        System.assert(u1!=null, 'No se encontró usuario con segmento MLK');
        
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
        
        System.assert(opp1.id!=null, 'No se encontro insertó una oportunidad');

        OpportunityLineItem popp1 = new OpportunityLineItem(
             OpportunityId = opp1.Id,
             Quantity = 5,
             PricebookEntryId = pbEntry.Id,
             TotalPrice = 5 * pbEntry.UnitPrice,
             Etapa__c = 'Implementación'
        );
        insert popp1;
        
        OpportunityLineItem popp2 = new OpportunityLineItem(
             OpportunityId = opp1.Id,
             Quantity = 5,
             PricebookEntryId = pbEntry.Id,
             TotalPrice = 5 * pbEntry.UnitPrice,
             Etapa__c = 'Cotización'
        );
        insert popp2;
      
        System.assert(popp1.id!=null, 'No se encontro insertó un producto de oportunidad');
      
    }

    @isTest static void BuildControllerTest(){
        List<OpportunityLineItem> items = [SELECT Id FROM OpportunityLineItem];
        System.assert(items.size()>0,'Los productos de oportunidad no han sido cargados');
        
        PageReference pageRef = Page.NewWorkOrder;   
        Test.setCurrentPageReference(pageRef);
		System.currentPageReference().getParameters().put('id', String.valueOf(items[0].Id));

        NewWorkOrderController ctrl = new NewWorkOrderController();
        ctrl.cancel();
    }
    
    @isTest static void SaveWorkOrder (){
        List<OpportunityLineItem> items = [SELECT Id FROM OpportunityLineItem];
        System.assert(items.size()>0,'Los productos de oportunidad no han sido cargados');
        
        PageReference pageRef = Page.NewWorkOrder;   
        Test.setCurrentPageReference(pageRef);
		System.currentPageReference().getParameters().put('id', String.valueOf(items[0].Id));

        NewWorkOrderController ctrl = new NewWorkOrderController();
        ctrl.insertWorkOrder();
    }
    
     @isTest static void SaveWorkOrderFail (){
        List<OpportunityLineItem> items = [SELECT Id FROM OpportunityLineItem];
        System.assert(items.size()>0,'Los productos de oportunidad no han sido cargados');
        
        PageReference pageRef = Page.NewWorkOrder;   
        Test.setCurrentPageReference(pageRef);
		System.currentPageReference().getParameters().put('id', String.valueOf(items[0].Id));

        NewWorkOrderController ctrl = new NewWorkOrderController();
        ctrl.newWorkOrder.OwnerId = null; 
        ctrl.insertWorkOrder();
    }
    
    @isTest static void LoadInvalidPOPP (){
        List<OpportunityLineItem> items = [SELECT Id FROM OpportunityLineItem WHERE Etapa__c = 'Cotización'];
        System.assert(items.size()>0,'Los productos de oportunidad no han sido cargados');
        
        PageReference pageRef = Page.NewWorkOrder;   
        Test.setCurrentPageReference(pageRef);
		System.currentPageReference().getParameters().put('id', String.valueOf(items[0].Id));

        NewWorkOrderController ctrl = new NewWorkOrderController();
        ctrl.newWorkOrder.OwnerId = null; 
        ctrl.insertWorkOrder();
    }*/
}