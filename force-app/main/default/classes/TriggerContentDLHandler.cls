public with sharing class TriggerContentDLHandler extends TriggerHandler {
    private Map<Id, ContentDocumentLink> newMap;
    private Map<Id, ContentDocumentLink> oldMap;
    private List<ContentDocumentLink> newList;
    private List<ContentDocumentLink> oldList;

    public TriggerContentDLHandler() {
        this.newMap = (Map<Id, ContentDocumentLink>) trigger.newMap;
        this.oldMap = (Map<Id, ContentDocumentLink>) trigger.oldMap;
        this.newList = (List<ContentDocumentLink>) trigger.new;
        this.oldList = (List<ContentDocumentLink>) trigger.old;
    }

    public override void afterInsert() {
        doSigloProcess();
        doDocumentSignProcess();
    }

    private void doSigloProcess() {
        set<Id> casesId = new set<id>(); 
        for(ContentDocumentLink att : this.newList  ){
            String s1 = String.valueof(att.LinkedEntityId );
            if(s1.startsWithIgnoreCase('500')){
                casesId.add(att.LinkedEntityId );
            }
        }
        if(!casesId.isEmpty()){
            List<Case> caseJira=[SELECT id, IssueCreado__c from Case where id=:casesId and IssueCreado__c=true];
            if(!caseJira.isEmpty()){
                System.debug('INICIOCDL');
        	    JCFS.API.pushUpdatesToJira(caseJira, this.oldList);
            }       
        }
    }
    private void doDocumentSignProcess() {
        List<String> docuSignIds = getDocuSignData();
        Map<Id,dsfs__DocuSign_Status__c> docuSignMap= new Map<Id,dsfs__DocuSign_Status__c>([SELECT Id,dsfs__Opportunity__c FROM dsfs__DocuSign_Status__c WHERE Id IN : docuSignIds]);
        duplicateDocumentLink(docuSignMap);
    }

    private List<String> getDocuSignData() {
        List<String> docuSignList = new List<String>();
        for(ContentDocumentLink cdLink : this.newList) {
            String sobjectType = cdLink.LinkedEntityId.getSObjectType().getDescribe().getName();
            if(sobjectType == 'dsfs__DocuSign_Status__c' || sobjectType ==  'DocuSign_Status__c') {
                docuSignList.add(cdLink.LinkedEntityId);
            }
        }
        return docuSignList;
    }
    private void duplicateDocumentLink(Map<Id,dsfs__DocuSign_Status__c> docuSignMap) {
        List<ContentDocumentLink> documentLinkList = new List<ContentDocumentLink>();
        if(docuSignMap.size() > 0 ) {
            for(ContentDocumentLink cdLink : this.newList) {
                if(docuSignMap.get(cdLink.LinkedEntityId) != null) {
                    ContentDocumentLink newContentLink = cdLink.clone(false,false,false,false);
                    newContentLink.LinkedEntityId = docuSignMap.get(cdLink.LinkedEntityId).dsfs__Opportunity__c;
                    documentLinkList.add(newContentLink);
                }
            }
        }
    }

}
