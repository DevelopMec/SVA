/**
    * @author calvarez@ctconsulting.com.mx
    * @date 2018
    * @description Controlador utilizado como servicio para cotizador.
*/
/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* @change	28/02/2020 Add opp validaction activation or deactivation with OpportunityAndThreatValidation__mdt.
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

global with sharing class PLAN_CuentaService {

    public QuoteLineItem qli {get; set;}
    public static string OppRecordType {get; set;}

    /**
        * @author calvarez@ctconsulting.com.mx
        * @date 2016
        * @description Controlador principal de Cotizador Edenred => Mantenimiento 10/11/2017 calvarez@ctconsulting.com.mx
    */

    global PLAN_CuentaService(ApexPages.StandardController controller) {}

    /**
        * @author calvarez@ctconsulting.com.mx
        * @date 2018
        * @param quoteId Id de una instancia del objeto Quote.
        * @param strDataBase64 Es un String en formato Base64.
        * @description Guarda archivo PDF de una propuesta comercial.
        * @return Objeto con la información del Attachment insertado.
    **/
    @RemoteAction
    global static Object guardaAnexoE( String qliId,  String strDataBase64,String codigoAS400 ) {
        System.debug(':::ENTRAANEXO:::');
        Map<String, Object> response = new Map<String, Object>();

        if(String.isNotBlank(qliId) && String.isNotBlank(strDataBase64)) {

            List<QuoteLineItem> soluciones = [SELECT Id,QuoteId, Product2.Name, Etapa__c, Quote.IdPDFContrato__c, Quote.OpportunityId FROM QuoteLineItem WHERE Id =: qliId];
            
            if( soluciones != null && soluciones.size() > 0 ) {
                QuoteLineItem qli = soluciones.get(0);
                

                List<Attachment> instances = new List<Attachment>();
                String nombre = '';
                if(String.isNotBlank(codigoAS400)){
                    nombre = 'Anexo E_' + qli.Product2.Name + '_' + codigoAS400 +'.pdf';
                }else{
                    nombre = 'Anexo E_' + qli.Product2.Name +'.pdf';
                }
                
                List<Attachment> documentos = [SELECT Id, Name FROM Attachment WHERE Name =: nombre  AND ParentId =: qli.Quote.OpportunityId];
                
                Attachment contrato = documentos != null && documentos.size() > 0 ? documentos.get(0) : new Attachment(ContentType = 'application/pdf', Name = nombre, ParentId = qli.Quote.OpportunityId);
                contrato.Body = EncodingUtil.base64Decode( strDataBase64 );
                instances.add(contrato);

                for (Database.upsertResult ur : Database.upsert(instances)) {
                    Map<String, Object> mapContrato = new Map<String, Object>();
                    mapContrato.put('Id', ur.getId());
                    mapContrato.put('errors', ur.getErrors());
                    mapContrato.put('isCreated', ur.isCreated());
                    mapContrato.put('isSuccess', ur.isSuccess());
                    response.put('Upsert_Attachment', mapContrato);
                }

            } else {
                response.put('error', 'Solución con Id ' + qliId + ' no encontrada');
            }
        } else {
            response.put('error', 'Parámetros {qliId} y {strDataBase64} son requeridos');
        }
        response.put('Limits', getLimits());

        return response;
    }
    
    /*
     * author Deloper Freeway
     * Metodo de duplicidad 
     * Descripcion: validacion de duplicidad en la claracion de oportunidades de tipo migracion, venta nueva y bpfleet
    */
    private static boolean ValidatepadlockOpportunity(Opportunity opp,String oppID,String productoID)
    {
          boolean resultado =false;
          
          //validar duplicado           
                Product2 producto = [Select Name from Product2 where id =:productoID];
          
                Opportunity cotiOppo = [Select Entidad_Cuenta__c,StageName,Familia__c,AccountId,RecordTypeId,Modify_opportunity__c
                                        From Opportunity 
                                        where Id=:oppID];
                
              List<Opportunity> o=new List<Opportunity>();
             // List<Opportunity> x=new List<Opportunity>();
          //Es ingreso por primera vez del producto
          
            o=[Select Entidad_Cuenta__c,StageName,Familia__c,Producto_cotizacion__c 
                      from Opportunity
                      where AccountId=:cotiOppo.AccountId 
                      and StageName Not In ('Ganada','Perdida','Planeada')
                      and Entidad_Cuenta__c =: cotiOppo.Entidad_Cuenta__c
                      and Familia__c =: cotiOppo.Familia__c
                      and Producto_cotizacion__c =: producto.Name 
                      and Modify_opportunity__c =true];
         
                   if(o.size()>0 && cotiOppo.Modify_opportunity__c!=true)//Si se encuentran registros se bloquea ya que estan duplicados
                    {
                       resultado=true; 
                    }
                                 
                //fin validacion duplicado 
          
          
        return resultado;  
    }
    
    /**
        * @author calvarez@ctconsulting.com.mx
        * @date 2018
        * @param strData cadena en formato JSON que contiene la información de la cotización a guardar, ejemplo: '{"Opportunity": {"Id": "0065B000009vHg2QAE"}, "Quote": {"ContactId": "0035B00000G9rx2QAB", "Familia__c": "Combustible", "VigenciaCotizacion__c": "7 días", "Id": "0Q05B0000002J7BSAU"}, "QuoteLineItem": [{"Product2Id": "01t61000000bwTWAAY", "CantidadTarjetas__c": "12", "Quantity": 1, "UnitPrice": "12000", "FormaPago__c": "TransferenciaElectronica", "OpcionesMetodoPago__c": "Banamex", "TarjetaAsociada__c": "1234", "ClabeInterbancaria__c": "123456789012345678", "TipoAmex__c": null, "NivelConsumo__c": null, "OtroMetodoPago__c": null, "Cantidad_Descuento__c": 0, "Total_Descuento__c": 0, "Cantidad_Descuento_Positivo__c": 0, "Total_Descuento_Positivo__c": 0, "Id": "0QL5B000000f9lhWAA", "Escalonamiento1__c": false } ], "ProductoComparado__c": [], "IndexProductoComparado": {}, "ProductoConcepto__c": [{"Concepto__c": "a0T5B000000mZIAUA2", "Bonificacion__c": 0, "PrecioLista2__c": 1.1, "EsProductoComparado__c": false, "CantidadTarjetas__c": 0, "PrecioFinal__c": 1.1, "VigenciaDescuento__c": null, "Id": "a0W5B000001A8MDUA0"} ], "IndexPConceptoCotizado": {"0": 0, "1": 0, "2": 0, "3": 0, "4": 0, "5": 0 }, "IndexPConceptoComparado": {}, "Ids2Delete": {"QuoteLineItem": [], "ProductoConcepto__c": [], "ProductoComparado__c": [] }, "IdsConEscalonamiento": {} }'
        * @param quoteData cadena en formato JSON que contiene la información de la cotización para aprobación.
        * @description Guarda archivo PDF de una propuesta comercial.
        * @return Objeto con la información de los objetos insertados, actualizados y eliminados.
    **/
    @RemoteAction
    global static Map<String, Object> guardaCotizacion( String strData, String quoteData) {
        Map<String, Object> response = new Map<String, Object>();
        try {
            Approval.ProcessSubmitRequest [] requestList = new Approval.ProcessSubmitRequest []{};
            Integer requiredApprovalLevel = null; 
            Integer grantedApprovalLevel = null; 
            String comment = null;
            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(strData);
            if( data != null || data.size() > 0 ) {
                
                Opportunity oportunidad = data.containsKey('Opportunity') ? ((Opportunity) JSON.deserialize(JSON.serialize(data.get('Opportunity')), Opportunity.class)) : null;
                
                List<QuoteLineItem> Listaluciones = (List<QuoteLineItem>) JSON.deserialize((String) JSON.serialize(data.get('QuoteLineItem')), List<QuoteLineItem>.class);
                
                //Metodo de duplicidad
        		List<OpportunityAndThreatValidation__mdt> oppValidation = [SELECT isActive__c FROM OpportunityAndThreatValidation__mdt WHERE DeveloperName = 'Opportunity'];
                Boolean isDuplicated = false;
                if (!oppValidation.isEmpty() && (oppValidation[0].isActive__c == true || Test.isRunningTest())) {  
                	isDuplicated = ValidatepadlockOpportunity(oportunidad,oportunidad.Id,Listaluciones[0].Product2Id);
                }
                if(!isDuplicated){
                    List<Opportunity> listOppValidacion = [SELECT Id, Solicitar_validaci_n_descuentos__c FROM Opportunity WHERE Id =: oportunidad.Id];
                    Quote cotizacion = data.containsKey('Quote') ? ((Quote) JSON.deserialize(JSON.serialize(data.get('Quote')), Quote.class)) : null;
                    
                    if( cotizacion.Id != null && listOppValidacion != null && listOppValidacion.size() > 0 && listOppValidacion[0].Solicitar_validaci_n_descuentos__c == true ) {
                        response.put('error', new List<String>{'Su cotización requiere de aprobación, favor de revisar el historial de aprobación para mayor detalle.'});
                    } else {
                        Boolean sincronizeOpp = false;
                        // Ids que se van a eliminar
                        Map<String, List<Id>> ids2Delete = data.containsKey('Ids2Delete') ? ((Map<String, List<Id>>) JSON.deserialize((String) JSON.serialize(data.get('Ids2Delete')), Map<String, List<Id>>.class)) : new Map<String, List<Id>>();
                        
                        Set<String> validar = new Set<String>{'QuoteLineItem', 'ProductoConcepto__c', 'ProductoComparado__c'};
                            for(String objName : ids2Delete.keySet()) {
                                if(validar.contains(objName) && ids2Delete.get(objName) != null && ids2Delete.get(objName).size() > 0 ) {
                                    
                                    if( objName == 'QuoteLineItem' ) {
                                        System.debug('::EXISTEQUOTELI::');
                                        /////
                                        List<ProductoConcepto__c> productosConcepto=new List<ProductoConcepto__c>();
                                        List<Anexo__c> anexos=new List<Anexo__c>();
                                        List<Contrato2__c> contratos=new List<Contrato2__c>();
                                        List<QuoteLineItem> liqli=[Select Id,(SELECT Id FROM Productos_Concepto__r),(SELECT Id FROM Anexos__r),(SELECT Id FROM Contratos2__r) from QuoteLineItem where Id IN :ids2Delete.get(objName)];
                                        for(QuoteLineItem temqli : liqli){
                                            productosConcepto.addAll(temqli.Productos_Concepto__r);
                                            anexos.addAll(temqli.Anexos__r);
                                            contratos.addAll(temqli.Contratos2__r);
                                        }
                                        
                                        /////
                                        //List<ProductoConcepto__c> productosConcepto = [SELECT Id FROM ProductoConcepto__c WHERE PartidaPresupuesto__c IN: ids2Delete.get(objName)];
                                        if( productosConcepto != null && productosConcepto.size() > 0 ) {
                                            response.put('DELETE_' + objName + '_ProductoConcepto__c', Database.delete(productosConcepto, false));
                                        }
                                        
                                        //List<Anexo__c> anexos = [SELECT Id FROM Anexo__c WHERE Solucion__c IN: ids2Delete.get(objName)];
                                        if( anexos != null && anexos.size() > 0 ) {
                                            response.put('DELETE_' + objName + '_Anexo__c', Database.delete(anexos, false));
                                        }
                                        
                                        //List<Contrato2__c> contratos = [SELECT Id FROM Contrato2__c WHERE PartidaPresupuesto__c IN: ids2Delete.get(objName)];
                                        if( contratos!= null && contratos.size() > 0 ) {
                                            response.put('DELETE_' + objName + '_Contrato2__c', Database.delete(contratos, false));
                                        }
                                    } else if( objName == 'ProductoComparado__c' ) {
                                        List<ProductoConcepto__c> productosConcepto = [SELECT Id FROM ProductoConcepto__c WHERE ProductoComparadoID__c IN: ids2Delete.get(objName)];
                                        if( productosConcepto != null && productosConcepto.size() > 0 ) {
                                            response.put('DELETE_' + objName + '_ProductoConcepto__c', Database.delete(productosConcepto, false));
                                        }
                                    }
                                    
                                    response.put('Deleted_' + objName, Database.delete(ids2Delete.get(objName), false));
                                }
                            }
                        
                        
                        if( cotizacion != null && oportunidad != null && oportunidad.Id != null ) {
                            
                            List<Opportunity> oppWhithQuotes = [SELECT (Select Id FROM Quotes), Name, CloseDate, RecordType.DeveloperName, Owner.ManagerId  FROM Opportunity WHERE Id =: oportunidad.Id]; 
                            OppRecordType = oppWhithQuotes[0].RecordType.DeveloperName;
                            Id oppOwnerManager = oppWhithQuotes[0].Owner.ManagerId;
                            if( cotizacion.Id == null ) {
                                Integer cantidad = oppWhithQuotes[0].Quotes.size() + 1;
                                String oppNumber = '';
                                if(!oppWhithQuotes.isEmpty()){
                                    oppNumber = (oppWhithQuotes[0].Name).splitByCharacterType()[0];
                                }
                                String nombre = 'COT' + ( cantidad > 9 ? ('0' + cantidad) : ('00' + cantidad)) + '-' + oppNumber;
                                cotizacion.Name = nombre;
                                cotizacion.OpportunityId = oportunidad.Id;
                            }
                            
                            List<QuoteLineItem> soluciones = (List<QuoteLineItem>) JSON.deserialize((String) JSON.serialize(data.get('QuoteLineItem')), List<QuoteLineItem>.class);

                            List<ProductoComparado__c> comparados = (List<ProductoComparado__c>) JSON.deserialize((String) JSON.serialize(data.get('ProductoComparado__c')), List<ProductoComparado__c>.class);
                            List<ProductoConcepto__c> pconceptos = (List<ProductoConcepto__c>) JSON.deserialize((String) JSON.serialize(data.get('ProductoConcepto__c')), List<ProductoConcepto__c>.class);
                            System.debug('VERCOTIZAPC:::'+JSON.serialize(pconceptos));
                            
                            Map<String, Object> indexComparados = (Map<String, Object>) JSON.deserializeUntyped((String) JSON.serialize(data.get('IndexProductoComparado')));
                            Map<String, Object> indexPConceptoCotizado = (Map<String, Object>) JSON.deserializeUntyped((String) JSON.serialize(data.get('IndexPConceptoCotizado')));
                            Map<String, Object> indexPConceptoComparado = (Map<String, Object>) JSON.deserializeUntyped((String) JSON.serialize(data.get('IndexPConceptoComparado')));
                            
                            Map<Id, PricebookEntry> mapIdsPBE = new Map<Id, PricebookEntry>();
                            
                            Set<Id> setIdsProduct2Id = new Set<Id>();
                            for( QuoteLineItem qli : soluciones ) {
                                if(!oppWhithQuotes.isEmpty()) {
                                    qli.ServiceDate = oppWhithQuotes[0].CloseDate;
                                }
                                if( qli.Product2Id != null ) {
                                    setIdsProduct2Id.add(qli.Product2Id);
                                }
                            }
                            
                            for(List<PricebookEntry> listPBE : [SELECT Id, Name, Product2Id, Pricebook2Id from PricebookEntry Where Product2Id IN: setIdsProduct2Id AND Pricebook2.Name = 'Edenred']) {
                                for(PricebookEntry pbe : listPBE) {
                                    mapIdsPBE.put(pbe.Product2Id, pbe);
                                }
                            }
                            if( cotizacion.Id == null ) {
                                if( mapIdsPBE.values().size() > 0 ) {
                                    cotizacion.Pricebook2Id = mapIdsPBE.values()[0].Pricebook2Id;
                                    sincronizeOpp = true;
                                } else {
                                    throw new CustomException('No se encontró lista de precios, verifique que sus productos cuenten con Entrada de lista de precios.');
                                }
                            }
                            
                            response.put('PricebookEntry', mapIdsPBE);
        
                            //Se realiza el envío del proceso de aprobación
                            Integer approvalComision = 1;
                            Integer approvalComisionMant = 1;
                            Integer approvalEnvioRecurrente = 1;
                            Integer approvalPrimerEnvio = 1;
                            Integer approvalTarjetaStock = 1;
                            Integer approvalTarjetaStockPrimer = 1;
                            oportunidad.Solicitar_validaci_n_descuentos__c = false;
                            if(OppRecordType != 'Migracion'){
                                if(quoteData != null && quoteData != 'null') {
                                    if(oppOwnerManager != null) {
                                        oportunidad.Solicitar_validaci_n_descuentos__c = true;
                                        Map<String,Object> quoteInfo = (Map<String,Object>)JSON.deserializeUntyped(quoteData);
                                        approvalComision = (Integer)quoteInfo.get('approvalComision');
                                        approvalComisionMant = (Integer)quoteInfo.get('approvalComisionMant');
                                        approvalEnvioRecurrente = (Integer)quoteInfo.get('approvalEnvioRecurrente');
                                        approvalPrimerEnvio = (Integer)quoteInfo.get('approvalPrimerEnvio');
                                        approvalTarjetaStock = (Integer)quoteInfo.get('approvalTarjetaStock');
                                        approvalTarjetaStockPrimer = (Integer)quoteInfo.get('approvalTarjetaStockPrimer');
                                        String quoteId = (string)quoteInfo.get('Id');
                                        comment = (string)quoteInfo.get('userComment');
                                        String owner = (string)quoteInfo.get('owner');
                                        requiredApprovalLevel = (Integer)quoteInfo.get('approvalLevel') - 1;
                                        grantedApprovalLevel = null;
                                        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                                        req1.setComments(comment);
                                        req1.setProcessDefinitionNameOrId('QuoteApprovalInitial');
                                        req1.setNextApproverIds(new Id[] {oppOwnerManager});
                                        req1.setSkipEntryCriteria(false);
                                        req1.setSubmitterId(owner);
                                        requestList.add(req1);
                                        cotizacion.RequiredApprovalLevel__c = requiredApprovalLevel;
                                        cotizacion.ApprovalRequestComments__c = comment;
                                        cotizacion.ApprovalStatus__c = 'Pendiente';
                                        cotizacion.ApprovalRequestDate__c = System.now();
                                    } else {
                                        throw new CustomException('El propietario del registro no cuenta con un gestor para que apruebe la solicitud de aprobación.');
                                    }
                                }
                            }
        
                            // Guardar información de la cotización.
                            Database.UpsertResult quoteUpsertResult = Database.upsert(cotizacion);
                            response.put('Upsert_Quote', quoteUpsertResult);
                            System.debug('***********************cotizacion '+cotizacion);
                            System.debug('***********************oportunidad '+oportunidad);
                            
                            if (!requestList.isEmpty()) {
                                requestList[0].setObjectId(quoteUpsertResult.getId());
                            }
                            
                            // Guardar información de productos cotizados
                            //Integer indexQLI = 1;
                            Precio_Litro__c pl=Precio_Litro__c.getInstance();
                            for( QuoteLineItem solucion: soluciones ) {
                                if(cotizacion.Familia__c=='Combustible'){
                                    System.debug('ESTE ES::'+cotizacion.Id);
                                    //solucion.Litros__c=pl.Precio_por_litro__c*solucion.UnitPrice;
                                    solucion.Litros__c=solucion.UnitPrice/pl.Precio_por_litro__c;
                                }else{
                                    solucion.Litros__c=0;
                                }
                                if( solucion.Id == null && solucion.QuoteId == null ) {
                                    solucion.QuoteId = cotizacion.Id;                                
                                    if( mapIdsPBE.containsKey(solucion.Product2Id)) {
                                        solucion.PricebookEntryId = mapIdsPBE.get(solucion.Product2Id).Id;
                                    } else {
                                        throw new CustomException('Producto ' + solucion.Product2Id + ' no tiene entrada de lista de precios, en lista Edenred.');      
                                    }
                                }
                                //Map<String, String> mapTest = new Map<String, String>();
                                //mapTest.put('desc', solucion.Description);
                                //response.put('QLI_' + indexQLI++, solucion.Description);
                            }
                            response.put('Upsert_QuoteLineItem', Database.upsert(soluciones));
                            
                            // Guarda Cotización sincronizada en la Oportunidad
                            if( sincronizeOpp ) {
                                oportunidad.SyncedQuoteId = cotizacion.Id;
                                oportunidad.Modify_opportunity__c=true;//prueba req 2331
                                response.put('Upsert_Opportunity', Database.upsert(oportunidad));
                            } else if (oportunidad.Solicitar_validaci_n_descuentos__c == true) {
                                response.put('Upsert_Opportunity', Database.upsert(oportunidad));
                            }
                            
                            // Verificar si es una cotización es duplicada y tiene escalonamientos
                            Map<String, Object> idsConEscalonamiento = (Map<String, Object>) JSON.deserializeUntyped((String) JSON.serialize(data.get('IdsConEscalonamiento')));
                            if( idsConEscalonamiento != null && idsConEscalonamiento.size() > 0 ) {
                                
                                List<QuoteLineItem> escalonamientos = [SELECT Id,QuoteId, UnitPrice, ServiceDate, Escalonamiento__c, Product2Id FROM QuoteLineItem WHERE Escalonamiento__c IN: idsConEscalonamiento.keySet() ];
                                
                                //response.put('EscalonamientosClonados', escalonamientos);
                                
                                //Map<Id, List<QuoteLineItem>> escalonamientosAClonar = new Map<Id, List<QuoteLineItem>>();
                                List<QuoteLineItem> solucionesEscalonamientos = new List<QuoteLineItem>();
                                for( QuoteLineItem qliACopiar: escalonamientos ) {
                                    //if( !escalonamientosAClonar.containsKey(qliACopiar.Escalonamiento__c) ) {
                                    //  escalonamientosAClonar.put(qliACopiar.Escalonamiento__c, new List<QuoteLineItem>());
                                    //}
                                    QuoteLineItem clon = qliACopiar.clone(false, false, false, false); 
                                    QuoteLineItem qliBase = soluciones[Integer.valueOf(idsConEscalonamiento.get(String.valueOf(qliACopiar.Escalonamiento__c)))];
                                    clon.Escalonamiento__c      = qliBase.Id;
                                    clon.QuoteId                = cotizacion.Id;
                                    clon.PricebookEntryId       = qliBase.PricebookEntryId;
                                    clon.Quantity               = 1;
                                    clon.CantidadTarjetas__c    = qliBase.CantidadTarjetas__c;
                                    clon.Product2Id             = qliBase.Product2Id;
                                    clon.Escalonamiento1__c     = true;
                                    if(cotizacion.Familia__c=='Combustible'){
                                        //clon.Litros__c=pl.Precio_por_litro__c*qliBase.UnitPrice;
                                        clon.Litros__c=qliBase.UnitPrice/pl.Precio_por_litro__c;
                                    }else{
                                        clon.Litros__c=0;
                                    }
                                    //clon.UnitPrice                = qliBase.UnitPrice;
                                    
                                    //escalonamientosAClonar.get(qliACopiar.Escalonamiento__c).add(clon);
                                    solucionesEscalonamientos.add(clon);
                                    
                                }
                                if( solucionesEscalonamientos != null && solucionesEscalonamientos.size() > 0 ) {
                                    response.put('Upsert_QuoteLineItemEscalonamiento', Database.upsert(solucionesEscalonamientos));
                                }
                                //response.put('ListosParaClonar', escalonamientosAClonar);
                            }
                            
                            
                            Integer indexProductoComparado = 0;
                            
                            for( ProductoComparado__c comparado: comparados ) {
                                if( comparado.ProductoCotizado__c == null ) {
                                    comparado.ProductoCotizado__c = soluciones[Integer.valueOf(indexComparados.get(String.valueOf(indexProductoComparado++)))].Id;
                                }
                            }
                            response.put('Upsert_ProductoComparado__c', Database.upsert(comparados));
                            
                            Integer indexPCComparado = 0;
                            Integer indexPCCotizado = 0;
                            String idPC='';
                            Double comision=0;
                            
                            //Extract approval levels for ProductoConcepto__c uuu
                            for( ProductoConcepto__c concepto: pconceptos ) {
                                if( concepto.EsProductoComparado__c == true ) {
                                    concepto.ProductoComparadoID__c = comparados[Integer.valueOf(indexPConceptoComparado.get(String.valueOf(indexPCComparado++)))].Id;
                                } else {
                                    concepto.PartidaPresupuesto__c = soluciones[Integer.valueOf(indexPConceptoCotizado.get(String.valueOf(indexPCCotizado++)))].Id;
                                }
                                System.debug('ENTRAA::'+concepto);
                                if(concepto.Concepto_Tipo_Cargo__c=='Comisión por el servicio'&&concepto.PartidaPresupuesto__c!=null){
                                    idPC=concepto.PartidaPresupuesto__c;
                                    comision=concepto.PrecioFinal__c;
                                }
                                if(quoteData != null && quoteData != 'null') {
                                    if(concepto.Concepto_Tipo_Cargo__c=='Comisión por el servicio'){
                                        concepto.ApprovalLevel__c = approvalComision;    
                                    } else if(concepto.Concepto_Tipo_Cargo__c=='Cobro por gestion de vehiculos') {
                                        concepto.ApprovalLevel__c = approvalComisionMant;  
                                    } else if(concepto.Concepto_Tipo_Cargo__c=='Cargo por envío - Recurrente') {
                                        concepto.ApprovalLevel__c = approvalEnvioRecurrente;    
                                    } else if(concepto.Concepto_Tipo_Cargo__c=='Cargo del primer envío') {
                                        concepto.ApprovalLevel__c = approvalPrimerEnvio;    
                                    } else if(concepto.Concepto_Tipo_Cargo__c=='Tarjeta titular / Stock') {
                                        concepto.ApprovalLevel__c = approvalTarjetaStock;    
                                    } else if(concepto.Concepto_Tipo_Cargo__c=='Tarjeta titular / Stock - primer envío') {
                                        concepto.ApprovalLevel__c = approvalTarjetaStockPrimer;    
                                    }
                                }
                            }                        
                            /*for( ProductoConcepto__c concepto: pconceptos ) {
                                if(concepto.Concepto_Tipo_Cargo__c=='Comisión por el servicio'&&concepto.PartidaPresupuesto__c!=null){
                                idPC=concepto.PartidaPresupuesto__c;
                                comision=concepto.PrecioFinal__c;
                                }
                            }*/
                            if(idPC!=''){
                                QuoteLineItem ql=new QuoteLineItem();
                                ql.Id=idPC;
                                ql.Comision_por_Servicio__c=comision;
                                Database.update(ql);
                            }
                            
                            response.put('request_ProductoConcepto__c', pconceptos);
                            
                            response.put('Upsert_ProductoConcepto__c', Database.upsert(pconceptos));
                            
                            response.put('Instance_Quote', [SELECT Id, Name, IsSyncing FROM Quote WHERE Id =: cotizacion.Id ]);
                        }
                    }
                    
                if (oportunidad.Solicitar_validaci_n_descuentos__c == true) {
                    response.put('SOQL_Opportunity', true);
                } else {
                    response.put('SOQL_Opportunity', false);
                }
                    
                    
                    response.put('request', data);
                    
                    
                    
                }else{//Fin verificacion de duplicidad OP
                    response.put('error', new List<String>{'“Ya existe una oportunidad abierta para ese mismo RFC Solución”'});
                }
                
                
            } else {
                response.put('error', 'No se recibieron datos.');
            }
            Approval.ProcessResult[] result = Approval.process(requestList);
        }  catch(DmlException e) {
            System.debug('DmlException caught: ' + e.getMessage());
            throw new CustomException(e.getMessage() + ' ' + e.getLineNumber());
        }
        catch( JSONException ex ) {
            System.debug('ERROR::'+ex.getMessage()+', linea:'+ex.getLineNumber());
            // response.put('error', ex.getStackTraceString() + ' ' + ex.getLineNumber());
            // response.put('JSONException', ex.getMessage());
            throw new CustomException(ex.getMessage() + ' ' + ex.getLineNumber());

        } catch( NullPointerException ex ) {
            System.debug('ERROR::'+ex.getMessage()+', linea:'+ex.getLineNumber());
            // response.put('error', ex.getStackTraceString() + ' ' + ex.getLineNumber());
            // response.put('NullPointerException', ex.getMessage() + ' ' + ex.getLineNumber());
            throw new CustomException(ex.getMessage() + ' ' + ex.getLineNumber());

        } catch( Exception ex ) {
            System.debug('ERROR::'+ex.getMessage()+', linea:'+ex.getLineNumber());
            // response.put('error', ex.getStackTraceString() + ' ' + ex.getLineNumber());
            // response.put('Exception', ex.getMessage() + ' ' + ex.getLineNumber());
            throw new CustomException(ex.getMessage() + ' ' + ex.getLineNumber());

        }
        

        response.put('Limits', getLimits());
        return response;
    }


    /**
        * @author calvarez@ctconsulting.com.mx
        * @date 09/01/2017
        * @param quoteId Id de una instancia del objeto Quote.
        * @param strDataBase64 Es un String en formato Base64.
        * @description Guarda archivo PDF de una propuesta comercial.
        * @return Objeto con la información del QuoteDocument insertado.
    **/
    @RemoteAction
    public static Map<String, Object> guardaPDFBase64( String quoteId, String strDataBase64 ) {
        //System.debug('guardaContrato, strData: ' + strData);
        Map<String, Object> response = new Map<String, Object>();
        List<QuoteDocument> instances = new List<QuoteDocument>();

        Quote cotizacion = [SELECT Id,Name, IdPDFPropuestaComercial__c from Quote where Id =: quoteId]; 
        
        System.debug('******************** '+ cotizacion.IdPDFPropuestaComercial__c+' '+quoteId);
        List<QuoteDocument> documentos = [SELECT Id, Name, QuoteId,Document FROM QuoteDocument WHERE Id =: cotizacion.IdPDFPropuestaComercial__c];

        QuoteDocument qDocument = new QuoteDocument(QuoteId = quoteId, Document = EncodingUtil.base64Decode(strDataBase64));
        instances.add(qDocument);

        if(documentos != null && documentos.size() > 0){
            delete documentos;
        }

        for (Database.upsertResult ur : Database.upsert(instances)) {
            Map<String, Object> mapAnexo = new Map<String, Object>();
            mapAnexo.put('Id', ur.getId());
            mapAnexo.put('errors', ur.getErrors());
            mapAnexo.put('isCreated', ur.isCreated());
            mapAnexo.put('isSuccess', ur.isSuccess());
            response.put('Upsert_QuoteDocument', mapAnexo);

            cotizacion.IdPDFPropuestaComercial__c = ur.getId();
            upsert cotizacion;
        }


        response.put('strDataBase64', strDataBase64);
        response.put('Limits', getLimits());
        return response;
    }

    /**
        * @author calvarez@ctconsulting.com.mx
        * @date 2018
        * @param query Es un string válido para realizar una consulta
        * @description Executa una consulta SOQL.
        * @return Lista de instancias de sObject.
    **/
    @RemoteAction
    global static List<sObject> query( String query ) {
        return Database.query(query);
    }
    
    /**
        * @author calvarez@ctconsulting.com.mx
        * @date 2018
        * @param objs Array de string que contiene nombre API de los objetos existentes en la instancia de salesforce.
        * @description Obtiene los metadatos de unos ó más objetos de salesforce.
        * @return Lista de instancias metadatos de los objetos.
    **/
    @RemoteAction
    global static Schema.DescribeSobjectResult[] describe( String[] objs ) {
        return Schema.describeSObjects(objs);
    }
    
    /**
        * @author calvarez@ctconsulting.com.mx
        * @date 2018
        * @param ids Array ids existentes de objetos existentes de salesforce.
        * @description Elimina instancias de salesforce por id.
        * @return Lista de resultados por instancia que se intentó eliminar.
    **/
    @RemoteAction
    global static List<Database.DeleteResult> deleteIds( String[] ids ) {
        return Database.delete(ids);
    }
    
    /**
        * @author calvarez@ctconsulting.com.mx
        * @date 2018
        * @param typeobj API name del objeto que se intenta insertar/actualizar.
        * @param data Lista de instancias que se van a insertar/actualizar.
        * @description Inserta/actualiza instancias de un obejto existente el el ambiente de salesforce.
        * @return Lista de resultados por instancia que se inserta/actualiza.
    **/
    @RemoteAction
    public static List<Database.UpsertResult> upsertSobjects( String typeobj, String data ) {
        Type t = Type.forName('List<' + typeobj + '>');
        System.debug('upsertSobjects' + typeobj);
         System.debug('upsertSobjects' + data);
        List<sObject> instances = (List<sObject>) JSON.deserialize(data, t);
        System.debug('upsertSobjects '+ instances);
        
        if(typeobj=='QuoteLineItem'){
            List<QuoteLineItem> lqli=(List<QuoteLineItem>)instances;
            Set<String> idCotTodos=new Set<String>();
            Set<String> idCotCombus=new Set<String>();
            for(QuoteLineItem tem:lqli){
                //idCotCombus.add(tem.QuoteId);
                idCotTodos.add(tem.QuoteId);
            }
            for(Quote q:[Select Id,Familia__c from Quote where Id IN:idCotTodos]){
                if(q.Familia__c=='Combustible'){
                    idCotCombus.add(q.Id);
                }
            }
            Precio_Litro__c pl=Precio_Litro__c.getInstance();
            boolean bandera=false;
            for(QuoteLineItem tem:lqli){
                if(idCotCombus.contains(tem.QuoteId)){
                    bandera=true;
                    //tem.Litros__c=pl.Precio_por_litro__c*tem.UnitPrice;
                    //tem.Litros__c=tem.UnitPrice/pl.Precio_por_litro__c;
                }
            }
            for(QuoteLineItem tem:lqli){
                if(bandera){
                    tem.Litros__c=tem.UnitPrice/pl.Precio_por_litro__c;
                }else{
                    tem.Litros__c=0;
                }
            }
            return Database.upsert(lqli);
        }
        
        return Database.upsert(instances);
    }

    /**
        * @author calvarez@ctconsulting.com.mx
        * @date 2018
        * @description Obtiene los límites de gobierno por transacción realizada.
        * @return Objeto con los límites de gobierno de la transacción.
    **/
    public static Map<String, Object> getLimits() {
        // Map<String, Object> ret = new Map<String, Object>();
        // ret.put('DMLLimit', Limits.getLimitDMLStatements());
        // ret.put('DMLExecuted', Limits.getDMLStatements());
        // ret.put('DMLAvailable', Limits.getLimitDMLStatements() - Limits.getDMLStatements());

        // ret.put('SOQLLimit', Limits.getLimitQueries());
        // ret.put('SOQLExecuted', Limits.getQueries());
        // ret.put('SOQLAvailable', Limits.getLimitQueries() - Limits.getQueries());
        return LightningService_CTRL.getLimits();
    }

    /**
        * @author calvarez@ctconsulting.com.mx
        * @date 2018
        * @description Manejo personalizado de excepciones
    */
    public class CustomException extends Exception { }
}