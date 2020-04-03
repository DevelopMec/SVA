trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
	set<Id> casesId = new set<id>(); 
    for(ContentDocumentLink att :Trigger.new  ){
        String s1 = String.valueof(att.LinkedEntityId );
        if(s1.startsWithIgnoreCase('500')){
            casesId.add(att.LinkedEntityId );
        }
    }
    if(!casesId.isEmpty()){
       List<Case> caseJira=[SELECT id, IssueCreado__c from Case where id=:casesId and IssueCreado__c=true];
        if(!caseJira.isEmpty()){
            System.debug('INICIOCDL');
        	JCFS.API.pushUpdatesToJira(caseJira, Trigger.old);
        }       
    }
}