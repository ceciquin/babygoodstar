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
}