public with sharing class JsonGenerator {

    public class A { 
        String str;
        
        public A(String s) { str = s; }
    }

    static void generateJSONContent() {
        
               system.JSONGenerator gen = system.JSON.createGenerator(true);
        

    }
}