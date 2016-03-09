trigger Device_ReasonCode on Device__c (before update) {
    if(Trigger.isUpdate){
        for(Integer i=0; i<trigger.new.size(); i++){ 

            if((Trigger.New[i].Device_ID__c != Trigger.Old[i].Device_ID__c) ||
            (Trigger.New[i].TOTAL_of_APPS__c != Trigger.Old[i].TOTAL_of_APPS__c) ||
            (Trigger.New[i].Device_Fully_Approved__c != Trigger.Old[i].Device_Fully_Approved__c) ||
            (Trigger.New[i].APC_code__c != Trigger.Old[i].APC_Code__c) ||
            (trigger.new[i].BLUR_Version_String__c != trigger.old[i].BLUR_Version_String__c) ||
            (trigger.new[i].Number_of_Sales_Models__c != trigger.old[i].Number_of_Sales_Models__c)){       
            
                if(Trigger.New[i].Device_ID__c != Trigger.Old[i].Device_ID__c){
                    Trigger.New[i].Reason_Code__c = 'DC';
                    Trigger.New[i].Reason_Code_Date__c = DateTime.now();
                }else if(Trigger.New[i].TOTAL_of_APPS__c != Trigger.Old[i].TOTAL_of_APPS__c){                   
                    Trigger.New[i].Reason_Code__c = 'SK';
                    Trigger.New[i].Reason_Code_Date__c = DateTime.now();
                }else if(Trigger.New[i].Device_Fully_Approved__c != Trigger.Old[i].Device_Fully_Approved__c){              
                    Trigger.New[i].Reason_Code__c = 'FA';
                    Trigger.New[i].Reason_Code_Date__c = DateTime.now();
                }else if(Trigger.New[i].APC_code__c != Trigger.Old[i].APC_Code__c){
                    Trigger.New[i].Reason_Code__c = 'AP'; 
                    Trigger.New[i].Reason_Code_Date__c = DateTime.now(); 
                }else if(trigger.new[i].BLUR_Version_String__c != trigger.old[i].BLUR_Version_String__c){
                    Trigger.New[i].Reason_Code__c = 'BV'; 
                    Trigger.New[i].Reason_Code_Date__c = DateTime.now();
                }
                /* BEGIN VHD Ticket #44023 
                   By: Neel Desai
                   Date: 14-Aug-2012 */
                // Change to Number of SalesModels on a Device
                else if(trigger.new[i].Number_of_Sales_Models__c != trigger.old[i].Number_of_Sales_Models__c) 
                {
                    Trigger.New[i].Reason_Code__c = 'SM'; 
                    Trigger.New[i].Reason_Code_Date__c = DateTime.now();
                }
                /* END: VHD Ticket #44023 */
            }
        }    
    }
}