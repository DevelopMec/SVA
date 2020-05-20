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
        for(QuoteLineItem qli:[Select Id,Product2.ProductCode from QuoteLineItem where Id IN :listQLI]){
            mapaProductos.put(qli.Id, qli.Product2.ProductCode);
        }
        for(Contrato2__c cont : contratosNuevos){
            if(mapaProductos.containsKey(cont.PartidaPresupuesto__c)&&mapaProductos.get(cont.PartidaPresupuesto__c)=='30-TC4'){
                cont.Item_Contratacion__c='TC Avanzado';
                cont.Controla_Presencia_Vehiculo_NFC__c=true;
            }
            if(trigger.isInsert&&mapaProductos.containsKey(cont.PartidaPresupuesto__c)&&(new List<String>{'30-TC4','30','30-B','30-E','30-G','30-S','31'}.indexOf(mapaProductos.get(cont.PartidaPresupuesto__c))!=-1)){
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
            if(Trigger.isUpdate&&cont.TipoPago__c!=contratosOld.get(cont.Id).TipoPago__c&&mapaProductos.containsKey(cont.PartidaPresupuesto__c)&&(new List<String>{'31'}.indexOf(mapaProductos.get(cont.PartidaPresupuesto__c))!=-1)){
                if(cont.TipoPago__c == 'Prepago' && cont.Facturacion_Cargos_Prepago__c != null){
                    cont.Facturacion_Cargos__c='Separado del Consumo';
                }
            }
        }
    }
}