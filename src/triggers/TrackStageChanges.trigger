trigger TrackStageChanges on Opportunity (before update) {

    /*
     * Author: Rajesh Krishnaiah
     * Creation Date: 20-Aug-2013
     * Description: <TODO>
     *
     * Test Class: <TODO>
     *
     * Change History:
     * Author and Date:
     * Description:
     */
    
    for (Integer i = 0; i < Trigger.new.size(); ++i) {
        Opportunity newOp = Trigger.new[i];
        Opportunity oldOp = Trigger.old[i];
        
        // Has the stage changed?
        if (newOp.stageName != oldOp.stageName) {
            // Is the next milestone date empty?
            if (newOp.Next_Milestone_Date__c == null)
                newOp.addError('Milestone date is required when changing the stage');
            else if (newOp.nextstep == null)
                newOp.addError('Next step is required when changing the stage');
            else {
                // Log milestone date and next step notes to Next_Steps_Log__c
                String str = Datetime.now().format('dd-MMM-yyyy');
                str += ': ' + oldOp.stageName + ' -> ' + newOp.stageName;
                
                Datetime dt = datetime.newInstance(newOp.Next_Milestone_Date__c.year(), 
                                newOp.Next_Milestone_Date__c.month(),
                                newOp.Next_Milestone_Date__c.day());
                
                str += '\nMilestone Date: ' + dt.format('dd-MMM-yyyy');
                str += '\nNext Step:' + newOp.nextStep;
                str += '\n=============\n';
                
                if (newOp.Next_Steps_Log__c != null)
                    newOp.Next_Steps_Log__c = str + newOp.Next_Steps_Log__c;
                else
                    newOp.Next_Steps_Log__c = str;
                
                // Empty mile stone date and next step
                newOp.Next_Milestone_Date__c = null;
                newOp.nextStep = null;
            }
        }
    }
}