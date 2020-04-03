public without Sharing class HistorialVeController {
    public List<HistorialVE__c> historial {get;set;}
    public List<List<Object>> historialVE {get;set;}
    public List<String> encabezados{get;set;}
	public Account cuenta{get;set;}
    public HistorialVeController(ApexPages.StandardController controller){
        cuenta=new Account(Id=controller.getId());
        obtenerDatos(controller.getId());
        encabezados();
    }
    public void obtenerDatos(String cuenta){
        try{
            String query = queries('HistorialVE__c');
            query += ' WHERE Cuenta__c = \''+cuenta+'\'';
            historial = database.query(query);
            historialVE = new List<List<Object>>();
            for(HistorialVE__c historia : historial){
                List<Object> history = new List<Object>();
                history.add(''+historia.id);
                history.add(historia.Name);
                history.add(validateValue(historia.NombreCliente__c));
                history.add(validateValue(historia.Giro__c));
                history.add(validateValue(historia.EstatusCliente__c));
                history.add(validateValue(historia.Gestor__c));
                history.add(validateValue(historia.Posvendedor__c));
                history.add(validateValue(historia.Comision__c));
                history.add(validateValue(historia.Frecuencia__c));
                history.add(validateValue(historia.FrecuenciaCalculada__c));
                history.add(validateValue(historia.FechaUltimoPedido__c));
                history.add(formatNumber(historia.PromedioCompra__c,true));
                
                history.add(formatNumber(historia.VEMes06__c,true));
                history.add(validateValue(historia.CIMes06__c));
                
                history.add(formatNumber(historia.VEMes05__c,true));
                history.add(validateValue(historia.CIMes05__c));
                
                history.add(formatNumber(historia.VEMes04__c,true));
                history.add(validateValue(historia.CIMes04__c));
                
                history.add(formatNumber(historia.VEMes03__c,true));
                history.add(validateValue(historia.CIMes03__c));
                
                history.add(formatNumber(historia.VEMes02__c,true));
                history.add(validateValue(historia.CIMes02__c));
                
                history.add(formatNumber(historia.VEMes01__c,true));
                history.add(validateValue(historia.CIMes01__c));
                
                history.add(formatNumber(historia.VEMes00__c,true));
                history.add(validateValue(historia.CIMes00__c));
                historialVE.add(history);
                System.debug(history);
            }
            System.debug(historialVE);
        }catch(Exception e){
            System.debug('Error'+e);
            historial= new List<HistorialVE__c>();
        }
    }
    
    public Object validateValue(Object value){
        System.debug(value);
        if(value == null){
            return ' ';
        }else{
            return value;
        }
        
    }
    
    public String formatNumber(Decimal value, Boolean isCurrency){
        String formattedString = '';
        
        if(value != null){
            String[] dec = String.valueOf(value).split('\\.');
            String numberAsString = dec[0];
            if (isCurrency){
                formattedString = '$';
            }
            
            Integer numberValue = Integer.valueOf(dec[0]);
            if(numberValue>999999999){
                formattedString += numberAsString.substring(0,numberAsString.length()-9)+ ',' + numberAsString.substring(numberAsString.length()-9,numberAsString.length()-6) + ',' + numberAsString.substring(numberAsString.length()-6,numberAsString.length()-3) + ',' + numberAsString.substring(numberAsString.length()-3,numberAsString.length());
            } else if(numberValue>999999){
                formattedString += numberAsString.substring(0,numberAsString.length()-6)+ ',' + numberAsString.substring(numberAsString.length()-6,numberAsString.length()-3) + ',' + numberAsString.substring(numberAsString.length()-3,numberAsString.length());
            } else if(numberValue>999){
                formattedString += numberAsString.substring(0,numberAsString.length()-3)+ ',' + numberAsString.substring(numberAsString.length()-3,numberAsString.length());
            } else {
                formattedString += numberAsString;
            }
            return formattedString+'.'+dec[1];
        }else{
            return '$0.00';
        }
    }
    
    public void encabezados(){
        encabezados = new List<String>();
        encabezados.add('Acciones');
        encabezados.add('Código Cliente AS400');
        encabezados.add('Razón Social');
        encabezados.add('Giro');
        encabezados.add('Estatus');
        encabezados.add('Gestor');
        encabezados.add('Posvendedor');
        encabezados.add('Comisión (%)');
        encabezados.add('Frecuencia contrato');
        encabezados.add('Frecuencia calculada');
        encabezados.add('Ultimo pedido');
        encabezados.add('Promedio VE 6 meses');
        
        date fecha = date.today();
        Integer anio = fecha.year();
        Integer mes = fecha.month();
        Integer dia = fecha.day();
        date anioAtras = date.newInstance(anio-1, mes, dia);
        anioAtras = anioAtras.addMonths(6);
        
        for (Integer i = 0; i<7; i++){
            if(anioAtras.month()==1){
                encabezados.add('VE Ene '+anioAtras.year());
                encabezados.add('CI Ene '+anioAtras.year());
            }
            if(anioAtras.month()==2){
                encabezados.add('VE Feb '+anioAtras.year());
                encabezados.add('CI Feb '+anioAtras.year());
            }
            if(anioAtras.month()==3){
                encabezados.add('VE Mar '+anioAtras.year());
                encabezados.add('CI Mar '+anioAtras.year());
            }
            if(anioAtras.month()==4){
                encabezados.add('VE Abr '+anioAtras.year());
                encabezados.add('CI Abr '+anioAtras.year());
            }
            if(anioAtras.month()==5){
                encabezados.add('VE May '+anioAtras.year());
                encabezados.add('CI May '+anioAtras.year());
            }
            if(anioAtras.month()==6){
                encabezados.add('VE Jun '+anioAtras.year());
                encabezados.add('CI Jun '+anioAtras.year());
            }
            if(anioAtras.month()==7){
                encabezados.add('VE Jul '+anioAtras.year());
                encabezados.add('CI Jul '+anioAtras.year());
            }
            if(anioAtras.month()==8){
                encabezados.add('VE Ago '+anioAtras.year());
                encabezados.add('CI Ago '+anioAtras.year());
            }
            if(anioAtras.month()==9){
                encabezados.add('VE Sep '+anioAtras.year());
                encabezados.add('CI Sep '+anioAtras.year());
            }
            if(anioAtras.month()==10){
                encabezados.add('VE Oct '+anioAtras.year());
                encabezados.add('CI Oct '+anioAtras.year());
            }
            if(anioAtras.month()==11){
                encabezados.add('VE Nov '+anioAtras.year());
                encabezados.add('CI Nov '+anioAtras.year());
            }
            if(anioAtras.month()==12){
                encabezados.add('VE Dic '+anioAtras.year());
                encabezados.add('CI Dic '+anioAtras.year());
            }
            anioAtras = anioAtras.addMonths(1);
        }
    }
    
    public String queries(String obj){
    	
        String objectName = obj;  // modify as needed
        String query = 'SELECT';
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        // Grab the fields from the describe method and append them to the queryString one by one.
        for(String s : objectFields.keySet()) {
           query += ' ' + s + ', ';
        }
        // Strip off the last comma if it exists.
        if (query.subString(query.Length()-2,query.Length()-1) == ','){
            query = query.subString(0,query.Length()-2);
        }
        
        // Add FROM statement
        query += ' FROM ' + objectName;
        
        // Add on a WHERE/ORDER/LIMIT statement as needed
        //query += ' WHERE  = \'test\''; // modify as needed
        return query;
    }
}