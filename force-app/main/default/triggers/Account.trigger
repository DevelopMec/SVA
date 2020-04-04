trigger Account on Account (before insert, after insert, after update,before update) {
    if(Trigger.isInsert && Trigger.isBefore){
        Profile perfil = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId()];
        for(Account cuenta : Trigger.new){
            if(!perfil.Name.containsIgnoreCase('sistema') && !cuenta.esConversionLead_Checkbox__c && !Test.isRunningTest()){
                cuenta.addError('Lo sentimos, pero una CUENTA sólo puede ser creada a partir de un PROSPECTO');
            }
        }
    }
    
    if(Trigger.isUpdate && Trigger.isBefore){
    	Account_Handler.populateFrozenSegment(Trigger.newMap,Trigger.oldMap);
    }
    
    if(Trigger.isInsert && Trigger.isAfter){
    	//List<Account> listaCuentas = new List<Account>();
    	//set<id> setCuentas = new set<id>();
    	//List<CatalogoDirecciones__c> listaDirecciones = new List<CatalogoDirecciones__c>();
    	map<id,CatalogoDirecciones__c> mapaDirecciones = new map<id,CatalogoDirecciones__c>();
    	/*String[] fieldNames = new String[] {'Calle__c', 'NumeroExterior__c', 'NumeroInterior__c','CodigoPostal__c','Colonia__c'};
     	 for(Account cuenta : Trigger.new){
     	 	Account cuentaOld = Trigger.oldMap.get(cuenta.Id);
     	 	for (String fields : fieldNames) {
	            if (cuenta.get(fields) != cuentaOld.get(fields)) {
	               	listaCuentas.add(cuenta);
	               	setCuentas.add(cuenta.Id);
	               	break;
	            }
	        }
     	}*/
     	//for(Account cuenta :listaCuentas){
     	for(Account cuenta :Trigger.new){
            if(cuenta.Calle__c!=null){
                mapaDirecciones.put(cuenta.id,new CatalogoDirecciones__c(CuentaID__c=cuenta.Id,Tipo_Pt__c='Cuenta',Name=cuenta.Calle__c !=null ? cuenta.Calle__c.length()>79 ? cuenta.Calle__c.subString(0,79) : cuenta.Calle__c : ' ',Calle_Tt__c=cuenta.Calle__c,NumeroExterior_Tt__c=cuenta.NumeroExterior__c,NumeroInterior_Tt__c=cuenta.NumeroInterior__c,CodigoPostalID__c=cuenta.ColMpoCpEdo__c,Ciudad_Tt__c=cuenta.Ciudad__c));   
            }     		
     	}
     	/*listaDirecciones=[SELECT id,CuentaID__c,CuentaID__r.Name,CuentaID__r.Calle__c  from CatalogoDirecciones__c where CuentaID__c=:setCuentas and Tipo_Pt__c= 'Cuenta'];
     	for(CatalogoDirecciones__c direccion :listaDirecciones){
     		if(mapaDirecciones.containskey(direccion.CuentaID__c)){
     			CatalogoDirecciones__c dir= new CatalogoDirecciones__c();
     			dir=mapaDirecciones.get(direccion.CuentaID__c);
     			dir.id=direccion.id;
     			dir.Name=direccion.CuentaID__r.Calle__c +'-'+direccion.CuentaID__r.Name;
     			mapaDirecciones.put(direccion.CuentaID__c,dir);
     		}
     	}*/
     	if(!mapaDirecciones.isEmpty()){upsert mapaDirecciones.values();}

    }
    
    /*if(Trigger.isInsert && Trigger.isAfter){
     	List<CatalogoDirecciones__c> creaDireccion= new List<CatalogoDirecciones__c>()  ;
     		for(Account cuenta :Trigger.new){
     		if(Calle__c!=null){

     		}		
     		creaDireccion.add(new CatalogoDirecciones__c(CuentaID__c=cuenta.Id,Tipo_Pt__c='Cuenta',Name=cuenta.Name+'-'+cuenta.Calle__c,Calle_Tt__c=cuenta.Calle__c,NumeroExterior_Tt__c=cuenta.NumeroExterior__c,NumeroInterior_Tt__c=cuenta.NumeroInterior__c,Colonia_Tt__c=cuenta.Colonia__c,
     			CodigoPostal_Tt__c=cuenta.CodigoPostal__c,DelegacionMunicipio_Tt__c=cuenta.DelegacionMunicipioFiscal__c,Estado_Tt__c=cuenta.Estado__c,Ciudad_Tt__c=cuenta.Ciudad__c));
     	}
     	insert creaDireccion;

     }*/


}