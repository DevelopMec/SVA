public class TriggerHandlerContrato2 {
    
    public static void metodo(List<Contrato2__c> contratos){
        for(Contrato2__c campo : contratos){
            if(campo.ManejaAutoconsumo_Checkbox__c == TRUE && campo.CuotaMensual_Currency__c != null){
                System.debug('CuotaMensual_Currency__c	 => ' + campo.CuotaMensual_Currency__c);    
                campo.CuotaMensualLetra_Text__c = ConversionNumeroTexto.Convertir(String.Valueof(campo.CuotaMensual_Currency__c), 'moneda');
            }else{
                campo.CuotaMensualLetra_Text__c = 'No Aplica';
            }
            if(campo.ManejaAutoconsumo_Checkbox__c == TRUE && campo.CuotaLitros_Currency__c != null){
                System.debug('CuotaLitros_Currency__c	 => ' + campo.CuotaLitros_Currency__c);    
                campo.CuotaLitrosLetra_Text__c = ConversionNumeroTexto.Convertir(String.Valueof(campo.CuotaLitros_Currency__c), 'moneda');
            }else{
                campo.CuotaLitrosLetra_Text__c = 'No Aplica';
            }
            if(campo.ManejaAutoconsumo_Checkbox__c == TRUE){
                campo.ManejaAutoconsumoLetra_Text__c = 'SI';
            }else{
                campo.ManejaAutoconsumoLetra_Text__c = 'NO';
            }
        }         
    }
    
    public static void asignarValores(List<Contrato2__c> contratosNuevos,Map<Id,Contrato2__c> contratosOld){
        Set<String> listQLI=new Set<String>();
        for(Contrato2__c cont : contratosNuevos){
            listQLI.add(cont.PartidaPresupuesto__c);
        }
        Map<String,String> mapaProductos=new Map<String,String>();
        Map<String,QuoteLineItem> mapaQli = new Map<String,QuoteLineItem>();//CEAM:3375
        for(QuoteLineItem qli:[Select Id,Product2.ProductCode, 
                               PaymentMethod__c, ContractingItem__c, OperatingLine__c, ReleasePeriod__c, WarrantyValue__c, CreditDays__c //CEAM:3375
                               from QuoteLineItem where Id IN :listQLI]){
                                   mapaProductos.put(qli.Id, qli.Product2.ProductCode);
                                   mapaQli.put(qli.Id, qli);//CEAM:3375
                               }
        for(Contrato2__c cont : contratosNuevos){
            if(mapaProductos.containsKey(cont.PartidaPresupuesto__c)&&mapaProductos.get(cont.PartidaPresupuesto__c)=='30-TC4'){
                cont.Item_Contratacion__c='TC Avanzado';
                cont.Controla_Presencia_Vehiculo_NFC__c=true;
            }
            if(trigger.isInsert&&mapaProductos.containsKey(cont.PartidaPresupuesto__c)&&
               (new List<String>{'30-TC4','30','30-B','30-E','30-G','30-S','31'}.indexOf(mapaProductos.get(cont.PartidaPresupuesto__c))!=-1)){
                   Map <String,String> mapMaquila=new Map <String,String>{'30-B'=>'BP Fleet','30-E'=>'Element','30-G'=>'G500 FLEET','30-S'=>'Servifacil'};
                       if(mapaProductos.get(cont.PartidaPresupuesto__c)=='31'){
                           cont.Item_Contratacion__c='TC Avanzado';
                           cont.Facturacion_Comision__c='Separado del Consumo';
                           cont.ComoFactura__c='Empresa';
                           cont.EmpresaPrincipal_PL__c='Prime';
                           cont.ModoOffline__c='Cliente NO opera offline';
                       }else{
                           cont.Facturacion_Cargos__c='Separado del Consumo';
                       }
                   //CEAM:3375 >>>
                   if(mapaQli.get(cont.PartidaPresupuesto__c) != null) {
                       cont.TipoPago__c                            = mapaQli.get(cont.PartidaPresupuesto__c).PaymentMethod__c;
                       cont.Item_Contratacion__c                   = mapaQli.get(cont.PartidaPresupuesto__c).ContractingItem__c;
                       cont.Linea_Operativa__c                     = String.valueOf(mapaQli.get(cont.PartidaPresupuesto__c).OperatingLine__c);
                       cont.Frecuencia_Liberacion_Automatica__c    = mapaQli.get(cont.PartidaPresupuesto__c).ReleasePeriod__c;
                       cont.MontoGarantia__c                       = mapaQli.get(cont.PartidaPresupuesto__c).WarrantyValue__c;
                       cont.CondicionesPagoPlazo__c                = String.valueOf(mapaQli.get(cont.PartidaPresupuesto__c).CreditDays__c);
                   }
                   //CEAM:3375 <<<
                   if(new List<String>{'30-B','30-E','30-G','30-S'}.indexOf(mapaProductos.get(cont.PartidaPresupuesto__c))!=-1&&mapMaquila.containsKey(mapaProductos.get(cont.PartidaPresupuesto__c))){
                       cont.Maquila__c=true;
                       cont.Tipo_Maquila__c=mapMaquila.get(mapaProductos.get(cont.PartidaPresupuesto__c));
                   }
                   
                   cont.Facturacion_Plasticos__c='Separado del Consumo';
               }
            if(Trigger.isUpdate&&cont.TipoPago__c!=contratosOld.get(cont.Id).TipoPago__c&&mapaProductos.containsKey(cont.PartidaPresupuesto__c)&&(new List<String>{'30-TC4','30','30-B','30-E','30-G','30-S'}.indexOf(mapaProductos.get(cont.PartidaPresupuesto__c))!=-1)){
                if(cont.TipoPago__c=='Prepago'){
                    //cont.CondicionesPagoPlazo__c='0';
                    cont.Tipo_de_Facturacion__c='Pedido';
                }else{
                    cont.Tipo_de_Facturacion__c='Consumo';
                }
            }
            /*if(Trigger.isUpdate&&cont.ComoFactura__c!=contratosOld.get(cont.Id).ComoFactura__c&&mapaProductos.containsKey(cont.PartidaPresupuesto__c)&&mapaProductos.get(cont.PartidaPresupuesto__c)=='30-TC4'||mapaProductos.containsKey(cont.PartidaPresupuesto__c)&&mapaProductos.get(cont.PartidaPresupuesto__c)=='30'){
if(cont.ComoFactura__c=='Consolidador'){
cont.TipoCliente__c='Web';
}else{
cont.TipoCliente__c='Facturación';
}
} */
            if(Trigger.isUpdate&&cont.TipoPago__c!=contratosOld.get(cont.Id).TipoPago__c&&
               mapaProductos.containsKey(cont.PartidaPresupuesto__c)&&
               (new List<String>{'31'}.indexOf(mapaProductos.get(cont.PartidaPresupuesto__c))!=-1)){
                   if(cont.TipoPago__c == 'Prepago' && cont.Facturacion_Cargos_Prepago__c != null){
                       cont.Facturacion_Cargos__c='Separado del Consumo';
                   }
               }
        }
    }
    
    //Valida si existe algun cambio en los campos que se envian a SIGLO
    public static void sendToSIGLO(Map<Id,Contrato2__c> newMap, Map<Id,Contrato2__c> oldMap){
        System.debug('-------SendToSIGLO---------');
        Set<Id> contractIds = new Set<Id>();
        for(Contrato2__c newContract : newMap.values()){
            Contrato2__c oldContract = oldMap.get(newContract.Id);
            if(newContract.Entidad_Legal__c != oldContract.Entidad_Legal__c || newContract.Contacto__c != oldContract.Contacto__c ||
               newContract.PartidaPresupuesto__c != oldContract.PartidaPresupuesto__c){
                   contractIds.add(newContract.Id);
               }
        }
        
        if(!contractIds.isEmpty()){
            List<Contrato2__c> contratoOpp = [SELECT Id, Entidad_Legal__c, PartidaPresupuesto__c, Contacto__c, PartidaPresupuesto__r.Quote.OpportunityId
                                              FROM Contrato2__c 
                                              WHERE Id IN: contractIds 
                                              AND PartidaPresupuesto__r.Quote.OpportunityId != null];
            List<Opportunity> oppListUPD = new List<Opportunity>();
            for(Contrato2__c contrato : contratoOpp){
                Opportunity oppToUpdate = new Opportunity(Id= contrato.PartidaPresupuesto__r.Quote.OpportunityId, SendToSIGLO__c = true);
                oppListUPD.add(oppToUpdate);
            }
            
            if(!oppListUPD.isEmpty()){
                update oppListUPD;
            }
        }
    }
}