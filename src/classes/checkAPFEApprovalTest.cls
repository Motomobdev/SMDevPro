@isTest
public class checkAPFEApprovalTest{
    
    public static Map<ID,List<Google_TA__c>> createGoogleTAs(List<Device__c> Devices,Integer googlePerDeviceCount){
        Map<ID,List<Google_TA__c>> newGoogleTAs = new Map<ID,List<Google_TA__c>>();
        for( Device__c device: Devices){
            if(!newGoogleTAs.containsKey(device.Id)) newGoogleTAs.put(device.Id,new List<Google_TA__c>());
            for(Integer count=0; count < googlePerDeviceCount; count++){
               newGoogleTAs.get(device.Id).add(new Google_TA__c(Name='Test Google TA -'+count,Device__c=device.Id)); 
            }
        }
        return newGoogleTAs;
    }
    
    public static List<Device__c> createDevices(Integer numberOfDevices){
        List<Device__c> devices = new List<Device__c>();
        for(Integer count = 0 ; count < numberOfDevices; count++) devices.add(new Device__c(Name='Test Device - '+count));
        return devices;
    }
    
    public static testMethod void testForErrorResponse(){
        Integer numOfDevices = 1;
        Integer numOfGoogleTAPerDevice = 1;
        
        // create Device Records
        List<Device__c> devices = createDevices(numOfDevices);
        insert devices;
        
        // create Google_TA__c records
        List<Google_TA__c> googleTAs = new List<Google_TA__c>();
        for(List<Google_TA__c> gtas: createGoogleTAs(devices,numOfGoogleTAPerDevice).values()){
            googleTAs.addAll(gtas);
        }
        
        insert googleTAs;
            
        checkAPFEApproval check = new checkAPFEApproval();
        
        Test.startTest();
        	checkAPFEApproval.Test_Approve_Value = false;
        	ID batchprocessid = Database.executeBatch(check);
        Test.stopTest();
        
        googleTAs = [Select id,Approved__c from Google_TA__c Where ID IN :googleTAs];
        System.assertEquals(numOfDevices * numOfGoogleTAPerDevice, googleTAs.size());
        for(Google_TA__c gta: googleTAs) System.assertEquals(checkAPFEApproval.Test_Approve_Value, gta.Approved__c);
    }
    
    public static testMethod void testForValidResponse(){
        Integer numOfDevices = 1;
        Integer numOfGoogleTAPerDevice = 1;
        
        // create Device Records
        List<Device__c> devices = createDevices(numOfDevices);
        insert devices;
        
        // create Google_TA__c records
        List<Google_TA__c> googleTAs = new List<Google_TA__c>();
        for(List<Google_TA__c> gtas: createGoogleTAs(devices,numOfGoogleTAPerDevice).values()){
            googleTAs.addAll(gtas);
        }
        
        insert googleTAs;
            
        checkAPFEApproval check = new checkAPFEApproval();
        
        Test.startTest();
        	checkAPFEApproval.Test_Approve_Value = true;
        	ID batchprocessid = Database.executeBatch(check);
        Test.stopTest();
        
        googleTAs = [Select id,Approved__c from Google_TA__c Where ID IN :googleTAs];
        System.assertEquals(numOfDevices * numOfGoogleTAPerDevice, googleTAs.size());
        for(Google_TA__c gta: googleTAs) System.assertEquals(checkAPFEApproval.Test_Approve_Value, gta.Approved__c);
    }

}