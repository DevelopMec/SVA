public class SplitOportunidadController {
    public Opportunity oportunidad{get;set;}
    public Boolean esAdministrador{get;set;}
    public List<SplitOportunidad__C> listaSplit{get;set;}
    public List<SplitOportunidad__C> listaEliminar{get;set;}
    public Double total {get{
        Double valor=0.0;
        for(SplitOportunidad__C item: listaSplit){
            valor+= item.Monto__c != null? item.Monto__c:0;
        }
        this.total=valor;
        return valor;
    }set;}
    public SplitOportunidadController(ApexPages.StandardController controller){
      
        
        String identificador = controller.getId();
        try{
            oportunidad = [Select Id,Name,CloseDate,amount  from Opportunity where Id =: identificador];
            obtenerDatos(identificador);}
        catch(Exception e){
            
        }
        try{
            if(([Select Profile.Name from User where Id =:UserInfo.getUserId()].Profile.Name).contains('Administrador')){
                esAdministrador=true;
            }else{
                esAdministrador=false;
            //    PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'No puedes borrar ningun registro'));
        
            }
        }catch(Exception e){
            esAdministrador=false;
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, e.getMessage() +'Linea:  ' + e.getLineNumber()));
        
        }
        
    }
    public void agregar(){
        if(listaSplit.size()==0)
       	 listaSplit.add(new SplitOportunidad__C(oportunidad__c = oportunidad.Id,Fecha__c = oportunidad.CloseDate));
        else
       	 listaSplit.add(new SplitOportunidad__C(oportunidad__c = oportunidad.Id));
        
        
    }
    public void guardar(){
        try{
            if(listaEliminar.size()>0)
                delete listaEliminar;
            upsert listaSplit;
            oportunidad.amount = total;
            upsert oportunidad;
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.CONFIRM, 'La información se guardo correctamente' ));
        }
        catch(Exception e){
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, e.getMessage() +'Linea:  ' + e.getLineNumber()));
        }
    }
    public void eliminar(){
        try{
            String indices = apexpages.currentpage().getparameters().get('indice'); 
            List<Integer> enteros=new List<Integer>();
            
            for(String numero:indices.split(',')) {
                enteros.add(Integer.valueOf(numero));
            }
            enteros.sort();
            
            for(Integer i=0;i<enteros.size();i++) {
                Integer indice = enteros[enteros.size()-1-i];
                if(listaSplit[indice].Id != null)
                    listaEliminar.add(listaSplit[indice]);
                listaSplit.remove(indice);
            }
        }catch(Exception e){}
        
    }
    public void obtenerDatos(String identificador){
        
             listaEliminar= new List<SplitOportunidad__C>();
        try{
            listaSplit = [Select Id,Monto__c,Fecha__c from SplitOportunidad__c where oportunidad__c =: identificador order by Fecha__c asc];
        }catch(Exception e){
             listaSplit= new List<SplitOportunidad__C>();
        }
    }
}