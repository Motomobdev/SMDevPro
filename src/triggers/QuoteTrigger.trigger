trigger QuoteTrigger on Quote (before insert, before update) {

    if(trigger.isBefore){
        if(trigger.isInsert){
            QuoteTriggerHelper.copyAccountId(trigger.New);
        }
        if(trigger.isUpdate){
            QuoteTriggerHelper.copyAccountId(trigger.New);
        }
    }
}