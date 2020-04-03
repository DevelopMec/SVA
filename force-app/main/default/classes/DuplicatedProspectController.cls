public with sharing class DuplicatedProspectController {
    private final Lead leadToSearch; 
    public Map<Id,String> types = new Map<Id,String>();

   /* Autor:  Gerardo Elisiel Martínez Cabral 
    * Objetivo: Controlador de la Visualforce “DuplicatedProspect” ejecuta una consulta a DuplicateRecordItem 
    * para mostrar los registros duplicados asociados al prospecto
    * Fecha: 30/01/2017
    */
    
    public ApexPages.StandardSetController setRecords {
        get {
            if(setRecords == null && leadToSearch != null) {
                Set<Id> recorsSets = new Set<Id> ();
                
                for (List<DuplicateRecordItem> itemsDuplicated :  [SELECT Name, RecordId, DuplicateRecordSetId FROM DuplicateRecordItem WHERE RecordId = :leadToSearch.Id]){
                    for (DuplicateRecordItem item :itemsDuplicated) {
                        recorsSets.add(item.DuplicateRecordSetId);
                    }
                }
               
                setRecords = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id, Name, Record.RecordTypeId, RecordId, Record.Name, DuplicateRecordSetId, DuplicateRecordSet.Name FROM DuplicateRecordItem WHERE DuplicateRecordSetId IN :recorsSets]));
                System.debug(setRecords);
            }
            return setRecords;
        }
        private set;
    }
    
   /* Autor:  Gerardo Elisiel Martínez Cabral 
    * Objetivo: Metodo que regresa la lista de registros duplicados en un Wrapper
    * Fecha: 30/01/2017
    */
    
    public List<Wrapper> getRecords() {
        List <Wrapper> result = new List<Wrapper>();
        List <DuplicateRecordItem> aux = (List<DuplicateRecordItem>) setRecords.getRecords();
        for (DuplicateRecordItem item : aux) {
            Wrapper wp = new Wrapper();
            wp.item = item;
            wp.name = item.RecordId.getSObjectType().getDescribe().getLabel();
            if(item.RecordId != leadToSearch.Id) {
                result.add(wp);
            }
        }
        return result;
    }
    
   
    /* Autor:  Gerardo Elisiel Martínez Cabral 
    * Objetivo: Constructor del controlador
    * Fecha: 30/01/2017
    */
    public DuplicatedProspectController(ApexPages.StandardController stdController) {
        this.leadToSearch = (Lead)stdController.getRecord(); 
    }    
    
    public class Wrapper {
        
        public DuplicateRecordItem item {get; set;}
        public String name {get; set;}
        
        public Wrapper() {
            this.item = item;
            this.name  = name;
        }
    }
    
}