@IsTest
private class EmailMessageHandlerTest {
    @IsTest
    static void testProcessEmailMessages() {
        //Create test data - a Planet__c record
        Planet_c__c testPlanet = new Planet_c__c(Name = 'Test Planet', Code__c = 'AB-12345');
        insert testPlanet;

        //Create a Case record
        Case testCase = new Case(Subject = 'Test Case', Status = 'New', Planet__c = testPlanet.Id);
        insert testCase;

        //Create an EmailMessage record related to the Case with a valid scan code in the TextBody
        EmailMessage testEmailMessage = new EmailMessage(
            ParentId = testCase.Id,
            TextBody = 'Here is a valid scan code: AB-12345',
            Status = '0' // Assuming '0' is a valid status for new EmailMessage records
        );
        insert testEmailMessage;

        //Prepare a list of EmailMessage records to process
        List<EmailMessage> emailMessages = new List<EmailMessage>{testEmailMessage};

        //Call the method under test
        Test.startTest();
        EmailMessageHandler.processEmailMessages(emailMessages);
        Test.stopTest();

        //Verify the Case record was updated correctly
        Case updatedCase = [SELECT Planet__c, Successful_Scan__c FROM Case WHERE Id = :testCase.Id];
        System.assertEquals(testPlanet.Id, updatedCase.Planet__c, 'The Planet__c field should be updated with the planet ID.');
        System.assertEquals(true, updatedCase.Successful_Scan__c, 'The Successful_Scan__c field should be set to true.');
    }
}