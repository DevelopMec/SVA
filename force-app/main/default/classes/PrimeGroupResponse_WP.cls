public without sharing class PrimeGroupResponse_WP {
    public metaWP meta{get;set;}
    public dataWP data{get;set;}
    public class metaWP{
        public String status{get;set;}
        public List<messageWP> messages{get;set;}        
    }
    public class messageWP{
        public String code{get;set;}
        public String description{get;set;}
        public String level{get;set;}
    }
    public class dataWP{
        public List<primeGroupWP> group_prime_list{get;set;}        
    }
    public class primeGroupWP{
        public Decimal client_identifier{get;set;}
        public Decimal group_identifier{get;set;}
        public Decimal prime_identifier{get;set;}
        public String prime_name{get;set;}
        public Decimal product_identifier{get;set;}
        public Decimal sucursal_identifier{get;set;}
    }
}