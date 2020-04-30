public class DireccionesEntrega_CR {
    @AuraEnabled
    public static Contrato2__c getOportunidadContrato(String recordID){
        Contrato2__c opp_contrato;  
        if(recordID.startsWith('006'))
          opp_contrato = [SELECT Id, PartidaPresupuesto__r.Quote.Opportunity.NumberOfShipments__c, Name, DireccionesAuxiliares__c, PartidaPresupuesto__r.Quote.Opportunity.Codigo_Producto_cotizacion__c, PartidaPresupuesto__r.Quote.Opportunity.AccountId, PartidaPresupuesto__r.Quote.Opportunity.StageName,PartidaPresupuesto__r.Quote.Opportunity.RecordType.DeveloperName FROM Contrato2__c WHERE PartidaPresupuesto__r.Quote.OpportunityId = :recordID and PartidaPresupuesto__r.Quote.IsSyncing=true];
        else
          opp_contrato = [SELECT Id, PartidaPresupuesto__r.Quote.Opportunity.NumberOfShipments__c, Name, DireccionesAuxiliares__c, PartidaPresupuesto__r.Quote.Opportunity.Codigo_Producto_cotizacion__c, PartidaPresupuesto__r.Quote.Opportunity.AccountId, PartidaPresupuesto__r.Quote.Opportunity.StageName,PartidaPresupuesto__r.Quote.Opportunity.RecordType.DeveloperName FROM Contrato2__c WHERE Id = :recordID];

        return opp_contrato;
    }
    
    @AuraEnabled
    public static List<CatalogoDirecciones__c> getCatalogoDirecciones(String opportunityID){
        return [SELECT Id, Name, Calle_Tt__c, NumeroInterior_Tt__c, NumeroExterior_Tt__c, Colonia_Tt__c, CodigoPostal_Tt__c, DelegacionMunicipio_Tt__c, Ciudad_Tt__c, Estado_Tt__c, Tipo_Pt__c, CodigoPostalID__c, CuentaID__c FROM CatalogoDirecciones__c WHERE CuentaID__c IN(SELECT AccountId FROM Opportunity WHERE Id =:opportunityID) ORDER BY CreatedDate];
    } 
    
    @AuraEnabled
    public static List<CatalogoDirecciones__c> getDireccionesTabla(Id contrato2ID){
        Map<String , Contrato_Direccion__c>  dirTabla = new Map<String, Contrato_Direccion__c>([SELECT Id, Name, DireccionId__r.Calle_Tt__c, DireccionId__r.NumeroInterior_Tt__c, DireccionId__r.NumeroExterior_Tt__c, DireccionId__r.Colonia_Tt__c, DireccionId__r.CodigoPostal_Tt__c, DireccionId__r.DelegacionMunicipio_Tt__c, DireccionId__r.Ciudad_Tt__c, DireccionId__r.Estado_Tt__c, DireccionId__r.Tipo_Pt__c FROM Contrato_Direccion__c WHERE ContratoId__c =: contrato2ID]);
        Map<String , CatalogoDirecciones__c> direciones = new Map<String , CatalogoDirecciones__c>();
        CatalogoDirecciones__c catdir;
        
        for(Contrato_Direccion__c con_dir : dirTabla.values()){
            catdir = new CatalogoDirecciones__c();
            catdir = con_dir.DireccionId__r;
            direciones.put(catdir.Id, catdir);
        }  
        return direciones.values(); 
    }
    
    @AuraEnabled
    public static void pruebaApex(String direcciones , String contrato2, String contrato2ID){
        
        List<CatalogoDirecciones__c> pr = (List<CatalogoDirecciones__c>)JSON.deserialize(direcciones, List<CatalogoDirecciones__c>.class);
        Contrato2__c contrato = (Contrato2__c) JSON.deserialize(contrato2 , Contrato2__c.class);
        
        Map<String,CatalogoDirecciones__c> dirAlmacenadas = new Map<String,CatalogoDirecciones__c>();
        dirAlmacenadas.putAll(getDireccionesTabla(contrato2ID));
        List<Contrato_Direccion__c> cons_dirs;
        
        if( dirAlmacenadas.size() > 0 && dirAlmacenadas.size() < pr.size() ){
            cons_dirs = new List<Contrato_Direccion__c>();
            Contrato_Direccion__c con_dir;
            System.debug('ALMACENADO ' + dirAlmacenadas.keySet());
            
            for(CatalogoDirecciones__c direccion : pr){
                System.debug('NEW: ' + direccion.Id);
                if(!dirAlmacenadas.containsKey(direccion.Id)){
                    con_dir = new Contrato_Direccion__c();
                    con_dir.Name = contrato.Name;
                    con_dir.ContratoID__c = contrato.Id;
                    con_dir.DireccionID__C = direccion.Id;
                    cons_dirs.add(con_dir);
                }
            }
            insert cons_dirs;
        }else if(dirAlmacenadas.size() > 0 && dirAlmacenadas.size() > pr.size() ){
            List<CatalogoDirecciones__c> dirs = new List<CatalogoDirecciones__c>();
            
            System.debug('ALMACENADO: ' + dirAlmacenadas.keySet());
            for(CatalogoDirecciones__c direccion : pr){
                System.debug('LLEGO: ' + direccion.Id);
                if(dirAlmacenadas.containsKey(direccion.Id)){
                    dirAlmacenadas.remove(direccion.Id);
                }
            }
            delete [SELECT Id FROM Contrato_Direccion__c WHERE DireccionID__c IN :dirAlmacenadas.keySet()];
        }else
        if(dirAlmacenadas.size() == 0){
            cons_dirs = new List<Contrato_Direccion__c>();
            Contrato_Direccion__c con_dir;   
            
            for(CatalogoDirecciones__c direccion : pr){
                con_dir = new Contrato_Direccion__c();
                con_dir.Name = contrato.Name;
                con_dir.ContratoID__c = contrato.Id;
                con_dir.DireccionID__C = direccion.Id;
                cons_dirs.add(con_dir);        
            }
            insert cons_dirs;
        }
    }
    
    @AuraEnabled
    public static void saveDirAux(String bandera , String contrato2){
        Contrato2__c contrato = (Contrato2__c) JSON.deserialize(contrato2 , Contrato2__c.class);
        contrato.DireccionesAuxiliares__c = Boolean.valueOf(bandera);        
        update contrato;
    }
}