@isTest
private class ContractRequestQueueCtrTest 
{
    static testMethod void myUnitTest() 
    {
        Test.startTest();
        
        ContractRequestQueueCtr con = new ContractRequestQueueCtr();
        
        con.refresh();
                
    	Test.stopTest();
    }
}