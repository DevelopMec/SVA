public class CreateCustomerRequestWP {
    public CustomerDTO customer{get;set;}
    public ConfigurationDTO configuration{get;set;}
    public List<FeeDTO> fees{get;set;}
    public List<AuxiliaryAddressDTO> auxiliary_addresses{get;set;}
    public List<PrintLinesDTO> print_lines{get;set;}
   //public Map<String,String> mapaCatalogos{get;set;}
    
    public CreateCustomerRequestWP(Map<String,String> mapaCatalogos,ContratoFilial__c filial,Opportunity opp,List<ProductoConcepto__c> conceptos,List<CatalogoDirecciones__c> listaDir,String posVendedor){                
        
        customer=getCliente(mapaCatalogos,filial,opp,posVendedor/*,opp.Funciones_de_Contactos_en_Oportunidad__r*/);
        configuration=getConfiguration(filial,mapaCatalogos);
        fees=getFees(filial,conceptos);
        auxiliary_addresses=getAuxiliaryAddress(listaDir,filial,opp);
        print_lines=getPrintLines();
    }
    
    public CustomerDTO getCliente(Map<String,String> mapaCatalogos,ContratoFilial__c filial,Opportunity opp,String posVendedor/*,List<OpportunityContactRole__c> rolesContacto*/){
        CustomerDTO cliente=new CustomerDTO();
        String as400=filial.CodigoAS400__c;
        List<String> datosFilial=as400.split('-');
        cliente.branch_ref=Integer.valueOf(datosFilial[0]);
        cliente.product_ref=Integer.valueOf(datosFilial[1]);
        cliente.group_ref=Integer.valueOf(datosFilial[2]);
        cliente.customer_ref=Integer.valueOf(datosFilial[3]);
        cliente.name=getStringBySize(filial.Entidad_Cuenta__r.EntidadLegal__r.RazonSocial__c,40);//razon social de RFC
        cliente.extended_name=getStringBySize(filial.Entidad_Cuenta__r.EntidadLegal__r.RazonSocial__c,100);
        cliente.sale_origin=Integer.valueOf(getValorCatalogo(mapaCatalogos,filial.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.LeadSource+'-LeadSource')=='0' ? '41' : getValorCatalogo(mapaCatalogos,filial.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.LeadSource+'-LeadSource'));
        cliente.competitor=Integer.valueOf(getValorCatalogo(mapaCatalogos,filial.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Competidor__c+'-Competidor__c'));
        cliente.line_of_business=32;//Integer.valueOf(getValorCatalogo(mapaCatalogos,filial.Entidad_Cuenta__r.Cuenta__r.Giro__c+'-Giro__c'));
        cliente.tax_payer_ref=filial.Entidad_Cuenta__r.RFCEL__c;
        cliente.invoicing_address=getAddress(filial);
        cliente.status='A';
        cliente.contact_info=getContactInfo(mapaCatalogos,filial,opp/*,rolesContacto*/);
        cliente.contract=getContract(mapaCatalogos,filial,cliente.product_ref,opp,posVendedor);
        cliente.transaction_control=getTransactionControl(mapaCatalogos,filial,opp);
        
        return cliente;
        
    }
    public static String getStringBySize(String cadena,Integer tam){
        String res=cadena!=null ? cadena : '';
        if(res.length()>tam){
            res=res.substring(0, tam);
        }
        return res;        
    }
    public String getValorCatalogo(Map<String,String> mapaCatalogos,String nombreCat){
        String res='';
        if(mapaCatalogos.containsKey(nombreCat)){
            res=mapaCatalogos.get(nombreCat);
        }else if(mapaCatalogos.containsKey('DefaultRecord')){
            res=mapaCatalogos.get('DefaultRecord');
        }else{
            res='0';
        }
        return res;
    }
    public CustomerAddressDTO getAddress(ContratoFilial__c filial){
        CustomerAddressDTO res=new CustomerAddressDTO();
        String dir='';
        dir=filial.Contrato_2__r.FiscalAddress__r.Calle_Tt__c!=null ? filial.Contrato_2__r.FiscalAddress__r.Calle_Tt__c : ''+' '+filial.Contrato_2__r.FiscalAddress__r.NumeroInterior_Tt__c!=null ? filial.Contrato_2__r.FiscalAddress__r.NumeroInterior_Tt__c : '';
        res.internal_number=filial.Contrato_2__r.FiscalAddress__r.NumeroInterior_Tt__c!=null ? getStringBySize(filial.Contrato_2__r.FiscalAddress__r.NumeroInterior_Tt__c,30).toUpperCase() : '';
        res.external_number=getStringBySize(filial.Contrato_2__r.FiscalAddress__r.NumeroExterior_Tt__c,30).toUpperCase();//limitar a 30
        res.street=getStringBySize(dir,50);//limitar a 50
        res.suburb=getStringBySize(filial.Contrato_2__r.FiscalAddress__r.Colonia_Tt__c,30);//limitar a 30
        res.zip_code=Integer.valueOf(filial.Contrato_2__r.FiscalAddress__r.CodigoPostal_Tt__c !=null ? filial.Contrato_2__r.FiscalAddress__r.CodigoPostal_Tt__c  : '0');
        return res;
    }
    public ContactInfoDTO getContactInfo(Map<String,String> mapaCatalogos,ContratoFilial__c filial,Opportunity opp/*,List<OpportunityContactRole__c> rolesContacto*/){
        ContactInfoDTO res=new ContactInfoDTO();
        res.receiving_bill_email=filial.Contrato_2__r.CorreoRecibeFactura__c!=null ? filial.Contrato_2__r.CorreoRecibeFactura__c : '';
        List<ContactDTO> lContacts=new List<ContactDTO>();
        ContactDTO tem=new ContactDTO(filial.Contrato_2__r.Contacto__r.FirstName,filial.Contrato_2__r.Contacto__r.LastName,filial.Contrato_2__r.Contacto__r.Email,filial.Contrato_2__r.Contacto__r.Extension__c!=null ? filial.Contrato_2__r.Contacto__r.Extension__c : '0',Integer.valueOf(filial.Contrato_2__r.FiscalAddress__r.CodigoPostal_Tt__c !=null ? filial.Contrato_2__r.FiscalAddress__r.CodigoPostal_Tt__c  : '0'));
        tem.type=2;//Representante Legal Quien Decide//Integer.valueOf(getValorCatalogo(mapaCatalogos,ocr.Role__c+'-Role__c'));
        tem.phone=Decimal.valueOf(filial.Contrato_2__r.Contacto__r.Phone!=null ? filial.Contrato_2__r.Contacto__r.Phone : '0');//Decimal.valueOf(ocr.ContactId__r.Phone);
        lContacts.add(tem);
        
        if(filial.isPrime__c){
            ContactDTO tem2=new ContactDTO(opp.Contacto__r.FirstName,opp.Contacto__r.LastName,opp.Contacto__r.Email,opp.Contacto__r.Extension__c!=null ? opp.Contacto__r.Extension__c : '0',Integer.valueOf(filial.Contrato_2__r.FiscalAddress__r.CodigoPostal_Tt__c !=null ? filial.Contrato_2__r.FiscalAddress__r.CodigoPostal_Tt__c  : '0'));
            tem2.type=1;//Administrador de PLataforma Quien Solicita//Integer.valueOf(getValorCatalogo(mapaCatalogos,ocr.Role__c+'-Role__c'));        
            tem2.phone=Decimal.valueOf(opp.Contacto__r.Phone!=null ? opp.Contacto__r.Phone : '0');//Decimal.valueOf(ocr.ContactId__r.Phone);
            lContacts.add(tem2);
        }else{
            ContactDTO tem2=new ContactDTO(filial.PlatformAdministrator__r.FirstName,filial.PlatformAdministrator__r.LastName,filial.PlatformAdministrator__r.Email,filial.PlatformAdministrator__r.Extension__c!=null ? filial.PlatformAdministrator__r.Extension__c : '0',Integer.valueOf(filial.Contrato_2__r.FiscalAddress__r.CodigoPostal_Tt__c !=null ? filial.Contrato_2__r.FiscalAddress__r.CodigoPostal_Tt__c  : '0'));
            tem2.type=1;
            tem2.phone=Decimal.valueOf(filial.PlatformAdministrator__r.Phone!=null ? filial.PlatformAdministrator__r.Phone : '0');//Decimal.valueOf(ocr.ContactId__r.Phone);
            lContacts.add(tem2);
        }        
        //}
        res.contacts=lContacts;
        return res;
    }
    public ContractDTO getContract(Map<String,String> mapaCatalogos,ContratoFilial__c filial,Integer producto,Opportunity opp,String posVendedor){
        ContractDTO res=new ContractDTO();
        res.version='TVWT-001';
        res.biannual_territory=opp.Owner.NumeroTerritorio__c!=null ? Integer.valueOf(opp.Owner.NumeroTerritorio__c) : 1;//NCLTE6M Territorio 6 MESES
        res.system_territory=opp.Owner.NumeroTerritorio__c!=null ? Integer.valueOf(opp.Owner.NumeroTerritorio__c) : 1;//se queda 1 Territorio Espada
        res.post_salesman=Integer.valueOf(posVendedor);//CLNUCO Post Vendedor
        res.ordering_frequency=Integer.valueOf(getValorCatalogo(mapaCatalogos,filial.Contrato_2__r.Frecuencia_de_Pedido__c+'-Frecuencia_de_Pedido__c'));//CLFRPE
        res.payment_method=Integer.valueOf(getValorCatalogo(mapaCatalogos,filial.Contrato_2__r.WayPay__c+'-WayPay__c'));//NCLTICH
        res.minimum_commission=filial.Contrato_2__r.ComisionMinima__c ? 0 : 1;//NCLCVCO
        res.delivery_address=1;//CCLDIEN
        res.business_hours='09:00 A 18:00';//CCLHORA
        res.invoice_printing_status='1';
        res.pay_per_use=getValorCatalogo(mapaCatalogos,filial.Contrato_2__r.TipoPago__c+'-TipoPago__c');//CLXLIQ---Forma de Pago
        res.issued_volume=filial.Contrato_2__r.VolumenEmision__c;//NCLVEEM
        res.invoicing_type=1;//Integer.valueOf(getValorCatalogo(mapaCatalogos,filial.Contrato_2__r.TipoPago__c=='Prepago' ? 'Pedido-Tipo_de_Facturacion__c' : 'Consumo-Tipo_de_Facturacion__c'));//NWCTTIPF
        res.warranty_amount=filial.Contrato_2__r.MontoGarantia__c!=null ? filial.Contrato_2__r.MontoGarantia__c : 0;
        res.operational_amount=filial.Contrato_2__r.VolumenEmision__c!=null ? filial.Contrato_2__r.VolumenEmision__c : 1;//NCLIOPE--volumen de emision
        res.is_joined_invoicing=getValorCatalogo(mapaCatalogos,filial.Contrato_2__r.Facturacion_Cargos__c+'-Facturacion_Cargos__c');//CCLFCJS
        res.main_enterprise=filial.Contrato_2__r.EmpresaPrincipal_PL__c=='Prime' ? 1 : 0;
        res.vip_status=0;
        res.business_segment=Integer.valueOf(getValorCatalogo(mapaCatalogos,filial.Entidad_Cuenta__r.Cuenta__r.Sector__c+'-Sector__c'));//Catalogo con sector de la cuenta
        res.payment_conditions=producto==30&&filial.Contrato_2__r.TipoPago__c=='Prepago' ? 0 : (filial.Contrato_2__r.CondicionesPagoPlazo__c!=null ? Integer.valueOf(filial.Contrato_2__r.CondicionesPagoPlazo__c) : 0);//NCLCOPA
        res.custom_name=filial.Contrato_2__r.Entidad_cuenta__r.NombreEL__c!=null ? getStringBySize(filial.Contrato_2__r.Entidad_cuenta__r.NombreEL__c,40) : 'a';
        res.custom_address=getStringBySize(filial.Contrato_2__r.FiscalAddress__r.Name,40);
        res.card_together=getValorCatalogo(mapaCatalogos,filial.Contrato_2__r.Facturacion_Plasticos__c+'-Facturacion_Plasticos__c');
        res.commission_together=getValorCatalogo(mapaCatalogos,filial.Contrato_2__r.Facturacion_Comision__c+'-Facturacion_Comision__c');
        res.consolidated_invoice=filial.Contrato_2__r.ComoFactura__c=='Consolidador' ? 1 : 0;
        res.web_client_invoicing=1;//Integer.valueOf(getValorCatalogo(mapaCatalogos,filial.Contrato_2__r.ComoFactura__c=='Consolidador' ? 'Web' : filial.Contrato_2__r.TipoCliente__c!=null ? filial.Contrato_2__r.TipoCliente__c : 'Facturación'+'-TipoCliente__c'));
        res.condolidated_branch=Integer.valueOf(filial.Contrato_2__r.Sucursal_Facturacion_Global__c!=null ? filial.Contrato_2__r.Sucursal_Facturacion_Global__c : '0');
        res.consolidated_product=0;
        res.consolidated_group=0;
        res.consolidated_customer=0;
        if(filial.Contrato_2__r.EmpresaPrincipal_PL__c!='Prime'){
            res.global_branch=Integer.valueOf(filial.Contrato_2__r.Sucursal_Facturacion_Global__c!=null ? filial.Contrato_2__r.Sucursal_Facturacion_Global__c : '0');
            res.global_product=producto;//Integer.valueOf(filial.Contrato_2__r.Producto_Factura_Global__c);
            res.global_customer=Integer.valueOf(filial.Contrato_2__r.Cliente_Facturacion_Global__c!=null ? filial.Contrato_2__r.Cliente_Facturacion_Global__c : '0');
        }else{
            res.global_branch=0;
            res.global_product=0;
            res.global_customer=0;
        }
        res.migration='0';
        res.previous_invoicing='0';
        res.risk_exposure=0;
        res.invoicing_delay_days=0;
        res.approval_policy='0';
        res.prime_company_identifier=Integer.valueOf(filial.Contrato_2__r.PrimeId__c!=null ? filial.Contrato_2__r.PrimeId__c : 0);//Integer.valueOf(filial.Contrato_2__r.PrimeGroupName__c!=null ? filial.Contrato_2__r.PrimeGroupName__c : '0');
        res.as_invoice=Integer.valueOf(getValorCatalogo(mapaCatalogos,filial.Contrato_2__r.ComoFactura__c+'-ComoFactura__c'));
        res.financial_level=1;
        res.contract_item=Integer.valueOf(getValorCatalogo(mapaCatalogos,filial.Contrato_2__r.Item_Contratacion__c+'-Item_Contratacion__c'));
        res.invoicing_frequency=Integer.valueOf(getValorCatalogo(mapaCatalogos,filial.Contrato_2__r.FrecuenciaFacturacion__c+'-FrecuenciaFacturacion__c'));
        return res;
    }
    public TransactionControlDTO getTransactionControl(Map<String,String> mapaCatalogos,ContratoFilial__c filial,Opportunity opp){
        TransactionControlDTO res=new TransactionControlDTO();
        res.offline_transaction_status=Integer.valueOf(getValorCatalogo(mapaCatalogos,filial.Contrato_2__r.ModoOffline__c+'-ModoOffline__c'));
        res.contact=getContact(filial,opp);
        res.odometer_snap=1;
        res.hourmeter_snap=1;        
        res.max_offline_transactions_quantity=filial.Contrato_2__r.MaxOfflineTransactionsQuantity__c!=null ? filial.Contrato_2__r.MaxOfflineTransactionsQuantity__c : 0;//MaxOfflineTransactionsQuantity
        res.max_offline_transactions_amount=filial.Contrato_2__r.MaxOfflineTransactionsAmount__c!=null ? filial.Contrato_2__r.MaxOfflineTransactionsAmount__c : 0;//MaxOfflineTransactionsAmount
        res.enabled_purchase_status =0;
        res.transaction_interval=filial.Contrato_2__r.TransactionInterval__c!=null ? filial.Contrato_2__r.TransactionInterval__c : 0;//TransactionInterval
        res.allow_card_nip =0;
        res.allow_disabled_card_nip =0;
        res.odometer_control =0;
        res.hourmeter_control =0;
        res.driver_control =0;
        res.car_plate_control =0;
        res.vehicle_control =0;
        res.commodity_control =0;
        res.conditional_control_with_nip =0;
        res.print_balance_enabled =0;
        res.allow_terminal =0;
        res.capture_reference =0;
        res.reference_control =0;
        res.limits =0;
        res.print_balance_on_ticket=0;
        res.driver_identification_nip_control =filial.Contrato_2__r.Maneja_Conductores__c ? 1 : 0;//maneja conductores
        res.driver_license_nip_control=0;
        res.stock_card =0;
        res.owm_pump =filial.Contrato_2__r.BombaPropia__c ? 1 : 0;
        res.deny_purchase_on_business_day =filial.Contrato_2__r.DenyPurchaseBusinessDay__c ? 1 : 0;
        res.deny_purchase_on_saturday =filial.Contrato_2__r.DenyPurchaseSaturday__c ? 1 : 0;
        res.deny_purchase_on_sunday =filial.Contrato_2__r.DenyPurchaseSunday__c ? 1 : 0;
        
        return res;
    }
    public ContactDTO getContact(ContratoFilial__c filial,Opportunity opp){        
        if(filial.isPrime__c){
            ContactDTO res=new ContactDTO(opp.Contacto__r.FirstName,opp.Contacto__r.LastName,opp.Contacto__r.Email,opp.Contacto__r.Extension__c!=null ? opp.Contacto__r.Extension__c : '0',Integer.valueOf(filial.Contrato_2__r.FiscalAddress__r.CodigoPostal_Tt__c !=null ? filial.Contrato_2__r.FiscalAddress__r.CodigoPostal_Tt__c  : '0'));
            return res;            
        }else{
            ContactDTO res=new ContactDTO(filial.PlatformAdministrator__r.FirstName,filial.PlatformAdministrator__r.LastName,filial.PlatformAdministrator__r.Email,filial.PlatformAdministrator__r.Extension__c!=null ? filial.PlatformAdministrator__r.Extension__c : '0',Integer.valueOf(filial.Contrato_2__r.FiscalAddress__r.CodigoPostal_Tt__c !=null ? filial.Contrato_2__r.FiscalAddress__r.CodigoPostal_Tt__c  : '0'));
            return res;
        }        
    }
    public ConfigurationDTO getConfiguration(ContratoFilial__c filial,Map<String,String> mapaCatalogos){
        ConfigurationDTO res=new ConfigurationDTO();
        res.voucher=1;
        res.invoice_pay_format='99';
        res.use_external_bank='P';
        res.cardless_consumption_indicator=Integer.valueOf(getValorCatalogo(mapaCatalogos,filial.Contrato_2__r.Modo_Transaccion__c+'-Modo_Transaccion__c'));
        res.tag_near_field_communication=filial.Contrato_2__r.Controla_Presencia_Vehiculo_NFC__c ? 1 : 0;
        res.opportunity_number=Integer.valueOf(filial.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.NumeroOportunidad__c);
        res.third_party_ref=Integer.valueOf(getValorCatalogo(mapaCatalogos,filial.Contrato_2__r.Tipo_Maquila__c+'-Tipo_Maquila__c'));
        return res;
    }
    public List<FeeDTO> getFees(ContratoFilial__c filial,List<ProductoConcepto__c> conceptos){
        List<FeeDTO> res=new List<FeeDTO>();
        FeeDTO tem;
        Integer i=1;
        for(ProductoConcepto__c concepto : conceptos){
            double montoTem=0;
            double appPerTem=0;
            String frequencyTem='';
            if((concepto.Bonificacion__c!=null&&concepto.Bonificacion__c>0)||concepto.Concepto__r.SinEdicion__c){
                montoTem=concepto.PrecioLista__c;                
            }else{
                montoTem=concepto.PrecioFinal__c ;
            }
            if(concepto.Concepto__r.ClaveReferencia__c=='CO01'){
                appPerTem=concepto.PrecioFinal__c;//==0 ? 1 : concepto.PrecioFinal__c ;
                montoTem=0;
            }else{
                appPerTem=0;
            }
            String stagTem='';
            if(concepto.Concepto__r.ClaveReferencia__c=='CA04'){
                frequencyTem='3';
            }else if(concepto.Concepto__r.ClaveReferencia__c=='CO01'){
                frequencyTem='0';
                stagTem='O';
            }else{
                frequencyTem='8';
            }            
            
            res.add(new FeeDTO(i,concepto.Concepto__r.ClaveReferencia__c,'',montoTem,appPerTem,1,concepto.FechaInicio__c!=null ? String.valueOf(concepto.FechaInicio__c) : String.valueOf(Date.today()),concepto.FechaFinal__c!=null ? String.valueOf(concepto.FechaFinal__c) : String.valueOf(Date.newInstance(2020, 12, 31)),frequencyTem,stagTem));
            if(concepto.Concepto__r.ClaveReferencia__c=='CT05'){
                i++;
                res.add(new FeeDTO(i,'CT01','',montoTem,appPerTem,1,concepto.FechaInicio__c!=null ? String.valueOf(concepto.FechaInicio__c) : String.valueOf(Date.today()),concepto.FechaFinal__c!=null ? String.valueOf(concepto.FechaFinal__c) : String.valueOf(Date.newInstance(2020, 12, 31)),frequencyTem,''));
                if(concepto.Bonificacion__c!=null&&concepto.Bonificacion__c>0){
                    i++;
                    res.add(new FeeDTO(i,'DT01','CT01',0,double.valueOf(concepto.Bonificacion__c!=null ? concepto.Bonificacion__c : 0),1,concepto.FechaInicio__c!=null ? String.valueOf(concepto.FechaInicio__c) : String.valueOf(Date.today()),concepto.VigenciaDescuento__c!=null ? String.valueOf(concepto.VigenciaDescuento__c>Date.newInstance(2020, 12, 31) ?  Date.newInstance(2020, 12, 31) :( concepto.VigenciaDescuento__c<Date.today() ? Date.today().addDays(1) :concepto.VigenciaDescuento__c ) ) : String.valueOf(Date.newInstance(2020, 12, 31)),frequencyTem,''));
                }
            }
            i++;
            if(concepto.Bonificacion__c!=null&&concepto.Bonificacion__c>0&&concepto.Concepto__r.ClaveReferencia__c!='CO01'){
                String freqEnv='8';
                if(concepto.Concepto__r.ClaveReferencia__c=='CE01'){
                    freqEnv='9';
                }
                res.add(new FeeDTO(i,concepto.Concepto__r.ReferenceKeyDiscount__c,concepto.Concepto__r.ClaveReferencia__c,0,double.valueOf(concepto.Bonificacion__c!=null ? concepto.Bonificacion__c : 0),1,concepto.FechaInicio__c!=null ? String.valueOf(concepto.FechaInicio__c) : String.valueOf(Date.today()),concepto.VigenciaDescuento__c!=null ? String.valueOf(concepto.VigenciaDescuento__c>Date.newInstance(2020, 12, 31) ?  Date.newInstance(2020, 12, 31) :( concepto.VigenciaDescuento__c<Date.today() ? Date.today().addDays(1) :concepto.VigenciaDescuento__c ) ) : String.valueOf(Date.newInstance(2020, 12, 31)),freqEnv,''));
                i++;
            }
        }
        return res;
    }
    public List<AuxiliaryAddressDTO> getAuxiliaryAddress(List<CatalogoDirecciones__c> listaDir,ContratoFilial__c filial,Opportunity opp){
        List<AuxiliaryAddressDTO> res=new List<AuxiliaryAddressDTO>();
        AuxiliaryAddressDTO tem;
        Integer i=1;
        boolean masDir=listaDir!=null ? listaDir.size()>1 ? true : false :false;
        for(CatalogoDirecciones__c dir : listaDir){
            tem=new AuxiliaryAddressDTO();
            tem.sequence=i;
            tem.address_ref=masDir ? getSecuencia(i) : 'ENTR';//Campo no existe en Salesforce
            tem.description=dir.Calle_Tt__c!=null ? getStringBySize(dir.Calle_Tt__c!=null ? dir.Calle_Tt__c.toUpperCase() : '',30) : 'NA';
            tem.street=getStringBySize(dir.Calle_Tt__c,30);
            tem.suburb=dir.Colonia_Tt__c!=null ? getStringBySize(dir.Colonia_Tt__c,30) : '';
            tem.schedule='9:00 a 18:00';            
            tem.zip_code=Integer.valueOf(dir.CodigoPostal_Tt__c!=null ? dir.CodigoPostal_Tt__c : '0');            
            tem.comment=dir.Calle_Tt__c!=null ? getStringBySize(dir.Calle_Tt__c!=null ? dir.Calle_Tt__c.toUpperCase() : '',30) : 'NA';//Campo no existe en Salesforce
            tem.customized_name=getStringBySize(dir.Name,30);
            tem.customized_address=getStringBySize(dir.Name,40);
            tem.external_number=dir.NumeroExterior_Tt__c!=null ? getStringBySize(dir.NumeroExterior_Tt__c,20).toUpperCase() : '';
            tem.internal_number=dir.NumeroInterior_Tt__c!=null ? getStringBySize(dir.NumeroInterior_Tt__c,20).toUpperCase() : '0';
            tem.in_charge_post='ADMINISTRADOR';
            if(filial.isPrime__c){
                tem.phone=opp.Contacto__r.Phone!=null ? Decimal.valueOf(opp.Contacto__r.Phone) : 0;
                tem.in_charge_email=opp.Contacto__r.Email!=null ? opp.Contacto__r.Email.right(40) : '';
                tem.attendant=opp.Contacto__r.Name!=null ? getStringBySize(opp.Contacto__r.Name,30) : '';//Campo no existe en Salesforce
            }else{
                tem.phone=filial.PlatformAdministrator__r.Phone!=null ? Decimal.valueOf(filial.PlatformAdministrator__r.Phone) : 0;
                tem.attendant=filial.PlatformAdministrator__r.Name!=null ? getStringBySize(filial.PlatformAdministrator__r.Name,30) : '';//Campo no existe en Salesforce
                tem.in_charge_email=filial.PlatformAdministrator__r.Email!=null ? filial.PlatformAdministrator__r.Email.right(40) : '';
            }
            res.add(tem);
            i++;
        }
        
        return res;
    }
    public String getSecuencia(Integer seq){
        if(seq<10){
            return '000'+seq;
        }else if(seq>=10&&seq<100){
            return '00'+seq;
        }else{
            return '0'+seq;
        }
    }
    public List<PrintLinesDTO> getPrintLines(){
        List<PrintLinesDTO> res=new List<PrintLinesDTO>();
        PrintLinesDTO priLine=new PrintLinesDTO();
        priLine.sequence=1;
        priLine.card_type_ref=0;
        priLine.kit_ref=1;
        List<EmbossingLineDTO> lisEmb=new List<EmbossingLineDTO>();
        lisEmb.add(new EmbossingLineDTO(9));
        lisEmb.add(new EmbossingLineDTO(9));
        lisEmb.add(new EmbossingLineDTO(9));
        priLine.embossing_lines=lisEmb;
        priLine.plastic_type_ref=1;
        res.add(priLine);
        /*************/
        PrintLinesDTO priLine2=new PrintLinesDTO();
        priLine2.sequence=2;
        priLine2.card_type_ref=4;
        priLine2.kit_ref=3;
        List<EmbossingLineDTO> lisEmb2=new List<EmbossingLineDTO>();
        lisEmb2.add(new EmbossingLineDTO(9));
        lisEmb2.add(new EmbossingLineDTO(9));
        lisEmb2.add(new EmbossingLineDTO(9));
        priLine2.embossing_lines=lisEmb2;
        priLine2.plastic_type_ref=2;
        res.add(priLine2);
        return res;
    }
    
    public class CustomerDTO{   
        public Integer branch_ref {get;set;}//Sucursal
        public Integer product_ref {get;set;}//No. de producto
        public Integer group_ref {get;set;}//grupo
        public Integer customer_ref {get;set;}//cliente
        public String name {get;set;}//nombre de la cuenta limitado a 40
        public String extended_name {get;set;}//nombre de la cuenta limitado a 100
        public Integer sale_origin {get;set;}//Origen del prospecto
        public Integer line_of_business {get;set;}
        public Integer competitor{get;set;}//competidor-Catálogo.
        public String tax_payer_ref {get;set;}//RFC
        public CustomerAddressDTO invoicing_address {get;set;}
        public String status {get;set;}//Siempre es A
        public ContactInfoDTO contact_info {get;set;}
        public ContractDTO contract {get;set;}
        public TransactionControlDTO transaction_control {get;set;}
    }
    public class CustomerAddressDTO{
        public String internal_number {get;set;}//número interior
        public String external_number {get;set;}//número exterior
        public String street {get;set;}//dirección
        public String suburb {get;set;}//colonia
        public Integer zip_code {get;set;}//Código postal
    }   
    public class ContactInfoDTO{
        public String receiving_bill_email {get;set;}//Email que recibe la factura
        public List<ContactDTO> contacts {get;set;}
    }
    public class ContactDTO{
        public Integer type{get;set;}//tipo de contacto-Catálogo
        public String first_name{get;set;}//nombre del contacto
        public String last_name{get;set;}//apellido del contacto
        public String working_position{get;set;}//Siempre ADMINISTRADOR
        public String email{get;set;}//email del contacto
        public Decimal phone{get;set;}//telefono del contacto
        public String extension{get;set;}//mandar 0
        public Integer zip_code{get;set;}//mandar 0
        public ContactDTO(String firstName,String lastName,String emai,String exten,Integer zip){
            this.type=0;
            this.first_name=getStringBySize(firstName,20);
            this.last_name=CreateCustomerRequestWP.getStringBySize(lastName,20);
            this.working_position='ADMINISTRADOR';
            this.email=emai;
            this.extension=exten;
            this.phone=0;
            this.zip_code=zip;
        }
    }
    public class ContractDTO{   
        public String version{get;set;}//Mandar TVWT-001
        public Integer biannual_territory {get;set;}//
        public Integer system_territory {get;set;}//Catálogo-----Territorio Espada
        public Integer post_salesman {get;set;}//Catálogo------Post Vendedor
        public Integer ordering_frequency {get;set;}//Catálogo----Frecuencia de Pedido
        public Integer payment_method {get;set;}//Catálogo SAT, mandar 99
        public Integer minimum_commission{get;set;}//comision minima 1 o 0
        public Integer delivery_address {get;set;}//Direccion de entrega
        public String business_hours {get;set;}// mandar 09:00 A 18:00
        public String invoice_printing_status{get;set;}//Catálogo Pendiente-----VALIDAR CAMPO
        public String pay_per_use{get;set;}//Catálogo Pendiente-----VALIDAR CAMPO
        public double issued_volume {get;set;}//volumen de emisión
        public Integer invoicing_type {get;set;}//Catálogo Pendiente-------Tipo de Facturacion tamaño 1 digito, siempre por consumo detallado
        public double warranty_amount{get;set;}//monto en garantia
        public double operational_amount{get;set;}//Pendiente
        public String is_joined_invoicing {get;set;}//Facturación Cargos,Facturación plasticos, Facturación comisión
        public Integer main_enterprise {get;set;}//empresa principal 1 o 0
        public Integer vip_status{get;set;}//VIP 1 o 0
        public Integer business_segment {get;set;}//Pendiente
        public Integer payment_conditions {get;set;}//Pendiente
        public String custom_name {get;set;}//Nombre_de_Personalizacion__c
        public String custom_address{get;set;}//Direccion
        public String card_together {get;set;}//Facturación Cargos,Facturación plasticos, Facturación comisión
        public String commission_together {get;set;}//Facturación Cargos,Facturación plasticos, Facturación comisión
        public Integer consolidated_invoice{get;set;}
        public Integer web_client_invoicing {get;set;}
        public Integer condolidated_branch {get;set;}
        public Integer consolidated_product {get;set;}
        public Integer consolidated_group {get;set;}
        public Integer consolidated_customer {get;set;}
        public Integer global_branch {get;set;}
        public Integer global_product {get;set;}
        public Integer global_customer {get;set;}
        public String migration {get;set;}
        public String previous_invoicing {get;set;}
        public double risk_exposure {get;set;}
        public Integer invoicing_delay_days {get;set;}
        public String approval_policy {get;set;}
        public Integer prime_company_identifier{get;set;}
        public Integer as_invoice {get;set;}
        public Integer financial_level {get;set;}//mandar P
        public Integer contract_item {get;set;}
        public Integer invoicing_frequency {get;set;}
    }    
    public class TransactionControlDTO{   
        public Integer offline_transaction_status{get;set;}
        public Decimal max_offline_transactions_quantity{get;set;}
        public Decimal max_offline_transactions_amount{get;set;}
        public Integer enabled_purchase_status {get;set;}
        public Decimal transaction_interval{get;set;}
        public ContactDTO contact{get;set;}
        public Integer allow_card_nip {get;set;}
        public Integer allow_disabled_card_nip {get;set;}
        public Integer odometer_snap {get;set;}
        public Integer hourmeter_snap {get;set;}
        public Integer odometer_control {get;set;}
        public Integer hourmeter_control {get;set;}
        public Integer driver_control {get;set;}
        public Integer car_plate_control {get;set;}
        public Integer vehicle_control {get;set;}
        public Integer commodity_control {get;set;}
        public Integer conditional_control_with_nip {get;set;}
        public Integer print_balance_enabled {get;set;}
        public Integer allow_terminal {get;set;}
        public Integer capture_reference {get;set;}
        public Integer reference_control {get;set;}
        public Integer limits {get;set;}
        public Integer print_balance_on_ticket{get;set;}
        public Integer driver_identification_nip_control {get;set;}
        public Integer driver_license_nip_control{get;set;}
        public Integer stock_card {get;set;}
        public Integer owm_pump {get;set;}
        public Integer deny_purchase_on_business_day {get;set;}
        public Integer deny_purchase_on_saturday {get;set;}
        public Integer deny_purchase_on_sunday {get;set;}
    }
    public class ConfigurationDTO{   
        public String filler {get;set;}
        public Integer voucher {get;set;}
        public String invoice_pay_format {get;set;}
        public String bank_account {get;set;}
        public Integer tag_near_field_communication {get;set;}
        public Integer tag_web_truck {get;set;}
        public Integer capture_net_identification {get;set;}
        public String use_external_bank {get;set;}
        public String extenal_bak_clasification {get;set;}
        public Integer at_folio {get;set;}
        public Integer external_bank_financing_kind {get;set;}
        public Integer financing_charges {get;set;}
        public Integer recurrent_payment {get;set;}
        public Integer gps_indicator {get;set;}
        public Integer not_viewable_mileage_on_pos {get;set;}
        public Integer pump_ticket_indicator {get;set;}
        public Integer cardless_consumption_indicator {get;set;}
        public Integer custom_name_ref {get;set;}
        public Integer opportunity_number {get;set;}
        public Integer third_party_ref {get;set;}
        public Integer print_logo {get;set;}
        public ConfigurationDTO(){
            this.third_party_ref=0;
            this.tag_web_truck=0;
            this.tag_near_field_communication=0;
            this.recurrent_payment=0;
            this.pump_ticket_indicator=0;
            this.print_logo=0;
            this.not_viewable_mileage_on_pos=0;
            this.gps_indicator=0;
            this.financing_charges=0;
            this.filler='';
            this.external_bank_financing_kind=0;
            this.extenal_bak_clasification='';
            this.custom_name_ref=0;
            this.cardless_consumption_indicator=0;
            this.capture_net_identification=0;
            this.bank_account='';
            this.at_folio=0;
        }
    }
    public class FeeDTO{
        public Integer sequence{get;set;}
        public String charge_key{get;set;}
        public String charge_apply{get;set;}
        public double amount{get;set;}
        public double apply_percentage{get;set;}
        public Integer quantity{get;set;}
        public String application_start_date{get;set;}
        public String application_end_date{get;set;}
        public String frequency{get;set;}
        public String status{get;set;}
        public String agreed_charge{get;set;}
        public double initial_unique_value{get;set;}
        public double final_unique_value{get;set;}
        public String staggering{get;set;}
        public FeeDTO(Integer seq,String chKe,String chAp,double am,double appPer,Integer quan,String appSt,String appEnd,String freq,String stag){
            this.sequence=seq;
            this.charge_key=chKe;
            this.charge_apply=chAp;
            this.amount=am;
            this.apply_percentage=appPer;
            this.quantity=quan;
            this.application_start_date=appSt;
            this.application_end_date=appEnd;
            this.frequency=freq;
            this.status='A';
            this.agreed_charge='P';
            this.initial_unique_value=0;
            this.final_unique_value=0;
            this.staggering=stag;
        }
    }
    public class AuxiliaryAddressDTO{              
        public String customized_name{get;set;}
        public String internal_number{get;set;}
        public String comment{get;set;}
        public String in_charge_email{get;set;}
        public String suburb{get;set;}
        public String in_charge_post{get;set;}
        public String external_number{get;set;}
        public Integer zip_code{get;set;}
        public Decimal phone{get;set;}
        public Integer extension{get;set;}
        public String attendant{get;set;}
        public String schedule{get;set;}        
        public String customized_address{get;set;}
        public String address_ref{get;set;}
        public String street{get;set;}
        public Integer sequence{get;set;}
        public String description{get;set;}  
        public AuxiliaryAddressDTO(){
            this.extension=0;
            this.phone=0;
        }
    }
    public class PrintLinesDTO{
        public Integer sequence{get;set;}
        public Integer card_type_ref{get;set;}
        public Integer kit_ref{get;set;}
        public List<EmbossingLineDTO> embossing_lines{get;set;}
        public Integer plastic_type_ref{get;set;}
    }
    public class EmbossingLineDTO{
        public Integer embossing_line_ref{get;set;}
        public EmbossingLineDTO(Integer val){
            this.embossing_line_ref=val;
        }
    }   
}