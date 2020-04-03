public class PantallaIntermediaContratoController {
    public Opportunity oportunidad{get;set;}
    public String idOportunidad{get;set;}
    public Boolean Exito{get;set;}
    public List<String> contactoRelacionado{get;set;}
    public List<SelectOption> opciones{get;set;}
    public Boolean habilitarGenerar{get;set;}
    list<String> tipoArchivos = new List<String> { 'OCRD - BusinessPartners_auraportal.csv', 'OCPR - ContactEmployees_auraportal.csv', 'CRD1 - BPAddresses_auraportal.csv','PriceLists1(Cabecera).csv','PriceLists2(Detalle).csv' };
    public QuoteLineItem qli {get; set;}//agrega calvarez 28feb2017

    public PantallaIntermediaContratoController(ApexPages.StandardController controller){

        //agrega calvarez 28feb2017 INICIO
        String idProd = ApexPages.currentPage().getParameters().get('idProd');
        if(String.isNotBlank(idProd)) {
            List<QuoteLineItem> qlis = [SELECT Id, FormaPago__c, Facturacion1__c, Facturacion2__c, Pedidos__c, RecursosHumanos__c FROM QuoteLineItem WHERE Id=: idProd];
            if(qlis != null && qlis.size() > 0) {
                qli = qlis[0];
            }
        }
        //agrega calvarez 28feb2017 FIN

        habilitarGenerar=true;
        idOportunidad = controller.getId();
        opciones = new List<SelectOption>();
        Exito=false;
        try {
            oportunidad = [SELECT Id, Metodo_Pago__c, AccountId, Facturacion1__c, Facturacion2__c, Pedidos__c, RecursosHumanos__c, Account.IdCuentaOPAM__c, Account.IdOportunidadOPAM__c, Account.RegistroPatronal__c, Account.SucursalFacturacion__c, Account.SucursalVentas__c FROM Opportunity WHERE Id =: idOportunidad];
        } catch(Exception e) {   
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, e.getMessage() ));
        }
        try {
            opciones.add(new SelectOption('','Seleccionar'));
        } catch(Exception e) {
                 PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, e.getMessage()));
        }
        try {
            /*Agrega contactos relacionados estándar - calvarez 14 diciembre de 2016*/
            for(Contact contacto : [SELECT Name,Id from Contact where Id in (SELECT ContactId from AccountContactRelation where AccountId=: oportunidad.AccountId)]){
                opciones.add(new SelectOption(contacto.Id,Contacto.Name));
            }
        } catch(Exception e) {
                 PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, e.getMessage() ));
        }
        verificaUsuario();
    }

    public void verificaUsuario() {
        String usuarioCadena = [SELECT Name from Profile Where Id =: UserInfo.getProfileId() lIMIT 1].Name; 
        if(usuarioCadena.contains('Administrador')){
            habilitarGenerar=true;
        } else {
            List <Attachment> archivosBorrar;
            try {
                archivosBorrar =[SELECT Id from Attachment where ParentId =:oportunidad.Id AND Name In :tipoArchivos];
            } catch(Exception e){
                archivosBorrar= new  List <Attachment> ();
            }
            if(archivosBorrar.size() == 0) {
                habilitarGenerar=true;
            } else {
                habilitarGenerar=false;
                PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR,  'Ya existen CSVs insertados, no tienes permisos de generar de nuevo' ));
            }
        }
    }

    public void guardar() {

        if(qli.Facturacion1__c == null || qli.Facturacion2__c == null || qli.Pedidos__c==null || qli.RecursosHumanos__c==null || oportunidad.Account.RegistroPatronal__c == null || oportunidad.Account.SucursalFacturacion__c == null || oportunidad.Account.SucursalFacturacion__c == null) {      
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR,  'Rellena los campos en rojo' ));
            return;
        }

        Account cuenta = new Account(Id = oportunidad.AccountId, RegistroPatronal__c = oportunidad.Account.RegistroPatronal__c,SucursalFacturacion__c = oportunidad.Account.SucursalFacturacion__c, SucursalVentas__c = oportunidad.Account.SucursalVentas__c);
        try {
            System.debug('qli to update: ' + qli);
            upsert cuenta;
            update qli;
            //upsert oportunidad;//comenta calvarez 27feb2017
        } catch(Exception e) {
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR,  e.getMessage() ));
        }
        Exito = true;
        PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.CONFIRM, 'Registros guardados' ));
       
    }
}