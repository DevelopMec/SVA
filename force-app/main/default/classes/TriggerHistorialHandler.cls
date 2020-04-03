public class TriggerHistorialHandler extends TriggerHandler{
	
    private Map<Id, HistorialVE__c> newMap;
	private Map<Id, HistorialVE__c> oldMap; 
	private List<HistorialVE__c> newList;
	private List<HistorialVE__c> oldList;
    
    public TriggerHistorialHandler(){
        this.newMap = (Map<Id, HistorialVE__c>) trigger.newMap;
		this.oldMap = (Map<Id, HistorialVE__c>) trigger.oldMap;
		this.newList = (List<HistorialVE__c>) trigger.new;
		this.oldList = (List<HistorialVE__c>) trigger.old;
    }
    
    public override void beforeInsert(){
        set<Id> setHistorial = new set<Id>(); // Crear un set donde se almacenan los Ids de cuenta de los registros entrantes
        for(HistorialVE__C historial: this.newList){
           setHistorial.add(historial.Cuenta__c); // Se agregan al set las cuentas
        }
        Map<Id, Account> MapCuentas = new Map <Id,Account>([Select ID, OwnerId from Account where Id in :setHistorial]); // Se crea un Map de cuentas con la lista de cuentas que estan en el set
        for(HistorialVE__C historial: this.newList){
            historial.OwnerId = MapCuentas.get(historial.Cuenta__c).OwnerId; // Se sobreescribe el Propietario.
        }
    }
}