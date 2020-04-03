global class BatchValidarUltimoPedido_Schedule Implements Schedulable{
	global void execute (SchedulableContext SC){
    	Database.executeBatch(new BatchValidarUltimoPedido(),200);    
    }
}