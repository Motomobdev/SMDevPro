public with sharing class SW_KIT_EffectiveDate_Test {
    
    static testMethod void TestmethodA() {

            date sa1 = date.newInstance(2010,1,1);
            date sa2 = date.newInstance(2011,1,1);
            date sa3 = date.newInstance(2011,6,6);
    
        SW_KIT__c sw = New SW_KIT__c(Name='Test KIT');
            insert sw;
        Device__c d = New Device__c(Name='Test Device', SA_Date__c = sa1, Device_ID__c='475639857',SW_KIT__c = sw.id);
            insert d;
       
      
        d.SA_Date__c = sa2;
        
        update d;
        
        SW_KIT__c updatedsw = [SELECT Effective_Date__c FROM SW_KIT__c WHERE Id =: sw.id];  
        
    }
    
    static testMethod void TestmethodB() {
       
        date sa1 = date.newInstance(2010,1,1);

    
        SW_KIT__c sw = New SW_KIT__c(Name='Test KIT');
            insert sw;
        
        SW_KIT__c updatedsw2 = [SELECT Effective_Date__c FROM SW_KIT__c WHERE Id =: sw.id];  
        System.assertequals(NULL, updatedsw2.Effective_Date__c);
  

          Device__c d = New Device__c(Name='Test Device', Device_ID__c='475639857',SW_KIT__c = sw.id);
          insert d;
          d.SA_Date__c = sa1;
          update d;
       
        SW_KIT__c updatedsw = [SELECT Effective_Date__c FROM SW_KIT__c WHERE Id =: sw.id];  
        //System.assertequals(sa1, updatedsw.Effective_Date__c);
   
        delete d;
        SW_KIT__c updatedsw3 = [SELECT Effective_Date__c FROM SW_KIT__c WHERE Id =: sw.id];  
        System.assertequals(NULL, updatedsw2.Effective_Date__c); 
    }
        
    static testMethod void TestmethodC() {

            date sa1 = date.newInstance(2010,1,1);
            date sa2 = date.newInstance(2011,1,1);
            date sa3 = date.newInstance(2011,6,6);
    
        SW_KIT__c sw = New SW_KIT__c(Name='Test KIT');
            insert sw;
            
        SW_KIT__c sw2 = New SW_KIT__c(Name='Test KIT 2');
            insert sw2;           
           
        Device__c d = New Device__c(Name='Test Device', Device_ID__c='475639857',SW_KIT__c = sw.id);
        Device__c d2 = New Device__c(Name='Test Device 2', SW_KIT__c = sw.id);

        List<Device__c> devices = New List<Device__c>();
        devices.add(d);
        devices.add(d2);

        
        
        insert devices;
        
        d.SA_Date__c = sa1;
        d2.SA_Date__c = sa2;

        
        update devices;

        
        SW_KIT__c updatedsw = [SELECT Effective_Date__c FROM SW_KIT__c WHERE Id =: sw.id];  
        //System.assertequals(sa2, updatedsw.Effective_Date__c);        
 }       
  
    static testMethod void TestmethodD() {

            date sa1 = date.newInstance(2010,1,1);
            date sa2 = date.newInstance(2011,1,1);
            date sa3 = date.newInstance(2011,6,6);
    
        SW_KIT__c sw = New SW_KIT__c(Name='Test KIT');
            insert sw;
            
        SW_KIT__c sw2 = New SW_KIT__c(Name='Test KIT 2');
            insert sw2;           
           
        Device__c d = New Device__c(Name='Test Device', Device_ID__c='475639857',SW_KIT__c = sw.id, SA_Date__c = sa1);
            insert d;

        d.sw_kit__c = sw2.id;
        update d;
        
        
 }   
     static testMethod void TestmethodSWKitChangesOnDeviceA() {
       
        date sa1 = date.newInstance(2010,1,1);
        date sa2 = date.newInstance(2011,1,1);
        date sa3 = date.newInstance(2011,6,6);    
        
        SW_KIT__c sw = New SW_KIT__c(Name='Test KIT');
            insert sw;

          Device__c d = New Device__c(Name='Test Device', Device_ID__c='475639857',SW_KIT__c = sw.id, SA_Date__c= sa1);
          Device__c d2 = New Device__c(Name='Test 2', Device_ID__c='435648', SA_Date__c = sa2 );
          insert d;
          insert d2;

             
         
         d2.SW_KIT__c = sw.id;
         update d2;         
     } 
     
     static testMethod void TestmethodSWKitChangesOnDeviceB() {
       
        date sa1 = date.newInstance(2010,1,1);
        date sa2 = date.newInstance(2011,1,1);
        date sa3 = date.newInstance(2011,6,6);
    
        SW_KIT__c sw = New SW_KIT__c(Name='Test KIT');
            insert sw;
        SW_KIT__c sw2 = New SW_KIT__c(Name='Test KIT 2');
            insert sw2;            

          Device__c d = New Device__c(Name='Test Device', Device_ID__c='475639857',SW_KIT__c = sw.id, SA_Date__c= sa1);
          Device__c d2 = New Device__c(Name='Test 2', Device_ID__c='43564834', SA_Date__c = sa2, SW_KIT__c=sw.id );
          Device__c d3 = New Device__c(Name='Test 3', Device_ID__c='435648', SA_Date__c = sa3, SW_KIT__c=sw.id );
          insert d;
          insert d2;
          insert d3;
          
          d3.SW_KIT__c = sw2.id;
          
          update d3;
          
          

             
                 
     }  
     
     
     static testMethod void TestmethodSWKitChangesOnDeviceC() {
       
        date sa1 = date.newInstance(2010,1,1);
        date sa2 = date.newInstance(2011,1,1);
        date sa3 = date.newInstance(2011,6,6);
        date sa4 = date.newInstance(2009,1,1);
        SW_KIT__c sw = New SW_KIT__c(Name='Test KIT');
            insert sw;
        SW_KIT__c sw2 = New SW_KIT__c(Name='Test KIT 2');
            insert sw2;            

          Device__c d = New Device__c(Name='Test Device', Device_ID__c='475639857',SW_KIT__c = sw.id, SA_Date__c= sa3);
          Device__c d2 = New Device__c(Name='Test 2', Device_ID__c='43564834', SA_Date__c = sa2, SW_KIT__c=sw.id );
          Device__c d3 = New Device__c(Name='Test 3', Device_ID__c='435648', SA_Date__c = sa1, SW_KIT__c=sw.id );
          insert d;
          insert d2;
          insert d3;
          
          d3.SW_KIT__c = sw2.id;
          
          update d3;
          
          
          d3.SA_Date__c = sa4;
          
          update d3;
             
                 
     }
}