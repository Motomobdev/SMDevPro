// jescamilla@levementum.com 12/22/14 Description: Part of the SYNC Mechanism to propagate changes to the Deal Family.
trigger BundleDeal on Quote (after update) {
	if(trigger.IsAfter && trigger.IsUpdate){
        BundleDealHandler.afterUpdate(trigger.New, trigger.oldMap);
    }
}