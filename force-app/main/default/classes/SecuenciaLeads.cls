public class SecuenciaLeads {
    
    public static void separaPorFamilia(List<Lead> newList){
        
        List<Lead> leadsFamiliaDespensaMVF    = new List<Lead>();
        List<Lead> leadsFamiliaDespensaOA     = new List<Lead>();
        List<Lead> leadsFamiliaCombustibleMVF = new List<Lead>();
        List<Lead> leadsFamiliaCombustibleOA  = new List<Lead>();
        List<Lead> leadsFamiliaViaticosMVF    = new List<Lead>();
        List<Lead> leadsFamiliaViaticosOA     = new List<Lead>();
        List<Lead> leadsFamiliasRestantes     = new List<Lead>();
        
        for(Lead lead : newList){ 
            if(!String.isBlank(lead.SubOrigen__c) && !String.isBlank(lead.ProductoInteres__c) && lead.CountryCode != 'CO' && lead.CountryCode != 'PE'){
                if(lead.SubOrigen__c == 'MVF' && lead.ProductoInteres__c == 'Despensa' && lead.NumEmpleados__c == '1-125')
                   leadsFamiliaDespensaMVF.add(lead);
                
                if(lead.SubOrigen__c != 'MVF' && lead.ProductoInteres__c == 'Despensa' && lead.NumEmpleados__c == '1-125')
                    leadsFamiliaDespensaOA.add(lead);
                
                if(lead.SubOrigen__c == 'MVF' && lead.ProductoInteres__c == 'Combustible' && ( lead.N_mero_de_veh_culos__c == '1-50' || lead.NumEmpleados__c == '1-125' ) )
                    leadsFamiliaCombustibleMVF.add(lead);
                
                if(lead.SubOrigen__c != 'MVF' && lead.ProductoInteres__c == 'Combustible' && ( lead.N_mero_de_veh_culos__c == '1-50' || lead.NumEmpleados__c == '1-125' ) )
                    leadsFamiliaCombustibleOA.add(lead);
                
                if(lead.SubOrigen__c == 'MVF' && lead.ProductoInteres__c == 'Viáticos' && lead.NumEmpleados__c == '1-125')
                    leadsFamiliaViaticosMVF.add(lead);
                
                if(lead.SubOrigen__c != 'MVF' && lead.ProductoInteres__c == 'Viáticos' && lead.NumEmpleados__c == '1-125')
                    leadsFamiliaViaticosOA.add(lead);
            }
            
            if(!String.isBlank(lead.ProductoInteres__c) && lead.ProductoInteres__c != 'Despensa' && lead.ProductoInteres__c != 'Viáticos' &&  lead.ProductoInteres__c != 'Combustible' && lead.CountryCode != 'CO' && lead.CountryCode != 'PE' && (lead.NumEmpleados__c == '1-125' || lead.N_mero_de_veh_culos__c == '1-50'))
                leadsFamiliasRestantes.add(lead);
        }
        
        if(leadsFamiliaDespensaMVF.size() > 0)
            contadorMVFLeadsFamiliaDespensa(leadsFamiliaDespensaMVF);
        
        if(leadsFamiliaDespensaOA.size() > 0)
            contadorOALeadsFamiliaDespensa(leadsFamiliaDespensaOA);
        
        if(leadsFamiliaCombustibleMVF.size() > 0)
            contadorMVFLeadsFamiliaCombustible(leadsFamiliaCombustibleMVF);
        
        if(leadsFamiliaCombustibleOA.size() > 0)
            contadorOALeadsFamiliaCombustible(leadsFamiliaCombustibleOA);
        
        if(leadsFamiliaViaticosMVF.size() > 0)
            contadorMVFLeadsFamiliaViaticos(leadsFamiliaViaticosMVF);
        
        if(leadsFamiliaViaticosOA.size() > 0)
            contadorOALeadsFamiliaViaticos(leadsFamiliaViaticosOA);
        
        if(leadsFamiliasRestantes.size() > 0)
            contadorLeadsOtrasFamilias(leadsFamiliasRestantes);
    }
    
    
    private static void contadorMVFLeadsFamiliaDespensa(List<Lead> leadsFamiliaDespensaMVF){
        
        AggregateResult UltimoLeadMVFFamiliaDespensa = [SELECT MAX(ContadorFamiliaDespensaMVF_Num__c) FROM Lead WHERE SubOrigen__c = 'MVF' AND ProductoInteres__c = 'Despensa'];
        
        if(UltimoLeadMVFFamiliaDespensa.get('expr0') != null){
            Decimal contadorAuxiliar = (Decimal)UltimoLeadMVFFamiliaDespensa.get('expr0');
            for(Lead lead : leadsFamiliaDespensaMVF){ 
                    contadorAuxiliar += 1;
                    lead.ContadorFamiliaDespensaMVF_Num__c = contadorAuxiliar;
            }
        }
    }
    
    private static void contadorOALeadsFamiliaDespensa(List<Lead> leadsFamiliaDespensaOA){
        
        AggregateResult UltimoLeadOAFamiliaDespensa = [SELECT MAX(ContadorFamiliaDespensaOA_Num__c) FROM Lead WHERE SubOrigen__c  != 'MVF' AND ProductoInteres__c = 'Despensa'];

        if(UltimoLeadOAFamiliaDespensa.get('expr0') != null){
            Decimal contadorAuxiliar = (Decimal)UltimoLeadOAFamiliaDespensa.get('expr0');
        	for(Lead lead : leadsFamiliaDespensaOA){ 
                contadorAuxiliar += 1;
                lead.ContadorFamiliaDespensaOA_Num__c = contadorAuxiliar;
            }
        }
    }
    
    
    private static void contadorMVFLeadsFamiliaCombustible(List<Lead> leadsFamiliaCombustibleMVF){
        AggregateResult UltimoLeadMVFFamiliaCombustible =  [SELECT MAX(ContadorFamiliaCombustibleMVF_Num__c) FROM Lead WHERE SubOrigen__c = 'MVF' AND ProductoInteres__c = 'Combustible'];
        
        if(UltimoLeadMVFFamiliaCombustible.get('expr0') != null){
            Decimal contadorAuxiliar = (Decimal)UltimoLeadMVFFamiliaCombustible.get('expr0');
        	for(Lead lead : leadsFamiliaCombustibleMVF){ 
                contadorAuxiliar += 1;
                lead.ContadorFamiliaCombustibleMVF_Num__c = contadorAuxiliar;
            }
        }
    }
    
    private static void contadorOALeadsFamiliaCombustible(List<Lead> leadsFamiliaCombustibleOA){
        AggregateResult UltimoLeadOAFamiliaCombustible =  [SELECT MAX(ContadorFamiliaCombustibleOA_Num__c) FROM Lead WHERE  SubOrigen__c != 'MVF' AND ProductoInteres__c = 'Combustible'];
        
        if(UltimoLeadOAFamiliaCombustible.get('expr0') != null){
            Decimal contadorAuxiliar = (Decimal)UltimoLeadOAFamiliaCombustible.get('expr0');
            for(Lead lead : leadsFamiliaCombustibleOA){ 
                contadorAuxiliar += 1;
                lead.ContadorFamiliaCombustibleOA_Num__c = contadorAuxiliar;
            }
        }
    }
    
    private static void contadorMVFLeadsFamiliaViaticos(List<Lead> leadsFamiliaViaticosMVF){
        AggregateResult UltimoLeadMVFFamiliaViaticos =  [SELECT MAX(ContadorFamiliaViaticosMVF_Num__c) FROM Lead WHERE SubOrigen__c = 'MVF' AND ProductoInteres__c = 'Viáticos'];
        
        if(UltimoLeadMVFFamiliaViaticos.get('expr0') != null){
            Decimal contadorAuxiliar = (Decimal)UltimoLeadMVFFamiliaViaticos.get('expr0');
            for(Lead lead : leadsFamiliaViaticosMVF){ 
                contadorAuxiliar += 1;
                lead.ContadorFamiliaViaticosMVF_Num__c = contadorAuxiliar;
            }
        }
    }
    
    private static void contadorOALeadsFamiliaViaticos(List<Lead> leadsFamiliaViaticosOA){
        AggregateResult  UltimoLeadOAFamiliaViaticos =  [SELECT MAX(ContadorFamiliaViaticosOA_Num__c) FROM Lead WHERE SubOrigen__c != 'MVF' AND ProductoInteres__c = 'Viáticos'];
        
        if(UltimoLeadOAFamiliaViaticos.get('expr0') != null){
            Decimal contadorAuxiliar = (Decimal)UltimoLeadOAFamiliaViaticos.get('expr0');
            for(Lead lead : leadsFamiliaViaticosOA){ 
                contadorAuxiliar += 1;
                lead.ContadorFamiliaViaticosOA_Num__c = contadorAuxiliar;
            }
        }
    }
    
    
    private static void contadorLeadsOtrasFamilias(List<Lead> leadsFamiliasRestantes){
        AggregateResult  UltimoLeadOtrasFamilias =  [SELECT MAX(ContadorFamiliasRestantes_Num__c) FROM Lead WHERE ProductoInteres__c != null AND ProductoInteres__c != 'Despensa' AND ProductoInteres__c != 'Viáticos' AND ProductoInteres__c != 'Combustible'];
        
        if(UltimoLeadOtrasFamilias.get('expr0') != null){
            Decimal contadorAuxiliar = (Decimal)UltimoLeadOtrasFamilias.get('expr0');
            for(Lead lead : leadsFamiliasRestantes){ 
                contadorAuxiliar += 1;
                lead.ContadorFamiliasRestantes_Num__c = contadorAuxiliar;
            }
        }
    }
}