/**
* Author 		Desarrollo Freeway
* Date 			30/10/2019
* Description 	Class to automatically send email messages for closed cases.
**/

public class SendMailForClosedCases {
    
    //Method to build the mail.
    @InvocableMethod(label='Send Mail For Closed Cases' description='Send a mail when a case is closed.')    
    public static void sendMailMessage(List<Case> closedCases) {
        if(!closedCases.isEmpty()){
            List<Id> caseIds = new List<Id>();
            for(Case closedCase : closedCases){
                if((closedCase.Status == 'Cancelado' || closedCase.Status == 'Concluido') && closedCase.ContactId != Null){
                    caseIds.add(closedCase.id);
                }
            }
            List<Case> closedCasesInfo = new List<Case>();
            if(!caseIds.isEmpty()) {
                closedCasesInfo = [Select Id, Status, Contact.Email, ContactId, Owner.Name From Case Where Id IN: caseIds And Contact.Email != Null And Contact.IsEmailBounced = false];
                if(!closedCasesInfo.isEmpty()) {
                    // Reserve email capacity for the current Apex transaction to ensure that we won't exceed our limits when sending email after the current transaction is committed.
                    Integer numberOfMails = closedCasesInfo.size();
                    Messaging.reserveSingleEmailCapacity(numberOfMails);
                    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                    List<EmailServicesAddress>  replyToAddressList = new List<EmailServicesAddress>([Select DeveloperName,EmailDomainName 
                                                                                                     From EmailServicesAddress Where Function.FunctionName = 'EmailToCase' And 
                                                                                                     DeveloperName =: System.Label.EmailToCaseAddressToReplyTo LIMIT 1 ]);
                    List<OrgWideEmailAddress> owea = new List<OrgWideEmailAddress>([Select Id, Address, DisplayName From 
                                                                                    OrgWideEmailAddress Where
                                                                                    DisplayName =: System.Label.OrgWideEmailAddressDisplayName
                                                                                    And Address =: System.Label.OrgWideEmailAddressToSendEmailFrom LIMIT 1]);
                    Map<String,Id> emailTemplates = getTemplatesMap();
                    for(Case caseToMail : closedCasesInfo) {
                        // Create a new single email message object
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        if(!replyToAddressList.isEmpty()) {
                            // String to hold the email addresses to which the recipient reply to.
                            String replyToAddress = replyToAddressList[0].DeveloperName + '@' + replyToAddressList[0].EmailDomainName;
                            // Specify the address used when the recipients reply to the email.
                            mail.setReplyTo(replyToAddress);
                        }
                        
                        // Specify the name used as the display name.
                        //mail.setSenderDisplayName('Salesforce Support');
                        
                        // Set to True if you want to BCC yourself on the email.
                        mail.setBccSender(false);
                        
                        // Optionally append the salesforce.com email signature to the email.
                        // The email address of the user executing the Apex Code will be used.
                        mail.setUseSignature(false);
                        if(emailTemplates.containsKey(caseToMail.Status)) {
                            mail.setTemplateID(emailTemplates.get(caseToMail.Status)); 
                        }
                        mail.setWhatId(caseToMail.Id);
                        mail.setTargetObjectId(caseToMail.ContactId);
                        if(!owea.isEmpty()) {
                            mail.setOrgWideEmailAddressId(owea[0].Id);
                        }
                        mails.add(mail);
                    }
                    // Send the emails.
                    Messaging.sendEmail(mails);
                }
            }
        }
    }
    
    //Method to get the email templates from configuration to include them in the email.
    public static Map<String,Id> getTemplatesMap() {
        List<EmailTemplate> emailTemplates = new List<EmailTemplate>([Select Id, DeveloperName From EmailTemplate Where 
                                                                      DeveloperName =: System.Label.CanceledTicketEmailTemplate Or 
                                                                      DeveloperName =: System.Label.CloncludedTicketEmailTemplate]);
        Map<String,Id> emailTemplatesMap = new Map<String,Id>();
        for(EmailTemplate emailTemplate: emailTemplates) {
            if(emailTemplate.DeveloperName == System.Label.CanceledTicketEmailTemplate) {
                emailTemplatesMap.put('Cancelado', emailTemplate.Id); 
            }
            if(emailTemplate.DeveloperName == System.Label.CloncludedTicketEmailTemplate) {
                emailTemplatesMap.put('Concluido', emailTemplate.Id); 
            }            
        }
        return emailTemplatesMap;
    }
    
}