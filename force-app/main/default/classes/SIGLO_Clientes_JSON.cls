public  class SIGLO_Clientes_JSON {
    
    public Integer EntityID = 1;
    public String EntityID_String = '1'; //clone
    public String OrigenSystemType = 'SALESFORCE';
    public String PersonTypeID = 'SIN INFORMACION';
    public String RelatedPersonType = 'SIN INFORMACION';
    public String PersonName = 'SIN INFORMACION';
    public String PaternalSurname = 'SIN INFORMACION';
    public String MaternalSurname = '';
    public String FiscalPersonType = 'SIN INFORMACION';
    public String TaxID = 'SIN INFORMACION';
    public Date Birthdate = Date.newInstance(1900, 01, 01);
    public String Birthdate_String = String.valueOf(Date.newInstance(1900, 01, 01)); //clone
    public String IsForeignCitizen = 'SIN INFORMACION';
    public String NationalityCountry = 'SIN INFORMACION';
    public String EconomicActivityCode = '9999999';
    public String ProfessionName = 'SIN INFORMACION';
    public String ClientCode = 'SIN INFORMACION';
    public String PEP = 'N';
    public String Street = 'SIN INFORMACION';
    public String OutsiderNumber = 'SIN INFORMACION';
    public String InternalNumber = 'SIN INFORMACION';
    public String Suburb = 'SIN INFORMACION';
    public String City = '';
    public String State = 'SIN CLASIFICAR';
    public String Country = 'SIN INFORMACION';
    public String ZipCode = 'SIN INFORMACION';
    public String Locality = '99999999';
    public String Telephone1 = 'SIN INFORMACION';
    public String ReferenceID = '0';
    public String BirthCountry = 'SIN INFORMACION';
    public String ContractCode = 'SIN INFORMACION';
    public String CURP = 'SIN INFORMACION';
    public String Email = 'SIN INFORMACION';
    public String WebPage = 'SIN INFORMACION';
    public String FEA = '';
    public String MaritalStatusID = '1';
    public String Ocupation = 'SIN INFORMACION';
    public String EmployeeCode = 'SIN INFORMACION';
    public String WritingNumber = 'SIN INFORMACION';
    public Datetime WritingDate = Date.newInstance(1900, 01, 01);
    public String WritingDate_String = String.valueOf(Date.newInstance(1900, 01, 01)); //clone
    public String PositionPEP = '';
    public String IsActingBehalfThirdPerson = '';
    public String RealOwnerName = '';
    public String LocalForexOperationsReason = '';
    public String County = 'SIN INFORMACION';
    public String Telephone2 = '';
    public String Fax = '';
    public String OriginResource = '';
    public String HasAttorney = '';
    public String ImportDate = '';
    public String Reference1 = 'SIN INFORMACION';
    public Datetime CheckSum = Date.today();
    public String CheckSum_String = String.valueOf(Date.today()); //clone
    public String Generic1RiskValueDescriptionString = 'SIN INFORMACION';
    public String Generic2RiskValueDescriptionString = 'SIN INFORMACION';
    public String Generic3RiskValueDescriptionString = '001';
    public String Generic4RiskValueDescriptionString = 'SIN INFORMACION';
    public String Generic5RiskValueDescriptionString = 'SIN INFORMACION';
    public String Generic6RiskValueDescriptionString = 'SIN INFORMACION';
    public String Generic7RiskValueDescriptionString = 'SIN INFORMACION';
    public String Generic8RiskValueDescriptionString = '001';
    public String Generic9RiskValueDescriptionString = '';
    public String Generic10RiskValueDescriptionString = '';
    public String BirthState = 'SIN INFORMACION';
    public Integer IsMale = 0;
    public String IsMale_String = ''; //clone
    public Integer IsOnDemand = 0;
    public String IsOnDemand_String = '0'; //clone
    public String Generic11RiskValueDescriptionString = '';
    public String Generic12RiskValueDescriptionString = '';
    public String Generic13RiskValueDescriptionString = '';
    public String Generic14RiskValueDescriptionString = '';
    public String Generic15RiskValueDescriptionString = '';
    public String Generic16RiskValueDescriptionString = '';
    public String Generic17RiskValueDescriptionString = '';
    public String Generic18RiskValueDescriptionString = '';
    public String Generic19RiskValueDescriptionString = '';
    public String Generic20RiskValueDescriptionString = '';
    public String Generic21RiskValueDescriptionString = '';
    public String Generic22RiskValueDescriptionString = '';
    public String Generic23RiskValueDescriptionString = '';
    public String Generic24RiskValueDescriptionString = '';
    public String Generic25RiskValueDescriptionString = '';
    public String SofomCode = '';
    public String TaxiIDCounty = 'SIN INFORMACION';
    public Integer BeneficiaryPct = 0;
    public String BeneficiaryPct_String = '0'; //clone
    public String RelatedPersonAccount = '';

    Blob cryptoKey = Blob.valueOf([SELECT key__c FROM SIGLO_Crypto_Key__mdt].key__c);

    public String generateJSONContent(SIGLO_Clientes_JSON clienteJSON, Boolean encrypted){
        system.JSONGenerator gen = system.JSON.createGenerator(true);
        
        gen.writeStartObject();
        if(encrypted){
            gen.writeStringField('EntityID',clienteJSON.EntityID_String);
        }else{
            gen.writeNumberField('EntityID', clienteJSON.EntityID);
        }
        gen.writeStringField('OrigenSystemType', clienteJSON.OrigenSystemType);
        gen.writeStringField('PersonTypeID',clienteJSON.PersonTypeID);
        gen.writeStringField('RelatedPersonType',clienteJSON.RelatedPersonType);
        gen.writeStringField('PersonName', clienteJSON.PersonName);
        gen.writeStringField('PaternalSurname', clienteJSON.PaternalSurname);
        gen.writeStringField('MaternalSurname', clienteJSON.MaternalSurname);
        gen.writeStringField('FiscalPersonType', clienteJSON.FiscalPersonType);
        gen.writeStringField('TaxID',clienteJSON.TaxID);
        if(encrypted){
            gen.writeStringField('Birthdate',clienteJSON.Birthdate_String);
        }else{
            gen.writeDateField('Birthdate', clienteJSON.Birthdate);
        }
        gen.writeStringField('IsForeignCitizen',clienteJSON.IsForeignCitizen );
        gen.writeStringField('NationalityCountry', clienteJSON.NationalityCountry);
        gen.writeStringField('EconomicActivityCode', clienteJSON.EconomicActivityCode);
        gen.writeStringField('ProfessionName', clienteJSON.ProfessionName);
        gen.writeStringField('ClientCode', clienteJSON.ClientCode);
        gen.writeStringField('PEP',clienteJSON.PEP );
        gen.writeStringField('Street', clienteJSON.Street);
        gen.writeStringField('OutsiderNumber', clienteJSON.OutsiderNumber);
        gen.writeStringField('InternalNumber',clienteJSON.InternalNumber);
        gen.writeStringField('Suburb',clienteJSON.Suburb);
        gen.writeStringField('City',clienteJSON.City);
        gen.writeStringField('State',clienteJSON.State);
        gen.writeStringField('Country',clienteJSON.Country);
        gen.writeStringField('ZipCode',clienteJSON.ZipCode);
        gen.writeStringField('Locality',clienteJSON.Locality);
        gen.writeStringField('Telephone1',clienteJSON.Telephone1);
        gen.writeStringField('ReferenceID',clienteJSON.ReferenceID);
        gen.writeStringField('BirthCountry',clienteJSON.BirthCountry);
        gen.writeStringField('ContractCode',clienteJSON.ContractCode);
        gen.writeStringField('CURP',clienteJSON.CURP);
        gen.writeStringField('Email',clienteJSON.Email);
        gen.writeStringField('WebPage',clienteJSON.WebPage);
        gen.writeStringField('FEA',clienteJSON.FEA);
        gen.writeStringField('MaritalStatusID',clienteJSON.MaritalStatusID);
        gen.writeStringField('Ocupation',clienteJSON.Ocupation);
        gen.writeStringField('EmployeeCode',clienteJSON.EmployeeCode);
        gen.writeStringField('WritingNumber',clienteJSON.WritingNumber);
        if(encrypted){
            gen.writeStringField('WritingDate',clienteJSON.WritingDate_String);
        }else{
            gen.writeDateTimeField('WritingDate', clienteJSON.WritingDate);
        }
        gen.writeStringField('PositionPEP',clienteJSON.PositionPEP);
        gen.writeStringField('IsActingBehalfThirdPerson',clienteJSON.IsActingBehalfThirdPerson);
        gen.writeStringField('RealOwnerName',clienteJSON.RealOwnerName);
        gen.writeStringField('LocalForexOperationsReason',clienteJSON.LocalForexOperationsReason);
        gen.writeStringField('County',clienteJSON.County);
        gen.writeStringField('Telephone2',clienteJSON.Telephone2);
        gen.writeStringField('Fax',clienteJSON.Fax);
        gen.writeStringField('OriginResource',clienteJSON.OriginResource);
        gen.writeStringField('HasAttorney',clienteJSON.HasAttorney);
        gen.writeStringField('ImportDate',clienteJSON.ImportDate);
        gen.writeStringField('Reference1',clienteJSON.Reference1);
        if(encrypted){
            gen.writeStringField('CheckSum',clienteJSON.CheckSum_String);
        }else{
            gen.writeDateTimeField('CheckSum', clienteJSON.CheckSum);
        }
        gen.writeStringField('Generic1RiskValueDescriptionString',clienteJSON.Generic1RiskValueDescriptionString);
        gen.writeStringField('Generic2RiskValueDescriptionString',clienteJSON.Generic2RiskValueDescriptionString);
        gen.writeStringField('Generic3RiskValueDescriptionString',clienteJSON.Generic3RiskValueDescriptionString);
        gen.writeStringField('Generic4RiskValueDescriptionString',clienteJSON.Generic4RiskValueDescriptionString);
        gen.writeStringField('Generic5RiskValueDescriptionString',clienteJSON.Generic5RiskValueDescriptionString);
        gen.writeStringField('Generic6RiskValueDescriptionString',clienteJSON.Generic6RiskValueDescriptionString);
        gen.writeStringField('Generic7RiskValueDescriptionString',clienteJSON.Generic7RiskValueDescriptionString);
        gen.writeStringField('Generic8RiskValueDescriptionString',clienteJSON.Generic8RiskValueDescriptionString);
        gen.writeStringField('Generic9RiskValueDescriptionString',clienteJSON.Generic9RiskValueDescriptionString);
        gen.writeStringField('Generic10RiskValueDescriptionString',clienteJSON.Generic10RiskValueDescriptionString);
        gen.writeStringField('BirthState', clienteJSON.BirthState);
        if(encrypted){
            gen.writeStringField('IsMale',clienteJSON.IsMale_String);
            gen.writeStringField('IsOnDemand',clienteJSON.IsOnDemand_String);
        }else{
            gen.writeNumberField('IsMale', clienteJSON.IsMale);
            gen.writeNumberField('IsOnDemand', clienteJSON.IsOnDemand);
        }
        gen.writeStringField('Generic11RiskValueDescriptionString',clienteJSON.Generic11RiskValueDescriptionString);
        gen.writeStringField('Generic12RiskValueDescriptionString',clienteJSON.Generic12RiskValueDescriptionString);
        gen.writeStringField('Generic13RiskValueDescriptionString',clienteJSON.Generic13RiskValueDescriptionString);
        gen.writeStringField('Generic14RiskValueDescriptionString',clienteJSON.Generic14RiskValueDescriptionString);
        gen.writeStringField('Generic15RiskValueDescriptionString',clienteJSON.Generic15RiskValueDescriptionString);
        gen.writeStringField('Generic16RiskValueDescriptionString',clienteJSON.Generic16RiskValueDescriptionString);
        gen.writeStringField('Generic17RiskValueDescriptionString',clienteJSON.Generic17RiskValueDescriptionString);
        gen.writeStringField('Generic18RiskValueDescriptionString',clienteJSON.Generic18RiskValueDescriptionString);
        gen.writeStringField('Generic19RiskValueDescriptionString',clienteJSON.Generic19RiskValueDescriptionString);
        gen.writeStringField('Generic20RiskValueDescriptionString',clienteJSON.Generic20RiskValueDescriptionString);
        gen.writeStringField('Generic21RiskValueDescriptionString',clienteJSON.Generic21RiskValueDescriptionString);
        gen.writeStringField('Generic22RiskValueDescriptionString',clienteJSON.Generic22RiskValueDescriptionString);
        gen.writeStringField('Generic23RiskValueDescriptionString',clienteJSON.Generic23RiskValueDescriptionString);
        gen.writeStringField('Generic24RiskValueDescriptionString',clienteJSON.Generic24RiskValueDescriptionString);
        gen.writeStringField('Generic25RiskValueDescriptionString',clienteJSON.Generic25RiskValueDescriptionString);
        gen.writeStringField('SofomCode',clienteJSON.SofomCode);
        gen.writeStringField('TaxiIDCounty',clienteJSON.TaxiIDCounty);
        if(encrypted){
            gen.writeStringField('BeneficiaryPct',clienteJSON.BeneficiaryPct_String);
        }else{
            gen.writeNumberField('BeneficiaryPct',clienteJSON.BeneficiaryPct);
        }
        gen.writeStringField('RelatedPersonAccount',clienteJSON.RelatedPersonAccount);

        gen.writeEndObject(); 
        
        return gen.getAsString();
    }

    public void encryptJSON(){
        this.EntityID_String = encryptData(this.EntityID_String);
        this.OrigenSystemType = encryptData(this.OrigenSystemType);
        this.PersonTypeID = encryptData(this.PersonTypeID);
        this.RelatedPersonType = encryptData(this.RelatedPersonType);
        this.PersonName = encryptData(this.PersonName);
        this.PaternalSurname = encryptData(this.PaternalSurname);
        this.MaternalSurname = encryptData(this.MaternalSurname);
        this.FiscalPersonType = encryptData(this.FiscalPersonType);
        this.TaxID = encryptData(this.TaxID);
        this.Birthdate_String = encryptData(this.Birthdate_String);
        this.IsForeignCitizen = encryptData(this.IsForeignCitizen);
        this.NationalityCountry = encryptData(this.NationalityCountry);
        this.EconomicActivityCode = encryptData(this.EconomicActivityCode);
        this.ProfessionName = encryptData(this.ProfessionName);
        this.ClientCode = encryptData(this.ClientCode);
        this.PEP = encryptData(this.PEP);
        this.Street = encryptData(this.Street);
        this.OutsiderNumber = encryptData(this.OutsiderNumber);
        this.InternalNumber = encryptData(this.InternalNumber);
        this.Suburb = encryptData(this.Suburb);
        this.City = encryptData(this.City);
        this.State = encryptData(this.State);
        this.Country = encryptData(this.Country);
        this.ZipCode = encryptData(this.ZipCode);
        this.Locality = encryptData(this.Locality);
        this.Telephone1 = encryptData(this.Telephone1);
        this.ReferenceID = encryptData(this.ReferenceID);
        this.BirthCountry = encryptData(this.BirthCountry);
        this.ContractCode = encryptData(this.ContractCode);
        this.CURP = encryptData(this.CURP);
        this.Email = encryptData(this.Email);
        this.WebPage = encryptData(this.WebPage);
        this.FEA = encryptData(this.FEA);
        this.MaritalStatusID = encryptData(this.MaritalStatusID);
        this.Ocupation = encryptData(this.Ocupation);
        this.EmployeeCode = encryptData(this.EmployeeCode);
        this.WritingNumber = encryptData(this.WritingNumber);
        this.WritingDate_String = encryptData(this.WritingDate_String);
        this.PositionPEP = encryptData(this.PositionPEP);
        this.IsActingBehalfThirdPerson = encryptData(this.IsActingBehalfThirdPerson);
        this.RealOwnerName = encryptData(this.RealOwnerName);
        this.LocalForexOperationsReason = encryptData(this.LocalForexOperationsReason);
        this.County = encryptData(this.County);
        this.Telephone2 = encryptData(this.Telephone2);
        this.Fax = encryptData(this.Fax);
        this.OriginResource = encryptData(this.OriginResource);
        this.HasAttorney = encryptData(this.HasAttorney);
        this.ImportDate = encryptData(this.ImportDate);
        this.Reference1 = encryptData(this.Reference1);
        this.CheckSum_String = encryptData(this.CheckSum_String);
        this.Generic1RiskValueDescriptionString = encryptData(this.Generic1RiskValueDescriptionString);
        this.Generic2RiskValueDescriptionString = encryptData(this.Generic2RiskValueDescriptionString);
        this.Generic3RiskValueDescriptionString = encryptData(this.Generic3RiskValueDescriptionString);
        this.Generic4RiskValueDescriptionString = encryptData(this.Generic4RiskValueDescriptionString);
        this.Generic5RiskValueDescriptionString = encryptData(this.Generic5RiskValueDescriptionString);
        this.Generic6RiskValueDescriptionString = encryptData(this.Generic6RiskValueDescriptionString);
        this.Generic7RiskValueDescriptionString = encryptData(this.Generic7RiskValueDescriptionString);
        this.Generic8RiskValueDescriptionString = encryptData(this.Generic8RiskValueDescriptionString);
        this.Generic9RiskValueDescriptionString = encryptData(this.Generic9RiskValueDescriptionString);
        this.Generic10RiskValueDescriptionString = encryptData(this.Generic10RiskValueDescriptionString);
        this.BirthState = encryptData(this.BirthState);
        this.IsMale_String = encryptData(this.IsMale_String);
        this.IsOnDemand_String = encryptData(this.IsOnDemand_String);
        this.Generic11RiskValueDescriptionString = encryptData(this.Generic11RiskValueDescriptionString);
        this.Generic12RiskValueDescriptionString = encryptData(this.Generic12RiskValueDescriptionString);
        this.Generic13RiskValueDescriptionString = encryptData(this.Generic13RiskValueDescriptionString);
        this.Generic14RiskValueDescriptionString = encryptData(this.Generic14RiskValueDescriptionString);
        this.Generic15RiskValueDescriptionString = encryptData(this.Generic15RiskValueDescriptionString);
        this.Generic16RiskValueDescriptionString = encryptData(this.Generic16RiskValueDescriptionString);
        this.Generic17RiskValueDescriptionString = encryptData(this.Generic17RiskValueDescriptionString);
        this.Generic18RiskValueDescriptionString = encryptData(this.Generic18RiskValueDescriptionString);
        this.Generic19RiskValueDescriptionString = encryptData(this.Generic19RiskValueDescriptionString);
        this.Generic20RiskValueDescriptionString = encryptData(this.Generic20RiskValueDescriptionString);
        this.Generic21RiskValueDescriptionString = encryptData(this.Generic21RiskValueDescriptionString);
        this.Generic22RiskValueDescriptionString = encryptData(this.Generic22RiskValueDescriptionString);
        this.Generic23RiskValueDescriptionString = encryptData(this.Generic23RiskValueDescriptionString);
        this.Generic24RiskValueDescriptionString = encryptData(this.Generic24RiskValueDescriptionString);
        this.Generic25RiskValueDescriptionString = encryptData(this.Generic25RiskValueDescriptionString);
        this.SofomCode = encryptData(this.SofomCode);
        this.TaxiIDCounty = encryptData(this.TaxiIDCounty);
        this.BeneficiaryPct_String = encryptData(this.BeneficiaryPct_String);
        this.RelatedPersonAccount = encryptData(this.RelatedPersonAccount);
    }

    public String encryptData(String uncryptedData){
        Blob data = Blob.valueOf(uncryptedData); 
        Blob encryptedData = Crypto.encryptWithManagedIV('AES128', cryptoKey, data ); 
        return EncodingUtil.base64Encode(encryptedData); 
    }
    
}