global class BatchContratosFiliales_Schedule implements Schedulable {
	global void execute (SchedulableContext SC){
    	Database.executeBatch(new BatchContratosFiliales(),100);    
    }
}