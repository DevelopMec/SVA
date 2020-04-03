@isTest
public class Reasignacion_oportunidad_CONT_Tst {
	@isTest
    public static void obtenerUsuariosTest(){
        Reasignacion_oportunidad_CONT.obtenerUsuarios();
    }
    /*@isTest
    public static void reasignarOppTest(){
        Opportunity opp=new Opportunity(Name='test',StageName='Won', CloseDate=Date.today());
        insert opp;
        User us= [SELECT Id FROM User WHERE UserRole.DeveloperName = 'CRM_Manager' AND IsActive = true ORDER BY Name LIMIT 1];
        Reasignacion_oportunidad_CONT.reasignarOpp(opp.Id, us.Id);
    }*/
    @isTest
    public static void reasignarOppCampaignTest(){        
        Account acc=new Account(Name='test');
        insert acc;
        Contact con=new Contact(FirstName='test',LastName='test',AccountId=acc.Id);
        insert con;        
        Opportunity opp=new Opportunity(Name='test',StageName='Won', CloseDate=Date.today(),Contacto__c=con.Id,AccountId=acc.Id);
        insert opp;
        Campaign cam=new Campaign(Name='Apadrinados');
        insert cam;
        User us= [SELECT Id FROM User WHERE UserRole.DeveloperName = 'CRM_Manager' AND IsActive = true ORDER BY Name LIMIT 1];
        Reasignacion_oportunidad_CONT.reasignarOpp(opp.Id, us.Id);
    }
}