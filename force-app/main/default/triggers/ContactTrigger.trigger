trigger ContactTrigger on Contact (after insert, after update, after delete) {
    if (Trigger.isInsert) {
        Helpers.insertContact(Trigger.new);
    } else if (Trigger.isUpdate) {
        Helpers.updateContact(Trigger.new, Trigger.oldMap);
    } else if (Trigger.isDelete) {
        Helpers.deleteContact(Trigger.old);
}
}