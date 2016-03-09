@isTest
public class testDeviceDates{

    public static testMethod void testDeviceIDLEDateCompareTo(){
    	DeviceDates.DeviceIDLEDate testInstance = new DeviceDates.DeviceIDLEDate();
        testInstance.LEDate = Date.today();
        
        DeviceDates.DeviceIDLEDate testCompare = new DeviceDates.DeviceIDLEDate();
        testCompare.LEDate = Date.today();
        
        System.assertEquals(0, testInstance.compareTo((Object)testCompare));
        
        testCompare.LEDate = Date.today().addDays(-1);
        
        System.assertEquals(1, testInstance.compareTo((Object)testCompare));
        
        testCompare.LEDate = Date.today().addDays(1);
        
        System.assertEquals(-1, testInstance.compareTo((Object)testCompare));
    }
    
    public static testMethod void testDeviceIDTADateCompareTo(){
    	DeviceDates.DeviceIDTADate testInstance = new DeviceDates.DeviceIDTADate();
        testInstance.TADate = Date.today();
        
        DeviceDates.DeviceIDTADate testCompare = new DeviceDates.DeviceIDTADate();
        testCompare.TADate = Date.today();
        
        System.assertEquals(0, testInstance.compareTo((Object)testCompare));
        
        testCompare.TADate = Date.today().addDays(-1);
        
        System.assertEquals(1, testInstance.compareTo((Object)testCompare));
        
        testCompare.TADate = Date.today().addDays(1);
        
        System.assertEquals(-1, testInstance.compareTo((Object)testCompare));
    }
    
    public static testMethod void testDeviceIDSADateCompareTo(){
    	DeviceDates.DeviceIDSADate testInstance = new DeviceDates.DeviceIDSADate();
        testInstance.SADate = Date.today();
        
        DeviceDates.DeviceIDSADate testCompare = new DeviceDates.DeviceIDSADate();
        testCompare.SADate = Date.today();
        
        System.assertEquals(0, testInstance.compareTo((Object)testCompare));
        
        testCompare.SADate = Date.today().addDays(-1);
        
        System.assertEquals(1, testInstance.compareTo((Object)testCompare));
        
        testCompare.SADate = Date.today().addDays(1);
        
        System.assertEquals(-1, testInstance.compareTo((Object)testCompare));
    }
    
}