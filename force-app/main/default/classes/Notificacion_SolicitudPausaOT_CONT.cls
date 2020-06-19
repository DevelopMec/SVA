public without sharing class Notificacion_SolicitudPausaOT_CONT {
    @AuraEnabled
    public static responseWP getDatos(String recordId){
        responseWP res=new responseWP();
        WorkOrder wo=[Select Pendiente_Pausa__c,estadoAcepRecha__c,estadoRechaza__c,Oportunidad__r.OwnerId,Oportunidad__r.Owner.ManagerId,comentarioPausa__c
                      from WorkOrder where Id=:recordId];
        res.pendientePausa=wo.Pendiente_Pausa__c;
        res.estadoAcepRecha=wo.estadoAcepRecha__c;
        res.comentario = wo.comentarioPausa__c;
        res.estadorechaza=wo.estadoRechaza__c;
        
        system.debug('pendie ' + res.pendientePausa);
        system.debug('estado ' + res.estadoAcepRecha);
        system.debug('estado 2 ' + res.estadorechaza);
        system.debug('dueño ' + res.duenoopp);
        system.debug('gestor ' + res.gestoropp);
        
        res.perfil=[Select Name from Profile where Id=:UserInfo.getProfileId()].Name;
        system.debug('perfil' + res.perfil);
        
        List<valoresWP> listMotivos= new List<valoresWP>();
        Schema.DescribeFieldResult fieldResult = WorkOrder.Motivo_del_estatus__c.getDescribe();
        for(Schema.PicklistEntry pickListVal : fieldResult.getPicklistValues()){
            if(pickListVal.getValue().endsWith('.')){
                valoresWP te = new valoresWP();
                te.label = pickListVal.getLabel();
                te.value = pickListVal.getValue();
                listMotivos.add(te);
            }
        }
        res.listM=listMotivos;
        return res;
    }
    public class responseWP{
        @AuraEnabled public List<valoresWP> listM{get;set;}
        @AuraEnabled public boolean pendientePausa{get;set;}
        @AuraEnabled public boolean estadoAcepRecha{get;set;}
        @AuraEnabled public boolean estadorechaza{get;set;}
        @AuraEnabled public String duenoopp{get;set;}
        @AuraEnabled public String gestoropp{get;set;}
        @AuraEnabled public String comentario{get;set;}
        @AuraEnabled public String perfil{get;set;}
    }
    public class valoresWP{
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String value{get;set;}
    }
    @AuraEnabled
    public static boolean solicitudPausa(String recordId,String motivos,String comentarios){
        try{            
            WorkOrder wo=[Select Id,OwnerId,estadoAcepRecha__c,Oportunidad__c,comentarioPausa__c,Oportunidad__r.OwnerId,Oportunidad__r.Owner.ManagerId,WorkOrderNumber 
                          from WorkOrder where Id=:recordId];
            User u = [Select Id,ManagerId From User where Id =: wo.OwnerId];
            wo.Pendiente_Pausa__c=true;
            wo.PremotivoPausa__c=motivos;
            update wo;
            
            system.debug('pendientepaus ' + wo.Pendiente_Pausa__c);
            system.debug('orden de gtrabajo ' + wo.OwnerId);
            system.debug('gestor opp ' + wo.Oportunidad__r.OwnerId);
            system.debug('manager opp ' + wo.Oportunidad__r.Owner.ManagerId);
            system.debug('dueño de la orden' + u.ManagerId);
            
            String IdOTnum = wo.WorkOrderNumber;
            String IdOT = wo.Id;
            String gestorOP=wo.Oportunidad__r.Owner.ManagerId;
            String duenoOP=wo.Oportunidad__r.OwnerId;
            String duenoOT=wo.OwnerId;
            String gestorOT=u.ManagerId;
 
            
            if((gestorOP !=null && gestorOP !='')&&(duenoOP !=null && duenoOP !='')&&(duenoOT !=null && duenoOT !='')&&(gestorOT !=null && gestorOT !='')){
                
                publicacioSolicitud(gestorOP,IdOTnum,IdOT,comentarios);
                publicacioSolicitud(duenoOP,IdOTnum,IdOT,comentarios);
                publicacioSolicitud(duenoOT,IdOTnum,IdOT,comentarios);
                publicacioSolicitud(gestorOT,IdOTnum,IdOT,comentarios);
            }
            
            return true;
                       
        }catch(Exception e){
            System.debug('Error:'+e.getMessage()+', Linea:'+e.getLineNumber());
            return false;
        }
    }
    
    public static boolean publicacioSolicitud(String Idpersona, String IdOTnum, String idOT,String comentarios){
        System.debug('INICIO publica');
        boolean ok=true;
         try{
            String titulo='';
            String comm=comentarios!='' ? 'Comentarios: \n'+ comentarios : '';
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            feedItemInput.subjectId=idOT;
            
            //ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            
            titulo=' Se realizo un solicitud de pausa: \n';
            //'+IdOTnum+'"('+URL.getSalesforceBaseUrl().toExternalForm()+'/'+idOT+'): \n';
            String texto='';
                 ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                 mentionSegmentInput.id = Idpersona;                 
                 messageBodyInput.messageSegments.add(mentionSegmentInput);
                 texto=titulo+'\n'+ comm;
                 textSegmentInput.text = texto;
                 messageBodyInput.messageSegments.add(textSegmentInput);
                 feedItemInput.body = messageBodyInput;
                 feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                 ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);

            System.debug('FIN publica');
            return ok;
        }catch(Exception e){
            System.debug('Error: '+e.getMessage()+', linea: '+e.getLineNumber());
            return ok;
        }
    }
  
    @AuraEnabled
    public static boolean solicitaRevision(String recordId,String comentarios){
        System.debug('INICIO solicitarRevision');
        try{
            System.debug('INICIO try');
            WorkOrder wo=[Select Id,OwnerId,Oportunidad__c,Oportunidad__r.OwnerId,WorkOrderNumber from WorkOrder where Id=:recordId];
            if(publicarChatter(wo.Oportunidad__r.OwnerId,wo.OwnerId,wo.Id,wo.WorkOrderNumber,wo.Oportunidad__c,comentarios,'1','')){
                wo.Pendiente_Pausa__c=false;
                wo.PremotivoPausa__c=null;
                update wo;
                return true;
            }else{
                System.debug('Error al publicar en chatter');
                return false;
            }            
        }catch(Exception e){
            System.debug('Error: '+e.getMessage()+', linea: '+e.getLineNumber());
            return false;
        }
    }
    @AuraEnabled
    public static aceptarclass aceptapausa(String recordId,String comentarios){
        system.debug('entra');
        
        aceptarclass ok = new aceptarclass();
        ok.comentario = comentarios;       
        system.debug('comen ' + ok.comentario);
        ok.estatus = 'aceptado';
        system.debug('estado ' +ok.estatus);
        
        WorkOrder wo=[Select Id,OwnerId,estadoAcepRecha__c,Oportunidad__c,comentarioPausa__c,Oportunidad__r.OwnerId,Oportunidad__r.Owner.ManagerId,WorkOrderNumber 
                      from WorkOrder where Id=:recordId];
        User u = [Select Id,ManagerId From User where Id =: wo.OwnerId];
        wo.estadoAcepRecha__c=true;
        wo.comentarioPausa__c = comentarios;
        update wo;
        
        system.debug('orden de gtrabajo ' + wo.OwnerId);
        system.debug('gestor opp ' + wo.Oportunidad__r.OwnerId);
        system.debug('manager opp ' + wo.Oportunidad__r.Owner.ManagerId);
        system.debug('dueño de la orden' + u.ManagerId);
        
        String IdOTnum = wo.WorkOrderNumber;
        String IdOT = wo.Id;
        String gestorOP=wo.Oportunidad__r.Owner.ManagerId;
       String duenoOP=wo.Oportunidad__r.OwnerId;
        String duenoOT=wo.OwnerId;
        String gestorOT=u.ManagerId;
        
        if((gestorOP !=null && gestorOP !='')&&(duenoOP !=null && duenoOP !='')&&(duenoOT !=null && duenoOT !='')&&(gestorOT !=null && gestorOT !='')){
            
            publicacionacep(gestorOP,IdOTnum,IdOT,comentarios);
            publicacionacep(duenoOP,IdOTnum,IdOT,comentarios);
            publicacionacep(duenoOT,IdOTnum,IdOT,comentarios);
            publicacionacep(gestorOT,IdOTnum,IdOT,comentarios);
            }
        system.debug('return component ' + ok);
        return ok;
                       
    }

    public class aceptarclass{
        @AuraEnabled public String comentario{get;set;}
        @AuraEnabled public String estatus{get;set;}
    }
    
    public static boolean publicacionacep(String Idpersona, String IdOTnum, String idOT,String comentarios){
        System.debug('INICIO publica');
        boolean ok=true;
         try{
            String titulo='';
            String comm=comentarios!='' ? 'Comentarios: \n'+ comentarios : '';
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            feedItemInput.subjectId=idOT;
            
            //ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            
            titulo=' Se aceptado la pausa de la Orden de Trabajo: \n';
            //' Se aceptado la pausa de la Orden de Trabajo "'+IdOTnum+'"('+URL.getSalesforceBaseUrl().toExternalForm()+'/'+idOT+'): \n';
            String texto='';
                 ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                 mentionSegmentInput.id = Idpersona;                 
                 messageBodyInput.messageSegments.add(mentionSegmentInput);
                 texto=titulo+'\n'+ comm;
                 textSegmentInput.text = texto;
                 messageBodyInput.messageSegments.add(textSegmentInput);
                 feedItemInput.body = messageBodyInput;
                 feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                 ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);

            System.debug('FIN publica');
            return ok;
        }catch(Exception e){
            System.debug('Error: '+e.getMessage()+', linea: '+e.getLineNumber());
            return ok;
        }
    }

    @AuraEnabled
    public static rechazoclass rechazarpausa(String recordId,String comentarios){
        rechazoclass acep = new rechazoclass();
        system.debug('entra');
        acep.comentario = comentarios;       
        system.debug('comen ' + acep.comentario);
        acep.estatus = 'rechazo';
        system.debug('estado ' +acep.estatus);
         WorkOrder wo=[Select Id,OwnerId,estadoRechaza__c,Oportunidad__c,comentarioPausa__c,Oportunidad__r.OwnerId,Oportunidad__r.Owner.ManagerId,WorkOrderNumber 
                      from WorkOrder where Id=:recordId];
        User u = [Select Id,ManagerId From User where Id =: wo.OwnerId];
        wo.estadoRechaza__c=true;
        wo.comentarioPausa__c = comentarios;
        update wo;        
        system.debug('orden de gtrabajo ' + wo.OwnerId);
        system.debug('gestor opp ' + wo.Oportunidad__r.OwnerId);
        system.debug('manager opp ' + wo.Oportunidad__r.Owner.ManagerId);
        system.debug('dueño de la orden' + u.ManagerId);
        
        String IdOTnum = wo.WorkOrderNumber;
        String IdOT = wo.Id;
        String gestorOP=wo.Oportunidad__r.Owner.ManagerId;
        String duenoOP=wo.Oportunidad__r.OwnerId;
        String duenoOT=wo.OwnerId;
        String gestorOT=u.ManagerId;
        
        if((gestorOP !=null && gestorOP !='')&&(duenoOP !=null && duenoOP !='')&&(duenoOT !=null && duenoOT !='')&&(gestorOT !=null && gestorOT !='')){
            
            publicacionrecha(gestorOP,IdOTnum,IdOT,comentarios);
            publicacionrecha(duenoOP,IdOTnum,IdOT,comentarios);
            publicacionrecha(duenoOT,IdOTnum,IdOT,comentarios);
            publicacionrecha(gestorOT,IdOTnum,IdOT,comentarios);
        }
        system.debug('return component ' + acep);
        return acep;
        
    }

    public class rechazoclass{
        @AuraEnabled public String comentario{get;set;}
        @AuraEnabled public String estatus{get;set;}
    }
    public static boolean publicacionrecha(String Idpersona, String IdOTnum, String idOT,String comentarios){
        System.debug('INICIO publica');
        boolean ok=true;
         try{
            String titulo='';
            String comm=comentarios!='' ? 'Comentarios: \n'+ comentarios : '';
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            feedItemInput.subjectId=idOT;
            
            //ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            
            titulo=' Se rechazo la pausa de la Orden de Trabajo: \n';
            //' Se rechazo la pausa de la Orden de Trabajo "'+IdOTnum+'"('+URL.getSalesforceBaseUrl().toExternalForm()+'/'+idOT+'): \n';
            String texto='';
                 ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                 mentionSegmentInput.id = Idpersona;                 
                 messageBodyInput.messageSegments.add(mentionSegmentInput);
                 texto=titulo+'\n'+ comm;
                 textSegmentInput.text = texto;
                 messageBodyInput.messageSegments.add(textSegmentInput);
                 feedItemInput.body = messageBodyInput;
                 feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                 ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);

            System.debug('FIN publica');
            return ok;
        }catch(Exception e){
            System.debug('Error: '+e.getMessage()+', linea: '+e.getLineNumber());
            return ok;
        }
    }
    
    public static boolean publicarChatter(String propietarioOpp,String propietarioOT,String IdWo,String numeroWO,String idOpp,String comentarios,String origen,String gestor){
        System.debug('INICIO publica');
        try{
            String titulo='';
            String comm=comentarios!='' ? 'Comentarios: \n'+comentarios : '';
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            feedItemInput.subjectId=IdWo;
            
            //ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            
            titulo=' Se ha solicitado la revisión de la Orden de trabajo: \n';
            //' Se ha solicitado la revisión de la Orden de trabajo "'+numeroWO+'"('+URL.getSalesforceBaseUrl().toExternalForm()+'/'+idwo+'): \n';
            String texto='';
            if(origen=='1'){
                ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                mentionSegmentInput.id = propietarioOT;
                messageBodyInput.messageSegments.add(mentionSegmentInput);
                
                texto=titulo+'\n'+ comm;
                textSegmentInput.text = texto;
                messageBodyInput.messageSegments.add(textSegmentInput);
            }else{
                ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                mentionSegmentInput.id = propietarioOT;
                messageBodyInput.messageSegments.add(mentionSegmentInput);
                
                textSegmentInput = new ConnectApi.TextSegmentInput();
                textSegmentInput.text = ', ';
                messageBodyInput.messageSegments.add(textSegmentInput);
                
                if(propietarioOpp==UserInfo.getUserId()){
                    if(gestor!=null&gestor!=''){
                        mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                        mentionSegmentInput.id =gestor;
                        messageBodyInput.messageSegments.add(mentionSegmentInput);
                    }
                }else{
                    mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                    mentionSegmentInput.id =propietarioOpp;
                    messageBodyInput.messageSegments.add(mentionSegmentInput);
                }
                /*textSegmentInput = new ConnectApi.TextSegmentInput();
                mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                mentionSegmentInput.id = gestor;
                messageBodyInput.messageSegments.add(mentionSegmentInput);*/
                textSegmentInput = new ConnectApi.TextSegmentInput();
                texto='\n Se ha pausado la Orden de Trabajo debido a que ';
                //texto='\n Se ha pausado la Orden de Trabajo "'+numeroWO+'" ('+URL.getSalesforceBaseUrl().toExternalForm()+'/'+idwo+') '+' debido a que ';
                textSegmentInput.text = texto;
                messageBodyInput.messageSegments.add(textSegmentInput);
                
                mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                mentionSegmentInput.id = propietarioOpp==UserInfo.getUserId() ? propietarioOpp : gestor;
                messageBodyInput.messageSegments.add(mentionSegmentInput);
                
                texto=' acepto el proceso de pausa';
                textSegmentInput = new ConnectApi.TextSegmentInput();
                textSegmentInput.text = texto;
                messageBodyInput.messageSegments.add(textSegmentInput);
            }
            //textSegmentInput.text = texto;
            //messageBodyInput.messageSegments.add(textSegmentInput);
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            //feedItemInput.subjectId=IdWo;
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
            System.debug('FIN publica');
            return true;
        }catch(Exception e){
            System.debug('Error: '+e.getMessage()+', linea: '+e.getLineNumber());
            return false;
        }
    }
    @AuraEnabled
    public static boolean pausarOT(String recordId){
        try{
            WorkOrder wo=[Select Id,PremotivoPausa__c,OwnerId,Oportunidad__c,Oportunidad__r.OwnerId,Oportunidad__r.Owner.ManagerId,WorkOrderNumber from WorkOrder where Id=:recordId];            
            if(publicarChatter(wo.Oportunidad__r.OwnerId,wo.OwnerId,wo.Id,wo.WorkOrderNumber,wo.Oportunidad__c,'','2',wo.Oportunidad__r.Owner.ManagerId)){
                system.debug('entra');
                wo.Pendiente_Pausa__c=false;
                wo.OrigenPausa__c='Aceptada';
                wo.estadoRechaza__c=false;
          wo.estadoAcepRecha__c=false;
                wo.Estatus__c='Pausada';
                wo.Motivo_del_estatus__c=wo.PremotivoPausa__c;
                wo.Motivo_de_pausa__c=wo.PremotivoPausa__c;
                system.debug('wo' + wo);
                update wo;
                return true;
            }else{
                System.debug('Error Chatter');
                return false;
            }                        
        }catch(Exception e){
            System.debug('Error: '+e.getMessage()+',Linea: '+e.getLineNumber());
            return false;
        }
    }
    
    @AuraEnabled
    public static boolean rechazo(String recordId){
        WorkOrder wo=[Select Id,OwnerId,estadoRechaza__c,Oportunidad__c,comentarioPausa__c,Oportunidad__r.OwnerId,Oportunidad__r.Owner.ManagerId,WorkOrderNumber 
                      from WorkOrder where Id=:recordId];
        wo.Pendiente_Pausa__c=false;
        wo.estadoRechaza__c=false;
      wo.estadoAcepRecha__c=false;
        wo.PremotivoPausa__c='';
        update wo;  
        system.debug('ow ' +wo);
        return false;
        
    }
}