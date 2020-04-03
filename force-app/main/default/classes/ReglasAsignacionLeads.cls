public class ReglasAsignacionLeads{
    private User usuarioIntegracion = [SELECT Id,Name FROM User WHERE Name = 'Desarrollo CTConsulting'];
    private Map<String,List<Lead>> agrupaciones = new Map<String,List<Lead>>();
    private Map<String,List<User>> ejecutivosReglaSmall = new Map<String,List<User>>(); 
    private Map<Id,Lead> newLeads = null;

    public ReglasAsignacionLeads(Map<Id,Lead> newLeads){
        this.newLeads = new Map<Id,Lead>([SELECT Id,Segmento__c,Maquilador__c,CategoriaSolucion__c,CreatedById,CountryCode,NumEmpleados__c FROM Lead WHERE Id IN :newLeads.keySet()]);
        agruparLeadporFamilia();
        getEjecutivosReglaSmall();
        asignarLead();
    }
        
    private void asignarLead(){
        List<ContadorRegistros_CS__c> updateContadores = new List<ContadorRegistros_CS__c>();
        List<Lead> updateLeads = new List<Lead>();
            
        for(String agrupador : agrupaciones.keySet()){
            System.debug('AGR:'+agrupador);
            ContadorRegistros_CS__c contadorRegistro = ContadorRegistros_CS__c.getValues(agrupador);
			System.debug('---CONTADOR--- ' + contadorRegistro);           
            Decimal auxiliar = contadorRegistro.NumeroRegistro__c;
            System.debug('auxiliar: ' + auxiliar);
            for(Lead lead : agrupaciones.get(agrupador)){
                auxiliar++;
                lead.AsignacionSmall_Number__c =  Math.mod(auxiliar.intValue() , ejecutivosReglaSmall.get(agrupador).size());
                System.debug('AQUI: ' + lead.AsignacionSmall_Number__c);
                updateLeads.add(lead);
            }
            contadorRegistro.NumeroRegistro__c = auxiliar;
            updateContadores.add(contadorRegistro);
            System.debug('TERMINA REGLA DE ASIGNACION');
        }
        update updateContadores;        
        update updateLeads;
        System.debug('LEAD: '+ updateLeads);

    }
    
    private void agruparLeadporFamilia(){        
        for(Lead newLead : newLeads.values()){
            if(newLead.CreatedById == usuarioIntegracion.Id && (newLead.CountryCode == 'MX' || newLead.CountryCode == 'US') && newLead.Segmento__c!=null && newLead.Segmento__c.containsIgnoreCase('Small') &&newLead.Maquilador__c==null){
                if(newLead.CategoriaSolucion__c == 'Empresarial'){
                    if( agrupaciones.containsKey('Lead_SmallViaticos'))     agrupaciones.get('Lead_SmallViaticos').add(newLead);
                    else agrupaciones.put('Lead_SmallViaticos' , new List<Lead>{newLead});
                }
                if(newLead.CategoriaSolucion__c == 'Ayuda Social'){
                    if( agrupaciones.containsKey('Lead_SmallAyudaSocial')) agrupaciones.get('Lead_SmallAyudaSocial').add(newLead);
                    else agrupaciones.put('Lead_SmallAyudaSocial' , new List<Lead>{newLead});
                }
                if(newLead.CategoriaSolucion__c == 'Mantenimiento' ){
                    if( agrupaciones.containsKey('Lead_SmallMantenimiento')) agrupaciones.get('Lead_SmallMantenimiento').add(newLead);
                    else agrupaciones.put('Lead_SmallMantenimiento' , new List<Lead>{newLead});
                }
                if(newLead.CategoriaSolucion__c == 'Regalo' || newLead.CategoriaSolucion__c == 'Despensa' || newLead.CategoriaSolucion__c == 'Ticket Restaurante' || newLead.CategoriaSolucion__c == 'Vestimenta'){
                    if( agrupaciones.containsKey('Lead_SmallBeneficios'))    agrupaciones.get('Lead_SmallBeneficios').add(newLead);
                    else agrupaciones.put('Lead_SmallBeneficios' , new List<Lead>{newLead});
                }
                if(newLead.CategoriaSolucion__c == 'Combustible'){
                    if( agrupaciones.containsKey('Lead_SmallCombustible'))   agrupaciones.get('Lead_SmallCombustible').add(newLead);
                    else agrupaciones.put('Lead_SmallCombustible' , new List<Lead>{newLead});
                }
            }else if(newLead.CreatedById == usuarioIntegracion.Id && (newLead.CountryCode == 'MX' || newLead.CountryCode == 'US') && newLead.Segmento__c!=null && newLead.Segmento__c.containsIgnoreCase('Small') &&newLead.Maquilador__c!=null){
                if(newLead.Maquilador__c=='Walmart Migracion'||newLead.Maquilador__c=='Walmart'||newLead.Maquilador__c=='Walmart Referidos'){
                    if( agrupaciones.containsKey('Alianza Walmart'))     agrupaciones.get('Alianza Walmart').add(newLead);
                    else agrupaciones.put('Alianza Walmart' , new List<Lead>{newLead});
                }else if(newLead.Maquilador__c=='Chedraui'){
                    if( agrupaciones.containsKey('Alianza Chedraui'))     agrupaciones.get('Alianza Chedraui').add(newLead);
                    else agrupaciones.put('Alianza Chedraui' , new List<Lead>{newLead});                    
                }else if(newLead.Maquilador__c=='BP Fleet'){
                    if( agrupaciones.containsKey('Alianza BP Fleet'))     agrupaciones.get('Alianza BP Fleet').add(newLead);
                    else agrupaciones.put('Alianza BP Fleet' , new List<Lead>{newLead});
                }
            }else if(newLead.CreatedById == usuarioIntegracion.Id && newLead.CountryCode == 'UY'){
                if( agrupaciones.containsKey('Uruguay'))     agrupaciones.get('Uruguay').add(newLead);
                else agrupaciones.put('Uruguay' , new List<Lead>{newLead});
            }else if(newLead.CreatedById == usuarioIntegracion.Id && newLead.CountryCode == 'CL'){
                if( agrupaciones.containsKey('Chile'))     agrupaciones.get('Chile').add(newLead);
                else agrupaciones.put('Chile' , new List<Lead>{newLead});
            }
        }
        System.debug('---------------------'+ agrupaciones);
    }
    
    private void getEjecutivosReglaSmall(){
        List<User> ejecutivosdeRegla = new List<User>([SELECT Id, Name, Asignaciones_PL__c, filtroAsignacion_MSPL__c  FROM User WHERE Asignaciones_PL__c = 'Prospectos' AND isActive = true ORDER BY CreatedDate]);
        for(User ejecutivoRegla : ejecutivosdeRegla){
            for(String familia : ejecutivoRegla.FiltroAsignacion_MSPL__c.split(';')){
                if(ejecutivosReglaSmall.containsKey(familia)){
                    ejecutivosReglaSmall.get(familia).add(ejecutivoRegla);                      
                }else{
                    ejecutivosReglaSmall.put(familia , new List<User>{ejecutivoRegla});                      
                }
            }            
        }
    }
}