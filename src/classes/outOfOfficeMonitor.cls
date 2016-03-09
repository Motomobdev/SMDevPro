public class outOfOfficeMonitor {
    public String currentStatus {get; set;}
    
    public outOfOfficeMonitor(){
    	if(isUserOutOfOffice(UserInfo.getUserId())){
    		currentStatus = 'Out Of Office';
    	} else {
    		currentStatus = 'Available';
    	}        
    }
    
    public static Boolean isUserOutOfOffice(Id userId){
        List<Out_Of_Office__c> oooList = [SELECT Id, Start_Time__c, End_Time__c FROM Out_Of_Office__c WHERE User__c =: userId AND Active__c = true];
        
        if(oooList.size() == 0) {
            return false;
        } else {
            for(Out_Of_Office__c ooo : oooList){
                if(ooo.Start_Time__c < Datetime.now() && ooo.End_Time__c > Datetime.now()){
                    return true;
                }
            }
            return false;
        }    	
    }
    
    public static testMethod void outOfOfficeMonitorTest(){
    	outOfOfficeMonitor oofM = new outOfOfficeMonitor();
    	
    	Out_Of_Office__c oof = new Out_Of_Office__c(User__c = UserInfo.getUserId(), Active__c = true, Start_Time__c = DateTime.now().addDays(-1), End_Time__c = DateTime.now().addDays(1));
    	insert oof;
    	oofM = new outOfOfficeMonitor();
    	
    	oof.Start_Time__c = DateTime.now().addDays(-5);
    	oof.End_Time__c = DateTime.now().addDays(-4);
    	update oof;
    	oofM = new outOfOfficeMonitor();
    }
}