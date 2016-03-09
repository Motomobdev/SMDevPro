public class Converged_Activity_PageController {
    private ApexPages.StandardController controller {get; set;}
 
    private Account a;
    
    public List<cActivity> activityList {get; set;}
     
    public Converged_Activity_PageController(ApexPages.StandardController controller) {
        this.controller = controller;
        this.a = (Account)controller.getRecord();
        
        activityList = new List<cActivity>();      
        
        for(Task t : [Select t.ActivityDate,t.Subject, t.Status, t.Priority, t.Type,t.whatid from Task t where t.type =:'Converged Activity' AND t.whatid=:this.a.id ORDER BY t.ActivityDate ASC]){
			activityList.add(new cActivity(t.Id, 'Task', t.Subject, t.ActivityDate, t.Status, t.Priority, 'N/A'));
		}
		
		for(Event e : [Select e.Subject, e.Type,e.whatid,e.ActivityDateTime,e.location, e.startdatetime from Event e where e.type =:'Converged Activity' AND e.whatid=:this.a.id ORDER BY e.ActivityDateTime ASC]){
			activityList.add(new cActivity(e.Id, 'Event', e.Subject, e.ActivityDateTime, 'N/A', 'N/A', e.location));
		}
    }
    
    public class cActivity{
    	public Id recordId {get; set;}
    	public String recordType {get; set;}
    	public String subject {get; set;}
    	public DateTime activityDate {get; set;}
    	public String status {get; set;}
    	public String priority {get; set;}
    	public String location {get; set;}
    	
    	public cActivity(Id recordId, String recordType, String subject, DateTime activityDate, String status, String priority, String location){
    		this.recordId = recordId;
    		this.recordType = recordType;
    		this.subject = subject;
    		this.activityDate = activityDate;
    		this.status = status;
    		this.priority = priority;
    		this.location = location;
    	}
    }
    
    public static testmethod void Converged_Activity_PageControllerTest(){
    	Account a = new Account(Name='account', Tier__c = '1');
    	insert a;
    	Task t = new Task(Subject = 'subject', whatid = a.Id, type = 'Converged Activity');
    	insert t;
    	Event e = new Event(Subject = 'subject', whatId = a.Id, StartDateTime = DateTime.now(), EndDateTime = DateTime.now().addHours(1), type = 'Converged Activity');
    	insert e;
    	
    	Apexpages.StandardController stanCon = new Apexpages.standardController(a);
    	
		Test.startTest();
			Converged_Activity_PageController capc = new Converged_Activity_PageController(stanCon);
		Test.stopTest();
    }

}