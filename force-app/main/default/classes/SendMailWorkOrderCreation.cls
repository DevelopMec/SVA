/**
* Author 		Desarrollo Freeway
* Date 			27/11/2019
* Description 	Class to automatically send email messages when a work order is created.
**/

public class SendMailWorkOrderCreation {
    
    //Method to build the mail.
    @InvocableMethod(label='SendWOImplementationMail' description='Send WO implementation mail.')  
    public static void alert(List<WorkOrder> ots){ 
        System.debug('::SendMailWorkOrderCreation::');
        if(!ots.isEmpty()) {  
            List<Id> OTIds = new List<Id>();
            for(WorkOrder ot:ots) {
                if(ot.Correo_Contacto_Asociado__c!=null && ot.Correo_Contacto_Asociado__c!='') {
                    OTIds.add(ot.Id);
                }                
            }
            
            List<WorkOrder> OTInfo = new List<WorkOrder>();
            if(!OTIds.isEmpty()) {                
                OTInfo = [Select Id, Owner.Name, Owner.Email, Correo_Contacto_Asociado__c, Oportunidad__r.Contacto__r.Id  
                        From WorkOrder Where Id IN: OTIds And Oportunidad__c != Null And Oportunidad__r.Contacto__c != Null
                        And Oportunidad__r.Contacto__r.IsEmailBounced = false And Oportunidad__r.Contacto__r.Email != Null];
                if (!OTInfo.isEmpty()) {
                    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                    
                    List<EmailTemplate> emailTemplates = getTemplate();
                    for(WorkOrder otToMail : OTInfo) {
                        // Create a new single email message object
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                       
                        String senderDisplayName = otToMail.Owner.Name;
                        mail.setSenderDisplayName(senderDisplayName);
                        
                        // Specify the address used when the recipients reply to the email.
                        String replyToAddress = otToMail.Owner.Email;
                        mail.setReplyTo(replyToAddress);
                        
                        // Set to True if you want to BCC yourself on the email.
                        mail.setBccSender(false);
                        
                        // The email address of the user executing the Apex Code will be used.
                        mail.setUseSignature(false);
                        if(!emailTemplates.isEmpty()) {
                            mail.setTemplateID(emailTemplates[0].Id); 
                        }
                        mail.setWhatId(otToMail.Id);
                        mail.setTargetObjectId(otToMail.Oportunidad__r.Contacto__r.Id);
                        
                        mails.add(mail);
                    }
                    // Send the emails.
                    Messaging.sendEmail(mails);                                
            	}                               
            }                        
        }               
    }
    
    //Method to get the email templates from configuration to include them in the email.
    public static List<EmailTemplate> getTemplate(){
        List<EmailTemplate> emailTemplates = new List<EmailTemplate>([Select Id,Name,DeveloperName From EmailTemplate Where 
                                                                      DeveloperName =: System.Label.StartedImplementationTemplate
                                                                      Limit 1]);
        return emailTemplates;
    }

}