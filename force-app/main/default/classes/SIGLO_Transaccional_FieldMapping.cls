public class SIGLO_Transaccional_FieldMapping {

    public static Map<String, String> createJSON(List<ContratoFilial__c> scope, Boolean encrypted){
        Map<String, String> productsJSON = new Map<String, String>();
        String responseJSON, clientesJSON, productId;
        for(ContratoFilial__c cf : scope){
            productId = cf.Producto__r.IDInterno__c;
            //responseJSON = encrypted ? fillJSON_Encrypted(opp, quote) : fillJSON(opp, quote);
            responseJSON = fillJSON(cf, encrypted);
            if(productsJSON.containsKey(productId+'-transacciones')){
                clientesJSON = productsJSON.get(productId+'-transacciones');
                productsJSON.put(productId+'-transacciones', clientesJSON + ',' + responseJSON);
            }else{
                productsJSON.put(productId+'-transacciones', responseJSON);
            }
            //clientesJSON = clientesJSON != null ? clientesJSON + ',' + responseJSON : responseJSON;
        }
        
        //return clientesJSON;
        return productsJSON;
    }

    public static String fillJSON(ContratoFilial__c cf, Boolean encrypted){
        
        SIGLO_Transaccional_JSON clienteJSON = new SIGLO_Transaccional_JSON();

        clienteJSON.ClientCode = cf.Contrato_2__r.CodigoAS400__c != null ? cf.Contrato_2__r.CodigoAS400__c : 'SIN INFORMACION';

        //clienteJSON.Frequency = cf.Contrato_2__r.PartidaPresupuesto__r.Quote.TransactionsEstimatedNumber__c != null ? cf.Contrato_2__r.PartidaPresupuesto__r.Quote.TransactionsEstimatedNumber__c : 3;

        //clienteJSON.Frequency_String = encrypted ? String.valueOf(clienteJSON.Frequency) : '';

        //clienteJSON.Amount = cf.Contrato_2__r.PartidaPresupuesto__r.Quote.TransactionsEstimatedNumber__c != null ? cf.Contrato_2__r.PartidaPresupuesto__r.Quote.TotalPrice : 1000000;

        //clienteJSON.Amount_String = encrypted ? String.valueOF(clienteJSON.Amount) : '';

        if(encrypted){clienteJSON.encryptJSON();}
        //return JSON.serialize(clienteJSON);
        
        return clienteJSON.generateJSONContent(clienteJSON, encrypted);

    }


}