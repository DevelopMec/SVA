global class OC_ClientOperationsClosing_Batch implements Database.Batchable<sObject>{
    global final Date fecha;
    
    global OC_ClientOperationsClosing_Batch(){
        Opportunity_closing__c co = Opportunity_closing__c.getOrgDefaults();
        this.fecha = system.today().addmonths(-integer.ValueOf(co.No_client_operations_closing__c));
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([
            Select Id, Name, CodigoClienteAS400__c
              From Opportunity
             where RecordType.DeveloperName in ('VentaNueva', 'Migracion', 'Incremento')
               and IsClosed = false
               and CodigoClienteAS400__c != null
               and Client_operations_alert__c = true
               and Client_operations_closing__c = false
        ]);
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        Pattern p = Pattern.compile('^[0-9]{2}[-]{1}[0-9]{2}[-]{1}[0-9]{5}[-]{1}[0-9]{3}$');
        
        Set<Id> sos = new Set<Id>();
        for(Opportunity op : scope){
            Matcher m = p.matcher(op.CodigoClienteAS400__c);
            if(m.matches()){
                sos.add(op.Id);
            }
        }
        
        List<ContratoFilial__c> lcfs = [
            Select Id, CodigoAS400__c, Contrato_2__r.PartidaPresupuesto__r.Quote.OpportunityId, CreatedDate,
                   (Select Id from Facturaciones_Mensuales__r),
                   (Select Id from Informacion_de_Pedidos__r)
              From ContratoFilial__c
             where Contrato_2__r.PartidaPresupuesto__r.Quote.OpportunityId in: sos
               and CreatedDate <: this.fecha
        ];
        
        Map<Id, ContratoFilial__c> mcfs = new Map<Id, ContratoFilial__c>();
        for(ContratoFilial__c cf : lcfs){
            mcfs.put(cf.Contrato_2__r.PartidaPresupuesto__r.Quote.OpportunityId, cf);
        }
        
        List<Opportunity> uopps = new List<Opportunity>();
        for(Opportunity op : scope){
            if(mcfs.containsKey(op.Id)){
                ContratoFilial__c cf = mcfs.get(op.Id);
                if(cf.Facturaciones_Mensuales__r == null || cf.Facturaciones_Mensuales__r.size() == 0){
                    if(cf.Informacion_de_Pedidos__r == null || cf.Informacion_de_Pedidos__r.size() == 0){
                        op.Client_operations_closing__c = true;
                        uopps.add(op);
                    }
                }
            }
        }
        system.debug('uopps: ' + uopps);
        database.update(uopps, false);
    }
    
    global void finish(Database.BatchableContext BC){
    }
}