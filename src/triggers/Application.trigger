trigger Application on Application__c (before insert, after insert, before update, after update,before delete) {
    if(trigger.isBefore && trigger.isInsert){
        Application_Insert.beforeInsert(trigger.new);
    }
    
    if(trigger.isAfter && trigger.isInsert){
        Application_Insert.afterInsert(trigger.new);
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        Application_Update.beforeUpdate(trigger.new, trigger.old);
    }
    
    if(trigger.isAfter && trigger.isUpdate){
        Application_Update.afterUpdate(trigger.new, trigger.old);
    }
    
    if(trigger.isBefore && trigger.isDelete){
        Application_Delete.beforeDelete(trigger.old);
    }
}