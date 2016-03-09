trigger Contract_ReasonCode on Contract (before insert, before update) {
    /*
     * Created by: Jesse
     * Creation date: Unknown
     * Description: <TO-DO>
     * Change history:
     * Date: 31-Jul-2012 Changed by: Rajesh Krishnaiah
     * Change: The end date comparison was compare trigger.new on both sides;
     *         changed "new" to "old" on the right side of the comparison.
     * Date: 14-Aug-2012 Changed by: Neel Desai
     * Change: refer ticket # 44023 below
     */
     
    if(Trigger.isInsert)
	{
        for(Integer i=0; i<trigger.new.size(); i++){
            Trigger.New[i].Reason_Code__c = 'NC';
            trigger.new[i].Reason_Code_Last_Modified_Date__c = DateTime.now();
        }
    }
	
    if(Trigger.isUpdate)
	{
        for(Integer i=0; i<trigger.new.size(); i++){ 
            if(Trigger.New[i].Total_Number_of_Applications__c != Trigger.Old[i].Total_Number_of_Applications__c){
                Trigger.New[i].Reason_Code__c = 'AC';
                trigger.new[i].Reason_Code_Last_Modified_Date__c = DateTime.now();
            }else if((Trigger.New[i].StartDate != Trigger.Old[i].StartDate) || (Trigger.New[i].EndDate != Trigger.Old[i].EndDate)){
                Trigger.New[i].Reason_Code__c = 'CD';
                trigger.new[i].Reason_Code_Last_Modified_Date__c = DateTime.now();
            }else if(Trigger.New[i].Contract_Status__c != Trigger.Old[i].Contract_Status__c){
                Trigger.New[i].Reason_Code__c = 'CS';
                trigger.new[i].Reason_Code_Last_Modified_Date__c = DateTime.now();
            }else if(Trigger.New[i].Rev_Share__c != Trigger.Old[i].Rev_Share__c){
                Trigger.New[i].Reason_Code__c = 'SC';
                trigger.new[i].Reason_Code_Last_Modified_Date__c = DateTime.now();
            }

            /* BEGIN VHD Ticket # 44023
               By: Neel Desai
               On: 14-Aug-2012
            */
            // Updated Contract Name
            else if(Trigger.New[i].Name != Trigger.Old[i].Name){
                Trigger.New[i].Reason_Code__c = 'CN';
                trigger.new[i].Reason_Code_Last_Modified_Date__c = DateTime.now();
            }
            // Payment Terms Changed
            else if(Trigger.New[i].Contract_Pmt_Terms__c != Trigger.Old[i].Contract_Pmt_Terms__c){
                Trigger.New[i].Reason_Code__c = 'PT';
                trigger.new[i].Reason_Code_Last_Modified_Date__c = DateTime.now();
            }
            // When the contract's earliest SA Date Device changes
            else if(Trigger.New[i].Earliest_SA_Date_Device__c != Trigger.Old[i].Earliest_SA_Date_Device__c){
                Trigger.New[i].Reason_Code__c = 'ED';
                trigger.new[i].Reason_Code_Last_Modified_Date__c = DateTime.now();
            }
            // When the contract's earliest Device SA date changes
            else if(Trigger.New[i].Earliest_Device_SA_Date__c != Trigger.Old[i].Earliest_Device_SA_Date__c){
                Trigger.New[i].Reason_Code__c = 'ES';
                trigger.new[i].Reason_Code_Last_Modified_Date__c = DateTime.now();
            }
            // When the contract Motorola Entity changes
            else if(Trigger.New[i].Motorola_Entity__c != Trigger.Old[i].Motorola_Entity__c){
                Trigger.New[i].Reason_Code__c = 'ME';
                trigger.new[i].Reason_Code_Last_Modified_Date__c = DateTime.now();
            }
            // When the contract type changes
            else if(Trigger.New[i].Contract_Type__c != Trigger.Old[i].Contract_Type__c){
                Trigger.New[i].Reason_Code__c = 'CT';
                trigger.new[i].Reason_Code_Last_Modified_Date__c = DateTime.now();
			}
           /* END VHD Ticket # 44023 */
		}
	}
}