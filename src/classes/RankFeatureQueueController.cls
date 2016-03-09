/**
Displays both Group Queue and Overall Queue and be able to sort their rank by dragging and dropping.

Author: Big Kite Consulting
Date: May 12, 2012
*/
public with sharing class RankFeatureQueueController {
    public List<Feature__c> groupQueue{get;set;}
    public List<Feature__c> overallQueue{get;set;}
    public Feature__c groupFeature{get;set;}
    public Feature__c overallFeature{get;set;}
    public String groupSequence {get;set;}
    public String overallSequence {get;set;}
    public Map<Id,Feature__c> groupQueueMap;
    public Map<Id,Feature__c> overallQueueMap;
    public List<Feature_Group__c> fgs;
    public List<SelectOption> groupRequestedGroups{get;set;}
    public String selectedGroupRequestedGroup{get;set;}
    public List<SelectOption> overallRequestedGroups{get;set;}
    public String selectedOverallRequestedGroup{get;set;}
    public boolean isAdministrator{get;set;}
    public RankFeatureQueueController(){
    	overallQueue=new List<Feature__c>();
        overallQueueMap=new Map<id,Feature__c>();
    	fgs=[select id,name from Feature_Group__c];
    	initGroupRequestedGroups();
        updateOverallQueue();
        // Only MotoDev - SysAdmin can modify the overall queue
        isAdministrator=false;
        Profile profile=[select name from Profile where id=:UserInfo.getProfileId()];
        if(profile.name.tolowercase().contains('motodev - sysadmin')){
        	isAdministrator=true;
        }
    }
    private void initGroupRequestedGroups(){
    	groupRequestedGroups=new List<SelectOption>();
    	groupRequestedGroups.add(new SelectOption('','Select Requested Group'));
    	for(Feature_Group__c featureGroup:fgs){
    		groupRequestedGroups.add(new SelectOption(featureGroup.id,featureGroup.name));
    	}
    }
    /**
    Save group sequence will save the Group Queue sequence but also will save the overall
    sequence.  The overall sequence is deteremined by Group sequence first, then overall
    sequence will be saved by that.
    Date: June 26, 2012
    Author: Big Kite - Andy Leung
    */
    public PageReference saveGroupSequence() {
        List<Feature__c> sortedFeatures = new List<Feature__c>();
        List<Feature__c> changedFeatures = new List<Feature__c>();
        List<String> seq = groupSequence.split(',');
        for (Integer i = 0; i < seq.size(); ++i) {
            Feature__c f = groupQueueMap.get(seq[i]);
            sortedFeatures.add(f);
            if (f.group_queue__c != i+1) {
                f.group_queue__c = i+1;
                changedFeatures.add(f);
            }
        }
        if (changedFeatures.size() > 0) {
            update changedFeatures;
        }
        groupQueue = sortedFeatures;
        sortOverall();
        return null;
    }
    /**
    1.  Put all empty group queue and overall queue to the end of the Overall Queue List.
    2.  Sort Overall Queue by Group Queue, Overall Queue
    3.  Write Overall Queue #.
    Date: June 26, 2012
    Author: Big Kite - Andy Leung
    */
    public void sortOverall(){
    	List<Feature__c> allFeaturesUnsorted=[select id,overall_queue__c from Feature__c where group_queue__c!=null for update];
    	Map<id,Feature__c> allFeaturesUnsortedMap=new Map<id,Feature__c>(allFeaturesUnsorted);
    	List<Feature__c> sortedFeatures=[select id,overall_queue__c from feature__c where group_queue__c!=null and (phase__c!='Deployed' and phase__c!='Closed - Verified' and phase__c!='Closed - Rejected') order by group_queue__c,overall_queue__c];
    	integer index=1;
    	for(Feature__c feature:sortedFeatures){
    		allFeaturesUnsortedMap.get(feature.id).overall_queue__c=index++;
    	}
        try{
        	update allFeaturesUnsortedMap.values();
        	this.updateOverallQueue();
        }catch(DmlException de){
        	System.debug(de);
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Unable to update Overall Queue at the moment, please try again later.'));
        }
    }
    public PageReference saveOverallSequence() {
        List<Feature__c> sortedFeatures = new List<Feature__c>();
        List<Feature__c> changedFeatures = new List<Feature__c>();
        List<String> seq = overallSequence.split(',');
        for (Integer i = 0; i < seq.size(); ++i) {
            Feature__c f = overallQueueMap.get(seq[i]);
            sortedFeatures.add(f);
            if (f.overall_queue__c != i+1) {
                f.overall_queue__c = i+1;
                changedFeatures.add(f);
            }
        }
        if (changedFeatures.size() > 0) {
            update changedFeatures;
        }
        overallQueue = sortedFeatures;
        return null;
    }
    /**
    After each query of group queue, empty queue number will be ranked the bottom of the list automatically.
    May 24, 2012
    Author: BigKite Consulting
    */
    private void updateGroupQueue(){
	    groupQueue=[select id,name,group_queue__c,phase__c,type__c,requested_group__c,description__c,resolution_type__c from feature__c where (phase__c!='Deployed' and phase__c!='Closed - Verified' and phase__c!='Closed - Rejected') and Requested_Group__c=:selectedGroupRequestedGroup order by group_queue__c];
    }
    /**
    	Update Feature Group Queue number by re-sorting all numbers and put empty ones to the bottom of the list.
    */
    private void updateFeatureGroupQueue(){
    	Map<id,Feature__c> allGroup=new Map<id,Feature__c>(groupQueue);
    	List<Feature__c> emptyGroupQueue=new List<Feature__c>();
    	for(Feature__c feature:groupQueue){
    		if(feature.group_queue__c==null||feature.group_queue__c<=0){
    			emptyGroupQueue.add(allGroup.remove(feature.id));
    		}
    	}
    	groupQueue=[select id,name,group_queue__c,phase__c,type__c,requested_group__c,description__c,resolution_type__c from feature__c where id!=:emptyGroupQueue and (phase__c!='Deployed' and phase__c!='Closed - Verified' and phase__c!='Closed - Rejected') and Requested_Group__c=:selectedGroupRequestedGroup order by group_queue__c];
    	integer index=1;
    	// Sort all numbers first
    	for(Feature__c feature:groupQueue){
    		feature.group_queue__c=index++;
    	}
    	if(emptyGroupQueue.size()>0){
    		index=allGroup.size()+1;
    		for(integer i=0;i<emptyGroupQueue.size();i++){
    			emptyGroupQueue.get(i).group_queue__c=index;
    			index++;
    		}
    		groupQueue.addall(emptyGroupQueue);
    	}
    	try{
    		update groupQueue;
    	}catch(DmlException de){
    		System.debug(de);
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Unable to update Group Queue at the moment, please try again later.'));
    	}
    }
    private void updateOverallQueue(){
    	overallQueue.clear();
    	List<Feature__c> emptyGroupOverall=[select id,name,overall_queue__c,group_queue__c,phase__c,type__c,requested_group__c,description__c,resolution_type__c from feature__c where overall_queue__c=null and group_queue__c=null and (phase__c!='Deployed' and phase__c!='Closed - Verified' and phase__c!='Closed - Rejected')];
    	List<Feature__c> emptyGroupButOverall=[select id,name,overall_queue__c,group_queue__c,phase__c,type__c,requested_group__c,description__c,resolution_type__c from feature__c where overall_queue__c!=null and group_queue__c=null and (phase__c!='Deployed' and phase__c!='Closed - Verified' and phase__c!='Closed - Rejected')];
    	List<Feature__c> sortedGroupOverall=[select id,name,overall_queue__c,group_queue__c,phase__c,type__c,requested_group__c,description__c,resolution_type__c from feature__c where group_queue__c!=null and (phase__c!='Deployed' and phase__c!='Closed - Verified' and phase__c!='Closed - Rejected') order by group_queue__c,overall_queue__c];
    	overallQueue.addAll(sortedGroupOverall);
    	overallQueue.addAll(emptyGroupButOverall);
    	overallQueue.addAll(emptyGroupOverall);
    	integer index=1;
    	for(Feature__c feature: overallQueue){
    		feature.overall_queue__c=index++;
    	}
    }
    /**
    	Update Feature Overall Queue number by re-sorting all numbers and put empty ones to the bottom of the list.
    
    private void updateFeatureOverallQueue(){
    	Map<id,Feature__c> allOverall=new Map<id,Feature__c>(overallQueue);
    	List<Feature__c> emptyOverallQueue=new List<Feature__c>();
    	for(Feature__c feature:overallQueue){
    		if(feature.overall_queue__c==null||feature.overall_queue__c<=0){
    			emptyOverallQueue.add(allOverall.remove(feature.id));
    		}
    	}
    	overallQueue=[select id,name,overall_queue__c,phase__c,type__c,requested_group__c,description__c,resolution_type__c from feature__c where id!=:emptyOverallQueue and (phase__c!='5) Completed' and phase__c!='DROPPED') order by group_queue__c];
    	integer index=1;
    	// Sort all numbers first
    	for(Feature__c feature:overallQueue){
    		feature.overall_queue__c=index++;
    	}
    	if(emptyOverallQueue.size()>0){
    		index=allOverall.size()+1;
    		for(integer i=0;i<emptyOverallQueue.size();i++){
    			emptyOverallQueue.get(i).overall_queue__c=index;
    			index++;
    		}
    		overallQueue.addall(emptyOverallQueue);
    	}
    	/*
    	try{
    		update overallQueue;
    	}catch(DmlException de){
    		System.debug(de);
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Unable to update Overall Queue at the moment, please try again later.'));
    	}
    }*/
    
    public PageReference updateGroupByFeatureGroup(){
    	updateGroupQueue();
    	updateFeatureGroupQueue();
    	groupQueueMap=new Map<id,Feature__c>(groupQueue);
    	return null;
    }/*
    public PageReference updateOverallByFeatureGroup(){
    	updateOverallQueue();
    	updateFeatureOverallQueue();
    	overallQueueMap=new Map<id,Feature__c>(overallQueue);
    	return null;
    }*/
    public static testmethod void TestRankFeatureQueueController(){
    	Test.startTest();
    	PageReference rankfeatureQueuePage=Page.RankFeatureQueue;
    	Test.setCurrentPage(rankfeatureQueuePage);
    	RankFeatureQueueController controller=new RankFeatureQueueController();
    	List<Feature__c> features=new List<Feature__c>();
    	for(integer i=0;i<10;i++){
    		features.add(new Feature__c());
    	}
    	insert features;
    	controller.groupSequence=features[0].id;
    	controller.overallSequence=features[0].id;
    	for(integer i=1;i<features.size();i++){
    		controller.groupSequence+=','+features[i].id;
    		controller.overallSequence+=','+features[i].id;
    	}
    	controller.groupQueueMap=new Map<Id, Feature__c>(features);
    	controller.saveGroupSequence();
    	controller.overallQueueMap=new Map<Id, Feature__c>(features);
    	controller.saveOverallSequence();
    	/*
    	controller.updateGroupByFeatureGroup();
    	controller.updateOverallByFeatureGroup();
    	*/
    	Test.stopTest();
    }
}