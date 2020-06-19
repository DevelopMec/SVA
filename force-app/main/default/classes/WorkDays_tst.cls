/**********************************************************************************
Developed by: Freeway Consulting
Author: Hector Diaz
Project:  "Edenred" 
Description: .
---------------------------------------------------------------------------------
Version       Date         Author                   Description
------ ---------- ---------------------------------------------------------------
1.0       18-Mayo-2020      Hector Diaz               Initial version
*************************************************************************************/
@isTest
public class WorkDays_tst {

    @isTest static void testMethodgetWorkDays(){         

        Test.startTest();
            WorkDays.getWorkDays(Datetime.now(),Datetime.now().addDays(5));
        Test.stopTest();
    }
}