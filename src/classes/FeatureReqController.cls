/**
Feature request form for users to submit feature request.

Change Log

Date: August 9, 2012
BigKite Consulting - Add assigning owner feature.

Date: August 7, 2012
BigKite Consulting - Add uploading attachment feature.
*/
public class FeatureReqController {

    public boolean controllerBoolTrueVar { get; set; }
    public boolean headerBoolTrueVar { get; set; }
    public String EmailLink { get; set; }
    public boolean isBug{get;set;}
    public String profileName{get;set;}
    public FeatureReqController() {
        feature = new Feature__C();
        String featureparam = Apexpages.CurrentPage().getParameters().get('feature');
        if (featureparam=='private'){
            controllerBoolTrueVar = false;
            headerBoolTrueVar = true;
            feature.Owner_Hidden__c=UserInfo.getUserId();
            EmailLink='/apex/MissingUser?feature=private';
        }
        else {
            controllerBoolTrueVar = true;
            headerBoolTrueVar = false;
            EmailLink='/apex/MissingUser';
        }
        Profile profile=[select name from Profile where id=:UserInfo.getProfileId() limit 1];
        profileName=profile.name;
        isBug=false;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'Welcome to the Business Operations Salesforce feature request page for MMI’s Ecosystem, Partner Management & SW Readiness Teams. Please fill out the form with as much detail as possible. Once submitted, your feature request will be reviewed and you will be notified of its status.'));
    }
    
    public boolean imageflag=false;
    public Attachment attachment {
      get {
          if (attachment == null)
            attachment = new Attachment();
          return attachment;
        }
      set;
      }
    
    
    public Feature__c feature;
    public Feature__c getFeature()
    {
       //if(feature == null)
       //feature = new Feature__c();
       return feature;
    }
    public void updateFeatureType(){}
    public void setFeature(Feature__c ft) {
      feature = ft;
    } 

    /**
    Include attachments.  Assign the feature owner to feature group owner by mapping
    profile name.
    */
    public PageReference submit() {
        List<Feature_Group_Mapping__c> featureGroupMappings=[select Feature_Group__c from Feature_Group_Mapping__c where Profile_Name__c=:profileName];
        if(!featureGroupMappings.isEmpty()){
            // Name should be matching to one group only.
            if(featureGroupMappings.size()==1){
                feature.Requested_Group__c = featureGroupMappings.get(0).Feature_Group__c;
            }
        }
        insert feature;
        if(attachment!=null&&attachment.Name!=null){
            attachment.OwnerId=UserInfo.getUserId();
            attachment.parentId=feature.id;
            attachment.isPrivate=true;
            try{
                insert attachment;
            }catch(DmlException de){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Error attaching file.'));
                return null;
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Error attaching file.'));
            return null;
        }
        if (controllerBoolTrueVar == false)
           return Page.FeatureRequestSuccess;
       else
           return Page.FeatureRequestSuccessPublic;
    }
    
     public PageReference home() {
        if (controllerBoolTrueVar == false){
            PageReference phome1 = new PageReference('/home/home.jsp');
            return phome1;
        }
        else {
            PageReference phome2 = new PageReference('http://motorolamobility.force.com/featurerequest');
            return phome2;
        }
    }
    
    //Unit Test
    static testMethod void FeatureReqController_Test()
    {
        //Test converage for the myPage visualforce page
        PageReference pageRef = Page.FeatureRequest;
        Test.setCurrentPageReference(pageRef);
        // create an instance of the controller
        FeatureReqController myPageCon = new FeatureReqController();
        
        User usr = [Select Id From User Where isActive = true Limit 1];
        String User_Id = usr.Id;
        System.debug('Inserting Unit Test 1... (single record validation)');
        
        Feature__c testFeature1 = new Feature__c(Name = 'Unit Test 1', Priority__c='Medium');
        insert testFeature1;
        
        // validate single insert    
        Feature__c f = [SELECT Name, Priority__c FROM Feature__c 
            WHERE Id=:testFeature1.Id];
        
        System.assertEquals(f.Name, 'Unit Test 1', 'Fail Name');
        System.assertEquals(f.Priority__c, 'Medium', 'Fail Priority');
        
        Feature__c testFeature = new Feature__c();
        insert testFeature;
        
        // validate single insert    
        Feature__c f1 = [SELECT Name, Priority__c FROM Feature__c 
            WHERE Id=:testFeature.Id];
        
        //System.assertEquals(f1.Name, null, 'Fail Name');
        System.assertEquals(f1.Priority__c, null, 'Fail Priority');
        
        Feature__c testFeature2 = new Feature__c(Name = 'Unit Test 2', Description__c='Test Description',  Priority__c='Medium', Owner_Hidden__c=User_Id);
        myPageCon.setFeature(testFeature2);
        Feature__c testFeature3 = myPageCon.getFeature();
        System.assertEquals(testFeature2, testFeature3, 'Get Feature Method Fail');
        
        // validate bulk insert
        List<Feature__c> testFeatures = new List<Feature__c>();
        for (Integer i=0;i<200;i++) {

            Feature__c a = new Feature__c(
            Name = 'Test Feature',
            Priority__c='Medium',
            Owner_Hidden__c=User_Id
            );
            testFeatures.add(a);     
        }

        insert testFeatures;
        
        // validate PageReference
        Attachment attachment=myPageCon.Attachment;
        attachment=new Attachment(Name='Test');
       
        PageReference submit = myPageCon.submit();
        if(submit!=null){
            system.assert( submit.getUrl().contains('featurerequestsuccess') ); 
        }
          //Test converage for the FeatureRequestSuccess visualforce page
        PageReference pageRefSuc = Page.FeatureRequestSuccess;
        Test.setCurrentPageReference(pageRefSuc);
        // create an instance of the controller
        FeatureReqController FeatureSucCon = new FeatureReqController();
        
        // validate PageReference
        PageReference home = FeatureSucCon.home();
        if (myPageCon.controllerBoolTrueVar == false){
            system.assert( home.getUrl().contains('home') ); 
        }
        
    }
}