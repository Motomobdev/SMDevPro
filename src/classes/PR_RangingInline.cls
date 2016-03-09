/**
 * @author           Gangadhar Rachakonda
 * @version          1.0 
 * @date             8/02/2014
 * @Status           Developed
 * @description      This  class is  created  as a controller for PR_RangingInline VF Page
 *                    This will set the string into VF page from customsetting  
 */
public class PR_RangingInline
{

    public string strbody {get; set;}
    public PR_RangingInline(ApexPages.StandardController controller)
    {
       
       PR_Inline__c mc = PR_Inline__c.getValues('TextMessage');
          system.debug('#############'+mc );
          string Msg = mc.Message__C;
          if(Msg  != null && Msg  != '')
          {
             strbody = Msg ;
           }
          
           
    }    
}