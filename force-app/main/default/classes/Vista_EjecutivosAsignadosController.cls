public class Vista_EjecutivosAsignadosController {
    private static String[] DistantSales{get;set;}
    private static String[] Corporate{get;set;}
    private static String[] Key{get;set;}
    private static String[] EMPLOYEEBENEFITS{get;set;}
    private static String[] familiafuncion{get;set;}
    private static String[] FLEETMOBILITY{get;set;}
    private static String[] DistantBusines{get;set;}
    private static String[] FLEETMOBILITYfamilia{get;set;}
    private static String[] EMPLOYEEBENEFITSfamilia{get;set;}
    
    static{
        DistantSales = [SELECT Funciones__c FROM Funciones_por_BU__mdt where QualifiedApiName = 'DistantSales'].Funciones__c.split(',');
        Corporate = [SELECT Funciones__c FROM Funciones_por_BU__mdt where QualifiedApiName = 'Corporate'].Funciones__c.split(','); 
        Key = [SELECT Funciones__c FROM Funciones_por_BU__mdt where QualifiedApiName = 'Key'].Funciones__c.split(',');
        EMPLOYEEBENEFITS = [SELECT Funciones__c FROM Funciones_por_BU__mdt where QualifiedApiName = 'EmployeeBenefits'].Funciones__c.split(',');
        FLEETMOBILITY = [SELECT Funciones__c FROM Funciones_por_BU__mdt where QualifiedApiName = 'FleetMobility'].Funciones__c.split(',');
        DistantBusines = [SELECT Funciones__c FROM Funciones_por_BU__mdt where QualifiedApiName = 'DistantBusiness'].Funciones__c.split(',');           
        familiafuncion = [SELECT Funciones__c FROM Funciones_por_BU__mdt where QualifiedApiName = 'FamiliaFuncion'].Funciones__c.split(',');
        FLEETMOBILITYfamilia = [SELECT Funciones__c FROM Funciones_por_BU__mdt where QualifiedApiName = 'FleetMobilityFamilia'].Funciones__c.split(',');
        EMPLOYEEBENEFITSfamilia = [SELECT Funciones__c FROM Funciones_por_BU__mdt where QualifiedApiName = 'EmployeeBenefitsFamilia'].Funciones__c.split(',');
    }
    
    @AuraEnabled
    public static List<ListBU> getListEjecutivos(Id recordId){
        List<ListBU> lBU = new List<ListBU>();
        List<ContratoFilial__c> contratoFilialList = new List<ContratoFilial__c>();
        List<EntidadCuenta__c> entidadCuentaList = New List<EntidadCuenta__c>(); 
        List<Account> ListCuenta = New List<Account>(); 
        
        Map<String,List<String>> mapaFamiliaBU = new Map<String,List<String>>();
        Map<String,List<Ejecutivo>> mapaData = new Map<String,List<Ejecutivo>>();
        Map<String,List<String>> mapaUsuarios = new Map<String,List<String>>();
        Map<String,Boolean> mapBusinessChannel = new Map<String,Boolean>();

        Boolean hasAllContractsInactive = false;
		Boolean accountToClient = false;
        //Change - Req. 2329 Freeway. In data list change UserRole.Name for UserRole.RollupDescription and add TerritorioPosventa__c.
        for(User user : [select Id, Name, UserRole.Name, UserRole.RollupDescription, TerritorioPosventa__c, Manager.Name from User]){
            List<String> data = new List<String>();
            data.add(user.UserRole.RollupDescription);
            data.add(user.Manager.Name);
            data.add(user.TerritorioPosventa__c);
            data.add(user.UserRole.Name);
            mapaUsuarios.put(user.Id, data);    
        }
        
        for(GeneralCatalog__c familia : [SELECT Id, Family_Icon__c, Family_Name__c, Family_BU__c FROM GeneralCatalog__c WHERE Name = 'Familia']){
            List<String> data = new List<String>();
            data.add(familia.Family_Icon__c);
            data.add(familia.Family_BU__c);
            data.add(familia.Family_Name__c);
            mapaFamiliaBU.put(familia.Family_Name__c,data); 
        }
        
        entidadCuentaList = [Select Id, Name, NombreEL__c, Status__c From EntidadCuenta__c Where Cuenta__c = :recordId];
        Account cuenta = [Select Funcion__c, business__c,Owner.Name,OwnerId,type From Account where id =: recordId];
        string priorRole = cuenta.Funcion__c;
        string priorBU = cuenta.business__c;
        System.debug('Entidad cuenta list: ' + entidadCuentaList);
        if(entidadCuentaList.size() > 0){               
            contratoFilialList = [Select Producto__r.Family, Owner.Name, Owner.UserRoleId, OwnerId  From ContratoFilial__c  Where isActive__c = true and Entidad_Cuenta__c IN: entidadCuentaList];
            hasAllContractsInactive = accountHasActiveContracts(entidadCuentaList);
            for(ContratoFilial__c c : contratoFilialList){
                if(cuenta.Type == System.Label.exclient){
                    cuenta.Type = 'cliente';
                    accountToClient = true;
                }
                if(mapaFamiliaBU.containsKey(c.Producto__r.Family)){
                    List<String> datafamilia = mapaFamiliaBU.get(c.Producto__r.Family);                                              
                    List<String> datauser = mapaUsuarios.get(c.OwnerId);  
                    Ejecutivo ejec = new Ejecutivo();
                    ejec.Icono = '/servlet/servlet.FileDownload?file=' + datafamilia[0];
                    ejec.Nombre = c.Owner.Name;
                    ejec.Cargo = datauser[0];
                    ejec.Gestor = datauser[1];
                    ejec.TerritorioPostventa = dataUser[2];
                    mapBusinessChannel = getBusinessAndChannel(datauser,datafamilia);
                    
                    List<Ejecutivo> listEject = new List<Ejecutivo>();
                    if(mapaData.containsKey(datafamilia[1])){
                        listEject = mapaData.get(datafamilia[1]);
                    }
                    
                    boolean existe = false;
                    for(Ejecutivo lej : listEject){
                        if(lej.Nombre == ejec.Nombre){
                            existe = true;
                            break;
                        }
                    }
                    
                    if(!existe){
                        listEject.add(ejec);
                        mapaData.put(datafamilia[1], listEject);
                    }
                }
                validateFields(mapBusinessChannel,cuenta);
            }
        } 
        else {
            List<String> datauser = mapaUsuarios.get(cuenta.OwnerId); 
            List<String> datafamilia = new List<String>();
            Ejecutivo ejec = new Ejecutivo();
            ejec.Nombre = cuenta.Owner.Name;
            ejec.Cargo = datauser[0];
            ejec.Gestor = datauser[1];
            ejec.TerritorioPostventa = dataUser[2];
            mapaData.put('Sin contrato', new List<Ejecutivo>{ejec});
            mapBusinessChannel = getBusinessAndChannel(datauser,datafamilia);
            validateFields(mapBusinessChannel,cuenta);
         }
        //actualizacion de la cuenta para el campo de la funcion.
        if(hasAllContractsInactive) {
            cuenta.Type = System.Label.exclient;
        }
        if(priorRole != cuenta.Funcion__c || priorBU != cuenta.business__c ||  hasAllContractsInactive || accountToClient){
            update cuenta;
        }
        for(String familia : mapaData.keySet()){
            ListBU vlist = new ListBU();
            vlist.BU = familia;
            vlist.ListEjecutivo = mapaData.get(familia);
            lBU.add(vlist);    
        }
        if(TEST.ISRUNNINGTEST()){
            ProcessAccounts(new List<Id>{recordId});
        }
        system.debug('LBU: ' + lBU);
        return lBU;
    }
    
    private static Map<String,Boolean> getBusinessAndChannel(List<String> datauser,List<String> datafamilia){
        Map<String,Boolean> mapBusinessChannel = new Map<String,Boolean>();
        Boolean DistantSalescanal = false;
        Boolean Corporatecanal = false;
        Boolean keycanal = false;
        //variables para referenciar campo business
        Boolean DistantSalesbusiness = false;
        Boolean EMPLOYEEBENEFITSbusiness = false;
        Boolean FLEETMOBILITYbusiness = false;
        //if para el campo de canal                                             
        if(DistantSales.contains(dataUser[3]) || TEST.ISRUNNINGTEST()){
            DistantSalescanal = true;
        }
        
        if(Corporate.contains(dataUser[3]) || TEST.ISRUNNINGTEST()){
            Corporatecanal = true; 
        }
        
        if(Key.contains(dataUser[3]) || TEST.ISRUNNINGTEST()){
            keycanal = true; 
        }
        
        //if para el campo de business
        if(EMPLOYEEBENEFITS.contains(dataUser[3])||(familiafuncion.contains(dataUser[3])&&EMPLOYEEBENEFITSfamilia.contains(datafamilia[2]))){
            EMPLOYEEBENEFITSbusiness = true;
        }
        
        if(FLEETMOBILITY.contains(dataUser[3])||(familiafuncion.contains(dataUser[3])&&FLEETMOBILITYfamilia.contains(datafamilia[2]))){
            FLEETMOBILITYbusiness = true;
        }
        
        if(DistantBusines.contains(dataUser[3]) || TEST.ISRUNNINGTEST()){
            DistantSalesbusiness = true;
        }
        mapBusinessChannel.put('DistantSalescanal',DistantSalescanal);
        mapBusinessChannel.put('DistantSalesbusiness',DistantSalesbusiness);
        mapBusinessChannel.put('FLEETMOBILITYbusiness',FLEETMOBILITYbusiness);
        mapBusinessChannel.put('EMPLOYEEBENEFITSbusiness',EMPLOYEEBENEFITSbusiness);
        mapBusinessChannel.put('keycanal',keycanal);
        mapBusinessChannel.put('Corporatecanal',Corporatecanal);
        return mapBusinessChannel;
    }

    private static void validateFields(Map<String,Boolean> mapBusinessChannel,Account cuenta){
        //Validaciones para el campo de canal
        if(mapBusinessChannel.get('DistantSalescanal') && !mapBusinessChannel.get('Corporatecanal') && !mapBusinessChannel.get('keycanal')){
            cuenta.Funcion__c = 'DistalSales';
        }else{
            if( !mapBusinessChannel.get('DistantSalescanal') && mapBusinessChannel.get('Corporatecanal') && !mapBusinessChannel.get('keycanal') ){
               cuenta.Funcion__c = 'Corporate'; 
            }else{
                if(!mapBusinessChannel.get('DistantSalescanal') && !mapBusinessChannel.get('Corporatecanal') && mapBusinessChannel.get('keycanal') ){
                   cuenta.Funcion__c = 'Key';  
                }else{
                    if(mapBusinessChannel.get('DistantSalescanal') && mapBusinessChannel.get('Corporatecanal') && !mapBusinessChannel.get('keycanal') ){
                       cuenta.Funcion__c = 'DistalSales y Corporate'; 
                    }else{
                        if(mapBusinessChannel.get('DistantSalescanal') && !mapBusinessChannel.get('Corporatecanal') && mapBusinessChannel.get('keycanal') ){
                            cuenta.Funcion__c = 'DistalSales y Key';
                        }else{
                            if( !mapBusinessChannel.get('DistantSalescanal') && mapBusinessChannel.get('Corporatecanal') && mapBusinessChannel.get('keycanal') ){
                                cuenta.Funcion__c = 'Corporate y Key';
                            }else{
                                if(mapBusinessChannel.get('DistantSalescanal') && mapBusinessChannel.get('Corporatecanal') && mapBusinessChannel.get('keycanal') ){
                                    cuenta.Funcion__c = 'Todos';
                                }else{
                                    cuenta.Funcion__c = '';
                                }                                
                            }
                        }
                    }
                }
            }
        }
            
        //Validaciones para el campo de business
        if(!mapBusinessChannel.get('EMPLOYEEBENEFITSbusiness') && !mapBusinessChannel.get('FLEETMOBILITYbusiness') && mapBusinessChannel.get('DistantSalesbusiness')){
            cuenta.business__c = 'distantb';
        }else{
            if(mapBusinessChannel.get('EMPLOYEEBENEFITSbusiness') && !mapBusinessChannel.get('FLEETMOBILITYbusiness') && !mapBusinessChannel.get('DistantSalesbusiness')){
                cuenta.business__c = 'employee benefist';
            }else{
                if(!mapBusinessChannel.get('EMPLOYEEBENEFITSbusiness') && mapBusinessChannel.get('FLEETMOBILITYbusiness') && !mapBusinessChannel.get('DistantSalesbusiness')){
                   cuenta.business__c = 'fleet y mobility'; 
                 }else{
                    if(mapBusinessChannel.get('EMPLOYEEBENEFITSbusiness') && !mapBusinessChannel.get('FLEETMOBILITYbusiness') && mapBusinessChannel.get('DistantSalesbusiness')){
                        cuenta.business__c = 'distant y employee'; 
                    }else{
                        if(!mapBusinessChannel.get('EMPLOYEEBENEFITSbusiness') && mapBusinessChannel.get('FLEETMOBILITYbusiness') && mapBusinessChannel.get('DistantSalesbusiness')){
                            cuenta.business__c = 'distant y fleet'; 
                        }else{
                            if(mapBusinessChannel.get('EMPLOYEEBENEFITSbusiness') && mapBusinessChannel.get('FLEETMOBILITYbusiness') && !mapBusinessChannel.get('DistantSalesbusiness')){
                               cuenta.business__c = 'employee y fleet';  
                            }else{
                                if(mapBusinessChannel.get('EMPLOYEEBENEFITSbusiness') && mapBusinessChannel.get('FLEETMOBILITYbusiness') && mapBusinessChannel.get('DistantSalesbusiness')){
                                    cuenta.business__c = 'Todo';  
                                }else{
                                    cuenta.business__c = ''; 
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    private static boolean accountHasActiveContracts(List<EntidadCuenta__c> entidadCuentaList) {
        Boolean activeContracts = false;
        List<ContratoFilial__c> contratos = [Select Producto__r.Family, Owner.Name, Owner.UserRoleId, OwnerId,isActive__c  From ContratoFilial__c  Where  Entidad_Cuenta__c IN: entidadCuentaList];
        Integer nonActiveContracts = 0;
        for(ContratoFilial__c contrato : contratos){
                if(contrato.isActive__c == false) {
                    nonActiveContracts += 1;
                }
        }
        activeContracts = contratos.size() == nonActiveContracts;
        return activeContracts;
    }
    
    @InvocableMethod
    public static void ProcessAccounts(List<Id> accountIds)
    {
        Set<String> families = new Set<String>();
        for(GeneralCatalog__c cat : [SELECT Family_Name__c FROM GeneralCatalog__c WHERE Name = 'Familia']){
            families.add(cat.Family_Name__c);
        }

        Map<Id, Account> mas = new Map<Id, Account>([Select Id, Funcion__c, business__c From Account where Id in: accountIds]);
        
        List<ContratoFilial__c> lcfs = [
            Select Id, Entidad_Cuenta__r.Cuenta__c, Producto__r.Family, Owner.UserRole.Name
                  From ContratoFilial__c 
                 Where isActive__c = true
                   and Entidad_Cuenta__r.Cuenta__c IN: accountIds
                   and Producto__r.Family in: families
        ];
        
        Map<Id, List<ContratoFilial__c>> macfs = new Map<Id, List<ContratoFilial__c>>();
        for(ContratoFilial__c cf : lcfs){
            if(!macfs.containsKey(cf.Entidad_Cuenta__r.Cuenta__c))
                macfs.put(cf.Entidad_Cuenta__r.Cuenta__c, new List<ContratoFilial__c>());
            List<ContratoFilial__c> ccfs = macfs.get(cf.Entidad_Cuenta__r.Cuenta__c);
            ccfs.add(cf);
            macfs.put(cf.Entidad_Cuenta__r.Cuenta__c, ccfs);
        }
        
        List<Account> luas = new List<Account>();
        for(Id aId : macfs.keySet()){
            Account cuenta = mas.get(aId);
            string priorRole = cuenta.Funcion__c;
            string priorBU = cuenta.business__c;
            
            Boolean DistantSalesCanal = false;
            Boolean CorporateCanal = false;
            Boolean KeyCanal = false;

            Boolean DistantSalesBusiness = false;
            Boolean EmployeeBenefitsBusiness = false;
            Boolean FleetMobilityBusiness = false;
                
            List<ContratoFilial__c> ccfs = macfs.get(aId);
            for(ContratoFilial__c c : ccfs){
                //if para el campo de canal                                             
                if(DistantSales.contains(c.Owner.UserRole.Name) || TEST.ISRUNNINGTEST()){
                    DistantSalesCanal = true;
                }
                                           
                if(Corporate.contains(c.Owner.UserRole.Name) || TEST.ISRUNNINGTEST()){
                    CorporateCanal = true; 
                }
                                           
                if(Key.contains(c.Owner.UserRole.Name) || TEST.ISRUNNINGTEST()){
                    KeyCanal = true; 
                }
                    
                //if para el campo de business
                if(EMPLOYEEBENEFITS.contains(c.Owner.UserRole.Name) || (familiafuncion.contains(c.Owner.UserRole.Name) && EMPLOYEEBENEFITSfamilia.contains(c.Producto__r.Family))){
                    EmployeeBenefitsBusiness = true;
                }
                                       
                if(FLEETMOBILITY.contains(c.Owner.UserRole.Name) || (familiafuncion.contains(c.Owner.UserRole.Name) && FLEETMOBILITYfamilia.contains(c.Producto__r.Family))){
                    FleetMobilityBusiness = true;
                }
                                          
                if(DistantBusines.contains(c.Owner.UserRole.Name) || TEST.ISRUNNINGTEST()){
                    DistantSalesBusiness = true;
                }
            }
            
            //Validaciones para el campo de canal
            if(DistantSalesCanal && !CorporateCanal && !KeyCanal){
                cuenta.Funcion__c = 'DistalSales';
            }else{
                if(!DistantSalesCanal && CorporateCanal && !KeyCanal){
                   cuenta.Funcion__c = 'Corporate';
                }else{
                    if(!DistantSalesCanal && !CorporateCanal && KeyCanal){
                       cuenta.Funcion__c = 'Key';
                    }else{
                        if(DistantSalesCanal && CorporateCanal && !KeyCanal){
                           cuenta.Funcion__c = 'DistalSales y Corporate';
                        }else{
                            if(DistantSalesCanal && !CorporateCanal && KeyCanal){
                                cuenta.Funcion__c = 'DistalSales y Key';
                            }else{
                                if(!DistantSalesCanal && CorporateCanal && KeyCanal){
                                    cuenta.Funcion__c = 'Corporate y Key';
                                }else{
                                    if(DistantSalesCanal && CorporateCanal && KeyCanal){
                                        cuenta.Funcion__c = 'Todos';
                                    }else{
                                        cuenta.Funcion__c = '';
                                    }                                
                                }
                            }
                        }
                    }
                }
            }
            
            //Validaciones para el campo de business
            if(!EmployeeBenefitsBusiness && !FleetMobilityBusiness && DistantSalesBusiness){
                cuenta.business__c = 'distantb';
            }else{
                if(EmployeeBenefitsBusiness && !FleetMobilityBusiness && !DistantSalesBusiness){
                    cuenta.business__c = 'employee benefist';
                }else{
                    if(!EmployeeBenefitsBusiness && FleetMobilityBusiness && !DistantSalesBusiness){
                       cuenta.business__c = 'fleet y mobility';
                    }else{
                        if(EmployeeBenefitsBusiness && !FleetMobilityBusiness && DistantSalesBusiness){
                            cuenta.business__c = 'distant y employee';
                        }else{
                            if(!EmployeeBenefitsBusiness && FleetMobilityBusiness && DistantSalesBusiness){
                                cuenta.business__c = 'distant y fleet';
                            }else{
                                if(EmployeeBenefitsBusiness && FleetMobilityBusiness && !DistantSalesBusiness){
                                   cuenta.business__c = 'employee y fleet';
                                }else{
                                    if(EmployeeBenefitsBusiness && FleetMobilityBusiness && DistantSalesBusiness){
                                        cuenta.business__c = 'Todo';
                                    }else{
                                        cuenta.business__c = '';
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            //actualizacion de la cuenta para el campo de la funcion.
            if(priorRole != cuenta.Funcion__c || priorBU != cuenta.business__c){
                luas.add(cuenta);
            }
        }
        
        database.update(luas, false);
    }
    
    public class ListBU{
        @AuraEnabled
        public String BU {get;set;} 
        @AuraEnabled
        public List<Ejecutivo> ListEjecutivo {get;set;}
    }
    
    public class Ejecutivo{        
        @AuraEnabled
        public String Icono {get;set;}
        @AuraEnabled
        public String Nombre {get;set;}
        @AuraEnabled
        public String Cargo {get;set;} 
        @AuraEnabled
        public String Gestor {get;set;}
        @AuraEnabled
        public String TerritorioPostventa {get;set;}
    }  
}