trigger SWSpendRequest on Project_Spend__c (before insert,after insert, before update, after update, before delete, after delete, after undelete) {

    if(Trigger.isInsert && Trigger.isAfter){
    	SWSpendController.createSWSpendRequestMonths(Trigger.new);
    }
    
    if(Trigger.isUpdate && Trigger.isAfter){
        SWSpendController.updateSWSpendRequestMonthsValues(Trigger.oldMap,Trigger.new);
    }
}