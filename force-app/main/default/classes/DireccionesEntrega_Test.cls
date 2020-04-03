@isTest
public class DireccionesEntrega_Test {
    
    @isTest
    static void testController(){        
        List<sObject> objs = new List<sObject>();
        
        //PRICEBOOK
        Pricebook2 pr = new Pricebook2(Name='Edenred', isActive=true);        
        Id pricebookId = Test.getStandardPricebookId();
        objs.add(pr);
        
        //PRODUCT
        Product2 p = new Product2(Family = 'Combustible', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ticket Car 3.0', ProductCode = '30', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta',IsActive = true);
        objs.add(p);
        Product2 p2 = new Product2(Family = 'Combustible', Formato__c = 'Chip + Pin', MonederoElectronico__c = true, Name = 'Ecovale Combustible Edenred Diesel', ProductCode = '60-D', Red__c = 'Cerrada', SegmentoVenta__c = 'Key;Large;Medium;Small', TipoSolucion__c = 'Básico', Uso__c = 'Herramienta',IsActive = true);
        objs.add(p2);
        
        //Account
        Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
        objs.add(acc);
        
        insert objs;
        objs.clear();
        
        //PRICEBOOK
        Id pricebookId2 = pr.Id;
        
        //OPPORTUNITY
        Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Prueba TESTWO', Pricebook2Id = pricebookId2,StageName = 'Prospecting', CloseDate = System.today().addDays(5),Solicitar_validaci_n_descuentos__c = false);
        objs.add(opp);
        
        //PRICEBOOKENTRY
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = p.Id, UnitPrice = 10000, IsActive = true);
        objs.add(pbe);
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id = pricebookId2, Product2Id = p.Id, UnitPrice = 10000, IsActive = true);
        objs.add(pbe2);
        
        //ENTIDADES LEGALES
        EntidadLegal__c eL = new EntidadLegal__c(Cuenta__c=acc.Id,
            ActaConstitutivaCliente__c = true,
            AltaSHCP__c = true,
            CURP__c = true,
            ComprobanteDomicilioCliente__c = true,
            Direccion_Cuenta__c = true,
            FM3__c = true,
            IdentificacionOficialCliente__c = true,
            PoderNotarial__c = true,
            RFCDoc__c = true,
            RegistroPatronal__c = true,
            Nombre__c = 'EL1',
            RazonSocial__c = 'SA DE CV',Name = 'CUPU800825569'
        );
        objs.add(eL);
        
        EntidadLegal__c eL2 = new EntidadLegal__c(Cuenta__c=acc.Id,
            ActaConstitutivaCliente__c = true,
            AltaSHCP__c = true,
            CURP__c = true,
            ComprobanteDomicilioCliente__c = true,
            Direccion_Cuenta__c = true,
            FM3__c = true,
            IdentificacionOficialCliente__c = true,
            PoderNotarial__c = true,
            RFCDoc__c = true,
            RegistroPatronal__c = true,
            Nombre__c = 'EL2',
            RazonSocial__c = 'SA DE CV',
            Name = 'CUPO800825569'
        );
        objs.add(eL2);
        insert objs;
        objs.clear();
        
        //QUOTE
        Quote quot = new Quote(Name = 'Cotización prueba', OpportunityId = opp.Id, Pricebook2Id = pricebookId2);
        objs.add(quot);
        
        //OPPORTUNITYLINEITEM
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 200, TotalPrice = 2000, PricebookEntryId = pbe2.Id, ServiceDate = System.today().addDays(5));
        objs.add(oli);
        
        insert objs;
        objs.clear();
        
        //QUOTELINEITEM
        QuoteLineItem qli = new QuoteLineItem(Quantity = 1, UnitPrice = 12, QuoteId = quot.Id, PricebookEntryId = pbe2.Id, Product2Id = p.Id, CantidadTarjetas__c = 10,Etapa__c = 'Cotización', ServiceDate = System.today().addDays(5));       
        insert qli;
        //objs.add(qli);
        //CONTRATO
        Contrato2__c contrato = new Contrato2__c(
            Cuenta__c = acc.Id,
            Entidad_Legal__c = eL.Id,
            CodigoAs400__c = '11-11-11111-111',
            PartidaPresupuesto__c = qli.Id,
            Personalizacion_de_Tarjetas__c = false,
            EtapaContrato__c = 'Autorizado',
            CamposValidados__c = true
        );
        objs.add(contrato);
        
        insert objs;
        objs.clear();
        
        CatalogoDirecciones__c dirEntrega = new CatalogoDirecciones__c();
        dirEntrega.Calle_Tt__c = 'Encinos';
        dirEntrega.NumeroExterior_Tt__c = '30';
        dirEntrega.Colonia_Tt__c = 'Campo Militar 1';
        dirEntrega.CodigoPostal_Tt__c = '11619';
        dirEntrega.DelegacionMunicipio_Tt__c = 'Miguel Hidalgo';
        dirEntrega.Ciudad_Tt__c = 'Ciudad de México';
        dirEntrega.Estado_Tt__c = 'Distrito Federal';
        dirEntrega.Tipo_Pt__c = 'Cuenta';
        dirEntrega.CuentaID__c = acc.Id;
        
        insert dirEntrega;
        
        CatalogoDirecciones__c dirEntrega2 = new CatalogoDirecciones__c();
        dirEntrega2.Calle_Tt__c = 'Roble';
        dirEntrega2.NumeroExterior_Tt__c = '13';
        dirEntrega2.Colonia_Tt__c = 'Bosques del Pedregal';
        dirEntrega2.CodigoPostal_Tt__c = '14738';
        dirEntrega2.DelegacionMunicipio_Tt__c = 'Tlalpan';
        dirEntrega2.Ciudad_Tt__c = 'Ciudad de México';
        dirEntrega2.Estado_Tt__c = 'Distrito Federal';
        dirEntrega2.Tipo_Pt__c = 'Cuenta';
        dirEntrega2.CuentaID__c = acc.Id;
        
        insert dirEntrega2;
        
        List<CatalogoDirecciones__c> dirSelected = new List<CatalogoDirecciones__c>();
        dirSelected.add(dirEntrega);
        dirSelected.add(dirEntrega2);
        
        String direccion = '[{"Calle_Tt__c":"Encinos","NumeroExterior_Tt__c":"30","Colonia_Tt__c":"Campo Militar 1","CodigoPostal_Tt__c":"11619","DelegacionMunicipio_Tt__c":"Miguel Hidalgo","Ciudad_Tt__c":"Ciudad de México","Estado_Tt__c":"Distrito Federal","Tipo_Pt__c":"Razón Social","Id":"'+dirEntrega.Id+'"}]';
        
        DireccionesEntrega_CR.getOportunidadContrato(contrato.Id);
        DireccionesEntrega_CR.getCatalogoDirecciones(opp.Id);
        DireccionesEntrega_CR.pruebaApex(direccion, JSON.serialize(contrato), contrato.Id);
        DireccionesEntrega_CR.saveDirAux('true', JSON.serialize(contrato));
        DireccionesEntrega_CR.getDireccionesTabla(contrato.Id);
        DireccionesEntrega_CR.pruebaApex(JSON.serialize(dirSelected), JSON.serialize(contrato), contrato.Id);
    }
    
    
    
    
    
}