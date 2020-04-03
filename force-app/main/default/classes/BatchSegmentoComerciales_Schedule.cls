global class BatchSegmentoComerciales_Schedule Implements Schedulable{
	global void execute (SchedulableContext SC){
    	Database.executeBatch(new BatchSegmentoComerciales(),200);    
    }
}