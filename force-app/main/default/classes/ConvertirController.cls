public with sharing class ConvertirController {
	
	public String idprospecto {get;set;}
	public Lead prospecto{get;set;}
	public Opportunity oportunidad {get;set;}
	//public List<SelectOption> productosPerfilados;
	//public String campoProducto{get;set;}
	public String cuentaNombre {get;set;}
	
	public List<Necesidad__c> necesidades {get;set;}
	
	public Boolean guardo {get;set;}
    
	
	public ConvertirController(ApexPages.StandardController stdController){
		try{
			idProspecto = System.currentPagereference().getParameters().get('id');
			prospecto = (Lead)Database.query('SELECT '+String.join(new List<String>(SObjectType.Lead.Fields.getMap().keySet()), ', ')+' FROM Lead Where id =: idprospecto');
            necesidades = [SELECT Id, Name,Cuenta__c FROM Necesidad__c WHERE Lead__c =: idprospecto];
			cuentaNombre = prospecto.Company;
			oportunidad = new Opportunity(Name = prospecto.Name+' - ' +prospecto.ProductoInteres__c+ ' - ' + prospecto.LeadSource, IdCrmOrigen__c =prospecto.IdCrmOrigen__c  );
		}
		catch(Exception e){
			PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, e.getMessage() ));
		}
	}
    
    
    /*public List<SelectOption> getProductosPerfilados()
	{
	 	List<SelectOption> productos = new List<SelectOption>();
	   	
      	productos.add(new SelectOption('',''));
       	for(Necesidad__c nec : [SELECT Id, Name, Familia__c FROM Necesidad__c WHERE Lead__c =: idprospecto])
       	{
        	productos.add(new SelectOption(String.valueof(nec.Familia__c), String.valueof(nec.Familia__c) ));
       	}
       	return productos;
	}*/
	
	public PageReference convierte(){
		PageReference pagReference = null;
		try{
			
			/*
			if(campoProducto == null){
				PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Selecciona un 

producto de interés' ));
				guardo=false;
				return pagReference;
			}*/
			if(prospecto.ProductoInteres__c == null){
				PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'No se puede convertir al prospecto hasta que tenga un producto de interés' ));
				guardo=false;
				return pagReference;
			}
			if(prospecto.LeadSource == null){
				PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'No se puede convertir al prospecto hasta que se defina su origen' ));
				guardo=false;
				return pagReference;
			}
			/*if(oportunidad.AccountId==null){
				PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Selecciona una 

cuenta asociada' ));
				guardo=false;
				return;
			}*/
			oportunidad.Familia__c = prospecto.ProductoInteres__c ;
			
            
            
            
			Account cuenta = new Account (Name = cuentaNombre, RazonSocial__c=cuentaNombre, ProductoInteres__c = prospecto.ProductoInteres__c, RFC__c=prospecto.RFC__c, Calle__c=prospecto.Calle__c, ColMpoCPEdo__c= prospecto.ColMpoCPEdo__c, Ciudad__c = prospecto.Ciudad__c, CodigoPostal__c = prospecto.CodigoPostal__c, Colonia__c = prospecto.Colonia__c, DelegacionMunicipioFiscal__c= prospecto.DelegaciOnMunicipio__c , Estado__c=prospecto.Estado__c, NumeroExterior__c= prospecto.NumeroExterior__c , NumeroInterior__c=prospecto.NumeroInterior__c, IdCrmOrigen__c =prospecto.IdCrmOrigen__c, IdCrmLead__c=prospecto.IdCrmLead__c, AccountSource=prospecto.LeadSource, SubOrigen__c= prospecto.SubOrigen__c  );
			insert cuenta;
			Contact con = new Contact(AccountId=cuenta.Id,Calle__c=prospecto.Calle__c,Ciudad__c=prospecto.Ciudad__c,CodigoPostal__c=prospecto.CodigoPostal__c,
                                     Colonia__c=prospecto.Colonia__c,Estado__c=prospecto.Estado__c, NumeroExterior__c=prospecto.NumeroExterior__c,
                                     NumeroInterior__c=prospecto.NumeroInterior__c, Puesto__c=prospecto.Puesto__c,  FirstName=prospecto.FirstName , LastName=prospecto.LastName,
                                     ColMpoCPEdo__c= prospecto.ColMpoCPEdo__c);
            //upsert con;
            insert con;
            
			Database.LeadConvert prospectoConvertido =  new Database.LeadConvert();
			prospectoConvertido.setLeadId(prospecto.id);
			prospectoConvertido.setOpportunityName(oportunidad.Name);
			prospectoConvertido.setAccountId(cuenta.Id);
            prospectoConvertido.setContactId(con.Id);
            
            
			LeadStatus estatusConversion = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
			prospectoConvertido.setConvertedStatus(estatusConversion.MasterLabel);
			
			Database.LeadConvertResult lcr = Database.convertLead(prospectoConvertido);
			system.assert(lcr.isSuccess());
			
			//oportunidad = [SELECT Name, Id, Necesidad__c,Account.Id,Account.Name FROM Opportunity WHERE Id =: lcr.opportunityId ];
			//Account cuenta =[SELECT Name, Id, ProductoInteres__c FROM Account WHERE Id =: oportunidad.AccountId LIMIT 1];
			
			
			for(Necesidad__c nec : necesidades)
	       	{
	        	//nec.Cuenta__c = oportunidad.Account.Id;
	        	nec.Cuenta__c = cuenta.Id;
	        	//nec.Lead__c = null;
	       	}
	       	upsert necesidades;
	       	
			guardo=true;
            
            
            
            /*
			            
			Contact con = [Select Id, Name FROM Contact WHERE Id=: prospectoConvertido.getContactId()];
			con.Calle__c=prospecto.Calle__c;
            con.Ciudad__c=prospecto.Ciudad__c;
            con.CodigoPostal__c=prospecto.CodigoPostal__c;
            con.Colonia__c=prospecto.Colonia__c;
            con.Estado__c=prospecto.Estado__c;
            con.NumeroExterior__c=prospecto.NumeroExterior__c;
            con.NumeroInterior__c=prospecto.NumeroInterior__c;
            
            upsert con;

			*/
            
            
            
			PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.CONFIRM, 'Prospecto convertido' ));
			pagReference = new PageReference('/' + cuenta.Id);
			pagReference.setRedirect(true);
			
            
			//system.Debug('oportunidad:'+oportunidad +'    prospectoConvertido:'+prospectoConvertido+'     lcr:'+lcr + guardo);
		}catch(Exception e){
			PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, e.getMessage() ));
		}
		
		return pagReference;
	}
	
}