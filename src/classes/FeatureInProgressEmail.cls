/**
Controller that will send an email to all Feature "Assigned To".
*/
public with sharing class FeatureInProgressEmail {
	public id featureReleaseId;
	public List<Feature__c> features;
	
	public void setFeatureReleaseId(id featureReleaseId){
		this.featureReleaseId=featureReleaseId;
	}
	public id getFeatureReleaseId(){
		return featureReleaseId;
	}
	
	public List<Feature__c> getFeatures(){
		features=[select id,assigned_to__c,name,implementation_status__c from Feature__c where Release__c=:featureReleaseId];
		return features;
	}
	public static testMethod void testFeatureInProgressEmail() { 
		Test.startTest();
		FeatureInProgressEmail featureInProgressEmail=new FeatureInProgressEmail();
		List<Feature__c> features=featureInProgressEmail.getFeatures();
		if(!features.isEmpty()){
			featureInProgressEmail.setFeatureReleaseId(features.get(0).release__c);
			featureInProgressEmail.getFeatureReleaseId();
		}
		Test.stopTest();
   }
}