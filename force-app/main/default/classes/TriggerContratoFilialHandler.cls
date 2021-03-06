public class TriggerContratoFilialHandler extends TriggerHandler{
    private List<ContratoFilial__c> newList;
    private Map<Id,ContratoFilial__c> oldMap;
    private Map<Id,ContratoFilial__c> newMap;
    
    public TriggerContratoFilialHandler(){
        this.newList=(List<ContratoFilial__c>)trigger.new;
        this.oldMap=(Map<Id,ContratoFilial__c>)trigger.oldMap;
        this.newMap=(Map<Id,ContratoFilial__c>)trigger.newMap;
    }
    public override void beforeInsert(){
        asignarProducto(newList);

    }

    public override void beforeUpdate(){
        ownerModifiedCheck(newList); 
    }

    public override void afterUpdate(){
        sendToSIGLO(newList); 
    }

    public void asignarProducto(List<ContratoFilial__c> listProd){  
        Map<String,String> mapaProductos=new Map<String,String>();
        Map<String,String> mapaProductosAs4=new Map<String,String>();
        Map<String,String> mapaContratos=new Map<String,String>();
        Set<String> IdContratos=new Set<String>();
        for(ContratoFilial__c tem:listProd){
            IdContratos.add(tem.Contrato_2__c);
        }
        for(Contrato2__c contr:[Select Id,PartidaPresupuesto__r.Product2Id from Contrato2__c where Id IN :IdContratos]){
            mapaContratos.put(contr.Id, contr.PartidaPresupuesto__r.Product2Id);
        }        
        for(Product2 prod:[Select Id,ProductCode from Product2]){
            //mapaProductos.put(prod.ProductCode.length()==1 ? '0'+prod.ProductCode : prod.ProductCode.length()==2 ? prod.ProductCode : '', prod.Id);
            if(!mapaProductos.containsKey(prod.ProductCode.length()==1 ? '0'+prod.ProductCode : prod.ProductCode.length()>=2 ? prod.ProductCode : '')){ mapaProductos.put(prod.ProductCode.length()==1 ? '0'+prod.ProductCode : prod.ProductCode.length()>=2 ? prod.ProductCode : '', prod.Id); }                    
            if(!mapaProductosAs4.containsKey(prod.ProductCode.length()==1 ? '0'+prod.ProductCode : prod.ProductCode.length()>=2 ? prod.ProductCode : '')){ mapaProductosAs4.put(prod.ProductCode.length()==1 ? '0'+prod.ProductCode : prod.ProductCode.length()>=2 ? prod.ProductCode : '', prod.Id); }
        }
        for(ContratoFilial__c contratoF : listProd){
            if(contratoF.Producto__c==null){
                if(contratoF.Contrato_2__c==null){
                    if(contratoF.CodigoAS400__c!=null){
                        List<String> codigo=contratoF.CodigoAS400__c.split('-');
                        if(codigo.size()==4){
                            contratoF.Producto__c=mapaProductosAs4.containsKey(codigo[1]) ? mapaProductosAs4.get(codigo[1]) : null ;
                        }else if(codigo.size()==2){
                            //codigo 2
                            System.debug('OPAN::'+codigo[1]);
                            if(codigo[1].startsWithIgnoreCase('G')||codigo[1].startsWithIgnoreCase('SEL')){ System.debug('60-M'); contratoF.Producto__c=mapaProductos.get('60-M'); }else if(codigo[1].startsWithIgnoreCase('A')||codigo[1].startsWithIgnoreCase('D')||codigo[1].startsWithIgnoreCase('E')||codigo[1].startsWithIgnoreCase('L')||codigo[1].startsWithIgnoreCase('C')||codigo[1].startsWithIgnoreCase('V')){ System.debug('52-C'); contratoF.Producto__c=mapaProductos.get('52-C'); }else if(codigo[1].startsWithIgnoreCase('R')){ System.debug('81'); contratoF.Producto__c=mapaProductos.get('81'); }else if(codigo[1].startsWithIgnoreCase('P')||codigo[1].startsWithIgnoreCase('IN')){ System.debug('48'); contratoF.Producto__c=mapaProductos.get('48'); }else if(codigo[1].startsWithIgnoreCase('PS')){ System.debug('39'); contratoF.Producto__c=mapaProductos.get('39'); }
                            System.debug('CF::'+contratoF);
                        }
                    }
                }else{
                    contratoF.Producto__c=mapaContratos.containsKey(contratoF.Contrato_2__c) ? mapaContratos.get(contratoF.Contrato_2__c) : null ;
                }
            }
        }
    }
    /**   HMDH
     * METODO PARA VALIDAR SI EL PROPIETARIO ES DIFERENTE , ENTONCE SE ACTUALIZA EL CAMPO ModifyOwnerContract__c EN TRUE 
     * 
     */
    public void ownerModifiedCheck(List<ContratoFilial__c> lstContract){  
        System.debug('************** ENTRO UPDATE *********************');
        for(ContratoFilial__c objContratoF : lstContract){
            if(objContratoF.OwnerId != oldMap.get(objContratoF.Id).OwnerId  && objContratoF.ModifyOwnerContract__c  == false ){
                System.debug('SE MODIFICO EL PROPIETARIO  ' + '* ESTE  : ' +oldMap.get(objContratoF.Id).OwnerId  + ' -----  ' + 'POR ESTE : ' +objContratoF.OwnerId  );
                objContratoF.ModifyOwnerContract__c =  true;
            }
        }

    }

    //Valida si existe algun cambio en los campos que se envian a SIGLO
    public void sendToSIGLO(List<ContratoFilial__c> lstContract){
        System.debug('-------SendToSIGLO---------');
        Set<Id> contractIds = new Set<Id>();
        for(ContratoFilial__c newContract : newMap.values()){
            ContratoFilial__c oldContract = oldMap.get(newContract.Id);
            if(newContract.Contrato_2__c != oldContract.Contrato_2__c || newContract.Producto__c != oldContract.Producto__c){
                   contractIds.add(newContract.Id);
               }
        }
        if(!contractIds.isEmpty()){
            List<ContratoFilial__c> cfOpp = [SELECT Contrato_2__c, Producto__c, Contrato_2__r.PartidaPresupuesto__r.Quote.OpportunityId
                                                FROM ContratoFilial__c 
                                                WHERE Id IN: contractIds 
                                                AND Contrato_2__r.PartidaPresupuesto__r.Quote.OpportunityId != null];
            List<Opportunity> oppListUPD = new List<Opportunity>();
            for(ContratoFilial__c cf : cfOpp){
                Opportunity oppToUpdate = new Opportunity(Id= cf.Contrato_2__r.PartidaPresupuesto__r.Quote.OpportunityId, SendToSIGLO__c = true);
                oppListUPD.add(oppToUpdate);
                
            }

            if(!oppListUPD.isEmpty()){
                update oppListUPD;
            }
        }

    }


}