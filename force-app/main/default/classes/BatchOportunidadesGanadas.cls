/*
* Busca las oportunidades en etapa de 'Pedido' obtiene la cuenta asociada y a continuación busca si hay más oportunidades ligadas a esa cuenta con igual estatus y producto, si es así se 
* envía un mail al dueño de la oportunidad haciéndole saber que existe una duplicidad (no se actualiza nada). Si por otro lado, la oportunidad es única en la cuenta (en cuanto a producto y estatus), se busca
* si su cuenta guarda relación con el objeto DocumentosCobranza__c, donde el documento de cobranza debe tener el mismo producto que el de la oportunidad que está siendo analizada. 
* Si existe una o más relaciones de este tipo, se obtienen los campos del documento más viejo (tomando como criterio el campo FechaDoc); entonces se actualiza la etapa de la oportunidad a 'Ganada' y se colocan los campos del 
* objeto DocumentosCobranza__c en la oportunidad. De modo que al actualizar la etapa, se insertan en la oportunidad: Núm. Pedido, Núm. Doc. Cobranza, Tipo Doc, Descripción Doc,
* Monto Pedido, Monto Pagado, Fecha Doc. Pagado y Estatus Doc.
*/


global class BatchOportunidadesGanadas implements Database.Batchable<sObject>{
    
    List<List<Opportunity>> oportunidadesDuplicadas;
    List<Opportunity> oportunidadesGuardar;
    
    
    global BatchOportunidadesGanadas(){
        oportunidadesDuplicadas = new  List<List<Opportunity>>();
        oportunidadesGuardar = new List<Opportunity>();
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        String query = 'SELECT Id, StageName, Name, AccountId, Producto__c, Producto__r.NumeroProducto__c,';
        query += ' NumPedido__c, IdentificacionDoc__c, TipoDocu__c, DoctoPedidoPagado__c, MontoDoc__c,';
        query += ' MontoPagadoDoc__c, FechaDoctoPagado__c, EstatusDoctoPagado__c, NumeroOportunidad__c ';
        query += ' ,Account.Name, OwnerId, Owner.Name, Owner.Email, Owner.Manager.Id, Owner.Manager.Email, Owner.Manager.Name ';
        query += ' FROM Opportunity ';
        query += ' WHERE StageName=\'Pedido\' ';
        query += ' AND Producto__c!=NULL ';
        query += ' AND (NumPedido__c=NULL ';
        query += ' AND IdentificacionDoc__c=NULL '; 
        //query += ' AND TipoDocu__c=NULL '; // Pase por aqui :3
        query += ' AND DoctoPedidoPagado__c=NULL ';
        query += ' AND MontoDoc__c=NULL ';
        query += ' AND MontoPagadoDoc__c=NULL ';
        query += ' AND FechaDoctoPagado__c=NULL ';
        query += ' AND EstatusDoctoPagado__c=NULL) ';
        //query += ' AND Owner.Name=\'Desarrollo CTConsulting\' ';
        
        Database.QueryLocator resultados=  Database.getQueryLocator(query);
        system.debug('LOS RESULTADOS DE LAS OPORTUNIDADES SON: ');
        system.debug(resultados);
        return resultados;
    }
    
    
    global void execute(Database.BatchableContext BC, List<sObject> oportunidades){
        
        //List<Messaging.SingleEmailMessage> correosTotales= new List<Messaging.SingleEmailMessage>();
		
        for(sObject objecto : oportunidades){
            
            Opportunity opp = (Opportunity)objecto;
            List<Opportunity> oportunidadesCta = new List<Opportunity>();
            
            try{
                oportunidadesCta = [SELECT Id, Name, Producto__c, Producto__r.Name, AccountId, Account.Name, OwnerId, Owner.Name, Owner.Email, NumeroOportunidad__c, Owner.Manager.Id, Owner.Manager.Email, Owner.Manager.Name
                                    FROM Opportunity 
                                    WHERE AccountId =: opp.AccountId 
                                    AND StageName='Pedido' 
                                    AND Producto__c=: opp.Producto__c];
            }catch(Exception e){}
            
            if(oportunidadesCta.size()>1){
                /* DHD: 25 de abril, se elimina el envío de maills a solicitud de cte
                String listadoOportunidades = '<ul>';
                for(Opportunity oppDup: oportunidadesCta){
                    listadoOportunidades+= '<li> Número de oportunidad: '+ oppDup.NumeroOportunidad__c + ', Nombre: '+ oppDup.Name +' </li>' ;
                }
                listadoOportunidades += '</ul>';
                
                String[] dirCorreo = new String[] {'alejandra.mendieta@edenred.com','mesquivel@ctconsulting.com.mx'};
                    if(opp.Owner.Email!=null && opp.Owner.Manager.Email!=null){
                        dirCorreo = new String[] {opp.Owner.Email, opp.Owner.Manager.Email,'alejandra.mendieta@edenred.com','mesquivel@ctconsulting.com.mx'};
                            }else{
                                if(opp.Owner.Email!=null){
                                    dirCorreo = new String[] {opp.Owner.Email,'mesquivel@ctconsulting.com.mx','alejandra.mendieta@edenred.com'};
                                        }
                            }
                String contenido;
                contenido= '<h3>Informativo:</h3>';
                contenido+='<p>Se ha encontrado una duplicidad dentro la cuenta:'+ opp.Account.Name;
                contenido+= '". Las siguientes oportunidades se encuentran en la etapa de Pedido y tienen el mismo producto: </p>';
                contenido+=listadoOportunidades;
                contenido+= '<br> <h3>Este e-mail se ha enviado al Propietario de la oportunidad y al Gestor.</h3>';
                
                
                Messaging.SingleEmailMessage correo = new Messaging.SingleEmailMessage();
                correo.setSubject('Duplicidad de oportunidades encontrada');
                correo.setSenderDisplayName('Soporte Edenred');
                correo.setToAddresses(dirCorreo);
                correo.setHtmlBody (contenido);
                correosTotales.add(correo);
                */
            }else{
                DocumentosCobranza__c doc = new DocumentosCobranza__c();
                try{
                    doc = [SELECT Id, Name, CodigoCliente__c, Cliente__c, DescripcionDoc__c,
                           EstatusDoc__c, 
                           FechaDoc__c, 
                           FechaPagoDoc__c, 
                           Grupo__c, MontoPagado__c,
                           MontoPedido__c, NumCliente__c, NumPedido__c, Producto__c,
                           Sucursal__c, TipoDoc__c 
                           FROM DocumentosCobranza__c 
                           WHERE Cliente__c =: opp.AccountId 
                           AND Producto__c=:opp.Producto__r.NumeroProducto__c 
                           ORDER BY FechaDoc__c ASC
                           LIMIT 1];
                    
                    
                    if(doc!=null){
                        opp.StageName='Ganada';
                        opp.CloseDate= Date.today(); 
                        opp.NumPedido__c  = doc.NumPedido__c;
                        opp.IdentificacionDoc__c  = doc.Name;
                        //opp.TipoDocu__c =doc.TipoDoc__c; // Buajajaja Nada me detiene  #MiMaldad
                        opp.DoctoPedidoPagado__c   = doc.DescripcionDoc__c;
                        opp.MontoDoc__c  = doc.MontoPedido__c;
                        opp.MontoPagadoDoc__c  = doc.MontoPagado__c;
                        opp.FechaDoctoPagado__c  = doc.FechaPagoDoc__c;
                        opp.EstatusDoctoPagado__c  = doc.EstatusDoc__c;
                        oportunidadesGuardar.add(opp);
                    }
                }catch(Exception e){}
            }
        }
        upsert oportunidadesGuardar;
        //Messaging.sendEmail(correosTotales);
    }
    
    global void finish(Database.BatchableContext BC){}
    
}