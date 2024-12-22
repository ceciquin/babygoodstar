public with sharing class CaseController {
    @AuraEnabled(cacheable=true)
    public static List<Case> getCases() {
        return [
            SELECT Id, Subject, Status, Contact.Email, ContactId, Contact.Name
            FROM Case
            WHERE OwnerId = :UserInfo.getUserId()
            AND IsClosed = false
            ORDER BY CreatedDate DESC
            LIMIT 5
        ];
    }
    @AuraEnabled(cacheable=true)
    public static Case getCaseWithAccessCode(String id) {
        // Assuming 'Planet_Access_Code__c' is the API name of the custom lookup field on Case
        // and 'Access_Code__c' is the field on Planet__c object holding the access code.
        Case caseRecord = [
            SELECT Id, Subject, Description, Planet__c
            FROM Case
            WHERE Planet__r.Code__c = :id
            LIMIT 1
        ];
        
        return caseRecord;
    }
}