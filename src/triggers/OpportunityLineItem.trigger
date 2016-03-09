trigger OpportunityLineItem on OpportunityLineItem (before insert, before update, before delete)
{
    if (Trigger.isBefore && Trigger.isUpdate) {
        OpportunityLineItemMethods.beforeUpdate(Trigger.Old, Trigger.New);
    }

    if (Trigger.isBefore && Trigger.isDelete) {
        OpportunityLineItemMethods.beforeDelete(Trigger.Old);
    }
}