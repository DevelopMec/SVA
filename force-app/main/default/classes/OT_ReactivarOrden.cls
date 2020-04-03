public with sharing class OT_ReactivarOrden {

    public id OTId;
    
    public OT_ReactivarOrden(apexPages.StandardController std){
        OTId = (Id)std.getRecord().Id;
    }
    
    public PageReference actualizaOT(){
        WorkOrder ot = new WorkOrder();
        ot.Id = OTId;
        ot.EsPausada__c = false;
        update ot;
        PageReference pR = new PageReference ('/'+OTId);
        return pR;        
    }
}