@istest 
public class Prospecto_Asignar_Test {

     @isTest(seeAllData=true)
    public static void Test(){
   
        Lead prosp = [Select id From Lead where RecordType.Name IN ('Benefits') LIMIT 1];

        Prospecto_Asignar_CONT.Asignar(prosp.Id);
        
    }
}