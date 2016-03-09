trigger CampaignProduct on Campaign_Product__c (before insert, before update) {

    if (Trigger.isBefore && Trigger.isUpdate) {
        CampaignProductMethods.UpdateProject(Trigger.new, Trigger.old);
    }

    if (Trigger.isBefore && Trigger.isInsert) {
        CampaignProductMethods.UpdateProject(Trigger.new, Trigger.old);
    }
}