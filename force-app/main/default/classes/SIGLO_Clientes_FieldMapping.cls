public class SIGLO_Clientes_FieldMapping { 
    
    private static final Map<String, String> personTypeMap = new Map<String, String>{
        'Persona Física - Mexicana' => '001',
        'Persona Física - Extranjera' => '002',

        'Persona Moral - Mexicana' => '003',
        'Persona Moral - Extranjera' => '004'
    };

    public static Map<String, String> createJSON(List<ContratoFilial__c> scope, Boolean repLegal, Boolean encrypted){
        Map<String, String> productsJSON = new Map<String, String>();
        Boolean pMoral, pFisica, extranjero = false;
        String responseJSON, clientesJSON, productId;

        Id pMoralRecordTypeId = Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByName().get('Persona Moral').getRecordTypeId();
        Id pFisicaRecordTypeId = Schema.SObjectType.EntidadLegal__c.getRecordTypeInfosByName().get('Persona Física').getRecordTypeId();

        for(ContratoFilial__c cf : scope){
            if((repLegal && cf.Contrato_2__r.Contacto__c != null) || !repLegal){
                productId = cf.Producto__r.IDInterno__c;
                pMoral = cf.Contrato_2__r.Entidad_Legal__r.RecordTypeId == pMoralRecordTypeId ? True : False;
                pFisica = cf.Contrato_2__r.Entidad_Legal__r.RecordTypeId == pFisicaRecordTypeId ? True : False;
                extranjero = cf.Contrato_2__r.Entidad_Legal__r.CountryOrigin__c == 'MEXICO' ? True : False;
                responseJSON = fillJSON(cf, pMoral, pFisica, extranjero, repLegal, encrypted);
                if(productsJSON.containsKey(productId+'-clientes')){
                    clientesJSON = productsJSON.get(productId+'-clientes');
                    productsJSON.put(productId+'-clientes', clientesJSON + ',' + responseJSON);
                }else{
                    productsJSON.put(productId+'-clientes', responseJSON);
                }
            }
        }
            
        return productsJSON;
        
    }

    public static String fillJSON(ContratoFilial__c cf, Boolean pMoral, Boolean pFisica, Boolean extranjero, Boolean repLegal, Boolean encrypted){

        SIGLO_Clientes_JSON clienteJSON = new SIGLO_Clientes_JSON();

        clienteJSON.PersonTypeID = repLegal ? '7' : '3';
        clienteJSON.RelatedPersonType = repLegal ? '1' : '0';
    
        if((repLegal || pFisica) && cf.Contrato_2__r.Contacto__r.FirstName != null){
            clienteJSON.PersonName = cf.Contrato_2__r.Contacto__r.FirstName;         
        }else if( pMoral && cf.Contrato_2__r.Entidad_Legal__r.RazonSocial__c != null ){
            clienteJSON.PersonName = cf.Contrato_2__r.Entidad_Legal__r.RazonSocial__c;  
        }

        if(repLegal || pFisica){
            clienteJSON.PaternalSurname = cf.Contrato_2__r.Contacto__r.LastName != null ? cf.Contrato_2__r.Contacto__r.LastName : 'SIN INFORMACION';
        }else {
            clienteJSON.PaternalSurname = '';
        }

        clienteJSON.FiscalPersonType = repLegal || pFisica ? 'F' : 'M';

        clienteJSON.TaxID = !repLegal && cf.Contrato_2__r.Entidad_Legal__r.Name != null ? cf.Contrato_2__r.Entidad_Legal__r.Name : 'SIN INFORMACION';


        if((repLegal || pFisica) && cf.Contrato_2__r.Contacto__r.Birthdate != null){
            clienteJSON.Birthdate = cf.Contrato_2__r.Contacto__r.Birthdate;
        }else if(pMoral && cf.Contrato_2__r.Entidad_Legal__r.DeedDate__c != null){
            clienteJSON.Birthdate = cf.Contrato_2__r.Entidad_Legal__r.DeedDate__c;
        }

        clienteJSON.Birthdate_String = encrypted ? String.valueOf(clienteJSON.Birthdate) : ''; //Daily callout data

        clienteJSON.IsForeignCitizen = extranjero ? '1' : '0';

        if((repLegal || pFisica) && cf.Contrato_2__r.Contacto__r.Nationality__c != null){
            clienteJSON.NationalityCountry = cf.Contrato_2__r.Contacto__r.Nationality__c;
        }else if(pMoral && cf.Contrato_2__r.Entidad_Legal__r.CountryOrigin__c != null){
            clienteJSON.NationalityCountry = cf.Contrato_2__r.Entidad_Legal__r.CountryOrigin__c;
        }

        if(!repLegal){
            clienteJSON.EconomicActivityCode = cf.Contrato_2__r.Entidad_Legal__r.EconomicActivity__c == null ? '99999999' : cf.Contrato_2__r.Entidad_Legal__r.EconomicActivity__c; 
        }

        clienteJSON.ProfessionName = !pMoral && cf.Contrato_2__r.Contacto__r.ProfessionName__c != null ? cf.Contrato_2__r.Contacto__r.ProfessionName__c : 'SIN INFORMACION';

        clienteJSON.ClientCode = cf.Contrato_2__r.CodigoAS400__c != null ? cf.Contrato_2__r.CodigoAS400__c : 'SIN INFORMACION';

        if(!repLegal){

            clienteJSON.Street =  cf.Contrato_2__r.Entidad_Legal__r.Calle__c != null ? cf.Contrato_2__r.Entidad_Legal__r.Calle__c : 'SIN INFORMACION';
        
            clienteJSON.OutsiderNumber =  cf.Contrato_2__r.Entidad_Legal__r.NumeroExterior__c != null ? cf.Contrato_2__r.Entidad_Legal__r.NumeroExterior__c : 'SIN INFORMACION';
            
            clienteJSON.InternalNumber =  cf.Contrato_2__r.Entidad_Legal__r.NumeroInterior__c != null ? cf.Contrato_2__r.Entidad_Legal__r.NumeroInterior__c : 'SIN INFORMACION';

            clienteJSON.Suburb =  cf.Contrato_2__r.Entidad_Legal__r.Colonia__c != null ? cf.Contrato_2__r.Entidad_Legal__r.Colonia__c : 'SIN INFORMACION';

            //clienteJSON.State =  cf.Contrato_2__r.Entidad_Legal__r.Estado__c != null ? cf.Contrato_2__r.Entidad_Legal__r.Estado__c : 'SIN INFORMACION';

            clienteJSON.Country =   cf.Contrato_2__r.Entidad_Legal__r.CountryOrigin__c != null ? cf.Contrato_2__r.Entidad_Legal__r.CountryOrigin__c : 'SIN INFORMACION';
            
            clienteJSON.ZipCode =  cf.Contrato_2__r.Entidad_Legal__r.CodigoPostal__c != null ? cf.Contrato_2__r.Entidad_Legal__r.CodigoPostal__c : 'SIN INFORMACION';
            
            //clienteJSON.Locality =  cf.Contrato_2__r.Entidad_Legal__r.DelegacionMunicipioFiscal__c != null ? cf.Contrato_2__r.Entidad_Legal__r.DelegacionMunicipioFiscal__c : 'SIN INFORMACION';
        }else{
            clienteJSON.Street =  cf.Contrato_2__r.Contacto__r.Calle__c != null ? cf.Contrato_2__r.Contacto__r.Calle__c : 'SIN INFORMACION';
        
            clienteJSON.OutsiderNumber =  cf.Contrato_2__r.Contacto__r.NumeroExterior__c != null ? cf.Contrato_2__r.Contacto__r.NumeroExterior__c : 'SIN INFORMACION';
            
            clienteJSON.InternalNumber =  cf.Contrato_2__r.Contacto__r.NumeroInterior__c != null ? cf.Contrato_2__r.Contacto__r.NumeroInterior__c : 'SIN INFORMACION';

            clienteJSON.Suburb =  cf.Contrato_2__r.Contacto__r.Colonia__c != null ? cf.Contrato_2__r.Contacto__r.Colonia__c : 'SIN INFORMACION';

            //clienteJSON.State =  cf.Contrato_2__r.Contacto__r.Estado__c != null ? cf.Contrato_2__r.Contacto__r.Estado__c : 'SIN INFORMACION';

            clienteJSON.Country =   cf.Contrato_2__r.Contacto__r.Nationality__c != null ? cf.Contrato_2__r.Contacto__r.Nationality__c : 'SIN INFORMACION';
            
            clienteJSON.ZipCode =  cf.Contrato_2__r.Contacto__r.CodigoPostal__c != null ? cf.Contrato_2__r.Contacto__r.CodigoPostal__c : 'SIN INFORMACION';
            
            //clienteJSON.Locality =  cf.Contrato_2__r.Contacto__r.DelegacionMunicipio__c != null ? cf.Contrato_2__r.Contacto__r.DelegacionMunicipio__c : 'SIN INFORMACION';
        }
    
        if(repLegal && cf.Contrato_2__r.Contacto__r.Phone != null){
            clienteJSON.Telephone1 = cf.Contrato_2__r.Contacto__r.Phone;
        }else if(cf.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Account.Phone != null){
            clienteJSON.Telephone1 = cf.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Account.Phone;
        }
    
        clienteJSON.BirthCountry = pFisica && cf.Contrato_2__r.Contacto__r.BirthCountry__c != null ? cf.Contrato_2__r.Contacto__r.BirthCountry__c : 'SIN INFORMACION';

        clienteJSON.ContractCode = clienteJSON.ClientCode;

        clienteJSON.CURP = (pFisica || repLegal ) && cf.Contrato_2__r.Contacto__r.Curp__c != null ? cf.Contrato_2__r.Contacto__r.Curp__c : 'SIN INFORMACION';

        clienteJSON.Email =  cf.Contrato_2__r.Contacto__r.Email != null ? cf.Contrato_2__r.Contacto__r.Email : 'SIN INFORMACION';

        clienteJSON.WebPage =  cf.Contrato_2__r.Contacto__r.Account.Website != null ? cf.Contrato_2__r.Contacto__r.Account.Website : 'SIN INFORMACION';

        clienteJSON.FEA = !extranjero && cf.Contrato_2__r.Entidad_Legal__r.FEA__c != null ? cf.Contrato_2__r.Entidad_Legal__r.FEA__c : '';
        
        clienteJSON.Ocupation = (pFisica || repLegal) && cf.Contrato_2__r.Contacto__r.ProfessionName__c != null ? cf.Contrato_2__r.Contacto__r.ProfessionName__c : 'SIN INFORMACION';

        clienteJSON.EmployeeCode = cf.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.OwnerId == null ? 'SIN INFORMACION' : cf.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.OwnerId;

        clienteJSON.WritingNumber = pMoral && cf.Contrato_2__r.Entidad_Legal__r.DeedNumber__c != null ? cf.Contrato_2__r.Entidad_Legal__r.DeedNumber__c : 'SIN INFORMACION';

        clienteJSON.WritingDate = !pFisica && cf.Contrato_2__r.Entidad_Legal__r.DeedDate__c != null ? cf.Contrato_2__r.Entidad_Legal__r.DeedDate__c : Date.newInstance(1900, 01, 01);
        
        clienteJSON.WritingDate_String = encrypted ? String.valueOf(clienteJSON.WritingDate) : ''; //Daily callout data

        if(repLegal && cf.Contrato_2__r.Contacto__r.Nationality__c != null){
            clienteJSON.County = cf.Contrato_2__r.Contacto__r.Nationality__c;
        }else if((pMoral || pFisica) && cf.Contrato_2__r.Entidad_Legal__r.CountryOrigin__c != null){
            clienteJSON.County = cf.Contrato_2__r.Entidad_Legal__r.CountryOrigin__c;
        }

        clienteJSON.Telephone2 =  cf.Contrato_2__r.Contacto__r.Telefono2__c != null ? cf.Contrato_2__r.Contacto__r.Telefono2__c : '';

        clienteJSON.Fax =  cf.Contrato_2__r.Contacto__r.Fax != null ? cf.Contrato_2__r.Contacto__r.Fax : 'SIN INFORMACION';

        if(!pMoral && cf.Contrato_2__r.Contacto__r.ElectorID__c != null){
            clienteJSON.Reference1 = cf.Contrato_2__r.Contacto__r.ElectorID__c;
        }else if(pMoral){
            clienteJSON.Reference1 = '';
        }

        clienteJSON.Generic1RiskValueDescriptionString = cf.Contrato_2__r.PartidaPresupuesto__r.Quote.OperationsInDollars__c == 'Sí' ? 'C001' : 'C002';

        if(cf.Contrato_2__r.Entidad_Legal__r.PersonType__c != null){
            clienteJSON.Generic2RiskValueDescriptionString = personTypeMap.get(cf.Contrato_2__r.Entidad_Legal__r.PersonType__c);
        }

        if((pFisica || repLegal )&& cf.Contrato_2__r.Contacto__r.Gender__c != null){
            clienteJSON.Generic4RiskValueDescriptionString = cf.Contrato_2__r.Contacto__r.Gender__c == 'Masculino' ? '001' : '002';
        }else if(pMoral){
            clienteJSON.Generic4RiskValueDescriptionString = '999';
        }

        if(cf.Contrato_2__r.PartidaPresupuesto__r.Quote.TransactionsEstimatedNumber__c > 2 && cf.Contrato_2__r.PartidaPresupuesto__r.Quote.TransactionsEstimatedNumber__c < 6){
            clienteJSON.Generic5RiskValueDescriptionString = '002';
        }else if(cf.Contrato_2__r.PartidaPresupuesto__r.Quote.TransactionsEstimatedNumber__c < 2){
            clienteJSON.Generic5RiskValueDescriptionString = '001';
        }else if (cf.Contrato_2__r.PartidaPresupuesto__r.Quote.TransactionsEstimatedNumber__c > 5){
            clienteJSON.Generic5RiskValueDescriptionString = '003';
        }
        
        if(clienteJSON.Generic1RiskValueDescriptionString == 'C002'){
            if(cf.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Amount > 1000000 && cf.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Amount <= 2000000){
                clienteJSON.Generic6RiskValueDescriptionString = '002';
            }else if(cf.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Amount <= 1000000){
                clienteJSON.Generic6RiskValueDescriptionString = '001';
            }else if (cf.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Amount > 2000000){
                clienteJSON.Generic6RiskValueDescriptionString = '003';
            }
        }else if(clienteJSON.Generic1RiskValueDescriptionString == 'C001'){
            if(cf.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Amount > 300000 && cf.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Amount <= 400000){
                clienteJSON.Generic6RiskValueDescriptionString = '002';
            }else if(cf.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Amount <= 300000){
                clienteJSON.Generic6RiskValueDescriptionString = '004';
            }else if (cf.Contrato_2__r.PartidaPresupuesto__r.Quote.Opportunity.Amount > 400000){
                clienteJSON.Generic6RiskValueDescriptionString = '003';
            }
        }

        if(pFisica && cf.Contrato_2__r.Contacto__r.Birthdate != null){
            Integer months = cf.Contrato_2__r.Contacto__r.Birthdate.monthsBetween(Date.today());
            Decimal years = Math.floor(months / 12.0);
            if(years < 26){
                clienteJSON.Generic7RiskValueDescriptionString = '001';
            }else if(years > 25 && years < 61){
                clienteJSON.Generic7RiskValueDescriptionString = '002';
            }else if (years > 60){
                clienteJSON.Generic7RiskValueDescriptionString = '002';
            }
        }else if(pMoral && cf.Contrato_2__r.Entidad_Legal__r.DeedDate__c != null){
            Integer months = cf.Contrato_2__r.Entidad_Legal__r.DeedDate__c.monthsBetween(Date.today());
            Decimal years = Math.floor(months / 12.0);
            if(years < 5){
                clienteJSON.Generic7RiskValueDescriptionString = '004';
            }else if(years > 4 && years < 6){
                clienteJSON.Generic7RiskValueDescriptionString = '005';
            }else if (years > 6){
                clienteJSON.Generic7RiskValueDescriptionString = '006';
            }
        }

        if(!pMoral && cf.Contrato_2__r.Contacto__r.MaritalStatus__c != null){
            clienteJSON.Generic8RiskValueDescriptionString = cf.Contrato_2__r.Contacto__r.MaritalStatus__c;
        }else if(pMoral){
            clienteJSON.Generic8RiskValueDescriptionString = '999';
        }

        clienteJSON.BirthState = (pFisica || repLegal) && cf.Contrato_2__r.Contacto__r.BirthState__c != null ? cf.Contrato_2__r.Contacto__r.BirthState__c : 'SIN INFORMACION';

        clienteJSON.IsMale = pFisica && cf.Contrato_2__r.Contacto__r.Gender__c == 'Masculino' ? 1: 0;
        
        clienteJSON.IsMale_String = encrypted ? String.valueOf(clienteJSON.IsMale) : '';

        clienteJSON.TaxiIDCounty = !pMoral && cf.Contrato_2__r.Contacto__r.Nationality__c != null ? cf.Contrato_2__r.Contacto__r.Nationality__c : 'SIN INFORMACION';

        if(encrypted){clienteJSON.encryptJSON();}
        //return JSON.serialize(clienteJSON);
        
        return clienteJSON.generateJSONContent(clienteJSON, encrypted);

    }
        
}