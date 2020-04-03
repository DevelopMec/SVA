trigger AccountCaseScore on Account (after update) {
    //--English--
    //This Code constitutes an Extra-functionality delivered in order to calculate a Ticket Score taking into account Eight (8) criteria.
    //Ticket Scoring was delivered as an Extra-functionality within the Service Cloud Implementation Project. Extra-Functionalities are not covered by the Project Scope 
    //and Guarantee.
    //One Ticket Scoring Criteria called "Open Tickets Count" is convered by the Trigger OpenCasesRollUpinAccount, it was also delivered as Extra-functionality.
    //AccountCaseScore Trigger works in conjunction with CaseScore Trigger.
    //--Spanish--
    //Este código constituye una Funcionalidad Extra brindada para calcular la Puntuación de un Ticket teniendo en cuenta 8 criterios.
    //La Puntuación de Tickets fue brindada como una Funcionalidad Extra en el Proyecto de Implementación Service Cloud. Las Funcionalidades Extras no están cubiertas por el Alcance
    //del Proyecto y Garantía.
    //Uno de los Criterios de Puntuación de Tickets llamadao "Conteo de Tickets Abiertos" es cubierto por el Trigger OpenCasesRollUpinAccount, este también fue entregado como
    //Funcionalidad Extra.
    //Desencadenador AccountCaseScore trabaja en conjunto con el Desencadenador CaseScore.    
    /*List<Case> casesForScoreUpdate=new List<Case>();
    List<Id> accountIds=new List<Id>();
    for (Account acc : Trigger.New) {
        if (acc.Sector__c!=Trigger.oldMap.get(acc.Id).Sector__c || acc.Segmento2__c!=Trigger.oldMap.get(acc.Id).Segmento2__c || acc.Canal_de_Atencion__c!=Trigger.oldMap.get(acc.Id).Canal_de_Atencion__c || acc.Open_Cases__c!=Trigger.oldMap.get(acc.Id).Open_Cases__c || acc.SumaOportunidadesAbiertas__c!=Trigger.oldMap.get(acc.Id).SumaOportunidadesAbiertas__c || acc.Suma_Amenazas_Atrici_n__c!=Trigger.oldMap.get(acc.Id).Suma_Amenazas_Atrici_n__c) {
            accountIds.add(acc.Id);
        }
    }
    casesForScoreUpdate=[SELECT Id, AccountId, Segmento_Comercial__c, Canal_de_Atencion__c, Sector__c, Oportunidades_Abiertas__c, Amenazas_de_Atricion__c, Sub_Motivo__c, Motivo__c, Temperatura_del_Contacto__c, Score3__c FROM Case WHERE AccountId IN :accountIds];
    System.debug('casesForScoreUpdate: '+casesForScoreUpdate);
    if (!casesForScoreUpdate.isEmpty()) {
        update casesForScoreUpdate;
    }*/
}