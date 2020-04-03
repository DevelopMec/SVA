public class RevisionDireccionController {
    public WrapperTipos registro{get;set;}
    public String identificador{get;set;}
    public String tipoObjeto{get;set;}
    public String ciudadCombo{get{
        if(ciudadCombo == null)
            ciudadCombo=registro.Ciudad;
        return this.ciudadCombo;
    }set;}
    public String estadoCombo{get{
        if(estadoCombo == null)
            estadoCombo=registro.Estado;
        return this.estadoCombo;
    }set;}
/*public String getEstadoCombo(){
        if(estadoCombo == null)
            estadoCombo=registro.Estado;
        return this.estadoCombo;
    }*/
    public void cambiaEstado(){
         registro.EstadoSugerido = estadoCombo;
    }
    public void cambiaCiudad(){
         registro.CiudadSugerido = ciudadCombo;
    }
   /* public void setEstadoCombo(String estadoCombo){
        registro.EstadoSugerido = estadoCombo;
        this.estadoCombo=estadoCombo;
    }*/
    public List<SelectOption> comboEstado{get{
        if(this.comboEstado==null){
            comboEstado=new List<SelectOption>();
            comboEstado.add(new SelectOption('',''));
            for(Catalogo__c estado : [Select Clave__c,Descripcion__c from Catalogo__c where Tipo__c='Estado']){
                comboEstado.add(new SelectOption(estado.Descripcion__c,estado.Descripcion__c));
            }
        }
        return comboEstado;
    }set;}
    public List<SelectOption> comboCiudad{get{
        if(this.comboCiudad==null){
            comboCiudad=new List<SelectOption>();
            comboCiudad.add(new SelectOption('',''));
            for(AggregateResult estado : [Select Ciudad__c from Direccion__C group by Ciudad__c ]){
                comboCiudad.add(new SelectOption(String.valueOf(estado.get('Ciudad__c')),String.valueOf(estado.get('Ciudad__c'))));
            }
        }
        return comboCiudad;
    }set;}
    public List<Direccion__C> direcciones;
    public List<Direccion__c> getDirecciones(){
        
        if(registro.EstadoSugerido != null || registro.Estado !=null){
            try{
                if(registro.EstadoSugerido==null){
                    registro.EstadoSugerido=registro.Estado;
                }
                if(registro.CiudadSugerido==null && registro.Ciudad != null){
                    registro.CiudadSugerido=registro.Ciudad;
                }
                this.direcciones=[Select CodigoPostal__C,Estado__c,Colonia__C,Ciudad__C,Calle__C from Direccion__C where (Estado__c =: registro.EstadoSugerido and 

Ciudad__c =: registro.CiudadSugerido) limit 999];
            }catch(Exception e){
                this.direcciones = new  List<Direccion__c> ();
            }
        }else{
            this.direcciones = new  List<Direccion__c> ();
        }
        return this.direcciones;
        
    }
    public void llenando(){
        Integer indice = Integer.valueOf(System.currentPagereference().getParameters().get('indice'));
        registro.CalleSugerido= direcciones[indice].Calle__c;
        registro.CiudadSugerido= direcciones[indice].Ciudad__c;
        registro.EstadoSugerido= direcciones[indice].Estado__c;
        registro.ColoniaSugerido= direcciones[indice].Colonia__c;
        registro.CodigoPostalSugerido= direcciones[indice].CodigoPostal__c;
    }
    public  RevisionDireccionController(){
        tipoObjeto='';
        if(System.currentPagereference().getParameters().get('idLead') != null){
           identificador = System.currentPagereference().getParameters().get('idLead');
            tipoObjeto='Lead';
            registro = new WrapperTipos((Lead)Database.query('Select Name,Id,Calle__c,Colonia__C,CodigoPostal__c,Estado__c,Ciudad__C from '+tipoObjeto+' where Id=\''+identificador+'\' Limit 1'));
         
        }
        else if(System.currentPagereference().getParameters().get('idAccount') != null)
        {
            identificador = System.currentPagereference().getParameters().get('idAccount');
            tipoObjeto='Account';
            registro = new WrapperTipos((Account)Database.query('Select Name,Id,Calle__c,Colonia__C,CodigoPostal__c,Estado__c,Ciudad__C from '+tipoObjeto+' where Id=\''+identificador+'\' Limit 1'));
         
        }
        else if(System.currentPagereference().getParameters().get('idContact') != null)
        {
            identificador = System.currentPagereference().getParameters().get('idContact');
            tipoObjeto='Contact';
            registro = new WrapperTipos((Contact)Database.query('Select Name,Id,Calle__c,Colonia__C,CodigoPostal__c,Estado__c,Ciudad__C from '+tipoObjeto+' where Id=\''+identificador+'\' Limit 1'));
         
        }
        if(tipoObjeto == ''){
            tipoObjeto='Account';
            registro = new WrapperTipos(new Account(Name='No hubo registro'));
        }
        if(registro.Estado ==null)
                 PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Por favor ingresa un Estado' ));
       
        System.debug(registro);
        
    }
    public void nada(){
        if(registro.EstadoSugeridoCheck == true)
            registro.Estado=registro.EstadoSugerido;
        
        if(registro.CiudadSugeridoCheck == true)
            registro.Ciudad=registro.CiudadSugerido;
        
        if(registro.CalleSugeridoCheck == true)
            registro.Calle=registro.CalleSugerido;
        if(registro.ColoniaSugeridoCheck == true)
            registro.Colonia=registro.ColoniaSugerido;
        if(registro.CodigoPostalSugeridoCheck == true)
            registro.CodigoPostal=registro.CodigoPostalSugerido;
    }
    public void guardar(){
        try{
            if('Lead' == tipoObjeto){
                Lead insertar= new Lead

(Id=identificador,Estado__c=registro.Estado,Colonia__c=registro.Colonia,Ciudad__c=registro.Ciudad,Calle__c=registro.Calle,CodigoPostal__c=registro.CodigoPostal);
                upsert insertar;
            }
            else if('Account' == tipoObjeto)
            {
                Account insertar= new Account

(Id=identificador,Estado__c=registro.Estado,Colonia__c=registro.Colonia,Ciudad__c=registro.Ciudad,Calle__c=registro.Calle,CodigoPostal__c=registro.CodigoPostal);
                upsert insertar;
            }
            else if(tipoObjeto=='Contact')
            {
                Contact insertar= new Contact

(Id=identificador,Estado__c=registro.Estado,Colonia__c=registro.Colonia,Ciudad__c=registro.Ciudad,Calle__c=registro.Calle,CodigoPostal__c=registro.CodigoPostal);
                upsert insertar;
            }
        }catch(Exception e){
            
        }
    }
    public class WrapperTipos{
        public String tipoRegistro{get;set;}
        public String Id{get;set;}
        
        public String Estado{get;set;}
        public String EstadoSugerido{get;set;}
        public Boolean EstadoSugeridoCheck{get;set;}
        public String Colonia{get;set;}
        public String ColoniaSugerido{get;set;}
        public Boolean ColoniaSugeridoCheck{get;set;}
        public String Calle{get;set;}
        public String CalleSugerido{get;set;}
        public Boolean CalleSugeridoCheck{get;set;}
        public String CodigoPostal{get;set;}
        public String CodigoPostalSugerido{get;set;}
        public Boolean CodigoPostalSugeridoCheck{get;set;}
        
        public String Ciudad{get;set;}
        public String CiudadSugerido{get;set;}
        public Boolean CiudadSugeridoCheck;
        public Boolean getCiudadSugeridoCheck(){
            return this.CiudadSugeridoCheck;
        }
        public void setCiudadSugeridoCheck(Boolean CiudadSugeridoCheck){
            if(CiudadSugeridoCheck == true){
                this.Ciudad=CiudadSugerido;
                
            }
            this.CiudadSugeridoCheck=CiudadSugeridoCheck;
        }
        
        public WrapperTipos(Account registro){
            this.Id=registro.Id;
            this.tipoRegistro='Account';
            this.Estado = registro.Estado__c;
            this.Colonia=registro.Colonia__c;
            this.Calle=registro.Calle__c;
            this.CodigoPostal=registro.CodigoPostal__c;
            this.Ciudad=registro.Ciudad__c;
            this.CodigoPostalSugeridoCheck=false;
            this.CalleSugeridoCheck=false;
            this.CiudadSugeridoCheck=false;
            this.EstadoSugeridoCheck=false;
            this.ColoniaSugeridoCheck=false;
            
        }
        public WrapperTipos(Contact registro){
            
            this.Id=registro.Id;
            this.tipoRegistro='Account';
            this.Estado = registro.Estado__c;
            this.Colonia=registro.Colonia__c;
            this.Calle=registro.Calle__c;
            this.CodigoPostal=registro.CodigoPostal__c;
            this.Ciudad=registro.Ciudad__c;
            this.CodigoPostalSugeridoCheck=false;
            this.CalleSugeridoCheck=false;
            
        }
        public WrapperTipos(Lead registro){
            
            this.Id=registro.Id;
            this.tipoRegistro='Account';
            this.Estado = registro.Estado__c;
            this.Colonia=registro.Colonia__c;
            this.Calle=registro.Calle__c;
            this.CodigoPostal=registro.CodigoPostal__c;
            this.Ciudad=registro.Ciudad__c;
            this.CodigoPostalSugeridoCheck=false;
            this.CalleSugeridoCheck=false;
            
        }
    }

}