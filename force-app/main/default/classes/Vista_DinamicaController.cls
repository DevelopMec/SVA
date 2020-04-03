/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @change	03/03/2020 	Modify getFamilia method to include the account solutions update. Add method
						updateAccountSolutions.
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public class Vista_DinamicaController {
    
    @AuraEnabled
    public static List<Family> getFamilia(Id recordId, string filtro) {
        Map<String,string> vmapaFamiliaImagenes = mapaFamiliaImagenes();
        list<Family> listafamilia = new list<Family>();
        
        if (filtro != 'Ejecutivo'){
            //List<Family> listafamilia = New List<Family>();
            List<ContratoFilial__c> familiasList = new List<ContratoFilial__c>();
            List<EntidadCuenta__c> entidad = New List<EntidadCuenta__c>();        
            entidad = [Select Id, Name, NombreEL__c, Cuenta__c, Cuenta__r.SolutionsText__c From EntidadCuenta__c Where Cuenta__c = :recordId];
            if(entidad.size() > 0){            
                familiasList= [Select Name, id, Producto__r.IDInterno__c, Producto__r.ProductCode, Producto__r.Family, 
                               Razon_Social__c, RFC__c, Entidad_Cuenta__c, Entidad_Cuenta__r.NombreEL__c, Entidad_Cuenta__r.Name,
                               Frecuency__c, Status__c, Entidad_Cuenta__r.Status__c, Last_order_date__c, Amount_last_order__c,                           
                               Owner.Name, isActive__c
                               From ContratoFilial__c Where Entidad_Cuenta__c IN: entidad AND Producto__r.Family != null 
                               and RFC__c != null]; 
            }            
            map<String,List<ContratoFilial__c> > mapOrder = new map<String,List<ContratoFilial__c>>();
            Set<String> familySet = new Set<String>();
            for(ContratoFilial__c contrato : familiasList){
                List<ContratoFilial__c> filiales= new List<ContratoFilial__c>();
                if(mapOrder.containskey(contrato.Producto__r.Family)){
                    filiales= mapOrder.get(contrato.Producto__r.Family);
                    filiales.add(contrato);
                    mapOrder.put(contrato.Producto__r.Family,filiales);
                }else{
                    filiales.add(contrato);
                    mapOrder.put(contrato.Producto__r.Family,filiales);
                }	
                if(contrato.isActive__c == true) {
					familySet.add(contrato.Producto__r.Family);                    
                }                
            }
            List<String> familyList = new List<String>(familySet);
            String familyListString = '';
            if(!familyList.isEmpty()){
                //Get the solutions combination in a string in alphabetical order.
                familyList.sort();
                familyListString = string.join(familyList,',');
            }
            //If the account has a new solutions combination, it´s updated.
            if (!entidad.isEmpty() && entidad[0].Cuenta__r.SolutionsText__c != familyListString){
				Account accToUpdate = new Account();
                accToUpdate.Id = entidad[0].Cuenta__c;
                accToUpdate.SolutionsText__c = familyListString;
                database.update(accToUpdate, false);
            }
            
            for (String fieldName : mapOrder.keySet()){
                List<ContratoFilial__c> a=  mapOrder.get(fieldName);
                Family b=new Family();
                b.familyOrRFC=fieldName;
                if (vmapaFamiliaImagenes.containsKey(fieldName)){
                    b.Imagen =  vmapaFamiliaImagenes.get(fieldName); 
                }
                b.listacontrato=mapOrder.get(fieldName);
                listafamilia.add(b);
            }
        }
        else{
            Family b=new Family();
            b.familyOrRFC='Ejecutivo';
            if (vmapaFamiliaImagenes.containsKey('Ejecutivo')){
                b.Imagen = vmapaFamiliaImagenes.get('Ejecutivo'); 
            }
            listafamilia.add(b);
        }
        
        System.debug(listafamilia);
        return listafamilia;
    } 
    
    public class Family{
        @AuraEnabled
        public String familyOrRFC {get;set;} 
        @AuraEnabled
        public String Imagen {get;set;} 
        @AuraEnabled
        public List<ContratoFilial__c> listacontrato{get;set;}        
    }    
    
    @AuraEnabled
    public static List<RFC> getentidades(id recordId){
        List<RFC> RFCsList = new List<RFC> (); 
        
        List<EntidadCuenta__c> entidadCuentaList = New List<EntidadCuenta__c>(); // RFC
        List<ContratoFilial__c> contratoFilialList = new List<ContratoFilial__c>();
        
        Set<String> RFCSet 				= new Set<String>();
        String RFCid			= '';
        String RazonSet			= '';
        Set<String> FamiliaProductosSet = new Set<String>();
        Map<String, Set<String>> MapRFC_FAMILIAS = new Map<String, Set<String>>();
        
        Map<String,string> vmapaFamiliaImagenes = mapaFamiliaImagenes();
        
        entidadCuentaList = [Select Id, Name, NombreEL__c, Status__c From EntidadCuenta__c Where Cuenta__c = :recordId];
        
        if(entidadCuentaList.size() > 0){            
            for(ContratoFilial__c c : [Select Name, id, Producto__r.IDInterno__c, Producto__r.ProductCode, Producto__r.Family, 
                                       Razon_Social__c, RFC__c, Entidad_Cuenta__c, Entidad_Cuenta__r.NombreEL__c, Entidad_Cuenta__r.Name,
                                       Frecuency__c, Status__c, isActive__c, Entidad_Cuenta__r.Status__c, Last_order_date__c, Amount_last_order__c,
                                       Owner.Name
                                       From ContratoFilial__c Where Entidad_Cuenta__c IN: entidadCuentaList ] ){
                                           contratoFilialList.add(c);          
                                           RFCSet.add(c.Entidad_Cuenta__r.Name);                                           
                                           FamiliaProductosSet.add(c.Producto__r.Family);
                                       }                                             
        }  
        
        if(RFCSet.size()>0){
            
            for(String rfc: RFCSet){
                Set<String> famProd = new Set<String>();
                for(ContratoFilial__c cf :contratoFilialList){
                    if(rfc == cf.Entidad_Cuenta__r.Name){
                        famProd.add(cf.Producto__r.Family);
                    }
                }
                MapRFC_FAMILIAS.put(rfc, famProd);                
            }
            
            
            for(String rfc: RFCSet){
                
                RFC Wrfc = new RFC ();
                //Wrfc.RFCName = rfc + RazonSet;                
                wrfc.setProducto = new set<Producto>();	
                
                Set<producto> WsetProducto = new Set <producto>();
                
                for(String famProd : MapRFC_FAMILIAS.get(rfc)){
                    List<Boolean> listStatusCF = new List<Boolean>();
                    List<ContratoFilial__c> contratosxFam = new List<ContratoFilial__c>();
                    
                    producto p = new producto ();
                    p.producto = famProd;
                    if (vmapaFamiliaImagenes.containsKey(famProd)){
                        p.Imagen =  vmapaFamiliaImagenes.get(famProd); 
                    }                    
                    for(ContratoFilial__c cf:contratoFilialList){
                        if(famProd == cf.Producto__r.Family && rfc == cf.Entidad_Cuenta__r.Name){
                            contratosxFam.add(cf);
                            RFCid = ''+ cf.Entidad_Cuenta__c;
                            RazonSet = ''+ cf.Razon_Social__c;
                            listStatusCF.add(cf.isActive__c);
                        }
                    }
                    
                    if(listStatusCF.contains(true)){
                        p.StatusRFCSolucion = true;   
                    } else {
                        p.StatusRFCSolucion = false;
                	}
                    
                    p.listacontrato = contratosxFam;
                    WsetProducto.add(p);
                    
                }
                Wrfc.RFCName 		= rfc;
                Wrfc.RFCId			= RFCid;
                Wrfc.RazonName		= RazonSet;          
                wrfc.setProducto 	= WsetProducto;                
                RFCsList.add(wrfc);
                
            }
        }
        
        for(RFC rfc: RFCsList){            
            System.debug('rfc.RFCName: '+rfc.RFCName);      
            for(producto p: rfc.setProducto){
                System.debug('p.producto: '+ p.producto);                
                for(ContratoFilial__c cf: p.listacontrato){
                    System.debug('cf.Entidad_Cuenta__r.Name: ' +cf);   
                }
            }
            System.debug('**********************************');
        }
        System.debug(RFCsList);
        System.debug('++++++++++++++++++++++++++++++++++++');                              
        return RFCsList;
    }
    
    public class RFC{
        @AuraEnabled
        public String RFCName {get;set;} 
        @AuraEnabled
        public String RFCId {get;set;} 
        @AuraEnabled
        public String RazonName {get;set;} 
        @AuraEnabled
        public Set<producto> setProducto{get;set;}
        
    }
    
    public class producto{        
        @AuraEnabled
        public String producto{get;set;}
        @AuraEnabled
        public String Imagen{get;set;}
        @AuraEnabled
        public List<ContratoFilial__c> listacontrato{get;set;}        
        @AuraEnabled
        public Boolean StatusRFCSolucion{get;set;}
    }            
    
    @AuraEnabled
    public static List<Ejecutivo> getEjecutivos(id recordId){
        List<Ejecutivo> EjecutivosList = new List<Ejecutivo> (); 
        
        List<EntidadCuenta__c> entidadCuentaList = New List<EntidadCuenta__c>(); 
        List<ContratoFilial__c> contratoFilialList = new List<ContratoFilial__c>();
        
        Set<String> EjecutivosSet = new Set<String>();
        
        Map<String, Set<String>> Map_EjecutivosFamilias = new Map<String, Set<String>>();
        
        Map<String,string> vmapaFamiliaImagenes = mapaFamiliaImagenes();
        
        entidadCuentaList = [Select Id, Name, NombreEL__c, Status__c From EntidadCuenta__c Where Cuenta__c = :recordId];
        
        if(entidadCuentaList.size() > 0){            
            for(ContratoFilial__c c : [Select Name, id, Producto__r.IDInterno__c, Producto__r.ProductCode, Producto__r.Family, 
                                       Razon_Social__c, RFC__c, Entidad_Cuenta__c, Entidad_Cuenta__r.NombreEL__c, Entidad_Cuenta__r.Name,
                                       Frecuency__c, Status__c, isActive__c, Entidad_Cuenta__r.Status__c, Last_order_date__c, Amount_last_order__c,
                                       Owner.Name
                                       From ContratoFilial__c Where Entidad_Cuenta__c IN: entidadCuentaList ] ){
                                           contratoFilialList.add(c);          
                                           EjecutivosSet.add(c.Owner.Name);                                           
                                       }                                             
        }  
        
        if(EjecutivosSet.size()>0){
            
            for(String ejecutivo: EjecutivosSet){
                Set<String> famProd = new Set<String>();
                for(ContratoFilial__c cf :contratoFilialList){
                    if(ejecutivo == cf.Owner.Name){
                        famProd.add(cf.Producto__r.Family);
                    }
                }
                
                Map_EjecutivosFamilias.put(ejecutivo, famProd);
            }
            
            for(String ejecutivo: EjecutivosSet){
                
                Ejecutivo WEjecutivo = new Ejecutivo ();
                WEjecutivo.setProducto = new set<Producto>();	
                Set<producto> WsetProducto = new Set <producto>();
                
                for(String famProd : Map_EjecutivosFamilias.get(ejecutivo)){
                    List<ContratoFilial__c> contratosxFam = new List<ContratoFilial__c>();
                    
                    producto p = new producto ();
                    p.producto = famProd;
                    if (vmapaFamiliaImagenes.containsKey(famProd)){
                        p.Imagen =  vmapaFamiliaImagenes.get(famProd); 
                    }
                    
                    for(ContratoFilial__c cf:contratoFilialList){
                        if(famProd == cf.Producto__r.Family && ejecutivo == cf.Owner.Name){
                            contratosxFam.add(cf);
                        }
                    }
                    
                    p.listacontrato = contratosxFam;
                    WsetProducto.add(p);
                    
                }
                WEjecutivo.NombreEjecutivo 	= ejecutivo;          
                WEjecutivo.setProducto 	= WsetProducto;                
                EjecutivosList.add(WEjecutivo);
                
            }
        }
        
        return EjecutivosList;
    }
    
    public class Ejecutivo{
        @AuraEnabled
        public String NombreEjecutivo {get;set;} 
        @AuraEnabled
        public Set<producto> setProducto{get;set;}
        
    }
    
    private static Map<String,String> mapaFamiliaImagenes(){
        Map<String,string> data=new Map<String,String>(); 
        for (GeneralCatalog__c cat: [SELECT Family_Icon__c, Family_Name__c, Family_BU__c FROM  GeneralCatalog__c WHERE Name='Familia']){
            data.put(cat.Family_Name__c, '/servlet/servlet.FileDownload?file=' + cat.Family_Icon__c);    
        }
        
        return data;
    }

/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @Created	03/03/2020 	Description: Called by Batch_UpdateAccountSolutions to mass update and by process builder to
						update the account solutions each time a contrato filial is created or each time a contrato 
						filial changes status.
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    @InvocableMethod(label='Update account solutions' description='Update account solutions.')    
    public static void updateAccountSolutions(List <EntidadCuenta__c> entidadesList) {
        Set<Id> entidadesIds = new Set<Id>();
        for(EntidadCuenta__c entidad : entidadesList) {
            entidadesIds.add(entidad.Id);
        }
        //Get active contratos filiales
        List<EntidadCuenta__c> entidades = [SELECT Cuenta__c, Cuenta__r.SolutionsText__c, 
                                            (SELECT Producto__r.Family, isActive__c FROM Contratos_Filial__r 
                                             WHERE Producto__r.Family != null AND RFC__c != null AND isActive__c = true)
                                            FROM EntidadCuenta__c WHERE Id IN: entidadesIds];
        List<Account> accsToUpdate = new List<Account>();
        for(EntidadCuenta__c entidad : entidades){
            Set<String> familySet = new Set<String>();
            for (ContratoFilial__c contrato : entidad.Contratos_Filial__r){
                familySet.add(contrato.Producto__r.Family);                    
            }
            List<String> familyList = new List<String>(familySet);
            String familyListString = '';
            if(!familyList.isEmpty()){
                //Get the solutions combination in a string in alphabetical order.
                familyList.sort();
                familyListString = string.join(familyList,',');
            }
            //If the account has a new solutions combination, it´s updated.
            if (entidad.Cuenta__r.SolutionsText__c != familyListString) {
                Account accToUpdate = new Account();
                accToUpdate.Id = entidad.Cuenta__c;
                accToUpdate.SolutionsText__c = familyListString;
                accsToUpdate.add(accToUpdate);
            }
        }
        if (!accsToUpdate.isEmpty()) {
        	database.update(accsToUpdate, false);
        }
    }
    
}