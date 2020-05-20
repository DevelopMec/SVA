/**********************************************************************************
Developed by: Freeway Consulting
Author: Hector Diaz
Project:  "Edenred" 
Description: .
---------------------------------------------------------------------------------
Version       Date         Author                   Description
------ ---------- ---------------------------------------------------------------
1.0       14-Mayo-2020      Hector Diaz               Initial version
*************************************************************************************/
public class EDR_OwnerContractsResponseWS_cls{ 

    public List<ErrorList> ErrorList;
    public Boolean Success;
    public String ProcessDate;

    public class ErrorList {
        public String Code;
        public String Message;
    }


}