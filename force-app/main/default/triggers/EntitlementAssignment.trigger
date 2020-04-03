trigger EntitlementAssignment on Case (Before Update) {
    //--English--
    //This Code constitutes an Extra-functionality delivered in order to assign Entitlements (SLAs) according to the Custom Field "Sub-motivo".
    //Entitlement Assignment was delivered as an Extra-functionality within the Service Cloud Implementation Project. Extra-Functionalities are not covered by the Project Scope 
    //and Guarantee.
    //--Spanish--
    //Este código constituye una Funcionalidad Extra brindada para asignar Entitlements (SLAs) de acuerdo al Campo Personalizado "Sub-motivo".
    //La Asignación de Entitlements (SLAs) fue brindada como una Funcionalidad Extra en el Proyecto de Implementación Service Cloud. Las Funcionalidades Extras no están cubiertas
    //por el Alcance del Proyecto ni Garantía.    
    //DYAMPI
    /*Map<Id, String> entitlementsMap=new Map<Id, String>();
    List<Entitlement> entitlements=[Select Id, Submotivos_Aplicables__c From Entitlement];
    for (Entitlement ent : entitlements) {
        entitlementsMap.put(ent.Id, ent.Submotivos_Aplicables__c);
    }  ]*/ 
    /*
    if (Trigger.isInsert) {
        for (Case c : Trigger.new) {
            for (Id key : entitlementsMap.keySet()) {
                if (entitlementsMap.get(key).split(';').contains(c.Sub_Motivo__c)) {
                    c.EntitlementId=key;
                    break;
                }
            }
        }
    }
	*/
    //DYAMPI
    /*if (Trigger.isUpdate) {
        List<Case> casesToUpdate=new List<Case>();
        for (Case c : Trigger.new) {
            Case old=Trigger.oldMap.get(c.Id);
            if (c.Sub_Motivo__c != old.Sub_Motivo__c) {
                casesToUpdate.add(c);
            }
        }
        for (Case c : casesToUpdate) {
            for (Id key : entitlementsMap.keySet()) {
                if (entitlementsMap.get(key).split(';').contains(c.Sub_Motivo__c)) {
                    c.EntitlementId=key;
                    c.SLA_Asignado_por_Codigo__c=true;
                    break;
                }
            }
        }        
    }*/
}
                /*
                for (String text : entitlementsMap.get(key).split(';')) {
                    System.debug('text: '+text);
                    System.debug('c.Sub_Motivo__c: '+c.Sub_Motivo__c);
                    if(text==c.Sub_Motivo__c) {
                        c.EntitlementId=key;
                    }                    
                }
				*/