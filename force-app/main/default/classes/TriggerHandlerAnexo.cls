public class TriggerHandlerAnexo {
    public static void metodo(List<Anexo__c> anexos){
        
        for(Anexo__c campo : anexos){
            if(campo.TarjetaAdicional__c != null ){
                System.debug('Tarjeta Adicional => ' + campo.TarjetaAdicional__c);
                campo.TarjetaAdicionalTexto__c = ConversionNumeroTexto.Convertir(campo.TarjetaAdicional__c, 'moneda');
            }
            if(campo.ReposicionTarjeta__c != null){
                System.debug('Reposicion Tarjeta => ' + campo.ReposicionTarjeta__c);
                campo.ReposicionTarjetaLetra__c = ConversionNumeroTexto.Convertir(campo.ReposicionTarjeta__c , 'moneda');
            }
            if(campo.TarjetaTitular__c != null){
                System.debug('Tarjeta Titular => ' + campo.TarjetaTitular__c);
                campo.TarjetaTitularTexto__c = ConversionNumeroTexto.Convertir(campo.TarjetaTitular__c , 'moneda');
            }
            if(campo.RenovacionTarjeta__c != null){
                System.debug('Renovacion Tarjeta => ' + campo.RenovacionTarjeta__c);
                campo.RenovacionTarjetaTexto__c = ConversionNumeroTexto.Convertir(campo.RenovacionTarjeta__c , 'moneda');
            }else{
                System.debug('Renovacion Tarjeta => ' + campo.RenovacionTarjeta__c);
                campo.RenovacionTarjetaTexto__c = 'NO APLICA';
            }
            
            if(campo.CuentaActiva__c != null){
                System.debug('CuentaActiva__c => ' + campo.CuentaActiva__c);
                campo.CuentaActiva_Text__c = ConversionNumeroTexto.Convertir(campo.CuentaActiva__c , 'moneda');
            }else {
                System.debug('CuentaActiva__c => ' + 'NO APLICA CARGO CUENTA ACTIVA');
                campo.CuentaActiva_Text__c = 'NO APLICA';
            }
            
            if(campo.ComisionServicio__c != null){
                System.debug('Renovacion Tarjeta => ' + campo.ComisionServicio__c);    
                campo.ComisionServicios__c = ConversionNumeroTexto.Convertir(String.valueOf(campo.ComisionServicio__c) , 'porcentaje');
            }
            if(campo.EnvioTarjetas__c != null){
                System.debug('EnvioTarjetas__c => ' + campo.EnvioTarjetas__c);    
                campo.Cargo_por_env_o_letra__c = ConversionNumeroTexto.Convertir(campo.EnvioTarjetas__c, 'moneda');
            }
            if(campo.CargoRefactura__c != null){
                System.debug('CargoRefactura__c => ' + campo.CargoRefactura__c);    
                campo.CargoRefacturacionLetra_Text__c = ConversionNumeroTexto.Convertir(campo.CargoRefactura__c, 'moneda');
            }
            if(campo.CuotaDispersion__c != null){
                System.debug('CuotaDispersion__c => ' + campo.CuotaDispersion__c);    
                campo.CuotaDispersionLetra__c = ConversionNumeroTexto.Convertir(campo.CuotaDispersion__c, 'moneda');
            }else{
                System.debug('CuotaDispersion__c => ' + campo.CuotaDispersion__c);    
                campo.CuotaDispersionLetra__c = 'No Aplica';
            }
            if(campo.CargoEnvio_Text__c != null){
                System.debug('CargoEnvio_Text__c => ' + campo.CargoEnvio_Text__c);    
                campo.CargoEnvioLetra_Text__c = ConversionNumeroTexto.Convertir(campo.CargoEnvio_Text__c, 'moneda');
            }
            if(campo.CuotaImpresionLogoUnaTinta_Text__c != null){
                System.debug('CuotaImpresionLogoUnaTinta_Text__c => ' + campo.CuotaImpresionLogoUnaTinta_Text__c);    
                campo.CuotaImpresionLogoUnaTintaLetra_Text__c = ConversionNumeroTexto.Convertir(campo.CuotaImpresionLogoUnaTinta_Text__c, 'moneda');
            }
            if(campo.CuotaImpresionLogoColor_Text__c != null){
                System.debug('CuotaImpresionLogoColor_Text__c => ' + campo.CuotaImpresionLogoColor_Text__c);    
                campo.CuotaImpresionLogoColorLetra_Text__c = ConversionNumeroTexto.Convertir(campo.CuotaImpresionLogoColor_Text__c, 'moneda');
            }
            if(campo.CargoCancelacion_Text__c != null){
                System.debug('CargoCancelacion_Text__c => ' + campo.CargoCancelacion_Text__c);    
                campo.CargoCancelacionLetra_Text__c = ConversionNumeroTexto.Convertir(campo.CargoCancelacion_Text__c, 'moneda');
            }
            if(campo.CargoEnsobretado_Text__c != null){
                System.debug('CargoEnsobretado_Text__c => ' + campo.CargoEnsobretado_Text__c);    
                campo.CargoEnsobretadoLetra_Text__c = ConversionNumeroTexto.Convertir(campo.CargoEnsobretado_Text__c, 'moneda');
            }
            if(campo.CobroTransaccionRechazada_Text__c != null){
                System.debug('CobroTransaccionRechazada_Text__c => ' + campo.CobroTransaccionRechazada_Text__c);    
                campo.CobroTransaccionRechazadaLetra_Text__c = ConversionNumeroTexto.Convertir(campo.CobroTransaccionRechazada_Text__c, 'moneda');
            }
            if(campo.CuotaAnual__c != null){
                System.debug('Cuota por Anualidad => ' + campo.CuotaAnual__c);    
                campo.CuotaAnualidadLetra_Text__c = ConversionNumeroTexto.Convertir(campo.CuotaAnual__c, 'moneda');
            }
            if(campo.MensualidadCliente_Text__c != null){
                System.debug('MensualidadCliente_Text__c => ' + campo.MensualidadCliente_Text__c);    
                campo.MensualidadClienteLetra_Text__c = ConversionNumeroTexto.Convertir(campo.MensualidadCliente_Text__c, 'moneda');
            }
            if(campo.CuotaAdscripcionGrande_Text__c	 != null){
                System.debug('CuotaAdscripcionGrande_Text__c	 => ' + campo.CuotaAdscripcionGrande_Text__c);    
                campo.CuotaAdscripcionGrandeLetra_Text__c = ConversionNumeroTexto.Convertir(campo.CuotaAdscripcionGrande_Text__c, 'moneda');
            }else {
                System.debug('CuotaAdscripcionGrande_Text__c	 => ' + campo.CuotaAdscripcionGrande_Text__c);    
                campo.CuotaAdscripcionGrandeLetra_Text__c = 'No Aplica';
            }
            if(campo.CuotaAdscripcionPyme_Text__c != null){
                System.debug('CuotaAdscripcionPyme_Text__c	 => ' + campo.CuotaAdscripcionPyme_Text__c);    
                campo.CuotaAdscripcionPymeLetra_Text__c = ConversionNumeroTexto.Convertir(campo.CuotaAdscripcionPyme_Text__c, 'moneda');
            }else {
                System.debug('CuotaAdscripcionPyme_Text__c	 => ' + campo.CuotaAdscripcionPyme_Text__c);    
                campo.CuotaAdscripcionPymeLetra_Text__c = 'No Aplica';
            }
            
            if(campo.CuotaImplementacion_Text__c != null){
                System.debug('CuotaImplementacion_Text__c	 => ' + campo.CuotaImplementacion_Text__c);    
                campo.CuotaImplementacionLetra_Text__c = ConversionNumeroTexto.Convertir(campo.CuotaImplementacion_Text__c, 'moneda');
            }else{
                System.debug('CuotaImplementacion_Text__c	 => ' + campo.CuotaImplementacion_Text__c);    
                campo.CuotaImplementacionLetra_Text__c = 'No Aplica';
            }
            if(campo.CuotaInscripcion_Text__c != null){
                System.debug('CuotaInscripcion_Text__c	 => ' + campo.CuotaInscripcion_Text__c);    
                campo.CuotaInscripcionLetra_Text__c = ConversionNumeroTexto.Convertir(campo.CuotaInscripcion_Text__c, 'moneda');
            }
            
            if(campo.ComisionFijaAS__c != null){
                System.debug('ComisionFijaAS__c	 => ' + campo.ComisionFijaAS__c);    
                campo.ComisionFijaAsignacionSaldo__c = ConversionNumeroTexto.Convertir(campo.ComisionFijaAS__c, 'moneda');
            }else {
                System.debug('ComisionFijaAS__c	 => ' + campo.ComisionFijaAS__c);    
                campo.ComisionFijaAsignacionSaldo__c = 'No Aplica';
            }
            
            if(campo.Cuota_por_cuenta_activa__c != null){
                System.debug('ComisionFijaAS__c	 => ' + campo.Cuota_por_cuenta_activa__c);    
                campo.Cuota_por_cuenta_activa_letra__c = ConversionNumeroTexto.Convertir(String.valueOf(campo.Cuota_por_cuenta_activa__c), 'moneda');
            }else {
                System.debug('ComisionFijaAS__c	 => ' + campo.Cuota_por_cuenta_activa__c);    
                campo.Cuota_por_cuenta_activa_letra__c = 'No Aplica';
            }
            
            /*
            if(campo.Implementacion_Text__c != null){
                System.debug('Implementacion_Text__c	 => ' + campo.Implementacion_Text__c);    
                campo.CuotaImplementacionLetra_Text__c = ConversionNumeroTexto.Convertir(campo.Implementacion_Text__c, 'moneda');
            }else {
                System.debug('Implementacion_Text__c	 => ' + campo.Implementacion_Text__c);    
                campo.CuotaImplementacionLetra_Text__c = 'No Aplica';
            }*/
            
            if(campo.CuotaMensualidad_Text__c != null){
                System.debug('CuotaMensualidad_Text__c	 => ' + campo.CuotaMensualidad_Text__c);    
                campo.CuotaMensualidadLetra_Text__c = ConversionNumeroTexto.Convertir(campo.CuotaMensualidad_Text__c, 'moneda');
            }else {
                System.debug('CuotaMensualidad_Text__c	 => ' + campo.CuotaMensualidad_Text__c);    
                campo.CuotaMensualidadLetra_Text__c = 'No Aplica';
            }
            if(campo.AnualidadGrande_Text__c != null){
                System.debug('AnualidadGrande_Text__c	 => ' + campo.AnualidadGrande_Text__c);    
                campo.AnualidadGrandeLetra_Text__c = ConversionNumeroTexto.Convertir(campo.AnualidadGrande_Text__c, 'moneda');
            }else {
                System.debug('AnualidadGrande_Text__c	 => ' + campo.AnualidadGrande_Text__c);    
                campo.AnualidadGrandeLetra_Text__c = 'No Aplica';
            }
            if(campo.AnualidadPyme_Text__c != null){
                System.debug('AnualidadPyme_Text__c	 => ' + campo.AnualidadPyme_Text__c);    
                campo.AnualidadPymeLetra_Text__c = ConversionNumeroTexto.Convertir(campo.AnualidadPyme_Text__c, 'moneda');
            }else {
                System.debug('AnualidadPyme_Text__c	 => ' + campo.AnualidadPyme_Text__c);    
                campo.AnualidadPymeLetra_Text__c = 'No Aplica';
            }
        }
    }
}