public with sharing class FormatoNecesidadesController {
	public String idProspecto {get;set;}
	public String idCuenta {get;set;}
	public Boolean despensa {get;set;}
	public Boolean gasolina {get;set;}
	public Boolean mantenimiento {get;set;}
	public Boolean restaurante {get;set;}
	public Boolean uniforme {get;set;}
	public Boolean incentivos {get;set;}
	public Boolean empresarial {get;set;}
	public Lead prospecto {get;set;}
	public Account cuenta {get;set;}
	public String valorRadio{get;set;}
	public String redirige{get;set;}
	
	public Necesidad__c[] regDespensa {get;set;}
	public Necesidad__c[] regCombustible {get;set;}
	public Necesidad__c[] regMantenimiento {get;set;}
	public Necesidad__c[] regRestaurante {get;set;}
	public Necesidad__c[] regUniforme {get;set;}
	public Necesidad__c[] regIncentivos {get;set;}
	public Necesidad__c[] regEmpresarial {get;set;}
	
	public Necesidad__c prodDespensa {get;set;}
	public Necesidad__c prodCombustible {get;set;}
	public Necesidad__c prodMantenimiento {get;set;}
	public Necesidad__c prodRestaurante {get;set;}
	public Necesidad__c prodUniforme {get;set;}
	public Necesidad__c prodIncentivos {get;set;}
	public Necesidad__c prodEmpresarial {get;set;}
	
	public FormatoNecesidadesController(ApexPages.StandardController stdController){
		try{
			idProspecto = System.currentPagereference().getParameters().get('id');
			idCuenta = System.currentPagereference().getParameters().get('IdCuenta');
			if(idProspecto != null){
				prospecto = [SELECT Id, Name, ProductoInteres__c FROM Lead WHERE Id =: idprospecto ];
				valorRadio = prospecto.ProductoInteres__c;
				redirige=idProspecto;
			}
			
			if(idCuenta!=null){
				cuenta = [SELECT Id, Name, ProductoInteres__c FROM Account WHERE Id =: idCuenta ];
				valorRadio = cuenta.ProductoInteres__c;
				redirige=idCuenta;
			}
		}catch(Exception e){
			System.debug('Se ha producido un error : '+e.getMessage());
		}
		
		crearRegistros();
		/*
		regDespensa= [SELECT EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Lead__c FROM Necesidad__c WHERE Lead__c =: idprospecto AND RecordType.Name='Despensa' LIMIT 1];
		regCombustible= [SELECT EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Lead__c FROM Necesidad__c WHERE Lead__c =: idprospecto AND RecordType.Name='Combustible' LIMIT 1];
		regMantenimiento = [SELECT EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Lead__c FROM Necesidad__c WHERE Lead__c =: idprospecto AND RecordType.Name='Mantenimiento' LIMIT 1];
		regRestaurante = [SELECT EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Lead__c FROM Necesidad__c WHERE Lead__c =: idprospecto AND RecordType.Name='Restaurante' LIMIT 1]; 
		regUniforme = [SELECT EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Lead__c FROM Necesidad__c WHERE Lead__c =: idprospecto AND RecordType.Name='Uniforme' LIMIT 1];
		regIncentivos = [SELECT EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Lead__c FROM Necesidad__c WHERE Lead__c =: idprospecto AND RecordType.Name='Incentivos' LIMIT 1];
		regEmpresarial = [SELECT EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Lead__c FROM Necesidad__c WHERE Lead__c =: idprospecto AND RecordType.Name='Empresarial' LIMIT 1];
		*/
		if(regDespensa.size()>0){
			prodDespensa=regDespensa[0];
			despensa=true;
		}else{
			if(idProspecto!=null){
				prodDespensa= new Necesidad__c(Lead__c = idprospecto, Familia__c='Despensa', recordTypeId=[Select Id,SobjectType,Name From RecordType WHERE DeveloperName ='Despensa' and SobjectType ='Necesidad__c'  limit 1].Id );
			}else{
				prodDespensa= new Necesidad__c(Cuenta__c = idCuenta, Familia__c='Despensa', recordTypeId=[Select Id,SobjectType,Name From RecordType WHERE DeveloperName ='Despensa' and SobjectType ='Necesidad__c'  limit 1].Id );
			}
			despensa=false;
		}
		
		if(regCombustible.size()>0){
			prodCombustible=regCombustible[0];
			gasolina=true;
		}else{
			if(idProspecto!=null){
				prodCombustible= new Necesidad__c(Lead__c = idprospecto, Familia__c='Combustible', recordTypeId=[Select Id,SobjectType,Name From RecordType WHERE DeveloperName ='Combustible' and SobjectType ='Necesidad__c'  limit 1].Id );
			}else{
				prodCombustible= new Necesidad__c(Cuenta__c = idCuenta, Familia__c='Combustible', recordTypeId=[Select Id,SobjectType,Name From RecordType WHERE DeveloperName ='Combustible' and SobjectType ='Necesidad__c'  limit 1].Id );
			}
			gasolina=false;
		}
		
		if(regMantenimiento.size()>0){
			prodMantenimiento=regMantenimiento[0];
			mantenimiento=true;
		}else{
			if(idProspecto!=null){
				prodMantenimiento= new Necesidad__c(Lead__c = idprospecto, Familia__c='Mantenimiento', recordTypeId=[Select Id,SobjectType,Name From RecordType WHERE DeveloperName ='Mantenimiento' and SobjectType ='Necesidad__c'  limit 1].Id );
			}else{
				prodMantenimiento= new Necesidad__c(Cuenta__c = idCuenta, Familia__c='Mantenimiento', recordTypeId=[Select Id,SobjectType,Name From RecordType WHERE DeveloperName ='Mantenimiento' and SobjectType ='Necesidad__c'  limit 1].Id );
			}
			mantenimiento=false;
		}
		
		if(regRestaurante.size()>0){
			prodRestaurante=regRestaurante[0];
			restaurante=true;
		}else{
			if(idProspecto!=null){
				prodRestaurante= new Necesidad__c(Lead__c = idprospecto, Familia__c='Restaurante', recordTypeId=[Select Id,SobjectType,Name From RecordType WHERE DeveloperName ='Restaurante' and SobjectType ='Necesidad__c'  limit 1].Id );
			}else{
				prodRestaurante= new Necesidad__c(Cuenta__c = idCuenta, Familia__c='Restaurante', recordTypeId=[Select Id,SobjectType,Name From RecordType WHERE DeveloperName ='Restaurante' and SobjectType ='Necesidad__c'  limit 1].Id );
			}
			restaurante=false;
		}
		
		if(regUniforme.size()>0){
			prodUniforme=regUniforme[0];
			uniforme=true;
		}else{
			if(idProspecto!=null){
				prodUniforme= new Necesidad__c(Lead__c = idprospecto, Familia__c='Uniforme', recordTypeId=[Select Id,SobjectType,Name From RecordType WHERE DeveloperName ='Uniforme' and SobjectType ='Necesidad__c'  limit 1].Id );
			}else{
				prodUniforme= new Necesidad__c(Cuenta__c = idCuenta, Familia__c='Uniforme', recordTypeId=[Select Id,SobjectType,Name From RecordType WHERE DeveloperName ='Uniforme' and SobjectType ='Necesidad__c'  limit 1].Id );
			}
			uniforme=false;
		}
		
		if(regIncentivos.size()>0){
			prodIncentivos=regIncentivos[0];
			incentivos=true;
		}else{
			if(idProspecto!=null){
				prodIncentivos= new Necesidad__c(Lead__c = idprospecto, Familia__c='Regalo', recordTypeId=[Select Id,SobjectType,Name From RecordType WHERE DeveloperName ='Incentivos' and SobjectType ='Necesidad__c'  limit 1].Id );
			}else{
				prodIncentivos= new Necesidad__c(Cuenta__c = idCuenta, Familia__c='Regalo', recordTypeId=[Select Id,SobjectType,Name From RecordType WHERE DeveloperName ='Incentivos' and SobjectType ='Necesidad__c'  limit 1].Id );
			}
			incentivos=false;
		}
		
		if(regEmpresarial.size()>0){
			prodEmpresarial=regEmpresarial[0];
			empresarial=true;
		}else{
			if(idProspecto!=null){
				prodEmpresarial= new Necesidad__c(Lead__c = idprospecto, Familia__c='Empresarial', recordTypeId=[Select Id,SobjectType,Name From RecordType WHERE DeveloperName ='Empresarial' and SobjectType ='Necesidad__c'  limit 1].Id );
			}else{
				prodEmpresarial= new Necesidad__c(Cuenta__c = idCuenta, Familia__c='Empresarial', recordTypeId=[Select Id,SobjectType,Name From RecordType WHERE DeveloperName ='Empresarial' and SobjectType ='Necesidad__c'  limit 1].Id );
			}
			empresarial=false;
		}
		
		
	}
	
	
	public void crearRegistros(){
		if(idProspecto != null){
            try{
			regDespensa= [SELECT Familia__c, EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Lead__c,UsoProducto__c FROM Necesidad__c WHERE (Lead__c =: idProspecto) AND RecordType.Name='Despensa' LIMIT 1];
			regCombustible= [SELECT Familia__c, EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Lead__c,UsoProducto__c FROM Necesidad__c WHERE (Lead__c =: idProspecto) AND RecordType.Name='Combustible' LIMIT 1];
			regMantenimiento = [SELECT Familia__c, EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Lead__c,UsoProducto__c FROM Necesidad__c WHERE (Lead__c =: idProspecto) AND RecordType.Name='Mantenimiento' LIMIT 1];
			regRestaurante = [SELECT Familia__c, EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Lead__c,UsoProducto__c FROM Necesidad__c WHERE (Lead__c =: idProspecto) AND RecordType.Name='Restaurante' LIMIT 1]; 
			regUniforme = [SELECT Familia__c, EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Lead__c,UsoProducto__c FROM Necesidad__c WHERE (Lead__c =: idProspecto) AND RecordType.Name='Uniforme' LIMIT 1];
			regIncentivos = [SELECT Familia__c, EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Lead__c,UsoProducto__c FROM Necesidad__c WHERE (Lead__c =: idProspecto) AND RecordType.Name='Incentivos' LIMIT 1];
			regEmpresarial = [SELECT Familia__c, EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Lead__c,UsoProducto__c FROM Necesidad__c WHERE (Lead__c =: idProspecto) AND RecordType.Name='Empresarial' LIMIT 1];
            }catch(Exception e){
            	inicializaListas();
            }
        }else if(idCuenta != null){
            try{
			regDespensa= [SELECT Familia__c, EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Cuenta__c,UsoProducto__c FROM Necesidad__c WHERE ( Cuenta__c=:idCuenta) AND RecordType.Name='Despensa' LIMIT 1];
			regCombustible= [SELECT Familia__c, EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Cuenta__c,UsoProducto__c FROM Necesidad__c WHERE (Cuenta__c=:idCuenta) AND RecordType.Name='Combustible' LIMIT 1];
			regMantenimiento = [SELECT Familia__c, EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Cuenta__c,UsoProducto__c FROM Necesidad__c WHERE (Cuenta__c=:idCuenta) AND RecordType.Name='Mantenimiento' LIMIT 1];
			regRestaurante = [SELECT Familia__c, EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Cuenta__c,UsoProducto__c FROM Necesidad__c WHERE (Cuenta__c=:idCuenta) AND RecordType.Name='Restaurante' LIMIT 1]; 
			regUniforme = [SELECT Familia__c, EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Cuenta__c,UsoProducto__c FROM Necesidad__c WHERE (Cuenta__c=:idCuenta) AND RecordType.Name='Uniforme' LIMIT 1];
			regIncentivos = [SELECT Familia__c, EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Cuenta__c,UsoProducto__c FROM Necesidad__c WHERE (Cuenta__c=:idCuenta) AND RecordType.Name='Incentivos' LIMIT 1];
                regEmpresarial = [SELECT Familia__c, EmpleadosSindicalizados__c, EmpleadosNoSindicalizados__c, Usuarios__c,TienePrestacion__c, Sistema__c, Proveedor__c, VolumenEmision__c, ComisionActual__c, MotivoCambio__c, FinVigenciaContrato__c, EmpresasGrupo__c,FlotaPrimaria__c,FlotaSecundaria__c,Utilitarios__c,Administrativo__c,Motocicletas__c,Maquinaria__c,Maritimo__c,Autoconsumo__c,EmpleadosViajan__c,CantidadViajes__c,ConsumosInternacionales__c,UsoCajaChica__c,DisposicionEfectivo__c,PagoCasetas__c,Cuenta__c,UsoProducto__c FROM Necesidad__c WHERE (Cuenta__c=:idCuenta) AND RecordType.Name='Empresarial' LIMIT 1];
            }catch(Exception e){
           		 inicializaListas();
            }
        }else{
            inicializaListas();
        }
	}
    void inicializaListas(){
        	 regDespensa = new List<Necesidad__c>();
            regCombustible = new List<Necesidad__c>();
            regMantenimiento = new List<Necesidad__c>();
            regRestaurante = new List<Necesidad__c>();
            regUniforme = new List<Necesidad__c>();
            regIncentivos = new List<Necesidad__c>();
            regEmpresarial = new List<Necesidad__c>();
        
    }
	public pageReference generarNecesidades(){
        PageReference pagReference;
        try{
            if(valorRadio == null || valorRadio == ''){
        		PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, 'Seleccione un producto de interés'));
        		return null;
        	}
            if(despensa){ upsert prodDespensa; }
            if(gasolina){ upsert prodCombustible; }
            if(mantenimiento){ upsert prodMantenimiento; }
            if(restaurante){ upsert prodRestaurante; }
            if(uniforme){ upsert prodUniforme; }
            if(incentivos){ upsert prodIncentivos; }
            if(empresarial){ upsert prodEmpresarial; }
            //System.debug(' actualizo los registros '+prodDespensa + '  '+prodEmpresarial);
            if(idProspecto!=null){
                prospecto.ProductoInteres__c = valorRadio;
                upsert prospecto;
            }
            else{
                cuenta.ProductoInteres__c = valorRadio;
                upsert cuenta;
            }
            pagReference = new PageReference('/' + redirige);
            pagReference.setRedirect(true);
        }catch(Exception e){
            system.debug('Se ha producido un error : '+e.getMessage());
            PageMessagesController.addMessage(new PageMessagesController.PageMessage(PageMessagesController.Severity.ERROR, e.getMessage() + e.getLineNumber()));
        }
        return pagReference;
    }
    
    
    public void selecciona(){
        valorRadio=valorRadio;
	}
    
    public void modificaRadioAplica(){
        if(valorRadio == 'Despensa'){
            despensa = true;
        }else if(valorRadio == 'Combustible'){
            gasolina = true;
        }else if(valorRadio == 'Mantenimiento'){
        	mantenimiento = true;
        }else if(valorRadio == 'Ticket Restaurante'){
        	restaurante = true;
        }else if(valorRadio == 'Uniforme'){
        	uniforme = true;
        }else if(valorRadio == 'Regalo'){
        	incentivos = true;
        }else if(valorRadio == 'Empresarial'){
        	empresarial = true;
        }
    }

}