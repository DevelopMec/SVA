/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Class to obtain and insert comments related to an approval process related to a quote.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author		Cindy Hernández
* @version      1.0
* @created      5/12/2019
* @change		06/01/2020 Reference to Schema.Quote.getSObjectType is replaced to comparison with 
				string Id to avoid errors caused by permissions (Lines 45, 59).
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public with sharing class ApprovalProcessCustomCommentsController {
    
    /*public class allApprovalInfo{
        @AuraEnabled public List<Comment__c> comments{get;set;}
        @AuraEnabled public Boolean isQuote{get;set;}
        @AuraEnabled public Boolean isPending{get;set;}
    }*/
    
    
/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* @description	Method to obtain the comments related to the ProcessInstanceStep or
				ProcessInstanceWorkItem.
* @params 		String recordId. Id from the current record.
* @return		allApprovalInfo. Wrapper with a list of comments, a boolean to determine if the
				object related to de ProcessInstance is a Quote(also works to specify when the
				approval process had been approved or rejected an there are no comments) and
				another boolean to specify if the ProcessInstanceWorkItem is pending.
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/    
    @AuraEnabled
    public static String getCommentsInfo(String recordId) {
    /*   allApprovalInfo res = new allApprovalInfo(); 
        Set<Id> idToSearchFor = new Set<Id>();
        Id recordIdCast = recordId;
        Boolean isQuote = false;
        Boolean isPending = false;
        //Identify if the current record is a ProcessInstanceStep or a ProcessInstanceWorkItem and get the necesary data. 
        if (recordIdCast.getSobjectType() == Schema.ProcessInstanceStep.getSObjectType()) {
            List<ProcessInstanceStep> stepInfo = [Select ProcessInstanceId, ProcessInstance.TargetObjectId, ProcessInstance.Status
                                                  From ProcessInstanceStep Where Id =: recordId];
            if (!stepInfo.isEmpty()) {
            	if (String.valueOf(stepInfo[0].ProcessInstance.TargetObjectId).StartsWith('0Q0')){
                    isQuote = true;
                    if(stepInfo[0].ProcessInstance.Status == 'Pending') {
                        isPending = true;
                    }
                    for (ProcessInstanceStep step : stepInfo) {
                        idToSearchFor.add(step.ProcessInstanceId);
                    }
                }
        	}
        } else if (recordIdCast.getSobjectType() == Schema.ProcessInstanceWorkItem.getSObjectType()) {
            List<ProcessInstanceWorkItem> instanceWIInfo = [Select ProcessInstanceId, ProcessInstance.TargetObjectId, ProcessInstance.Status
                                                            From ProcessInstanceWorkItem Where Id =: recordId];
            if (!instanceWIInfo.isEmpty()) {
            	if (String.valueOf(instanceWIInfo[0].ProcessInstance.TargetObjectId).StartsWith('0Q0')){
                    isQuote = true;
                    if(instanceWIInfo[0].ProcessInstance.Status == 'Pending') {
                        isPending = true;
                    }
                    for (ProcessInstanceWorkItem instanceWI : instanceWIInfo) {
                        idToSearchFor.add(instanceWI.ProcessInstanceId);
                    }
                }
        	}
        }
        List<Comment__c> commentsList = new List<Comment__c>();
        //Only get the comments if the record related to the ProcessInstance is a Quote.
        if (isQuote) {
            commentsList = [SELECT Comment__c, CreatedDate, CreatedBy.Name FROM Comment__c 
                                                                  WHERE ProcessInstance__c IN: idToSearchFor 
                                                                  ORDER BY CreatedDate ASC];
            res.comments = commentsList;
        }
        res.isPending = isPending;
        //If the approval process had been  rejected or approved and there are not comments, the component is not shown.
        if (!isPending && commentsList.isEmpty()) {
            isQuote = false;
        }
        res.isQuote = isQuote;
        return res;*/
        return null;
    }

/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* @description	Method to insert a new comment.
* @params 		String recordId. Id from the current record.
				String comment. The submitter comment.
* @return		void.
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/    
    /*@AuraEnabled
    public static void insertComments(String recordId, String comment) {
        Id recordIdCast = recordId;
        String processInstance = '';
        String processInstanceWI = '';
        String submitter = '';
        String approver = '';
        //Identify if the current record is a ProcessInstanceStep or a ProcessInstanceWorkItem and get the necesary data. 
        if (recordIdCast.getSobjectType() == Schema.ProcessInstanceStep.getSObjectType()) {
            List<ProcessInstanceStep> stepInfo = [Select ProcessInstanceId, ProcessInstance.SubmittedById From ProcessInstanceStep Where Id =: recordId];
            List<ProcessInstanceWorkItem> wIInfo = [Select Id, ActorId From ProcessInstanceWorkItem 
                                                    Where ProcessInstanceId =: stepInfo[0].ProcessInstanceId];
            if (!stepInfo.isEmpty()) {
            	processInstance = stepInfo[0].ProcessInstanceId;
            	submitter = stepInfo[0].ProcessInstance.SubmittedById;
            }
            if (!wIInfo.isEmpty()) {
            	processInstanceWI = wIInfo[0].Id;
                approver = wIInfo[0].ActorId;
        	}
        } else if (recordIdCast.getSobjectType() == Schema.ProcessInstanceWorkItem.getSObjectType()) {
            List<ProcessInstanceWorkItem> instanceWIInfo = [Select ProcessInstanceId, ProcessInstance.SubmittedById, ActorId From ProcessInstanceWorkItem Where Id =: recordId];
            processInstanceWI = recordId;
            if (!instanceWIInfo.isEmpty()) {
                processInstance = instanceWIInfo[0].ProcessInstanceId;
                submitter = instanceWIInfo[0].ProcessInstance.SubmittedById;
                approver = instanceWIInfo[0].ActorId;
            }
        }
        //Build the Comment__c record.
        Comment__c cmt = new Comment__c();
        cmt.Approver__c = approver;
        cmt.Sender__c = submitter;
        if (UserInfo.getUserId() == submitter) {
            cmt.SenderType__c = 'Remitente';
        } else {
            cmt.SenderType__c = 'Aprobador';
        }
        cmt.Comment__c = comment;
        cmt.ProcessInstance__c = processInstance;
        cmt.ProcessInstanceWorkItem__c = processInstanceWI;
        insert cmt;	
    }    */
}