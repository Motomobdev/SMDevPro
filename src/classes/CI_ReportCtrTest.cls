@isTest
private class CI_ReportCtrTest 
{
    static testMethod void myUnitTest() 
    {
    	String motoRecordTypeId = Schema.SObjectType.Competitive_Product__c.getRecordTypeInfosByName().get('Motorola Product').getRecordTypeId();
        String compRecordTypeId = Schema.SObjectType.Competitive_Product__c.getRecordTypeInfosByName().get('Competitor Product').getRecordTypeId();
            	
    	List<Competitive_Product__c> cpList = new List<Competitive_Product__c>();
    	
    	cpList.add(new Competitive_Product__c(RecordTypeId = motoRecordTypeId,
    	                                      Name = 'MOTOROLA Prod 1',
                                              Brand__c = 'MOTOROLA',
                                              Product__c = 'Prod 1'));
        cpList.add(new Competitive_Product__c(RecordTypeId = compRecordTypeId,
                                              Name = 'SAMSUNG Prod 2',
                                              Brand__c = 'SAMSUNG',
                                              Product__c = 'Prod 2'));
        cpList.add(new Competitive_Product__c(RecordTypeId = compRecordTypeId,
                                              Name = 'HTC Prod 3',
                                              Brand__c = 'HTC',
                                              Product__c = 'Prod 3'));
        insert cpList;


        List<Competitive_Product_Comp_Set__c> compSetList = new List<Competitive_Product_Comp_Set__c>();

        compSetList.add(new Competitive_Product_Comp_Set__c(Name = 'Comp Set 1', 
                                                            Motorola_Product__c = 'MOTOROLA Prod 1',
                                                            Competitor_Products__c = 'SAMSUNG Prod 2,HTC Prod 3'));
        compSetList.add(new Competitive_Product_Comp_Set__c(Name = 'Comp Set 2', 
                                                            Motorola_Product__c = 'MOTOROLA Prod 1',
                                                            Competitor_Products__c = 'SAMSUNG Prod 2,HTC Prod 3'));
    	
    	insert compSetList;
    	    	
    	Test.startTest();
        
    	//page without comp set Id & Data parameter
        PageReference pageRef1 = Page.CIReport;
        Test.setCurrentPage(pageRef1);
        
        CI_ReportCtr con1 = new CI_ReportCtr();
        
        System.assertEquals(con1.errorMessage, 'You cannot launch report directly. Please use Build Comp Set page');
        
        
        //with comp set Id parameter but missing comp set
        PageReference pageRef2 = Page.CIReport;
        pageRef2.getParameters().put('CompSetId', compSetList.get(0).Id);
        Test.setCurrentPage(pageRef2);

        delete compSetList.get(0);
                
        CI_ReportCtr con2 = new CI_ReportCtr();
        
        System.assertEquals(con2.errorMessage, 'Comp Set no longer exists. Please build a new Comp Set');
        
        
        //with comp set Id parameter
        PageReference pageRef3 = Page.CIReport;
        pageRef3.getParameters().put('CompSetId', compSetList.get(1).Id);
        Test.setCurrentPage(pageRef3);
        
        CI_ReportCtr con3 = new CI_ReportCtr();
        
        System.assertNotEquals(con3.rptTable, null);
        System.assert(con3.rptTable.contains('Prod 1'));
        System.assert(con3.rptTable.contains('Prod 2'));
        System.assert(con3.rptTable.contains('Prod 3'));
        
        PageReference excel = con3.exportToExcel();
        
        System.assertNotEquals(excel, null);
        

        //with comp Data parameter
        String products = cpList[0].Name + ',' + cpList[1].Name;
        String encodedData = EncodingUtil.base64Encode(Blob.valueOf(products));
        
        PageReference pageRef4 = Page.CIReport;
        pageRef4.getParameters().put('CompSetData', encodedData);
        Test.setCurrentPage(pageRef4);
        
        CI_ReportCtr con4 = new CI_ReportCtr();
        
        System.assertNotEquals(con4.rptTable, null);
        System.assert(con4.rptTable.contains('Prod 1'));
        System.assert(con4.rptTable.contains('Prod 2'));
        System.assert(!con4.rptTable.contains('Prod 3'));
        
        Test.stopTest();
    }
}