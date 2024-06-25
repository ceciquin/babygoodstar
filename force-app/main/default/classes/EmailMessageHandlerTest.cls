@IsTest
private class EmailMessageHandlerTest {
    @IsTest
    static void testProcessEmailMessages() {
        // Step 1: Create test data - a Planet__c record
        Planet__c testPlanet = new Planet__c(Name = 'Test Planet', External_id__c = 'AB-12345');
        insert testPlanet;

        // Step 2: Create a Case record
        Case testCase = new Case(Subject = 'Test Case', Status = 'New', Planet__c = testPlanet.Id);
        insert testCase;

        // Step 3: Create an EmailMessage record related to the Case with a valid scan code in the TextBody
        EmailMessage testEmailMessage = new EmailMessage(
            ParentId = testCase.Id,
            TextBody = 'Here is a valid scan code: AB-12345',
            Status = '0' // Assuming '0' is a valid status for new EmailMessage records
        );
        insert testEmailMessage;

        // Prepare a list of EmailMessage records to process
        List<EmailMessage> emailMessages = new List<EmailMessage>{testEmailMessage};

        // Step 4: Call the method under test
        Test.startTest();
        EmailMessageHandler.processEmailMessages(emailMessages);
        Test.stopTest();

        // Step 5: Verify the Case record was updated correctly
        Case updatedCase = [SELECT Planet__c, Successful_Scan__c FROM Case WHERE Id = :testCase.Id];
        System.assertEquals(testPlanet.Id, updatedCase.Planet__c, 'The Planet__c field should be updated with the planet ID.');
        System.assertEquals(true, updatedCase.Successful_Scan__c, 'The Successful_Scan__c field should be set to true.');
    }
}