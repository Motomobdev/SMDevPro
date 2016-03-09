/**
Get the selected Features from List View and allow users to select the Feature Release to assign to.

Change Log

Date: August 6, 2012
Big Kite Consulting - Added class and logic.
*/
public with sharing class AssignFeatureReleaseExtension {
    List<Feature__c> features;
    Feature__c selectedFeatureRelease;
    PageReference fromPage;
    public AssignFeatureReleaseExtension(ApexPages.StandardSetController controller) {
        features=(List<Feature__c>)controller.getSelected();
        features=[select id,name,feature__c,Release__c,phase__c,type__c,description__c from feature__c where id=:features];
        String url=(String)(ApexPages.currentPage().getParameters().get('retURL'));
        fromPage=new PageReference(url);
        fromPage.setRedirect(true);
        selectedFeatureRelease=new Feature__c();
    }
    public Feature__c getFeatureRelease(){
        return selectedFeatureRelease;
    }
    public List<Feature__c> getSelectedFeatures(){
        return features;
    }
    public PageReference doCancel(){
        return fromPage;
    }
    public PageReference doSave(){
        for(Feature__c feature:features){
            feature.Release__c=selectedFeatureRelease.Release__c;
        }
        Database.DMLOptions options=new Database.DMLOptions();
        options.optAllOrNone=true;
        List<Database.SaveResult> srs=Database.update(features,options);
        for(Database.SaveResult sr:srs){
            for(Database.Error err: sr.getErrors()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,err.getMessage()));
            }
        }
        return fromPage;
    }
    static testmethod void testAssignFeatureReleaseExtension(){
    	Test.startTest();
    	Feature_Release__c featureRelease=new Feature_Release__c(name='Test Feature Release');
    	insert featureRelease;
    	Feature__c feature=new Feature__c(name='test',Release__c=featureRelease.id,type__c='Enhancement');
    	insert feature;
    	List<Feature__c> selectedFeatures=new List<Feature__c>();
    	selectedFeatures.add(feature);
    	ApexPages.StandardSetcontroller controller=new ApexPages.StandardSetcontroller(selectedFeatures);
    	controller.setSelected(selectedFeatures);
    	PageReference featurePage=new PageReference('/');
    	featurePage.getParameters().put('retURL','/');
    	Test.setCurrentPage(featurePage);
    	AssignFeatureReleaseExtension ext=new AssignFeatureReleaseExtension(controller);
    	ext.getFeatureRelease();
    	ext.getSelectedFeatures();
    	ext.doSave();
    	ext.doCancel();
    	Test.stopTest();
    }
}