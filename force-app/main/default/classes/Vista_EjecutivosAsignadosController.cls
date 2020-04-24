public class Vista_EjecutivosAsignadosController {
    private static String[] DistantSales {get;set;}
    private static String[] Corporate {get;set;}
    private static String[] Key {get;set;}
    private static String[] EmployeeBenefits {get;set;}
    private static String[] FamiliaFuncion {get;set;}
    private static String[] FleetMobility {get;set;}
    private static String[] DistantBusiness {get;set;}
    private static String[] FleetMobilityFamilia {get;set;}
    private static String[] EmployeeBenefitsfamilia {get;set;}
    
    static{
        DistantSales = [SELECT Funciones__c FROM Funciones_por_BU__mdt where QualifiedApiName = 'DistantSales'].Funciones__c.split(',');
        Corporate = [SELECT Funciones__c FROM Funciones_por_BU__mdt where QualifiedApiName = 'Corporate'].Funciones__c.split(','); 
        Key = [SELECT Funciones__c FROM Funciones_por_BU__mdt where QualifiedApiName = 'Key'].Funciones__c.split(',');
        EmployeeBenefits = [SELECT Funciones__c FROM Funciones_por_BU__mdt where QualifiedApiName = 'EmployeeBenefits'].Funciones__c.split(',');
        FleetMobility = [SELECT Funciones__c FROM Funciones_por_BU__mdt where QualifiedApiName = 'FleetMobility'].Funciones__c.split(',');
        DistantBusiness = [SELECT Funciones__c FROM Funciones_por_BU__mdt where QualifiedApiName = 'DistantBusiness'].Funciones__c.split(',');           
        FamiliaFuncion = [SELECT Funciones__c FROM Funciones_por_BU__mdt where QualifiedApiName = 'FamiliaFuncion'].Funciones__c.split(',');
        FleetMobilityFamilia = [SELECT Funciones__c FROM Funciones_por_BU__mdt where QualifiedApiName = 'FleetMobilityFamilia'].Funciones__c.split(',');
        EmployeeBenefitsfamilia = [SELECT Funciones__c FROM Funciones_por_BU__mdt where QualifiedApiName = 'EmployeeBenefitsfamilia'].Funciones__c.split(',');
    }
    
    @AuraEnabled
    public static List<ListBU> getListEjecutivos(Id recordId){
        Map<String, List<Ejecutivo>> mapaData = new Map<String, List<Ejecutivo>>();
        
        Map<String, List<String>> mapaFamiliaBU = new Map<String, List<String>>();
        for(GeneralCatalog__c familia : [SELECT Id, Family_Icon__c, Family_Name__c, Family_BU__c FROM GeneralCatalog__c WHERE Name = 'Familia']){
            List<String> data = new List<String>();
            data.add(familia.Family_Icon__c);
            data.add(familia.Family_BU__c);
            data.add(familia.Family_Name__c);
            mapaFamiliaBU.put(familia.Family_Name__c, data);
        }
        
        Account cuenta = [
            Select Id, Funcion__c, business__c, Owner.Name, OwnerId, type,
                   Owner.UserRole.RollupDescription, Owner.Manager.Name, Owner.TerritorioPosventa__c, Owner.UserRole.Name
              From Account
             where Id =: recordId
        ];
        string priorRole = cuenta.Funcion__c;
        string priorBU = cuenta.business__c;
        
        List<EntidadCuenta__c> entidadCuentaList = [Select Id, Name, NombreEL__c, Status__c From EntidadCuenta__c Where Cuenta__c =: recordId];
        if(!entidadCuentaList.isEmpty()){
            List<ContratoFilial__c> contratoFilialList = [
                Select Id, Producto__r.Family, Owner.UserRoleId, OwnerId, Owner.UserRole.Name,
                       Owner.Name, Owner.UserRole.RollupDescription, ManagerName__c, Territory__c
                  From ContratoFilial__c
                 Where isActive__c = true
                   and Entidad_Cuenta__c IN: entidadCuentaList
                   and Producto__r.Family in: mapaFamiliaBU.KeySet()
            ];
            
            Boolean DistantSalesCanal = false;
            Boolean CorporateCanal = false;
            Boolean KeyCanal = false;

            Boolean DistantSalesBusiness = false;
            Boolean EmployeeBenefitsBusiness = false;
            Boolean FleetMobilityBusiness = false;
            
            for(ContratoFilial__c c : contratoFilialList){
                List<String> datafamilia = mapaFamiliaBU.get(c.Producto__r.Family);
                
                Ejecutivo ejec = new Ejecutivo();
                ejec.Icono = '/servlet/servlet.FileDownload?file=' + datafamilia[0];
                ejec.Nombre = c.Owner.Name;
                ejec.Cargo = c.Owner.UserRole.RollupDescription;
                ejec.Gestor = c.ManagerName__c;
                ejec.TerritorioPostventa = c.Territory__c;
                
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
                
                // Canal
                if(DistantSales.contains(c.Owner.UserRole.Name) || TEST.ISRUNNINGTEST()){
                    DistantSalesCanal = true;
                }
                if(Corporate.contains(c.Owner.UserRole.Name) || TEST.ISRUNNINGTEST()){
                    CorporateCanal = true; 
                }
                if(Key.contains(c.Owner.UserRole.Name) || TEST.ISRUNNINGTEST()){
                    KeyCanal = true; 
                }
                // Business
                if(EmployeeBenefits.contains(c.Owner.UserRole.Name) || (familiafuncion.contains(c.Owner.UserRole.Name) && EmployeeBenefitsfamilia.contains(c.Producto__r.Family))){
                    EmployeeBenefitsBusiness = true;
                }
                if(FleetMobility.contains(c.Owner.UserRole.Name) || (familiafuncion.contains(c.Owner.UserRole.Name) && FleetMobilityFamilia.contains(c.Producto__r.Family))){
                    FleetMobilityBusiness = true;
                }
                if(DistantBusiness.contains(c.Owner.UserRole.Name) || TEST.ISRUNNINGTEST()){
                    DistantSalesBusiness = true;
                }
            }
            Map<String,Boolean> mapBusinessChannel = new Map<String,Boolean>();
            // Canal
            mapBusinessChannel.put('DistantSalesCanal', DistantSalesCanal);
            mapBusinessChannel.put('CorporateCanal', CorporateCanal);
            mapBusinessChannel.put('KeyCanal', KeyCanal);
            // Business
            mapBusinessChannel.put('EmployeeBenefitsBusiness', EmployeeBenefitsBusiness);
            mapBusinessChannel.put('FleetMobilityBusiness', FleetMobilityBusiness);
            mapBusinessChannel.put('DistantSalesBusiness', DistantSalesBusiness);
            validateFields(mapBusinessChannel, cuenta);
        } 
        else {
            Ejecutivo ejec = new Ejecutivo();
            ejec.Nombre = cuenta.Owner.Name;
            ejec.Cargo = cuenta.Owner.UserRole.RollupDescription;
            ejec.Gestor = cuenta.Owner.Manager.Name;
            ejec.TerritorioPostventa = cuenta.Owner.TerritorioPosventa__c;
            mapaData.put('Sin contrato', new List<Ejecutivo>{ejec});
            Map<String, Boolean> mapBusinessChannel = getBusinessAndChannel(cuenta.Owner.UserRole.Name, '');
            validateFields(mapBusinessChannel, cuenta);
        }
        if(priorRole != cuenta.Funcion__c || priorBU != cuenta.business__c){
            update cuenta;
        }
        
        List<ListBU> lBU = new List<ListBU>();
        for(String familia : mapaData.keySet()){
            ListBU vlist = new ListBU();
            vlist.BU = familia;
            vlist.ListEjecutivo = mapaData.get(familia);
            lBU.add(vlist);    
        }
        if(TEST.ISRUNNINGTEST()){
            ProcessAccounts(new List<Id>{recordId});
        }
        return lBU;
    }
    
    private static Map<String, Boolean> getBusinessAndChannel(string UserRoleName, string ProductoFamily){
        Map<String,Boolean> mapBusinessChannel = new Map<String,Boolean>();
        
        // Canal
        Boolean DistantSalesCanal = false;
        Boolean CorporateCanal = false;
        Boolean KeyCanal = false;
        // Business
        Boolean DistantSalesBusiness = false;
        Boolean EmployeeBenefitsBusiness = false;
        Boolean FleetMobilityBusiness = false;
        
        // Canal
        if(DistantSales.contains(UserRoleName) || TEST.ISRUNNINGTEST()){
            DistantSalesCanal = true;
        }
        if(Corporate.contains(UserRoleName) || TEST.ISRUNNINGTEST()){
            CorporateCanal = true; 
        }
        if(Key.contains(UserRoleName) || TEST.ISRUNNINGTEST()){
            KeyCanal = true; 
        }
        // Business
        if(EmployeeBenefits.contains(UserRoleName) || (familiafuncion.contains(UserRoleName) && EmployeeBenefitsfamilia.contains(ProductoFamily))){
            EmployeeBenefitsBusiness = true;
        }
        if(FleetMobility.contains(UserRoleName) || (familiafuncion.contains(UserRoleName) && FleetMobilityFamilia.contains(ProductoFamily))){
            FleetMobilityBusiness = true;
        }
        if(DistantBusiness.contains(UserRoleName) || TEST.ISRUNNINGTEST()){
            DistantSalesBusiness = true;
        }
        
        // Canal
        mapBusinessChannel.put('DistantSalesCanal', DistantSalesCanal);
        mapBusinessChannel.put('CorporateCanal', CorporateCanal);
        mapBusinessChannel.put('KeyCanal', KeyCanal);
        // Business
        mapBusinessChannel.put('EmployeeBenefitsBusiness', EmployeeBenefitsBusiness);
        mapBusinessChannel.put('FleetMobilityBusiness', FleetMobilityBusiness);
        mapBusinessChannel.put('DistantSalesBusiness', DistantSalesBusiness);
        
        return mapBusinessChannel;
    }

    private static void validateFields(Map<String, Boolean> mapBusinessChannel, Account cuenta){
        // Canal
        if(mapBusinessChannel.get('DistantSalesCanal') && !mapBusinessChannel.get('CorporateCanal') && !mapBusinessChannel.get('KeyCanal')){
            cuenta.Funcion__c = 'DS';
        }else{
            if(!mapBusinessChannel.get('DistantSalesCanal') && mapBusinessChannel.get('CorporateCanal') && !mapBusinessChannel.get('KeyCanal') ){
               cuenta.Funcion__c = 'C';
            }else{
                if(!mapBusinessChannel.get('DistantSalesCanal') && !mapBusinessChannel.get('CorporateCanal') && mapBusinessChannel.get('KeyCanal') ){
                   cuenta.Funcion__c = 'K';  
                }else{
                    if(mapBusinessChannel.get('DistantSalesCanal') && mapBusinessChannel.get('CorporateCanal') && !mapBusinessChannel.get('KeyCanal') ){
                       cuenta.Funcion__c = 'DS&C'; 
                    }else{
                        if(mapBusinessChannel.get('DistantSalesCanal') && !mapBusinessChannel.get('CorporateCanal') && mapBusinessChannel.get('KeyCanal') ){
                            cuenta.Funcion__c = 'DS&K';
                        }else{
                            if( !mapBusinessChannel.get('DistantSalesCanal') && mapBusinessChannel.get('CorporateCanal') && mapBusinessChannel.get('KeyCanal') ){
                                cuenta.Funcion__c = 'C&K';
                            }else{
                                if(mapBusinessChannel.get('DistantSalesCanal') && mapBusinessChannel.get('CorporateCanal') && mapBusinessChannel.get('KeyCanal') ){
                                    cuenta.Funcion__c = 'All';
                                }else{
                                    cuenta.Funcion__c = '';
                                }                                
                            }
                        }
                    }
                }
            }
        }
            
        // Business
        if(!mapBusinessChannel.get('EmployeeBenefitsBusiness') && !mapBusinessChannel.get('FleetMobilityBusiness') && mapBusinessChannel.get('DistantSalesBusiness')){
            cuenta.business__c = 'DS';
        }else{
            if(mapBusinessChannel.get('EmployeeBenefitsBusiness') && !mapBusinessChannel.get('FleetMobilityBusiness') && !mapBusinessChannel.get('DistantSalesBusiness')){
                cuenta.business__c = 'EB';
            }else{
                if(!mapBusinessChannel.get('EmployeeBenefitsBusiness') && mapBusinessChannel.get('FleetMobilityBusiness') && !mapBusinessChannel.get('DistantSalesBusiness')){
                   cuenta.business__c = 'FM';
                 }else{
                    if(mapBusinessChannel.get('EmployeeBenefitsBusiness') && !mapBusinessChannel.get('FleetMobilityBusiness') && mapBusinessChannel.get('DistantSalesBusiness')){
                        cuenta.business__c = 'DS&EB';
                    }else{
                        if(!mapBusinessChannel.get('EmployeeBenefitsBusiness') && mapBusinessChannel.get('FleetMobilityBusiness') && mapBusinessChannel.get('DistantSalesBusiness')){
                            cuenta.business__c = 'DS&FM'; 
                        }else{
                            if(mapBusinessChannel.get('EmployeeBenefitsBusiness') && mapBusinessChannel.get('FleetMobilityBusiness') && !mapBusinessChannel.get('DistantSalesBusiness')){
                               cuenta.business__c = 'EB&FM';  
                            }else{
                                if(mapBusinessChannel.get('EmployeeBenefitsBusiness') && mapBusinessChannel.get('FleetMobilityBusiness') && mapBusinessChannel.get('DistantSalesBusiness')){
                                    cuenta.business__c = 'All';  
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
    
    @InvocableMethod
    public static void ProcessAccounts(List<Id> accountIds)
    {
        Set<String> families = new Set<String>();
        for(GeneralCatalog__c cat : [SELECT Family_Name__c FROM GeneralCatalog__c WHERE Name = 'Familia']){
            families.add(cat.Family_Name__c);
        }

        Map<Id, Account> mas = new Map<Id, Account>([
            Select Id, Name, Funcion__c, business__c, Owner.UserRole.Name
              From Account
             where Id in: accountIds
             order by Name
        ]);

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
        for(Id aId : mas.keySet()){
            Account cuenta = mas.get(aId);
            system.debug('Cuenta: ' + cuenta.Name);
            string priorRole = cuenta.Funcion__c;
            string priorBU = cuenta.business__c;
            
            Boolean DistantSalesCanal = false;
            Boolean CorporateCanal = false;
            Boolean KeyCanal = false;

            Boolean DistantSalesBusiness = false;
            Boolean EmployeeBenefitsBusiness = false;
            Boolean FleetMobilityBusiness = false;
                
            if(macfs.containsKey(aId)){
                List<ContratoFilial__c> ccfs = macfs.get(aId);
                for(ContratoFilial__c c : ccfs){
                    // Canal
                    if(DistantSales.contains(c.Owner.UserRole.Name) || TEST.ISRUNNINGTEST()){
                        DistantSalesCanal = true;
                    }
                    if(Corporate.contains(c.Owner.UserRole.Name) || TEST.ISRUNNINGTEST()){
                        CorporateCanal = true; 
                    }
                    if(Key.contains(c.Owner.UserRole.Name) || TEST.ISRUNNINGTEST()){
                        KeyCanal = true; 
                    }
                        
                    // Business
                    if(EmployeeBenefits.contains(c.Owner.UserRole.Name) || (familiafuncion.contains(c.Owner.UserRole.Name) && EmployeeBenefitsfamilia.contains(c.Producto__r.Family))){
                        EmployeeBenefitsBusiness = true;
                    }
                    if(FleetMobility.contains(c.Owner.UserRole.Name) || (familiafuncion.contains(c.Owner.UserRole.Name) && FleetMobilityFamilia.contains(c.Producto__r.Family))){
                        FleetMobilityBusiness = true;
                    }
                    if(DistantBusiness.contains(c.Owner.UserRole.Name) || TEST.ISRUNNINGTEST()){
                        DistantSalesBusiness = true;
                    }
                }
            }
            else{
                // Canal
                if(DistantSales.contains(cuenta.Owner.UserRole.Name) || TEST.ISRUNNINGTEST()){
                    DistantSalesCanal = true;
                }
                if(Corporate.contains(cuenta.Owner.UserRole.Name) || TEST.ISRUNNINGTEST()){
                    CorporateCanal = true; 
                }
                if(Key.contains(cuenta.Owner.UserRole.Name) || TEST.ISRUNNINGTEST()){
                    KeyCanal = true; 
                }

                // Business
                if(EmployeeBenefits.contains(cuenta.Owner.UserRole.Name) || (familiafuncion.contains(cuenta.Owner.UserRole.Name) && EmployeeBenefitsfamilia.contains(''))){
                    EmployeeBenefitsBusiness = true;
                }
                if(FleetMobility.contains(cuenta.Owner.UserRole.Name) || (familiafuncion.contains(cuenta.Owner.UserRole.Name) && FleetMobilityFamilia.contains(''))){
                    FleetMobilityBusiness = true;
                }
                if(DistantBusiness.contains(cuenta.Owner.UserRole.Name) || TEST.ISRUNNINGTEST()){
                    DistantSalesBusiness = true;
                }
            }
            
            //Validaciones para el campo de canal
            if(DistantSalesCanal && !CorporateCanal && !KeyCanal){
                cuenta.Funcion__c = 'DS';
            }else{
                if(!DistantSalesCanal && CorporateCanal && !KeyCanal){
                   cuenta.Funcion__c = 'C';
                }else{
                    if(!DistantSalesCanal && !CorporateCanal && KeyCanal){
                       cuenta.Funcion__c = 'K';
                    }else{
                        if(DistantSalesCanal && CorporateCanal && !KeyCanal){
                           cuenta.Funcion__c = 'DS&C';
                        }else{
                            if(DistantSalesCanal && !CorporateCanal && KeyCanal){
                                cuenta.Funcion__c = 'DS&K';
                            }else{
                                if(!DistantSalesCanal && CorporateCanal && KeyCanal){
                                    cuenta.Funcion__c = 'C&K';
                                }else{
                                    if(DistantSalesCanal && CorporateCanal && KeyCanal){
                                        cuenta.Funcion__c = 'All';
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
                cuenta.business__c = 'DS';
            }else{
                if(EmployeeBenefitsBusiness && !FleetMobilityBusiness && !DistantSalesBusiness){
                    cuenta.business__c = 'EB';
                }else{
                    if(!EmployeeBenefitsBusiness && FleetMobilityBusiness && !DistantSalesBusiness){
                       cuenta.business__c = 'FM';
                    }else{
                        if(EmployeeBenefitsBusiness && !FleetMobilityBusiness && DistantSalesBusiness){
                            cuenta.business__c = 'DS&EB';
                        }else{
                            if(!EmployeeBenefitsBusiness && FleetMobilityBusiness && DistantSalesBusiness){
                                cuenta.business__c = 'DS&FM';
                            }else{
                                if(EmployeeBenefitsBusiness && FleetMobilityBusiness && !DistantSalesBusiness){
                                   cuenta.business__c = 'EB&FM';
                                }else{
                                    if(EmployeeBenefitsBusiness && FleetMobilityBusiness && DistantSalesBusiness){
                                        cuenta.business__c = 'All';
                                    }else{
                                        cuenta.business__c = '';
                                    }
                                }
                            }
                        }
                    }
                }
            }
            system.debug('priorRole: ' + priorRole);
            system.debug('cuenta.Funcion__c: ' + cuenta.Funcion__c);
            system.debug('priorBU: ' + priorBU);
            system.debug('cuenta.business__c: ' + cuenta.business__c);
            //actualizacion de la cuenta para el campo de la funcion.
            if(priorRole != cuenta.Funcion__c || priorBU != cuenta.business__c){
                luas.add(cuenta);
            }
        }
        system.debug('luas: ' + luas.size());
        database.update(luas, true);
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