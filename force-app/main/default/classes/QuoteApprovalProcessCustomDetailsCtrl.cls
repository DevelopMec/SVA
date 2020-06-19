/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Class to obtain necesary data to be showed in a Process Instance Step or Process Instance 
  Work Item record (related to a Quote record).
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author		Cindy Hernández
* @version      1.0
* @created      10/12/2019
* @change		06/01/2020 Reference to Schema.Quote.getSObjectType is replaced to comparison with 
				string Id to avoid errors caused by permissions (Line 68).
				15/01/2019 Fields added to quoteInfo query.
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public with sharing class QuoteApprovalProcessCustomDetailsCtrl {
    
    public class allApprovalInfo{
        @AuraEnabled public Quote quoteInfo{get;set;}
        @AuraEnabled public String submitterComment{get;set;}
        @AuraEnabled public List<ProcessInstanceStep> lastApproverComments{get;set;}
        @AuraEnabled public List<ProductoConcepto__c> conceptos{get;set;}
        @AuraEnabled public Decimal elapsedTime{get;set;}
        @AuraEnabled public Boolean isQuote{get;set;}
        @AuraEnabled public Boolean isPospago{get;set;}//CEAM:3375
    }

/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* @description	Method to obtain the data related to the Quote in order to show the necesary data
				for approvers and submitters.
* @params 		String recordId. Id from the current record (Process Instance Step or Process
				Instance Work Item).
* @return		allApprovalInfo. Wrapper with the quote data, the last approver comments, a list of
				ProductoConcepto__c, the elapsed time and a boolean to specify if the targetObject 
				is a Quote.
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/       
    @AuraEnabled
    public static allApprovalInfo getRelatedQuoteInfo(String recordId) {
        allApprovalInfo res = new allApprovalInfo();
        Boolean isQuote = false;
        Id quoteId = null;
        Id recordIdCast = recordId;
        Id processInstanceId = null;
        Boolean isPospago = false;//CEAM:3375
        //Identify if the current record is a ProcessInstanceStep or a ProcessInstanceWorkItem and get the necesary data. 
        if (recordIdCast.getSobjectType() == Schema.ProcessInstanceStep.getSObjectType()) {
            List<ProcessInstanceStep> stepInfo = [Select ProcessInstance.ElapsedTimeInDays, ProcessInstanceId, ProcessInstance.TargetObjectId, StepStatus, ElapsedTimeInDays 
                                                  From ProcessInstanceStep Where Id =: recordId];
            if (!stepInfo.isEmpty()) {
                processInstanceId =  stepInfo[0].ProcessInstanceId;
                if(stepInfo[0].StepStatus == 'Approved' || stepInfo[0].StepStatus == 'Rejected' || stepInfo[0].StepStatus == 'Started'){
                    res.elapsedTime = stepInfo[0].ProcessInstance.ElapsedTimeInDays.setScale(2);
                } else {
                    List<ProcessInstanceWorkItem> instanceWIInfo = [Select ElapsedTimeInDays
                                                                    From ProcessInstanceWorkItem Where ProcessInstanceId =: stepInfo[0].ProcessInstanceId];
                    res.elapsedTime = instanceWIInfo[0].ElapsedTimeInDays.setScale(2);
                }
                quoteId = stepInfo[0].ProcessInstance.TargetObjectId;
            }
        } else if (recordIdCast.getSobjectType() == Schema.ProcessInstanceWorkItem.getSObjectType()) {
            List<ProcessInstanceWorkItem> instanceWIInfo = [Select ProcessInstance.TargetObjectId,
                                                            ElapsedTimeInDays, ProcessInstanceId
                                                            From ProcessInstanceWorkItem Where Id =: recordId];
            if (!instanceWIInfo.isEmpty()) {
                processInstanceId =  instanceWIInfo[0].ProcessInstanceId;
            	quoteId = instanceWIInfo[0].ProcessInstance.TargetObjectId;
                res.elapsedTime = instanceWIInfo[0].ElapsedTimeInDays.setScale(2);
            }
        }
        
        if (String.valueOf(quoteId).StartsWith('0Q0')){
            isQuote = true;
        }
        if (isQuote) {
            //Get QuoteLineItems data. 
            //CEAM:3375 >>
            Quote quoteInfo = [SELECT Opportunity.Account.Segmento_Logo__c, Opportunity.Account.Ejecutivo_Logo__c, Opportunity.Account.Busines__c,
                               Opportunity.Account.Sum_turnover_volume__c, Opportunity.Account.Giro__c, Opportunity.Elapsed_days__c,
                               Opportunity.Owner.Name, Opportunity.Account.Sector__c, Opportunity.Maquilador__c, Opportunity.RecordType.Name, Owner.Name,
                               ApprovalRequestComments__c,Opportunity.Gestor__c, Opportunity.CloseDate, Opportunity.Competidor__c,
                               RequiredApprovalLevel__c, GrantedApprovalLevel__c, NumberOfShipments__c, (SELECT Id, Product2Id, Product2.ProductCode,
                               Product2.Name, Product2.Red__c, Product2.Uso__c, Product2.Formato__c, CantidadTarjetas__c, UnitPrice, ServiceDate,
                               PaymentMethod__c, ContractingItem__c, ReleasePeriod__c, OperatingLine__c, CreditDays__c, WarrantyType__c, CreditWeeks__c, 
                               ReleasesNumber__c, TotalCreditDays__c, WarrantyValue__c, PreAnalysis__c
                               FROM QuoteLineItems) FROM Quote WHERE Id =: quoteId];
            if(quoteInfo.RequiredApprovalLevel__c != null) {
                List<ProcessInstanceStep> listStepInfo = [SELECT Comments FROM ProcessInstanceStep WHERE 
                                                          ProcessInstance.TargetObjectId =: quoteId AND ProcessInstanceId =: processInstanceId AND StepStatus = 'Started' 
                                                          ORDER BY CreatedDate DESC LIMIT 1];
                res.submitterComment = listStepInfo[0].Comments;
            }
   			if(quoteInfo.RequiredApprovalLevel__c != null && quoteInfo.GrantedApprovalLevel__c != null) {
            	//Get last approver comments. 
            	res.lastApproverComments = null;
                List<ProcessInstanceStep> lastStepInfo = new List<ProcessInstanceStep>();
                	lastStepInfo = [SELECT Comments, Actor.Name FROM ProcessInstanceStep WHERE 
                                                          ProcessInstance.TargetObjectId =: quoteId
                                    					  AND StepStatus = 'Approved' 
                                                          ORDER BY CreatedDate ASC]; 
                if (!lastStepInfo.isEmpty()) {
                    res.lastApproverComments = lastStepInfo;
                }
            }
            Set<Id> quoteLineItemIds = new Set<Id>();
            for (QuoteLineItem quoteLI : quoteInfo.QuoteLineItems) {
                quoteLineItemIds.add(quoteLI.Id);
                // CEAM:3375 >>>
                if(quoteLI.PaymentMethod__c == 'Pospago'){
                    isPospago = true;
                }
                // CEAM:3375 <<<
            }
            //Get ProductoConcepto__c records related to the QuoteLineItem related to the Quote in approval process.
            List<ProductoConcepto__c> conceptos = [SELECT Concepto__r.TipoCargo__c, PrecioLista__c, PrecioLista2__c, PrecioFinal__c,
                                                   Bonificacion__c, VigenciaDescuento__c, CantidadTarjetas__c, ApprovalLevel__c FROM ProductoConcepto__c 
                                                   WHERE PartidaPresupuesto__c IN: quoteLineItemIds ORDER BY Concepto__r.Orden__c];
            res.conceptos = conceptos;
            res.quoteInfo = quoteInfo;
            res.isPospago = isPospago; // CEAM:3375
        }
        res.isQuote = isQuote; 
        
        return res;
        
    }
    
}