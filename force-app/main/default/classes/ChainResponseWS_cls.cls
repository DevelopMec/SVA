/**********************************************************************************
Developed by: Freeway Consulting
Author: Hector Diaz
Project:  "Edenred" 
Description: .
---------------------------------------------------------------------------------
Version       Date         Author                   Description
------ ---------- ---------------------------------------------------------------
1.0       20-Abril-2020      Hector Diaz               Initial version
*************************************************************************************/
public class ChainResponseWS_cls{
    public Meta meta {get;set;}
    
    public class Meta {
        public List<Messages> messages {get;set;}
        public String status{get;set;}
    }
 
    public class Messages {
        public String code;
        public String description;
    } 

}