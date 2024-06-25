public class EmailMessageHandler {
    public static void processEmailMessages(List<EmailMessage> emailMessages) {
        //collect Case IDs and query related Cases
        Set<Id> caseIds = new Set<Id>();
        for (EmailMessage em : emailMessages) {
            if (em.ParentId != null && String.valueOf(em.ParentId).startsWith('500')) {
                caseIds.add(em.ParentId);
            }
        }
        Map<Id, Case> relatedCases = new Map<Id, Case>([SELECT Id, Planet__c, Successful_Scan__c FROM Case WHERE Id IN :caseIds]);

        // pattern for scan codes
        Pattern pattern = Pattern.compile('\\b[A-Z]{1,2}-\\d{5}\\b');
        Set<String> scanCodes = new Set<String>();

        // Collect all unique scan codes from the email messages
        for (EmailMessage em : emailMessages) {
            Matcher matcher = pattern.matcher(em.TextBody != null ? em.TextBody : '');
            while (matcher.find()) {
                scanCodes.add(matcher.group(0));
            }
        }

        // Query Planet__c records matching the scan codes
        Map<String, Id> scanCodeToPlanetId = new Map<String, Id>();
        for (Planet__c planet : [SELECT Id, External_id__c FROM Planet__c WHERE External_id__c IN :scanCodes]) {
            scanCodeToPlanetId.put(planet.External_id__c, planet.Id);
        }

        // List to hold Cases for update
        List<Case> casesToUpdate = new List<Case>();

        // Update related Cases with the Planet__c ID
        for (EmailMessage em : emailMessages) {
            if (relatedCases.containsKey(em.ParentId)) {
                Matcher matcher = pattern.matcher(em.TextBody != null ? em.TextBody : '');
                if (matcher.find()) {
                    String scanCode = matcher.group(0);
                    system.debug('Scan Code: ' + scanCode);
                    if (scanCodeToPlanetId.containsKey(scanCode)) {
                        Case relatedCase = relatedCases.get(em.ParentId);
                        // Assign the Planet__c ID instead of the scan code
                        relatedCase.Planet__c = scanCodeToPlanetId.get(scanCode);
                        relatedCase.Successful_Scan__c = true;
                        casesToUpdate.add(relatedCase);
                    }
                }
            }
        }

        // Update the Cases if there are any to update
        if (!casesToUpdate.isEmpty()) {
            update casesToUpdate;
        }
    }
}