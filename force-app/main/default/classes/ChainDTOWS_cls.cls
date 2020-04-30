/**********************************************************************************
Developed by: Freeway Consulting
Author: Hector Diaz
Project:  "Edenred" 
Description: .
---------------------------------------------------------------------------------
Version       Date         Author                   Description
------ ---------- ---------------------------------------------------------------
1.0       20-Abril-2020      Hector Diaz               Initial versionn
***************************************************************************************/
public class ChainDTOWS_cls{

    public class ChainRequest{
        Chain chain {get;set;}

        public ChainRequest(Chain chain){
           this.chain = chain;
        }
    } 

    public class Chain {
	    public Integer option {get;set;}
		public String crm_number {get;set;}
		public Integer branch {get;set;}
		public Integer product {get;set;}
		public Integer chain_identifier {get;set;}
		public String name {get;set;}
		public String address {get;set;}
		public String settlement {get;set;}
		public Integer zip_code {get;set;}
		public Long phone_number {get;set;}
		public String contact_name {get;set;}
		public String job_title {get;set;}
		public String chain_status {get;set;}
		public Integer total_refund_amount {get;set;}
		public Integer total_refund_bonuses {get;set;}
		public Integer commission_total {get;set;}
		public String record_id {get;set;}
		public Integer vip_merchant {get;set;}
		public Integer red_code {get;set;}
		public Integer red_user {get;set;}
        public String user {get;set;} 

        public Chain(){
            this.option = 1;
            this.crm_number = '1234573'; //1234572  erro:123456
            this.branch = 1;
            this.product = 32;
            this.chain_identifier = 9102;
            this.name = 'Hector';
            this.address = 'calle 2 100';
            this.settlement = 'Polanco';
          //  this.zip_code =  11520; 
            this.phone_number = 585469953;
            this.contact_name = 'Juanito';
            this.job_title = 'Ingeniero';
            this.chain_status = 'A';
            this.total_refund_amount = 111;
            this.total_refund_bonuses = 111;
            this.commission_total = 111;
            this.record_id = '12345';
            this.vip_merchant = 1;
            this.red_code = 1234;
            this.red_user = 123;
            this.user = '*AN1';
        }
	}
}