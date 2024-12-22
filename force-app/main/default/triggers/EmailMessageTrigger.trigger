trigger EmailMessageTrigger on EmailMessage (after insert) {
    try {
        EmailMessageHandler.processEmailMessages(Trigger.new);
    } catch (Exception e) {
        // Log the error or handle it appropriately
        System.debug('Error processing email messages: ' + e.getMessage());
    }
}