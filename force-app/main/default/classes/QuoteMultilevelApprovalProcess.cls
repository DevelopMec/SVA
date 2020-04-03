/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Class to obtain manage second and third approval levels (create aproval process). 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author		Cindy Hernández
* @version      1.0
* @created      5/12/2019
* @change       14/01/2020. Path added for first approval level.
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public class QuoteMultilevelApprovalProcess {
    
/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* @description	Method to get initial list of quotes that aply for next approval process.
Create approval process obtainen from getNextApprovers.
* @params 		List<Quote> newQuoteList. Quotes being updated.
Map<Id, Quote> oldQuoteMap. Quote map with the old values.
* @return		void.
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/     
    public static void sendNextApprovalProcess(List<Quote> newQuoteList, Map<Id, Quote> oldQuoteMap) {
        List<String> ownerIdForFirstApproval = new List<String>();
        List<Quote> quotesToLevel1 = new List<Quote>();
        List<String> ownerIdForSecondApproval = new List<String>();
        List<Quote> quotesToLevel2 = new List<Quote>();
        List<String> ownerIdForThirdApproval = new List<String>();
        List<Quote> quotesToLevel3 = new List<Quote>();
        
        for(Quote qte: newQuoteList) {
            //Get the old object record, and check if the GrantedApprovalLevel__c has been updated to 1. If so, put it in a map.
            Quote oldQuote = oldQuoteMap.get(qte.Id);
            if ((qte.RequiredApprovalLevel__c == 1 || qte.RequiredApprovalLevel__c == 2 || qte.RequiredApprovalLevel__c == 3) && oldQuote.GrantedApprovalLevel__c == null &&  qte.GrantedApprovalLevel__c == 0) { 
                ownerIdForFirstApproval.add(qte.OwnerId);
                quotesToLevel1.add(qte);
            } else if ((qte.RequiredApprovalLevel__c == 2 || qte.RequiredApprovalLevel__c == 3) && oldQuote.GrantedApprovalLevel__c == 0 &&  qte.GrantedApprovalLevel__c == 1) { 
                ownerIdForSecondApproval.add(qte.OwnerId);
                quotesToLevel2.add(qte);
            } else if (qte.RequiredApprovalLevel__c == 3 && oldQuote.GrantedApprovalLevel__c == 1 &&  qte.GrantedApprovalLevel__c == 2) {
                ownerIdForThirdApproval.add(qte.OwnerId);
                quotesToLevel3.add(qte);
            }
        }
        Boolean isFuelOrPerDiem1 = false;
        Boolean isFuelOrPerDiem2 = false;
        Boolean isFuelOrPerDiem3 = false;
        //Check if the quote apply for the Fuel or PerDiem exception
        if(!quotesToLevel1.isEmpty()){
            List<Quote> oppInfo1 = new List<Quote>([SELECT Opportunity.Familia__c FROM Quote WHERE Id IN: quotesToLevel1 
                                                    AND (Opportunity.Familia__c = 'Combustible' 
                                                         OR Opportunity.Familia__c = 'Empresarial')]);
            if(!oppInfo1.isEmpty()){
                isFuelOrPerDiem1 = true;             
            }
        }
        if(!quotesToLevel2.isEmpty()){
            List<Quote> oppInfo2 = new List<Quote>([SELECT Opportunity.Familia__c FROM Quote WHERE Id IN: quotesToLevel2 
                                                    AND (Opportunity.Familia__c = 'Combustible' 
                                                         OR Opportunity.Familia__c = 'Empresarial')]);
            if(!oppInfo2.isEmpty()){
                isFuelOrPerDiem2 = true;             
            }
        }
        if(!quotesToLevel3.isEmpty()){
            List<Quote> oppInfo3 = new List<Quote>([SELECT Opportunity.Familia__c FROM Quote WHERE Id IN: quotesToLevel3 
                                                    AND (Opportunity.Familia__c = 'Combustible' 
                                                         OR Opportunity.Familia__c = 'Empresarial')]);
            if(!oppInfo3.isEmpty()){
                isFuelOrPerDiem3 = true;             
            }
        }
        Approval.ProcessSubmitRequest [] requestList = new Approval.ProcessSubmitRequest []{};
            if (!ownerIdForFirstApproval.isEmpty()) { 
                Approval.ProcessSubmitRequest [] reqs1 = getNextApprovers(ownerIdForFirstApproval, quotesToLevel1, 1, isFuelOrPerDiem1);
                requestList.addAll(reqs1);
            }
        if (!ownerIdForSecondApproval.isEmpty()) { 
            Approval.ProcessSubmitRequest [] reqs2 = getNextApprovers(ownerIdForSecondApproval, quotesToLevel2, 2, isFuelOrPerDiem2);
            requestList.addAll(reqs2);
        }
        if (!ownerIdForThirdApproval.isEmpty()) { 
            Approval.ProcessSubmitRequest [] reqs3 = getNextApprovers(ownerIdForThirdApproval, quotesToLevel3, 3, isFuelOrPerDiem3);
            requestList.addAll(reqs3);
        }
        
        if(!requestList.isEmpty()) {
            Approval.ProcessResult[] result = Approval.process(requestList);
        }
    }
    
    /**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* @description	Method to obtain the next approver and build the approval process.
* @params 		List<String> ownerIdsForApproval. Quote owner ids list.
List<Quote> quotesToApprove. List of quotes to be approved for the next level.
Integer approvalLevel. Next approval level required (Example: 2).
Boolean isFuelOrPerDiem. True if the approval process aply for Fuel or Per Diem
exception.
* @return		Approval.ProcessSubmitRequest []. Approval process to be sended array.
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/         
    public static Approval.ProcessSubmitRequest [] getNextApprovers(List<String> ownerIdsForApproval, List<Quote> quotesToApprove, Integer approvalLevel, Boolean isFuelOrPerDiem) {
        Set<User> ownerRoleList = new Set<User>([Select Id, UserRole.Name FROM User WHERE Id IN: ownerIdsForApproval]);
        Map<Id, String> ownerRoleNames = new Map<Id, String>(); 
        for(User u: ownerRoleList) {
            ownerRoleNames.put(u.Id, u.UserRole.Name);
        }
        List<QuoteApprovalProcessHierarchy__mdt> approvalLevels = new List<QuoteApprovalProcessHierarchy__mdt>(); 
        if(isFuelOrPerDiem){
            //Queries to mdt does not accept OR but the queries does not count against the limits
            approvalLevels = [SELECT ApprovalLevel1__c, ApprovalLevel2__c, ApprovalLevel3__c, 
                              ApprovalLevel4__c, Fuel_PerDiem__c FROM QuoteApprovalProcessHierarchy__mdt WHERE 
                              ApprovalLevel1__c IN: ownerRoleNames.values() AND ApprovalLevel1__c = 'Ejecutivo Multiproducto Region Noroeste'
                              AND Fuel_PerDiem__c = true];
            List<QuoteApprovalProcessHierarchy__mdt> otherApproval = new List<QuoteApprovalProcessHierarchy__mdt>([SELECT ApprovalLevel1__c, ApprovalLevel2__c, ApprovalLevel3__c, 
                                                                                                                   ApprovalLevel4__c, Fuel_PerDiem__c FROM QuoteApprovalProcessHierarchy__mdt WHERE 
                                                                                                                   ApprovalLevel1__c IN: ownerRoleNames.values() AND ApprovalLevel1__c = 'Ejecutivo Multiproducto Region Sureste'
                                                                                                                   AND Fuel_PerDiem__c = true]); 
            List<QuoteApprovalProcessHierarchy__mdt> otherApproval2 = new List<QuoteApprovalProcessHierarchy__mdt>([SELECT ApprovalLevel1__c, ApprovalLevel2__c, ApprovalLevel3__c, 
                                                                                                                    ApprovalLevel4__c, Fuel_PerDiem__c FROM QuoteApprovalProcessHierarchy__mdt WHERE 
                                                                                                                    ApprovalLevel1__c != 'Ejecutivo Multiproducto Region Noroeste' 
                                                                                                                    AND ApprovalLevel1__c != 'Ejecutivo Multiproducto Region Sureste' AND Fuel_PerDiem__c = false]); 
            approvalLevels.addAll(otherApproval);
            approvalLevels.addAll(otherApproval2);
            
        } else {
            approvalLevels = [SELECT ApprovalLevel1__c, ApprovalLevel2__c, ApprovalLevel3__c, 
                              ApprovalLevel4__c, Fuel_PerDiem__c FROM QuoteApprovalProcessHierarchy__mdt WHERE 
                              ApprovalLevel1__c IN: ownerRoleNames.values() AND Fuel_PerDiem__c = false];
        }
        List<String> hierarchyRoles = new List<String>();
        for(QuoteApprovalProcessHierarchy__mdt hierarchy: approvalLevels) {
            if(approvalLevel == 1){
                hierarchyRoles.add(hierarchy.ApprovalLevel2__c);
            }
            if(approvalLevel == 2){
                hierarchyRoles.add(hierarchy.ApprovalLevel3__c);
            }
            if (approvalLevel == 3) {
                hierarchyRoles.add(hierarchy.ApprovalLevel4__c);
            }
        }
        Set<User> userHierarchyList = new Set<User>([Select Id, UserRole.Name FROM User WHERE UserRole.Name IN: hierarchyRoles
                                                     AND IsActive = true]);
        Map<String, Id> userHierarchyMap = new Map<String, Id>(); 
        for(User u: userHierarchyList) {
            userHierarchyMap.put(u.UserRole.Name, u.Id);
        }
        Map<String, Id> ownerRoleApproverId = new Map<String, Id>();
        List<String> ownerRoleToSkipApproval = new List<String>();
        for (QuoteApprovalProcessHierarchy__mdt approval : approvalLevels) {
            if (approvalLevel == 1 && userHierarchyMap.containsKey(approval.ApprovalLevel2__c)){
                ownerRoleApproverId.put(approval.ApprovalLevel1__c, userHierarchyMap.get(approval.ApprovalLevel2__c));
            } else if (approvalLevel == 1 && !userHierarchyMap.containsKey(approval.ApprovalLevel2__c)) {
                //Quote que no entrará a la aprobación 1 y GantedApprovalLevel se debe updatear a 1.
                ownerRoleToSkipApproval.add(approval.ApprovalLevel1__c);
            }
            if (approvalLevel == 2 && userHierarchyMap.containsKey(approval.ApprovalLevel3__c)){
                ownerRoleApproverId.put(approval.ApprovalLevel1__c, userHierarchyMap.get(approval.ApprovalLevel3__c));
            } else if (approvalLevel == 2 && !userHierarchyMap.containsKey(approval.ApprovalLevel3__c)) {
                //Quote que no entrará a la aprobación 2 y GantedApprovalLevel se debe updatear a 2.
                ownerRoleToSkipApproval.add(approval.ApprovalLevel1__c);
            }
            if (approvalLevel == 3 && userHierarchyMap.containsKey(approval.ApprovalLevel4__c)){
                ownerRoleApproverId.put(approval.ApprovalLevel1__c, userHierarchyMap.get(approval.ApprovalLevel4__c));
            } else if (approvalLevel == 3 && !userHierarchyMap.containsKey(approval.ApprovalLevel4__c)) {
                //Quote que no entrará a la aprobación 3 y GantedApprovalLevel se debe updatear a 3.
                ownerRoleToSkipApproval.add(approval.ApprovalLevel1__c);
            }
        }
        Map<Id, Id> ownerIdApproverId = new Map<Id, Id>(); 
        for (User u : ownerRoleList) {
            if(ownerRoleApproverId.containsKey(u.UserRole.Name)) {
                ownerIdApproverId.put(u.Id, ownerRoleApproverId.get(u.UserRole.Name));
            }
        }
        Approval.ProcessSubmitRequest [] requestList = new Approval.ProcessSubmitRequest []{};
            if(!ownerIdApproverId.isEmpty()) {
                String ApprovalLevelName = '';
                if (approvalLevel == 1){
                    ApprovalLevelName = 'QuoteApprovalLevel1';
                } else if (approvalLevel == 2){
                    ApprovalLevelName = 'QuoteApprovalLevel2';
                } else if(approvalLevel == 3){
                    ApprovalLevelName = 'QuoteApprovalLevel3';
                }
                for(Quote quoteToApprove : quotesToApprove) {
                    if(ownerIdApproverId.containsKey(quoteToApprove.OwnerId)) {
                        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                        req1.setComments(quoteToApprove.ApprovalRequestComments__c);
                        req1.setObjectId(quoteToApprove.Id);
                        req1.setProcessDefinitionNameOrId(ApprovalLevelName);
                        req1.setNextApproverIds(new Id[] {ownerIdApproverId.get(quoteToApprove.OwnerId)});
                        req1.setSkipEntryCriteria(false);
                        req1.setSubmitterId(quoteToApprove.OwnerId);
                        
                        requestList.add(req1);
                    }
                }
            }
        List<Quote> quotesToSkip = new List<Quote>();
        if(!ownerRoleToSkipApproval.isEmpty()) {
            for(Quote quoteToApprove : quotesToApprove) {
                //Update GrantedApprovalLevel__c to next level witouth the approval because there is not active user to approve.
                if (ownerRoleNames.containsKey(quoteToApprove.OwnerId) && ownerRoleToSkipApproval.contains(ownerRoleNames.get(quoteToApprove.OwnerId))) {
                    Quote quoteToSkipApproval = new Quote(Id = quoteToApprove.Id,
                                                          GrantedApprovalLevel__c = quoteToApprove.GrantedApprovalLevel__c + 1);
                    quotesToSkip.add(quoteToSkipApproval);
                }	    
            }
        }
        if(!quotesToSkip.isEmpty()) {
            update quotesToSkip;    
        }
        return requestList;
    }
    
    /**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* @description	Method to make the rejected comments mandatory. When the approval procces is
rejected it updates the Quote ApprovalStatus__c field.
* @params 		List<Quote> newQuoteList. Quotes being updated.
Map<Id, Quote> oldQuoteMap. Quote map with the old values.
* @return		void.
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/      
    /*Description: */
    public static void makeCommentsRequired(List<Quote> newQuoteList, Map<Id, Quote> quoteOldMap) {
        Map<Id, Quote> rejectedQuotes = new Map<Id, Quote>();
        for(Quote qte: newQuoteList) {
            //Get the old object record, and check if the approval status field has been updated to rejected. If so, put it in a map.
            Quote oldQuote = quoteOldMap.get(qte.Id);
            
            if ((oldQuote.ApprovalStatus__c != 'Rechazada' && qte.ApprovalStatus__c == 'Rechazada') || (oldQuote.ApprovalStatus__c != 'Aprobada' && qte.ApprovalStatus__c == 'Aprobada')) { 
                rejectedQuotes.put(qte.Id, qte);  
            }
        }
        
        if (!rejectedQuotes.isEmpty()) {
            //Get the most recent approval process instance for the object.
            List<Id> processInstanceIds = new List<Id>{};
                
                for (Quote quotes : [SELECT (SELECT ID FROM ProcessInstances ORDER BY CreatedDate DESC LIMIT 1) FROM Quote
                                     WHERE ID IN :rejectedQuotes.keySet()]) {
                                         processInstanceIds.add(quotes.ProcessInstances[0].Id);
                                     }
            
            //Now that we have the most recent process instances, we can check the most recent process steps for comments.  
            for (ProcessInstance pInstance : [SELECT TargetObjectId, (SELECT Id, StepStatus, Comments FROM Steps 
                                                                      ORDER BY CreatedDate DESC LIMIT 1) FROM ProcessInstance WHERE Id IN :processInstanceIds
                                              ORDER BY CreatedDate DESC]) {          
                                                  if ((pInstance.Steps[0].Comments == null || pInstance.Steps[0].Comments.trim().length() == 0)) {
                                                      rejectedQuotes.get(pInstance.TargetObjectId).addError('Favor de incluir los comentarios.');
                                                  }
                                              }  
        }
    }
    
}