public with sharing class Helpers {
    /*
    * Submit a approval process for contact which have account
    */
    public static void submitAndApprovalProcess(Contact c) {
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitted for approval. Please approve.');
        req.setObjectId(c.Id);
        Approval.ProcessResult result = Approval.process(req);
        System.debug('Submitted for approval successfully: ' + result.isSuccess());
    }

    /*
    * Submit and approval process when insert contact
    */
    public static void insertContact(List<Contact> listContacts) {
        for (Contact c: listContacts) {
            if (!String.isBlank(c.AccountId)) {
                submitAndApprovalProcess(c);
            }
        }
    }

    /*
    * Increment Total_Contacts__c when update contact
    */
    public static void updateContact(List<Contact> listContacts, Map<Id, Contact> mapOldContact) {
        for (Contact c: listContacts) {
            // Check Counter__c to avoid conflict Task 3
            if (!String.isBlank(c.AccountId) && mapOldContact.get(c.Id).Counter__c == c.Counter__c) {
                if (c.Active__c) {
                    Account a = [SELECT Id, Total_Contacts__c FROM Account WHERE Id = :c.AccountId];
                    // Check Total_Contacts__c for old Account
                    a.Total_Contacts__c = a.Total_Contacts__c == NULL ? 1 : a.Total_Contacts__c + 1;
                    update a;
                } else {
                    submitAndApprovalProcess(c);
                }
            }
        }
    }

    /*
    * Decrement Total_Contacts__c when delete contact
    */
    public static void deleteContact(List<Contact> listContacts) {
        for (Contact c: listContacts) {
            if (!String.isBlank(c.AccountId) && c.Active__c) {
                Account a = [SELECT Id, Total_Contacts__c FROM Account WHERE Id = :c.AccountId];
                a.Total_Contacts__c -= 1;
                update a;
            }
        }
    }
}