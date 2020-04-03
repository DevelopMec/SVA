@isTest
public class MERC_AccountStructure_CTRL_TST {
	@isTest
    public static void testCTRL(){
        
        Account acc = new Account(Name = 'Cuenta prueba', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
		insert acc;
        EntidadLegal__c el = new EntidadLegal__c(Name='PECM961017LJ8', RFC__C= 'PECM961017LJ8');
        insert el;
        EntidadCuenta__c ec = new EntidadCuenta__c(Cuenta__c = acc.Id,EntidadLegal__c = el.Id);
        insert ec;
        Affiliate__c afiliado = new Affiliate__c (Name='Test Afiliado' , isActive__c = true,AccountEntity__c = ec.Id);
        insert afiliado;
        
        MERC_AccountStructure_CTRL.structureWrapper testWrapper = new MERC_AccountStructure_CTRL.structureWrapper();
        testWrapper = MERC_AccountStructure_CTRL.getStructure(acc.id);
		
        system.assertEquals( true, testWrapper.afiliados.size() > 0, 'Se espera lista con afiliados');
    }
}