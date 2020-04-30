public class PLAN_AltaAfiliados_Ctrl {
    public Establishment__c[] establishments{get;set;}
    public String fecha{get;set;}
    public String isPaper{get;set;}
    public String isCard{get;set;}
    public String BankingTerminal{get;set;}
    public String AggregatorTerminal{get;set;}
    public String ConventionalTerminal{get;set;}
    public String eCommerce{get;set;}
    public String NombreProducto{get;set;}
    public String Despensa{get;set;}
    
 
    
    
    public PLAN_AltaAfiliados_Ctrl(){
        fecha=String.valueOf(Date.today());
        
        String currentId = ApexPages.currentPage().getParameters().get('contractId');
        System.debug('currentId:'+currentId);
        establishments = [Select Id,Name,Bank__r.Bank__c,Bank__r.CLABE__c,Bank__r.StandardiziedBankKey__c,Bank__r.Reference__c,Bank__r.PaymentType__c,Contract__r.Bank_Account__r.CLABE__c,Contract__r.Bank_Account__r.Reference__c,IdCRE__c,Id_Estacion__c,Contract__r.Entidad_Legal__r.RazonSocial__c,Contract__r.Entidad_Legal__r.Name,Contract__r.Entidad_Legal__r.Calle__c
                          , Contract__r.Entidad_Legal__r.NumeroExterior__c,Contract__r.Entidad_Legal__r.NumeroInterior__c,Contract__r.Entidad_Legal__r.RecordType.Name,
                          Contract__r.Entidad_Legal__r.Colonia__c, Contract__r.Entidad_Legal__r.CodigoPostal__c,Contract__r.Entidad_Legal__r.DelegacionMunicipioFiscal__c
                          ,Contract__r.Entidad_Legal__r.Estado__c,Contract__r.Contacto__r.Name,Contract__r.stationId__c,Contract__r.Contacto__r.Funcion__c,
                          Contract__r.Contacto__r.Phone,Contract__r.Entidad_Legal__r.RecordType.DeveloperName,Contract__r.Contacto__r.MobilePhone,Contract__r.webAccessEmail__c,Contract__r.billingEmail__c
                          ,Account__r.Name, Street__c,ExternalNumber__c,InternalNumber__c,Settlement__c,PostalCode__c,Email__c,Web__c,
                          E_Commerce__c,City__c , State__c,Contract__r.CorreoRecibeFactura__c,Contract__r.Contacto__r.Email,StartTimeBusiness__c,
                          EndTimeBusiness__c,FuelBrand__c,FuelType__c,Observations__c,Contract__r.WayPay__c ,
                          Contract__r.Bank_Account__r.Bank__c,Contract__r.Bank_Account__r.Branch__c,Contract__r.Bank_Account__r.PaymentType__c,Contract__r.Bank_Account__r.StandardiziedBankKey__c,
                          Gas_Station_Quantity__c,PetrolPumpQuantity__c,location__Latitude__s,location__Longitude__s,VolumetricControl__c ,
                          Contract__r.Branch__c,Contract__r.Chain__c,Contract__r.Affiliate__c,Contract__r.IntraseBranch__c,
                          Contract__r.PartidaPresupuesto__r.Quote.Opportunity.Owner.Name,Contract__r.PartidaPresupuesto__r.Quote.Opportunity.Owner.NumeroTerritorio__c,
                          Contract__r.Sucursal_Facturacion_Global__c,Contract__r.Request__c,Contract__r.Cuenta__r.Giro__c, Contract__r.IsPaper__c,Contract__r.IsCard__c
                          ,Contract__r.ConventionalTerminal__c,Contract__r.AggregatorTerminal__c ,Contract__r.PartidaPresupuesto__r.Product2.ProductCode,Contract__r.BankingTerminal__c,Contract__r.affiliateProduct__c,Contract__r.electronicAffiliatesProduct__c FROM Establishment__c where Contract__c = :currentId]; 
        
        if(!establishments.isEmpty()){
            isPaper=new list<string> {'des-AF'}.contains(establishments[0].Contract__r.PartidaPresupuesto__r.Product2.ProductCode) && establishments[0].Contract__r.IsPaper__c? '/img/checkbox_checked.gif':'/img/checkbox_unchecked.gif';
           // isPaper=new list<string> {'multip-AF','viat-AF','ince-AF','ayudaS-AF','vest-AF','com-AF'}.contains(establishments[0].Contract__r.PartidaPresupuesto__r.Product2.ProductCode) && establishments[0].Contract__r.IsPaper__c? '':'';
            isCard=new list<string> {'des-AF'}.contains(establishments[0].Contract__r.PartidaPresupuesto__r.Product2.ProductCode) && establishments[0].Contract__r.isCard__c ? '/img/checkbox_checked.gif':'/img/checkbox_unchecked.gif';
            ConventionalTerminal=establishments[0].Contract__r.ConventionalTerminal__c ? '/img/checkbox_checked.gif':'/img/checkbox_unchecked.gif';
            BankingTerminal=establishments[0].Contract__r.BankingTerminal__c ? '/img/checkbox_checked.gif':'/img/checkbox_unchecked.gif';
            AggregatorTerminal=establishments[0].Contract__r.AggregatorTerminal__c ? '/img/checkbox_checked.gif':'/img/checkbox_unchecked.gif';
            eCommerce=establishments[0].E_Commerce__c ? '/img/checkbox_checked.gif':'/img/checkbox_unchecked.gif';
            NombreProducto=new list<string> {'multip-AF','viat-AF','ince-AF','ayudaS-AF','vest-AF','com-AF'}.contains(establishments[0].Contract__r.PartidaPresupuesto__r.Product2.ProductCode)?'MULTIPRODUCTO':'DESPENSA';
           // Multicheck=isPaper=new list<string> {'multip-AF','viat-AF','ince-AF','ayudaS-AF','vest-AF','com-AF'}.contains(establishments[0].Contract__r.PartidaPresupuesto__r.Product2.ProductCode) && establishments[0].Contract__r.IsPaper__c? '':'';
            Despensa=new list<string> {'des-AF'}.contains(establishments[0].Contract__r.PartidaPresupuesto__r.Product2.ProductCode)?'Sistema Despensa Papel Tarjeta':'';
        }else{
            Establishment__c establecimiento =new Establishment__c();
            Contrato2__c contrato = new Contrato2__c();
            contrato=[Select Id,Name,Bank_Account__r.CLABE__c,Bank_Account__r.Reference__c,stationId__c,Entidad_Legal__r.RazonSocial__c,Entidad_Legal__r.Name,Entidad_Legal__r.Calle__c
                          ,Entidad_Legal__r.NumeroExterior__c,Entidad_Legal__r.NumeroInterior__c,Entidad_Legal__r.RecordType.Name,
                          Entidad_Legal__r.Colonia__c,Entidad_Legal__r.CodigoPostal__c,Entidad_Legal__r.DelegacionMunicipioFiscal__c
                          ,Entidad_Legal__r.Estado__c,Contacto__r.Name,Contacto__r.Funcion__c,
                          Contacto__r.Phone,Entidad_Legal__r.RecordType.DeveloperName,Contacto__r.MobilePhone,webAccessEmail__c,billingEmail__c
                          ,CorreoRecibeFactura__c,Contacto__r.Email,FuelBrand__c,WayPay__c ,
                          Bank_Account__r.Bank__c,Bank_Account__r.Branch__c,Bank_Account__r.StandardiziedBankKey__c,
                          Branch__c,Chain__c,Affiliate__c,IntraseBranch__c,
                          PartidaPresupuesto__r.Quote.Opportunity.Owner.Name,PartidaPresupuesto__r.Quote.Opportunity.Owner.NumeroTerritorio__c,
                          Sucursal_Facturacion_Global__c,Request__c,Cuenta__r.Giro__c, IsPaper__c,IsCard__c
                          ,ConventionalTerminal__c,AggregatorTerminal__c ,PartidaPresupuesto__r.Product2.ProductCode,BankingTerminal__c,affiliateProduct__c,electronicAffiliatesProduct__c FROM Contrato2__c where id = :currentId];
            if(contrato !=null){               
                establecimiento.Name=contrato.Name;
                establecimiento.Contract__r=contrato;
                establishments.add(establecimiento);
                isPaper=new list<string> {'des-AF'}.contains(establishments[0].Contract__r.PartidaPresupuesto__r.Product2.ProductCode) && contrato.IsPaper__c ? '/img/checkbox_checked.gif':'/img/checkbox_unchecked.gif';
                isCard=new list<string> {'des-AF'}.contains(establishments[0].Contract__r.PartidaPresupuesto__r.Product2.ProductCode) && contrato.isCard__c ? '/img/checkbox_checked.gif':'/img/checkbox_unchecked.gif';
                ConventionalTerminal=contrato.ConventionalTerminal__c ? '/img/checkbox_checked.gif':'/img/checkbox_unchecked.gif';
                BankingTerminal=contrato.BankingTerminal__c ? '/img/checkbox_checked.gif':'/img/checkbox_unchecked.gif';
                AggregatorTerminal=contrato.AggregatorTerminal__c ? '/img/checkbox_checked.gif':'/img/checkbox_unchecked.gif';
                eCommerce='/img/checkbox_unchecked.gif'; 
                NombreProducto=new list<string> {'multip-AF','viat-AF','ince-AF','ayudaS-AF','vest-AF','com-AF'}.contains(contrato.PartidaPresupuesto__r.Product2.ProductCode)?'MULTIPRODUCTO':'DESPENSA';
                Despensa=new list<string> {'des-AF'}.contains(establishments[0].Contract__r.PartidaPresupuesto__r.Product2.ProductCode)?'Sistema Despensa Papel Tarjeta':'';
               
            }
        }
        
    }
    
    
}