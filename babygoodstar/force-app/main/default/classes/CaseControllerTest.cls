@isTest
private class CaseControllerTest {
    @isTest static void testGetCases() {
        // Set up test data
        // Insert a user to assign the cases to
        User testUser = new User(/* required fields */);
        insert testUser;
        
        // Run as the created user
        System.runAs(testUser) {
            // Create and insert test cases
            List<Case> casesToInsert = new List<Case>();
            for(Integer i = 0; i < 10; i++) {
                casesToInsert.add(new Case(
                    Subject = 'Test Case ' + i,
                    Status = (i < 5) ? 'Closed' : 'New', // First 5 cases are closed
                    OwnerId = testUser.Id
                ));
            }
            insert casesToInsert;
            
            // Test the getCases method
            Test.startTest();
            List<Case> cases = CaseController.getCases();
            Test.stopTest();
            
            // Verify that 5 cases are returned
            System.assertEquals(5, cases.size(), 'Should return exactly 5 cases');
            
            // Verify that all returned cases are not closed
            for(Case c : cases) {
                System.assertNotEquals('Closed', c.Status, 'Case should not be closed');
            }
            
            // Optionally, verify the cases are the last 5 created
            // This requires the cases to be ordered in the query by CreatedDate
        }
    }
}