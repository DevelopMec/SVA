public class SIGLO_Transaccional_JSON_Encrypted {
    
    public String RecordID = '';
    public String EntityID = '1';
    public String ClientCode = 'SIN INFORMACION';
    public String TransactionTypeCode = '01';
    public String ProductName = 'HERRAMIENTA DE TRABAJO';
    public String Frequency = '3';
    public String Amount = '1000000';
    public String ImportDate = '';
    public String CheckSum = '';
    public String IsOnDemand = '0';
    public String IsInitial = '0';
    Blob cryptoKey = Blob.valueOf([SELECT key__c FROM SIGLO_Crypto_Key__mdt].key__c);

    public String generateJSONContent(SIGLO_Transaccional_JSON_Encrypted clienteJSON){
        system.JSONGenerator gen = system.JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeStringField('RecordID', encryptData(clienteJSON.RecordID));
        gen.writeStringField('EntityID', encryptData(clienteJSON.EntityID));
        gen.writeStringField('ClientCode', encryptData(clienteJSON.ClientCode));
        gen.writeStringField('TransactionTypeCode',encryptData(clienteJSON.TransactionTypeCode));
        gen.writeStringField('ProductName',encryptData(clienteJSON.ProductName));
        gen.writeStringField('Frequency', encryptData(clienteJSON.Frequency));
        gen.writeStringField('Amount', encryptData(clienteJSON.Amount));
        gen.writeStringField('ImportDate', encryptData(clienteJSON.ImportDate));
        gen.writeStringField('CheckSum', encryptData(clienteJSON.CheckSum));
        gen.writeStringField('IsOnDemand', encryptData(clienteJSON.IsOnDemand));
        gen.writeStringField('IsInitial', encryptData(clienteJSON.IsInitial));

        gen.writeEndObject(); 
        
        return gen.getAsString();
    }

    public String encryptData(String uncryptedData){
        Blob data = Blob.valueOf(uncryptedData); 
        Blob encryptedData = Crypto.encryptWithManagedIV('AES128', cryptoKey, data ); 
        return EncodingUtil.base64Encode(encryptedData); 
    }
    
}