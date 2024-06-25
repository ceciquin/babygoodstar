@IsTest
private class EmailMessageTriggerTest {
    @IsTest
    static void testEmailMessageInsertion() {
        // Create a Planet__c record as setup for EmailMessage
        Planet__c testPlanet = new Planet__c(Name = 'Test Planet', External_id__c = 'AB-12345');
        insert testPlanet;

        // Create a Case record as setup for EmailMessage
        Case testCase = new Case(Subject = 'Test Case', Status = 'New');
        insert testCase;

        // Create an EmailMessage record related to the Case
        EmailMessage testEmail = new EmailMessage(
            ParentId = testCase.Id,
            Subject = 'Test Email',
            TextBody = 'This is a test email body with a scan code AB-12345.',
            Status = '0' // Assuming '0' is a valid status for new EmailMessage records
        );

        // Insert the EmailMessage record to trigger the EmailMessageTrigger
        Test.startTest();
        insert testEmail;
        Test.stopTest();

        // Query the updated Case to verify the trigger's effect
        Case updatedCase = [SELECT Planet__c, Successful_Scan__c FROM Case WHERE Id = :testCase.Id LIMIT 1];

        // Assert that the Case fields were updated as expected
        System.assertEquals(testPlanet.Id, updatedCase.Planet__c, 'The Planet__c field should be updated with the planet ID from the Planet__c record.');
        System.assertEquals(true, updatedCase.Successful_Scan__c, 'The Successful_Scan__c field should be set to true.');
    }
}