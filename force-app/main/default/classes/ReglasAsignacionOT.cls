public class ReglasAsignacionOT {
   /* private Map<Id,WorkOrder> oldMap  = null;
    private List<WorkOrder>   newList = null;
    private Map<Id,Contrato2__c> opp_ctro_prpo_cta = new Map<Id,Contrato2__c>();
    private Map<Id, Id> OtsCapacitacion   = new Map<Id, Id>();
    private Map<String,List<User>> ejecutivosReglaOT         = new Map<String,List<User>>();
    private Map<String,Map<Id,List<WorkOrder>>> agrupaciones = new Map<String,Map<Id,List<WorkOrder>>>();
    
    
    public ReglasAsignacionOT(List<WorkOrder> newList){
        this.newList = new List<WorkOrder>(newList);
        getRegistrosRelacionados();
        getEjecutivosReglaOT();
        agruparPedidoTarjetas();
        asignarOT();
    }
    
    public ReglasAsignacionOT(List<WorkOrder> newList , Map<Id,WorkOrder> oldMap){
        this.newList = new List<WorkOrder>(newList);
        this.oldMap  = new Map<Id,WorkOrder>(oldMap);
        getRegistrosRelacionados();
        getEjecutivosReglaOT();
        agruparCapacitacion();
        asignarOTespecial();
        asignarOT();
    }
    
    private void getRegistrosRelacionados(){
        Set<ID> idsOportunidad = new Set <ID>();
        
        for(WorkOrder ordenTrabajo : newList) 
            idsOportunidad.add(ordenTrabajo.Oportunidad__c);
        for(Contrato2__c contrato :[SELECT PartidaPresupuesto__r.Quote.OpportunityId, ModoOperacionCliente_PL__c, PartidaPresupuesto__r.Quote.Opportunity.Owner.Segmento__c, PartidaPresupuesto__r.Quote.Opportunity.Codigo_Producto_cotizacion__c, PartidaPresupuesto__r.Quote.Opportunity.Account.NumeroEmpleados__c, PartidaPresupuesto__r.Quote.Opportunity.Account.Sector__c, PartidaPresupuesto__r.Quote.Opportunity.Familia__c, PartidaPresupuesto__r.Quote.Opportunity.LeadSource, PartidaPresupuesto__r.Quote.Opportunity.SubOrigen__c, PartidaPresupuesto__r.Quote.Opportunity.VentaTradeMarketing_PL__c, PartidaPresupuesto__r.Quote.Opportunity.Owner.UserRole.DeveloperName, PartidaPresupuesto__r.Quote.Opportunity.Owner.state FROM Contrato2__c WHERE PartidaPresupuesto__r.Quote.OpportunityId IN : idsOportunidad])
            opp_ctro_prpo_cta.put(contrato.PartidaPresupuesto__r.Quote.OpportunityId, contrato);
        for(WorkOrder oppwo : [SELECT OwnerId, Oportunidad__c FROM WorkOrder WHERE Oportunidad__c IN :idsOportunidad AND estatus__c = 'Capacitación' LIMIT 1])
            OtsCapacitacion.put(oppwo.Oportunidad__c, oppwo.OwnerId);     
    }
    
    private void agruparPedidoTarjetas(){
        for(WorkOrder wo : newList){
            Contrato2__c contrato    = opp_ctro_prpo_cta.get(wo.Oportunidad__c);
            Opportunity  oportunidad = opp_ctro_prpo_cta.get(wo.Oportunidad__c).PartidaPresupuesto__r.Quote.Opportunity;
            User         propietario = opp_ctro_prpo_cta.get(wo.Oportunidad__c).PartidaPresupuesto__r.Quote.Opportunity.Owner;
            Account      cuenta      = opp_ctro_prpo_cta.get(wo.Oportunidad__c).PartidaPresupuesto__r.Quote.Opportunity.Account;
            
            //Asignación Trade Marketing/
            if( oportunidad.VentaTradeMarketing_PL__c == 'SI' && contrato.ModoOperacionCliente_PL__c == 'No opera solo'){ 
                setMapaAgrupaciones('TradeMarketing', wo);
            }else//Large, Key y Públic/ 
            if( cuenta.NumeroEmpleados__c == '501-2500' || cuenta.NumeroEmpleados__c == '+2500' || (cuenta.Sector__c == 'Público' &&  propietario.Segmento__c == 'MLK') ){ 
                setMapaAgrupaciones('Corporate: Large-Key-Publico', wo);
            }else //Asignacion Corporate/
            if( propietario.UserRole.DeveloperName.Contains('Ejecutivo') && propietario.UserRole.DeveloperName.Contains('Region_Occ')){ 
                setMapaAgrupaciones('Corporate: Occidente', wo);
            }else
            if( propietario.UserRole.DeveloperName.Contains('Ejecutivo') && propietario.UserRole.DeveloperName.Contains('Region_Norte')){ 
                setMapaAgrupaciones('Corporate: Norte', wo);
            }else
            if( propietario.UserRole.DeveloperName.Contains('Ejecutivo') && propietario.UserRole.DeveloperName.Contains('Region_Bajio') && (propietario.state == 'Guanajuato' || propietario.state == 'Aguascalientes' || propietario.state == 'Zacatecas') ){ 
                setMapaAgrupaciones('Corporate: Bajio GT-AS-ZS', wo);
            }else
            if( propietario.UserRole.DeveloperName.Contains('Ejecutivo') && propietario.UserRole.DeveloperName.Contains('Region_Bajio') && (propietario.state == 'San Luis Potosí' || propietario.state == 'Querétaro') ){ 
                setMapaAgrupaciones('Corporate: Bajio SP-QT', wo);
            }else
            if( (propietario.UserRole.DeveloperName.contains('Ejecutivo') && ( propietario.UserRole.DeveloperName.contains('_TE')  || propietario.UserRole.DeveloperName.contains('T_E') || propietario.UserRole.DeveloperName.contains('Metro') || propietario.UserRole.DeveloperName.contains('Noroeste') || propietario.UserRole.DeveloperName.contains('Centro') || propietario.UserRole.DeveloperName.contains('Sureste') || propietario.UserRole.DeveloperName.contains('Mantenimiento') )) || propietario.UserRole.DeveloperName.contains('KAMs') ){ 
                setMapaAgrupaciones('Corporate: TE-MTTO-KAM-CE-NE-SE-MRO', wo);
            }else//Asignación Small/
            if( propietario.Segmento__c == 'Small'  && oportunidad.Familia__c   != 'Combustible' && oportunidad.Familia__c   != 'Viáticos' ){ 
                setMapaAgrupaciones('Small: Familias Restantes', wo);
            }else
            if( propietario.Segmento__c == 'Small'   &&  (oportunidad.Familia__c   == 'Combustible' || oportunidad.Familia__c   == 'Viáticos') ){ 
                setMapaAgrupaciones('Small-PT: Combustible-Viaticos', wo);
            }//Asignaciones por Defecto/
            else if( propietario.Segmento__c == 'Small' ){  setMapaAgrupaciones('Small', wo); }
            else if( propietario.Segmento__c == 'MLK' ){  setMapaAgrupaciones('MLK', wo); }
        }
    }
    
    private void setMapaAgrupaciones(String agrupador, WorkOrder wo){
        if(agrupaciones.get(agrupador) != null && agrupaciones.get(agrupador).containsKey(wo.Oportunidad__c)) agrupaciones.get(agrupador).get(wo.Oportunidad__c).add(wo);
        else agrupaciones.put(agrupador, new Map<Id,List<WorkOrder>>{wo.Oportunidad__c => new List<WorkOrder>{wo}});
    }
    
    private void agruparCapacitacion(){
        for(WorkOrder wo : newList){
            Opportunity  oportunidad = opp_ctro_prpo_cta.get(wo.Oportunidad__c).PartidaPresupuesto__r.Quote.Opportunity;
            User         propietario = opp_ctro_prpo_cta.get(wo.Oportunidad__c).PartidaPresupuesto__r.Quote.Opportunity.Owner;
            //Asignación Small//
            if( oldMap.get(wo.Id).Estatus__c == 'Pedido de tarjetas' && wo.Estatus__c == 'Capacitación' && propietario.Segmento__c == 'Small'   &&  (oportunidad.Familia__c   == 'Combustible' || oportunidad.Familia__c == 'Viáticos') ){ 
                setMapaAgrupaciones('Small-Cap: Combustible-Viaticos', wo);
            }
        }
    }
    
    private void getEjecutivosReglaOT(){
        for(User ejecutivoRegla : [SELECT Id, Name, Asignaciones_PL__c, filtroAsignacion_MSPL__c FROM User WHERE Asignaciones_PL__c = 'Ordenes de trabajo' AND isActive = true AND filtroAsignacion_MSPL__c!=null ORDER BY CreatedDate]){
            for(String familia : ejecutivoRegla.FiltroAsignacion_MSPL__c.split(';')){
                if(ejecutivosReglaOT.containsKey(familia)){
                    ejecutivosReglaOT.get(familia).add(ejecutivoRegla);
                }else{
                    ejecutivosReglaOT.put(familia , new List<User>{ejecutivoRegla});
                }
            }
        }
    }
    
    
    private void asignarOT(){
        List<ContadorRegistros_CS__c> updateContadores = new List<ContadorRegistros_CS__c>();
        for(String agrupador : agrupaciones.keySet()){
            ContadorRegistros_CS__c contadorRegistro = ContadorRegistros_CS__c.getValues(agrupador);
            Decimal auxiliar = contadorRegistro.NumeroRegistro__c;
            for(Id IdOpp : agrupaciones.get(agrupador).KeySet()){
                auxiliar++;
                for(WorkOrder wo : agrupaciones.get(agrupador).get(IdOpp)){
                    String otSegmento = opp_ctro_prpo_cta.get(wo.Oportunidad__c).PartidaPresupuesto__r.Quote.Opportunity.Owner.Segmento__c;
                    wo.OwnerId = ejecutivosReglaOT.get(agrupador) == null ? ejecutivosReglaOT.get(otSegmento).get(Math.mod(auxiliar.intValue() , ejecutivosReglaOT.get(otSegmento).size())).Id : ejecutivosReglaOT.get(agrupador).get(Math.mod(auxiliar.intValue() , ejecutivosReglaOT.get(agrupador).size())).Id; 
                    if(wo.StartDate == null) wo.StartDate = System.now();
                }
            }   
            contadorRegistro.NumeroRegistro__c = auxiliar;
            updateContadores.add(contadorRegistro);
        }
        update updateContadores;
    }
    
    private void asignarOTespecial(){
        for(String agrupador : agrupaciones.keySet()){
            for(Id IdOpp : agrupaciones.get(agrupador).KeySet()){
                for(WorkOrder wo : agrupaciones.get(agrupador).get(IdOpp)){
                    if(OtsCapacitacion.containsKey(wo.Oportunidad__c)) { 
                        wo.OwnerId = OtsCapacitacion.get(wo.Oportunidad__c);
                        agrupaciones.get(agrupador).remove(IdOpp);
                    }
                }
            }   
        }
    }*/
}