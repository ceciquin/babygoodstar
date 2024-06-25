trigger EmailMessageTrigger on EmailMessage (after insert) {
    // Check if there are any EmailMessage records being inserted
    if (Trigger.new != null && !Trigger.new.isEmpty()) {
        // Handler the EmailMessage records
        system.debug('Trigger.new: ' + Trigger.new);
        EmailMessageHandler.processEmailMessages(Trigger.new);
    }
}