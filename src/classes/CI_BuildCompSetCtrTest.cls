@isTest
private class CI_BuildCompSetCtrTest 
{
    static testMethod void myUnitTest() 
    {
        String motoRecordTypeId = Schema.SObjectType.Competitive_Product__c.getRecordTypeInfosByName().get('Motorola Product').getRecordTypeId();
        String compRecordTypeId = Schema.SObjectType.Competitive_Product__c.getRecordTypeInfosByName().get('Competitor Product').getRecordTypeId();
                
        List<Competitive_Product__c> cpList = new List<Competitive_Product__c>();
        
        cpList.add(new Competitive_Product__c(Name = 'MOTO Prod 1',
                                              RecordTypeId = motoRecordTypeId,
                                              Brand__c = 'MOTOROLA',
                                              Product__c = 'Prod 1',
                                              Entry_Period__c = 'Q1 2014'));
        cpList.add(new Competitive_Product__c(Name = 'SS Prod 2', RecordTypeId = compRecordTypeId,
                                              Brand__c = 'SAMSUNG', Product__c = 'Prod 2', Region_India__c = true,
                                              Operator_ATT__c = true, Operator_Sprint__c = true, Operator_T_Mobile__c = true, 
                                              Operator_US_Cellular__c = true, Operator_Verizon__c = true,
                                              OS__c = 'Jelly Bean', Entry_Period__c = 'Q1 2014', Form_Factor__c = 'TOUCH',
                                              Processor_Cores__c = 'Quad Core'));
        insert cpList;
    	
    	Test.startTest();
    	
    	//PageReference pageRef = Page.BuildCompSet;
    	//Test.setCurrentPage(pageRef);
    	
    	CI_BuildCompSetCtr con = new CI_BuildCompSetCtr();
    	
    	//initialize variables manually
        con.region = new List<String>();
        //con.operator = new List<String>();
        con.brand = new List<String>();
        con.os = new List<String>();
        con.entryPeriod = new List<String>();
        con.formFactor = new List<String>();
        con.processorCores = new List<String>();
        con.compProducts = new List<String>();
        con.displayResolutions = new List<String>();
        
        //Global region
    	con.motoProduct = 'MOTO_Prod 1';
    	con.region.add('Global');
    	con.displayResolutions.add('1440x1080');
    	con.filterByRegion();
    	
    	//back to region selection
    	con.backToRegionSelection();
    	
    	//Other than Global region
        con.motoProduct = 'MOTO_Prod 1';
        con.region.clear();
        con.region.add('India');
        con.filterByRegion();
        
        //select parameter values
        //con.operator.add('AT&T');
        //con.operator.add('Verizon');
        con.brand.add('SAMSUNG');
        con.os.add('Key Lime Pie');
        con.entryPeriod.add('Q3 2013');
        con.formFactor.add('TOUCH');
        con.processorCores.add('Quad Core');
        con.displayResolutions.add('720x540');
        con.minCameraMP = '1.0';
        con.maxCameraMP = '5.0';
        con.minSecCameraMP = '1.0';
        con.maxSecCameraMP = '5.0';
        con.minPrice = '100';
        con.maxPrice = '200';
        con.minScreenSize = '4.0';
        con.maxScreenSize = '4.3';
        con.minClockspeed = '1.0';
        con.maxClockspeed = '2.0';
        con.yes4G = true;
        con.no4G = true;
        //con.ipxx = true;
        //con.scratchResistant = true;
        con.nfc = true;
        con.dualSim = true;
        con.fmRadio = true;
        //next to prod selection
        con.nextToProductSelection();
        
        //clear parameter selection
        con.clearParameterSelections();
        
        con.brand.add('SAMSUNG');
        con.nextToProductSelection();
        
        //back to param selection
        con.backToParamSelection();
        
        con.nextToProductSelection();
        
        //add to favourites
        con.compProducts.add('SS_Prod 2');
        con.compSetName = 'Test Comp Product';
        con.addToFavourite();
        
        //run report
        con.runReport();
        
        //reset to new comp set
        con.buildNewCompSet();
        
    	Test.stopTest();
    }
}