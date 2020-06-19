public  class SIGLO_Transaccional_JSON {
    
    public String RecordID = '';
    public Integer EntityID = 1;
    public String EntityID_String = '1'; //clone
    public String ClientCode = 'SIN INFORMACION';
    public String TransactionTypeCode = '01';
    public String ProductName = 'HERRAMIENTA DE TRABAJO';
    public Decimal Frequency = 5; //Solo en carga inicial
    public String Frequency_String = '5'; //clone
    public Decimal Amount = 500000; //Solo en carga inicial
    public String Amount_String = '500000'; //clone
    public String ImportDate = '';
    public String CheckSum = '';
    public Integer IsOnDemand = 0;
    public String IsOnDemand_String = '0'; //clone
    public Integer IsInitial = 0;
    public String IsInitial_String = '0'; //clone

    Blob cryptoKey = Blob.valueOf([SELECT key__c FROM SIGLO_Crypto_Key__mdt].key__c);

    public String generateJSONContent(SIGLO_Transaccional_JSON clienteJSON, Boolean encrypted){
        system.JSONGenerator gen = system.JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeStringField('RecordID', clienteJSON.RecordID);
        gen.writeNumberField('EntityID', clienteJSON.EntityID);
        gen.writeStringField('ClientCode', clienteJSON.ClientCode);
        gen.writeStringField('TransactionTypeCode',clienteJSON.TransactionTypeCode);
        gen.writeStringField('ProductName',clienteJSON.ProductName);
        gen.writeNumberField('Frequency', clienteJSON.Frequency);
        gen.writeNumberField('Amount', clienteJSON.Amount);
        gen.writeStringField('ImportDate', clienteJSON.ImportDate);
        gen.writeStringField('CheckSum', clienteJSON.CheckSum);
        gen.writeNumberField('IsOnDemand', clienteJSON.IsOnDemand);
        gen.writeNumberField('IsInitial', clienteJSON.IsInitial);

        gen.writeEndObject(); 
        
        return gen.getAsString();
    }

    public void encryptJSON(){
        this.RecordID = encryptData(this.EntityID_String);
        this.EntityID_String = encryptData(this.EntityID_String); //clone
        this.ClientCode = encryptData(this.EntityID_String);
        this.TransactionTypeCode = encryptData(this.EntityID_String);
        this.ProductName = encryptData(this.EntityID_String);
        this.Frequency_String = encryptData(this.EntityID_String);
        this.Amount_String = encryptData(this.EntityID_String);
        this.ImportDate = encryptData(this.EntityID_String);
        this.CheckSum = encryptData(this.EntityID_String);
        this.IsOnDemand_String = encryptData(this.EntityID_String);
        this.IsInitial_String = encryptData(this.EntityID_String);
    }

    public String encryptData(String uncryptedData){
        Blob data = Blob.valueOf(uncryptedData); 
        Blob encryptedData = Crypto.encryptWithManagedIV('AES128', cryptoKey, data ); 
        return EncodingUtil.base64Encode(encryptedData); 
    }
    
}