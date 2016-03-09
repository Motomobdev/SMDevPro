/*
*************************************************************************************************
Description:
This  Class is controller for page BPA to LOS COPY Page 

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*************************************************************************************************
*/
public class CD_Copy_BPA_LOS{
public boolean display{get; set;}
public  PageReference costNotif(){
display=true;
CD_CostTakeDown_Batch batch = new CD_CostTakeDown_Batch();
Database.executeBatch(batch,500);
return null;
}
}