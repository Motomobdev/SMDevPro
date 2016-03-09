public with sharing class FeatureInProgressNotifyDevelopersC {
	public Feature_Release__c featureRelease{get;set;}
	public PageReference retPage;
	public boolean hasMessages{get;set;}
	public List<User> developers{get;set;}
	public FeatureInProgressNotifyDevelopersC(ApexPages.StandardController controller){
		featureRelease=(Feature_Release__c)controller.getRecord();
		featureRelease=[select id,Emailed_Developers__c from Feature_Release__c where id=:featureRelease.id];
		if(featureRelease.Emailed_Developers__c==false){
			set<id> developerIds=new set<id>();
			List<Feature__c> features=[select id,assigned_to__c,name,implementation_status__c from Feature__c where Release__c=:featureRelease.id];
			for(Feature__c feature:features){
				developerIds.add(feature.assigned_to__c);
			}
			developers=[select id,name,email from User where id=:developerIds];
		}else{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please uncheck Emailed Developers to send notification to developers again.'));
		}
		hasMessages=ApexPages.hasMessages();
	}
	public PageReference sendEmail(){
		try{
			EmailTemplate template=[select id from EmailTemplate where DeveloperName='Feature_Release_In_progress' limit 1];
			Messaging.SingleEmailMessage email;
			for(User user:developers){
				email=new Messaging.Singleemailmessage();
				email.setTargetObjectId(user.id);
				email.setWhatId(featureRelease.id);
				email.setTemplateId(template.id);
				email.setSaveAsActivity(false);
				Messaging.SendEmailResult[] results=Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
				for(Messaging.SendEmailResult result:results){
					if(!result.isSuccess()){
						for(Messaging.SendEmailError error:result.getErrors()){
							ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,error.getMessage()));
						}
					}
				}
			}
			User jason=[select id,email from User where firstname='jason' and lastname='dobbs' limit 1];
			email=new Messaging.Singleemailmessage();
			email.setTargetObjectId(jason.id);
			email.setWhatId(featureRelease.id);
			email.setTemplateId(template.id);
			email.setSaveAsActivity(false);
			Messaging.SendEmailResult[] results=Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
			for(Messaging.SendEmailResult result:results){
				if(!result.isSuccess()){
					for(Messaging.SendEmailError error:result.getErrors()){
						ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,error.getMessage()));
					}
				}
			}
			featureRelease.Emailed_Developers__c=true;
			update featureRelease;
			String retURL='/'+featureRelease.id;
			retPage=new PageReference(retURL);
			retPage.setRedirect(true);
			return retPage;
		}catch(QueryException qe){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'No email template found.'));
			return null;
		}
	}
	public PageReference goBack(){
		String retURL='/'+featureRelease.id;
		retPage=new PageReference(retURL);
		retPage.setRedirect(true);
		return retPage;
	}
	static testmethod void testFeatureInProgressNotifyDevelopersC(){
		Test.startTest();
		Feature_Release__c featureRelease=new Feature_Release__c(name='test');
		insert featureRelease;
    	Feature__c feature=new Feature__c(name='test',Release__c=featureRelease.id,type__c='Enhancement',assigned_to__c=UserInfo.getUserId());
    	insert feature;
    	ApexPages.StandardController controller=new ApexPages.Standardcontroller(featureRelease);
    	FeatureInProgressNotifyDevelopersC f=new FeatureInProgressNotifyDevelopersC(controller);
    	f.sendEmail();
    	f.goBack();
		Test.stopTest();
	}
}