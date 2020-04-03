public without sharing class GruposAtencionFlujo_CONT {
    @AuraEnabled
    public static void cambiarTipoCaso(String tipo,String idRecord){
        Case c=[Select Id from Case where Id=:idRecord];
        c.Motivo__c=null;
        c.Sub_Motivo__c=null;
        c.Grupo_atencion_siguiente__c='--';
        c.Type=tipo;
        update c;
    }
    
    @AuraEnabled
    public static List<valoresWP> getTipos(String idRecord){
        List<valoresWP> res=new List<valoresWP>();
        boolean filtroporUsuario = false;
        try{
            Case c = [Select Type From Case where Id =: idRecord];
            string tipo = c.Type;
            if (tipo.contains('Usuario')){
                filtroporUsuario = true;     
            }
         }
        catch(Exception e){
            
        }
        
        Schema.DescribeFieldResult fieldResult = Case.Type.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        valoresWP tem;
        for( Schema.PicklistEntry pickListVal : ple){
            string label = pickListVal.getLabel();
            if (filtroporUsuario){
                if (!label.contains('Usuario') ){
                    continue;    
                }
            }
            else{
                if (label.contains('Usuario') ){
                    continue;    
                }
            }
            tem=new valoresWP();
            tem.label=label;
            tem.value=pickListVal.getValue();
            res.add(tem);
        }
        return res;        
    }

    public without sharing class valoresWP{
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String value{get;set;}
    }
    
    private static boolean EscalacionAutomatica = false;
    
    @AuraEnabled
    public static Map<String,String> escalarRechazarCaso(String caso,String comentarios,String tipo){
        System.debug('INI::'+tipo);
        try{
            Map<String,String> mapRes=new Map<String,String>();
            
            Case ticket = [
                Select Id,Description, OwnerId, CreatedById, CreatedBy.Grupo_de_Atencion__c, Grupo_atencion_anterior__c,
                       Grupo_de_Atencion__c, Grupo_atencion_siguiente__c, Status, Motivo__c, Sub_Motivo__c, Type,
                       NumberGroupAtention__c, StatusApproval__c
                  from Case where Id=:caso];
            String idOwn=ticket.OwnerId;
            String grupoAtencionProp=idOwn.startsWithIgnoreCase('005') ? [Select Id,Grupo_de_Atencion__c from User where Id=:ticket.OwnerId].Grupo_de_Atencion__c : '';
            if(ticket.Motivo__c==null||ticket.Status=='Concluido'||ticket.Status=='Cancelado'){
                return getReturn('warning','Error!',ticket.Motivo__c==null ? 'Ingrese Motivo y Submotivo' : 'El caso se encuentra concluido o cancelado');
            }
            System.debug('VERR::'+ticket.Motivo__c+'--'+ticket.Sub_Motivo__c+'--'+ticket.Type);
            Submotivo__c subMot;
            try{
                subMot=[Select Id,SecondaryFields__c,RequiredFields__c,Grupo_Soporte_1__c,Grupo_Soporte_2__c,Grupo_Soporte_3__c,Grupo_Soporte_4__c,Grupo_Soporte_5__c,Grupo_Soporte_6__c,Grupo_Soporte_7__c,ManualProcess__c 
                        from Submotivo__c where Motivo__c=:ticket.Motivo__c and Name=:ticket.Sub_Motivo__c and Tipo_de_Ticket__c=:ticket.Type limit 1];
            }catch(Exception e){
                return getReturn('error','Error!','No existen los valores en el catalogo');
            }
            if(subMot.ManualProcess__c&&ticket.Status=='Abierto'&&tipo=='escalar'&&validar(subMot.RequiredFields__c,ticket.Id)){
                if(subMot.get('Grupo_Soporte_1__c')!=null && subMot.get('Grupo_Soporte_1__c').toString().startsWithIgnoreCase('TI')&&(ticket.Description==null||ticket.Description=='')){
                    return getReturn('warning','Error!','Favor de ingresar la descripción del problema');
                }
                ticket.Status='En Proceso';update ticket;                
                return getReturn('success','Exito!','Caso escalado correctamente');
            }else if(subMot.ManualProcess__c&&ticket.Status=='En Proceso'&&tipo=='escalar'&&ticket.Grupo_de_Atencion__c!=null&&ticket.Grupo_de_Atencion__c!=''&&ticket.Grupo_de_Atencion__c!='--'){
                if (!EscalacionAutomatica){
                    return getReturn('warning','Información!','La escalación debe hacerce manualmente');
                }
            }
            if((subMot.ManualProcess__c&&tipo=='rechazo'&&ticket.Grupo_de_Atencion__c!=null&&ticket.Grupo_de_Atencion__c!=''&&ticket.Grupo_de_Atencion__c!='--')||(ticket.Status=='Abierto'&&tipo=='rechazo')){
                return getReturn('warning','Error!',(ticket.Status=='Abierto'&&tipo=='rechazo') ? 'El caso no se puede rechazar en estatus abierto' : 'El rechazo debe hacerce manualmente'); 
            }
            
            if(tipo == 'rechazo'){
                ticket.OwnerId = ticket.CreatedById;ticket.Rejected__c = true;                
                update ticket;
                return getReturn('success','Exito!','Caso rechazado correctamente');
            }
            
            if(tipo=='escalarMontoAprobacion'&&ticket.Status=='Abierto'&&validar(subMot.RequiredFields__c,ticket.Id)){
                ticket.Status='En Proceso';ticket.InApprovalProcess__c = true;                
                update ticket;
                return getReturn('success','Exito!','Caso escalado correctamente');
            }
            if(tipo=='escalar'){
                System.debug('ESCALAR::');
                if(!validar(subMot.RequiredFields__c,ticket.Id)){
                    return getReturn('warning','Error!','Ingrese todos los campos de la sección de Información del ticket');
                }
                if(subMot.get('Grupo_Soporte_'+ticket.NumberGroupAtention__c+'__c')==null){//if(ticket.Grupo_atencion_siguiente__c==null||ticket.Grupo_atencion_siguiente__c=='--'||ticket.Grupo_atencion_siguiente__c==''){
                    return getReturn('info','Información!','No hay mas grupos que asignar');
                }
                if(ticket.Status=='En Proceso'){
                    if(!validar(subMot.SecondaryFields__c,ticket.Id)&&(UserInfo.getUserId()!=ticket.OwnerId||grupoAtencionProp!=ticket.Grupo_de_Atencion__c)){
                        return getReturn('warning','Error!','Ingrese todos los campos de la sección de Información del ticket');
                    }else if(subMot.get('Grupo_Soporte_'+ticket.NumberGroupAtention__c+'__c')!=null && subMot.get('Grupo_Soporte_'+ticket.NumberGroupAtention__c+'__c').toString().startsWithIgnoreCase('TI')&&(ticket.Description==null||ticket.Description=='')){
                        return getReturn('warning','Error!','Favor de ingresar la descripción del problema');
                    }else{
                        ticket.Grupo_atencion_anterior__c=ticket.Grupo_de_Atencion__c!='CALIDAD' ? ticket.NumberGroupAtention__c>1 ?  subMot.get('Grupo_Soporte_'+(ticket.NumberGroupAtention__c-1)+'__c').toString() : '--' : 'CALIDAD' ;
                        ticket.Grupo_de_Atencion__c=subMot.get('Grupo_Soporte_'+ticket.NumberGroupAtention__c+'__c')!=null ? subMot.get('Grupo_Soporte_'+ticket.NumberGroupAtention__c+'__c').toString() : '--';//ticket.Grupo_atencion_siguiente__c;
                        ticket.Grupo_atencion_siguiente__c=subMot.get('Grupo_Soporte_'+(ticket.NumberGroupAtention__c+1)+'__c')!=null ? subMot.get('Grupo_Soporte_'+(ticket.NumberGroupAtention__c+1)+'__c').toString() : '--';
                        ticket.NumberGroupAtention__c=ticket.NumberGroupAtention__c!=null ? ticket.NumberGroupAtention__c+1 : null;   
                    }
                }else if(ticket.Status=='Abierto'){
                    if(subMot.get('Grupo_Soporte_1__c')!=null && subMot.get('Grupo_Soporte_1__c').toString().startsWithIgnoreCase('TI')&&(ticket.Description==null||ticket.Description=='')){
                        return getReturn('warning','Error!','Favor de ingresar la descripción del problema');
                    }else{
                        ticket.Status='En Proceso';
                    }
                }
            }else{
                if(ticket.Grupo_de_Atencion__c=='CALIDAD'){
                    return getReturn('warning','Error!','El caso no se puede rechazar en CALIDAD');
                }else if(ticket.NumberGroupAtention__c>1){
                    String idAdmin=[Select Id from Profile where Name='Administrador del sistema'].Id;
                    if(ticket.OwnerId==UserInfo.getUserId()||idAdmin==UserInfo.getProfileId()){                    
                        ticket.Grupo_atencion_anterior__c='--';
                        ticket.Grupo_atencion_siguiente__c=subMot.get('Grupo_Soporte_'+(ticket.NumberGroupAtention__c-1)+'__c')!=null ? subMot.get('Grupo_Soporte_'+(ticket.NumberGroupAtention__c-1)+'__c').toString() : '--';
                        ticket.Grupo_de_Atencion__c=ticket.CreatedBy.Grupo_de_Atencion__c!=null ? (ticket.CreatedBy.Grupo_de_Atencion__c.equalsIgnoreCase('Inbox')||ticket.CreatedBy.Grupo_de_Atencion__c.equalsIgnoreCase('Elite') ? ticket.CreatedBy.Grupo_de_Atencion__c : 'CALIDAD') : 'CALIDAD';//subMot.Grupo_Soporte_1__c;
                        ticket.NumberGroupAtention__c=ticket.NumberGroupAtention__c!=null ? ticket.NumberGroupAtention__c-1 : null;
                        Comentario_de_Rechazo__c coment = new Comentario_de_Rechazo__c();
                        coment.Name = comentarios;
                        coment.Fecha_Hora__c = System.now();
                        coment.Grupo_de_Atencion__c = ticket.Grupo_atencion_siguiente__c;
                        coment.Ticket__c = ticket.Id;
                        coment.Usuario__c = ticket.OwnerId!=null ? String.valueOf(ticket.OwnerId).startsWith('005') ? ticket.OwnerId : null : null;
                        insert coment;
                    }else{
                        return getReturn('warning','Error!','El caso solo puede ser rechazado por el propietario');
                    }
                }else{
                    return getReturn('warning','Error!','El caso no se puede rechazar en el primer grupo de atención');
                }
            }
            update ticket;
            return getReturn('success','Exito!',tipo=='escalar' ? 'Caso escalado correctamente' : 'Caso rechazado correctamente');
        }catch(DMLException e){
            Integer numErrors = e.getNumDml();List<String> lErr=new List<String>();            
            for(Integer i=0;i<numErrors;i++) {lErr.add(e.getDmlMessage(i));}
            return getReturn('error','Error!',String.join(lErr, ','));
        }catch(Exception e){
            return getReturn('error','Error!',e.getMessage());
        }

    }
    @AuraEnabled
    public static Map<String,String> escalarRechazarCaso2(String caso,String comentarios,String tipo){
        EscalacionAutomatica = true;
        return escalarRechazarCaso(caso, comentarios, tipo);
    }
    
    public static Map<String,String> getReturn(String tipo,String titulo,String msj){
        Map<String,String> res=new Map<String,String>();
        res.put('tipo',tipo);
        res.put('titulo',titulo);
        res.put('msj',msj);
        return res;
    }
    public static boolean validar(String campos,String caso){
        boolean res=true;
        if(campos!=null){
            String query='Select Id,'+campos.replace(';', ',')+' from case where Id=\''+caso+'\'';
            Case ticket=Database.query(query);
            List<String> lisCam=campos.split(';');
            for(String tem:lisCam){
                if(ticket.get(tem)==null||ticket.get(tem)==''){
                    res=false;
                    break;
                }
            }
        }
        return res;
    }
}