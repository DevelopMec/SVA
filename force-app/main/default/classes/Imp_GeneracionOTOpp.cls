public class Imp_GeneracionOTOpp {

    public  Id otId;
    public String message {get;set;}
    
    public Imp_GeneracionOTOpp (apexPages.StandardController std){
        otId = (Id)std.getRecord().id;
    }
    
    public PageReference  generarOTOpp(){
        PageReference pR = new PageReference('/'+otId);
        String respuesta = '';
        WorkOrder newWorkOrder = new WorkOrder();
        Map<Id,WorkOrder> wOContratoFiliales = new Map<Id,WorkOrder>();
        Set<Id> qlitems = new Set<Id>();
        Set<Id> idsProducto2 = new Set<Id>();
        Map<Id,Product2> productosQLI = new Map<Id,Product2>();
        
        try{
            //Lista que contiene lar ordenes de trabajo relacionadas a las opp entrantes
            WorkOrder ordenOpp = [Select Id ,Oportunidad__c,Oportunidad__r.SyncedQuoteId,Estatus__c,Entidad_Legal__c,IDProductoOpp__c,AccountId,OT_Inactiva__c from WorkOrder where Id =: otId AND Estatus__c = 'Cancelada' AND OT_Inactiva__c = false];                                        
            
            ContratoFilial__c cF = new ContratoFilial__c();
            if(ordenOpp != null){
                //Loop para obtener los Id de las partidas de las cotizaciones sincronizadas y en base a estás obtener los contratos y código AS400
                for(QuoteLineItem qli :  [Select Id, Product2Id  from QuoteLineItem where QuoteId =: ordenOpp.Oportunidad__r.SyncedQuoteId]){
                    System.debug(qli);
                    qlitems.add(qli.Id);
                    idsProducto2.add(qli.Product2Id);
                }
                
                //Se obtiene la información de los productos2 para poder determinar el estatus y otras reglas de los productos
                for(Product2 prod2 : [SELECT Id, ProductCode, OT_Pedidos_Small__c, OT_Estatus_Pedido_Fondos__c FROM Product2 Where Id in: idsProducto2]){
                    System.debug(prod2);
                    if(!productosQLI.containsKey(prod2.Id)){
                        productosQLI.put(prod2.Id, prod2);
                    }
                }
                
                Contrato2__c contrato = [Select Id, CodigoAs400__c, Entidad_Legal__c, PartidaPresupuesto__r.Quote.OpportunityId, PartidaPresupuesto__r.Quote.Opportunity.AccountId, PartidaPresupuesto__r.Product2Id from Contrato2__c where PartidaPresupuesto__c in: qlitems];
                    //Es la principal
                if(ordenOpp.Entidad_Legal__c != null){
                    newWorkOrder.FechaInicio__c = System.today();
                    newWorkOrder.StartDate = System.today();
                    newWorkOrder.OT_Principal__c = true;
                    if(productosQLI.get(contrato.PartidaPresupuesto__r.Product2Id).OT_Estatus_Pedido_Fondos__c == true){
                        newWorkOrder.Estatus__c = 'Pedido';
                    }else{
                        newWorkOrder.Estatus__c = 'Pedido de tarjetas';
                    }
                    
                    newWorkOrder.IDProductoOpp__c = ordenOpp.IDProductoOpp__c;
                    newWorkOrder.Oportunidad__c = ordenOpp.Oportunidad__c;
                    newWorkOrder.AccountId = ordenOpp.AccountId;
                    newWorkOrder.Entidad_Legal__c = ordenOpp.Entidad_Legal__c;
                    newWorkOrder.Codigo_AS400__c = contrato.CodigoAs400__c;
                    system.debug('Imp_GeneracionOTOpp: asignar Codigo_AS400__c por Contrato2');
                    ordenOpp.OT_Inactiva__c = true;
                }
                //Son Contratos Filiales
                else{
                    cF = [Select Id, Orden_de_trabajo__c, CodigoAS400__c from ContratoFilial__c Where Orden_de_trabajo__c =: ordenOpp.Id];
                    newWorkOrder.FechaInicio__c = System.today();
                    newWorkOrder.StartDate = System.today();
                    newWorkOrder.OT_Principal__c = false;
                    if(productosQLI.get(contrato.PartidaPresupuesto__r.Product2Id).OT_Estatus_Pedido_Fondos__c == true){
                        newWorkOrder.Estatus__c = 'Pedido';
                    }else{
                        newWorkOrder.Estatus__c = 'Pedido de tarjetas';
                    }
                    newWorkOrder.IDProductoOpp__c = ordenOpp.IDProductoOpp__c;
                    newWorkOrder.Oportunidad__c = ordenOpp.Oportunidad__c;
                    newWorkOrder.AccountId = ordenOpp.AccountId;
                    
                    newWorkOrder.Codigo_AS400__c = cF.CodigoAs400__c;
                    newWorkOrder.Contrato_Filial__c = cF.Id;
                    system.debug('Imp_GeneracionOTOpp: asignar Codigo_AS400__c por ContratoFilial, asignar lookup');
                    
                    wOContratoFiliales.put(ordenOpp.Id, newWorkOrder);
                    ordenOpp.OT_Inactiva__c = true;
                }
            }
            try{
                update ordenOpp;
    
                insert newWorkOrder;
                   
                if(newWorkOrder.OT_Principal__c != true){
                    cF.Orden_de_trabajo__c = newWorkOrder.Id;
                    update cF;
                }   
                
                pR = new PageReference ('/'+newWorkOrder.Id);
            }catch(Exception e){
                System.debug('Exception Cause actualiza OT o ContratoF status: '+e.getCause() +'Line: '+ e.getLineNumber()+' Message: '+e.getMessage());
            }
            
        }catch(Exception e){
            System.debug('Exception Cause generarOTOpp status: '+e.getCause() +'Line: '+ e.getLineNumber()+' Message: '+e.getMessage());
        }
        
        return pR;
    }
}