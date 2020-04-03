/***TEST:: AltaContrato_CONT_TEST**/
public without sharing class TriggerHandlerProductoConcepto extends triggerHandler{
    private List<ProductoConcepto__c> newList;
    private Map<Id, ProductoConcepto__c> oldMap;
    private Map<Id, ProductoConcepto__c> newMap;
    Map<String, Schema.SObjectField> mapaCamposAnexo;
    
    public TriggerHandlerProductoConcepto() {
        System.debug('::TriggerHandlerProductoConcepto::'+limits.getQueries());
        this.newList = (List<ProductoConcepto__c>) trigger.new;
        this.oldMap = (Map<Id, ProductoConcepto__c>) trigger.oldMap;
        this.newMap = (Map<Id, ProductoConcepto__c>) trigger.newMap;
        mapaCamposAnexo=getCampos();
    }
    public override void afterInsert(){
        convertirValores(this.newList,this.oldMap);
    }
    public override void afterUpdate(){
        convertirValores(this.newList,this.oldMap);
    }
    
    public Map<String, Schema.SObjectField>  getCampos(){
        return Schema.getGlobalDescribe().get('Anexo__c').getDescribe().fields.getMap();
    }
    
    public void convertirValores(List<ProductoConcepto__c> listIns,Map<Id, ProductoConcepto__c> mapaOld){
        Map<String,Anexo__c> mapaAnexo=getAnexosInfo(listIns);
        Map<String,Concepto__c> mapaConceptos=getConceptosInfo(listIns);
        for(ProductoConcepto__c pc: listIns){
            if(pc.PrecioFinal__c!=null&&mapaConceptos.containsKey(pc.Concepto__c)&&mapaConceptos.get(pc.Concepto__c).FieldText__c!=null){
                Anexo__c an;
                if(!mapaAnexo.containsKey(pc.PartidaPresupuesto__c)){
                    an=new Anexo__c(Solucion__c=pc.PartidaPresupuesto__c);
                }else{
                    an=mapaAnexo.get(pc.PartidaPresupuesto__c);
                }
                if(mapaCamposAnexo.containsKey(mapaConceptos.get(pc.Concepto__c).FieldText__c)){
                    System.debug('CAMPO CORRECTO');
                    Schema.DescribeFieldResult dfr=mapaCamposAnexo.get(mapaConceptos.get(pc.Concepto__c).FieldText__c).getDescribe();
                    an.put(mapaConceptos.get(pc.Concepto__c).FieldText__c,obtenerValor(pc.PrecioFinal__c,String.valueOf(dfr.getType())));   
                }else{
                    System.debug('CAMPO INCORRECTO');
                    pc.addError('El campo del Concepto '+pc.Concepto_Tipo_Cargo__c+' no existe en el objeto Anexo');
                }            
               /* if(pc.Concepto_Tipo_Cargo__c!='Comisión por el Servicio'){
                    //an.put(mapaConceptos.get(pc.Concepto__c).FieldText__c,ConversionNumeroTexto.Convertir(pc.PrecioFinal__c!=null ? String.valueOf(pc.PrecioFinal__c) : '0', 'moneda'));                    
                }else{
                    an.put(mapaConceptos.get(pc.Concepto__c).FieldText__c,ConversionNumeroTexto.Convertir(pc.PrecioFinal__c!=null ? String.valueOf(pc.PrecioFinal__c) : '0', 'porcentaje'));
                }*/
                mapaAnexo.put(pc.PartidaPresupuesto__c,an);
            }
        }
        if(mapaAnexo!=null&&mapaAnexo.values()!=null&&mapaAnexo.values().size()>0){
            upsert mapaAnexo.values();
        }
    }
    public Map<String,Concepto__c> getConceptosInfo(List<ProductoConcepto__c> listIns){
        Map<String,Concepto__c> res=new Map<String,Concepto__c>();
        Set<String> idsConceptos=new Set<String>();
        for(ProductoConcepto__c pc: listIns){
            idsConceptos.add(pc.Concepto__c);
        }
        for(Concepto__c c : [Select Id,FieldText__c from Concepto__c where Id IN:idsConceptos]){
            res.put(c.Id, c);
        }
        return res;
    }
    public Map<String,Anexo__c> getAnexosInfo(List<ProductoConcepto__c> listIns){
        Map<String,Anexo__c> res=new Map<String,Anexo__c>();
        Set<String> idsQLI=new Set<String>();
        for(ProductoConcepto__c pc: listIns){
            idsQLI.add(pc.PartidaPresupuesto__c);
        }
        for(Anexo__c an : [Select Id,Solucion__c from Anexo__c where Solucion__c IN:idsQLI]){
            res.put(an.Solucion__c, an);
        }
        return res;
    }
    public Object obtenerValor(Decimal cantidad,String tipo){
        if(tipo.equalsIgnoreCase('STRING')){
            return String.valueOf(cantidad!=null ? cantidad : 0);
        }else{
            return cantidad!=null ? cantidad : 0;
        }
    }
}