@isTest
private class UtilsTest {
    @isTest 
    static void myUnitTest(){
        Tarifa__c tarifa= new Tarifa__c(TipoCargo__c='sffa 34',CodigoProducto__c='21',ClaveReferencia__c='41');
        Tarifa__c tarifa2= new Tarifa__c(TipoCargo__c='sffa re',CodigoProducto__c='21',ClaveReferencia__c='41');
        insert tarifa;
        insert tarifa2;
        tarifa= new Tarifa__c(TipoCargo__c='sffa 34',CodigoProducto__c='41',ClaveReferencia__c='434');
        insert tarifa;
        String obtenernombretarifa= Utils.OBTENER_NOMBRETARIFA('21','41');
        
         obtenernombretarifa= Utils.OBTENER_NOMBRETARIFA('41','434');
        Tarifa__c obtenerTarifa= Utils.OBTENER_TARIFA('21','41','sffa 34');
       Map<String,String> MAP_GIRO = UTILS.MAP_GIRO;
       Map<String,String> MAP_SECTOR = UTILS.MAP_SECTOR;
       Map<String,String> MAP_ESTADOCLAVE = UTILS.MAP_ESTADOCLAVE;
       Map<String,String> MAP_ESTADOCLAVEDOS = UTILS.MAP_ESTADOCLAVEDOS;
       Map<String,String> MAP_ESTADO = UTILS.MAP_ESTADO;
       Map<String,String> MAP_SUCURSAL = UTILS.MAP_SUCURSAL;
       Map<String,String> MAP_ORIGENVENTA = UTILS.MAP_ORIGENVENTA;
       Map<String,String> MAP_COMPETIDOR = UTILS.MAP_COMPETIDOR;
       Map<String,String> MAP_TIPOPAGO = UTILS.MAP_TIPOPAGO;
       Map<String,String> MAP_MEDIOPAGO = UTILS.MAP_MEDIOPAGO;
       Map<String,String> MAP_FRECUENCIALIBERACIONAUTOMATICA = UTILS.MAP_FRECUENCIALIBERACIONAUTOMATICA;
       Map<String,String> MAP_TIPOFACTURACION = UTILS.MAP_TIPOFACTURACION;
       Map<String,String> MAP_FRECUENCIAFACTURACION = UTILS.MAP_FRECUENCIAFACTURACION;
       Map<String,String> MAP_COMOFACTURA = UTILS.MAP_COMOFACTURA;
       Map<String,String> MAP_TIPOCLIENTE = UTILS.MAP_TIPOCLIENTE;
       Map<String,String> MAP_FACTURACIONCOMISION = UTILS.MAP_FACTURACIONCOMISION;
       Map<String,String> MAP_FACTURACIONPLASTICO = UTILS.MAP_FACTURACIONPLASTICO;
       Map<String,String> MAP_ITEMCONTRATACION = UTILS.MAP_ITEMCONTRATACION;
       Map<String,String> MAP_PUESTO = UTILS.MAP_PUESTO;
       Map<String,String> MAP_FACTURACIONCARGOS = UTILS.MAP_FACTURACIONCARGOS;
       Map<String,String> MAP_MANEJA = UTILS.MAP_MANEJA;
        
       Map<String,String> MAP_RED = UTILS.MAP_RED;
       Map<String,String> MAP_OPERACIONMODOOFFLINE = UTILS.MAP_OPERACIONMODOOFFLINE;
       Map<String,String> MAP_DESCRIPCIONLINEAIMPRESION = UTILS.MAP_DESCRIPCIONLINEAIMPRESION;
       Map<String,String> MAP_FINANCIAMIENTO = UTILS.MAP_FINANCIAMIENTO;
       Map<String,String> MAP_TIPOFINANCIAMIENTO = UTILS.MAP_TIPOFINANCIAMIENTO;
       Map<String,String> MAP_TIPOPLASTICOTARJETAFINANCIERA = UTILS.MAP_TIPOPLASTICOTARJETAFINANCIERA;
       Map<String,String> MAP_TIPOPLASTICOTARJETASTOCK = UTILS.MAP_TIPOPLASTICOTARJETASTOCK;
       List<SelectOption> obtenerCatalogo = UTILS.obtenerCatalogo('Estado');
        
            Account cta = new Account(Name='cuenta', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
            insert cta;
        String obtenerNombreObjeto= utils.obtenerNombreObjeto(cta.Id);
    }

}