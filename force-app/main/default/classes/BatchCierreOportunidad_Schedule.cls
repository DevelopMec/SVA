global class BatchCierreOportunidad_Schedule Implements Schedulable{
	global void execute (SchedulableContext SC){
    	Database.executeBatch(new BatchCierreOportunidad(),30);    
    }
}