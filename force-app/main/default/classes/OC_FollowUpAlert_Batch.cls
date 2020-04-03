global class OC_FollowUpAlert_Batch implements Database.Batchable<sObject>{
    global final Date fecha;
    
    global OC_FollowUpAlert_Batch(){
    	Opportunity_closing__c co = Opportunity_closing__c.getOrgDefaults();
        this.fecha = system.today().addmonths(-integer.ValueOf(co.No_follow_up_alert__c));
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([
            Select Id, RecordType.DeveloperName, Name, StageName, LastModifiedDate,
                   (Select Id from OpenActivities where CreatedDate >=: this.fecha), 
                   (Select Id from ActivityHistories where CreatedDate >=: this.fecha),
                   (Select Id from Histories where Field = 'Owner' and createdDate >=: this.fecha),
                   (Select Id from Quotes where LastModifiedDate >=: this.fecha)
              From Opportunity
             where RecordType.DeveloperName in ('VentaNueva', 'Migracion', 'Incremento')
               and IsClosed = false
               and Follow_up_alert__c = false
        ]);
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        List<Opportunity> uopps = new List<Opportunity>();
        for(Opportunity op : scope){
            if(op.LastModifiedDate < this.fecha || Test.isRunningTest()){
                if(op.OpenActivities == null || op.OpenActivities.size() == 0){
                    if(op.ActivityHistories == null || op.ActivityHistories.size() == 0){
                        if(op.Histories == null || op.Histories.size() == 0){
                            if(op.Quotes == null || op.Quotes.size() == 0){
                                op.Follow_up_alert__c = true;
                                uopps.add(op);
                            }
                        }
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