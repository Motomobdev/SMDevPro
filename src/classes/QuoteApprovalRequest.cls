public class QuoteApprovalRequest {
    
    public Date StartDate {get;set;}
     public Date endDate {get;set;}  
    public String userType { get; set; }
    public Quote Quot {get;set;}
    public Boolean blnShowTable {get;set;}
    public boolean showNoRecordsFound {get;set;}
    
    public List<SelectOption> weekNumbers {get; set;} {weekNumbers = new List<SelectOption>();}
    public List<Quote> Records {get; set;}
    public List<Quote> Records3 {get; set;}
    public transient List<Quote> myQuotes {get; set;}
      
    public void search()
    {
     showNoRecordsFound = true;
     if(userType =='View Draft Deals' || userType =='All Approved Deals' || userType =='All Deals'  || userType =='Next Weeks Agenda' || userType =='This Weeks Agenda'  )
        {
           showNoRecordsFound =false;
           DisplayQueryList(); 
            
    }else if(userType =='Selected Week Deals')
    {
    
    showNoRecordsFound =false;
           DisplayQueryList3(); 
    }
    }

public List<Quote> DisplayQueryList(){
if(userType =='This Weeks Agenda')
        {
Records = [Select Deal_Review_Date__c,Id,Name,QuoteNumber,Reviewed__c,Status, Account__r.Name,Account_Country__c,Account_Region__c,CreatedBy.Name from Quote where (Deal_Review_Date__c = THIS_WEEK  and Reviewed__c = False and Status='Submitted For Approval' and ParentQuote__c ='' and RecordType.id = '01240000000DwGV') OR (Deal_Review_Date__c = THIS_WEEK  and Reviewed__c = False and Status='Submitted For Approval' and ParentQuote__c ='' and RecordType.id ='01240000000Dvin')];

}else if(userType =='Next Weeks Agenda')
{
Records = [Select Deal_Review_Date__c,Id,Name,QuoteNumber,Reviewed__c,Status, Account__r.Name,Account_Country__c,Account_Region__c,CreatedBy.Name from Quote Where ( Deal_Review_Date__c = NEXT_WEEK  and Reviewed__c = False and Status='Submitted For Approval' and ParentQuote__c ='' and RecordType.id = '01240000000DwGV') OR (Deal_Review_Date__c = NEXT_WEEK  and Reviewed__c = False and Status='Submitted For Approval' and ParentQuote__c ='' and RecordType.id ='01240000000Dvin')];
}  
else if(userType =='View Draft Deals')
        {
Records = [Select Deal_Review_Date__c,Id,Name,QuoteNumber,Reviewed__c,Status, Account__r.Name,Account_Country__c,Account_Region__c,CreatedBy.Name from Quote where (Status='New' and ParentQuote__c ='' and RecordType.id = '01240000000DwGV') OR (Status='New' and ParentQuote__c ='' and RecordType.id ='01240000000Dvin')];

}
else if(userType =='All Approved Deals')
        {
Records = [Select Deal_Review_Date__c,Id,Name,QuoteNumber,Reviewed__c,Status, Account__r.Name,Account_Country__c,Account_Region__c,CreatedBy.Name from Quote where (Status='Approved' and ParentQuote__c ='' and RecordType.id = '01240000000DwGV') OR (Status='Approved' and ParentQuote__c ='' and RecordType.id ='01240000000Dvin')];

}
else if(userType =='All Deals')
        {
Records = [Select Deal_Review_Date__c,Id,Name,QuoteNumber,Reviewed__c,Status, Account__r.Name,Account_Country__c,Account_Region__c,CreatedBy.Name from Quote where (Status='Submitted For Approval' and ParentQuote__c ='' and RecordType.id = '01240000000DwGV') OR (Status='Submitted For Approval' and ParentQuote__c ='' and RecordType.id ='01240000000Dvin')];

}

if (Records.size() > 0)
     {
        blnShowTable = true;
     }
return Records;
}
public List<Quote> DisplayQueryList3(){
           if (StartDate !=null && endDate !=null)
                 
      {      
          
           Date today = Date.today();
           /*Date strDatetime = startDate.format();
           Date endDatetime= endDate.format();*/
           DateTime strTime = DateTime.newInstance(startDate.year(), startDate.month(), startDate.day());
            String startDateStr = strTime.format('yyyy-MM-dd'); 
            DateTime endTime = DateTime.newInstance(endDate.year(), endDate.month(), endDate.day());
            String endDateStr = endTime.format('yyyy-MM-dd'); 
            Date strDatetime = Date.valueOf(startDateStr);
           Date endDatetime= Date.valueOf(endDateStr);
           /*Derive Weekstart and end*/
           /*Date weekStrt = startDate.toStartOfWeek();
           Date weekEnd = weekStrt.addDays(7);*/
           
                //Date testdate = Date.valueOf('2014-08-01');
            Records3 = [Select Deal_Review_Date__c,Id,Name,QuoteNumber,Reviewed__c,Status,CreatedBy.Name, 
                                           Account__r.Name,Account_Country__c,Account_Region__c from Quote
                                         where Deal_Review_Date__c >=:strDatetime and Deal_Review_Date__c <=:endDatetime and ((Status='Submitted For Approval' and ParentQuote__c ='' and RecordType.id = '01240000000DwGV') OR (Status='Submitted For Approval' and ParentQuote__c ='' and RecordType.id ='01240000000Dvin')) limit 50000];

                                         if (Records3.size() > 0)
     {
        blnShowTable = true;
     }
}

return Records3;

}
}