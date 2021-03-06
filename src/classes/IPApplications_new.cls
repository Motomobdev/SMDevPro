global class IPApplications_new implements Database.Batchable<sObject>, Database.Stateful{    
        Set<Id> devicesToProcessId = new Set<Id>();
        
        //Constructor initialization
        global IPApplications_new(Set<Id> devices) {
        devicesToProcessId = devices;
        }
       global Database.QueryLocator start(Database.BatchableContext BC) {
            return DataBase.getQueryLocator([Select Id,Adjunct_Chipset__c,Audio_Playback_Codecs__c,Baseband_Chipset__c, Browser_Type__c, 
                                                  Business_Unit__c,Camera_Resolution__c, Carrier__c,Country__c,Device_Type__c,Display_Pixels__c,
                                                  DTV__c,Dual_SIM__c,Email__c,Messaging_Types__c,Navigation_Control__c,Platform__c,Software_Features__c,
                                                  Tech_Description__c, Technology__c 
                                                  FROM  Device__c where Id in :devicesToProcessId]);
        }
        global void execute(Database.BatchableContext BC, List<Device__c> scopeDevice)  { 
             Map<String,DeviceApplicationAssoc__c> devAppAssocMap = new Map<String,DeviceApplicationAssoc__c>();
             List<DeviceApplicationAssoc__c> devAppsToAdd = new List<DeviceApplicationAssoc__c>();
             List<DeviceApplicationAssoc__c> devAppsToRemove = new List<DeviceApplicationAssoc__c>();             
             
            for (Integer i=0;i<scopeDevice.size();i++){
                DeviceApplicationAssoc__c[] devApps = [SELECT Device__c, Application__c FROM DeviceApplicationAssoc__c 
                     WHERE Device__c = :scopeDevice.get(i).Id];
                
                for(DeviceApplicationAssoc__c devApp : devApps) {
                    // store in map to avoid SOQL queries
                    devAppAssocMap.put(String.valueOf(devApp.Device__c).substring(0,15) + '|' + String.valueOf(devApp.Application__c).substring(0,15), devApp);
                 }
                 
                    String devId = null;
                    String appId = null;
                    Boolean meetingCriteria = false;
                    
                    String adjunctChipset = null;
                    String audioPlaybackCodecs = null;
                    String basebandChipset = null;
                    String browserType = null;
                    String bussinessUnit = null;
                    String cameraResolution = null;
                    String carrier = null;
                    String country = null;
                    String deviceType = null;
                    String displayPixels = null;
                    String dtv = null;
                    String dualsim = null;
                    String email = null;
                    String messagingTypes = null;
                    String navigationControl = null;
                    String platform = null;
                    String softwareFeatures = null;
                    String techDescription = null;
                    String technology = null;

                    // convert string value to lower case for comparison
                    // null values to blank to avoid exception
                    devId = String.valueOf(scopeDevice.get(i).Id).substring(0,15); // important - otherwise comparison will be false
                    adjunctChipset = (scopeDevice.get(i).Adjunct_Chipset__c == null) ? '' : scopeDevice.get(i).Adjunct_Chipset__c.toLowerCase();
                    audioPlaybackCodecs = (scopeDevice.get(i).Audio_Playback_Codecs__c == null) ? '' : scopeDevice.get(i).Audio_Playback_Codecs__c.toLowerCase();
                    basebandChipset = (scopeDevice.get(i).Baseband_Chipset__c == null) ? '' : scopeDevice.get(i).Baseband_Chipset__c.toLowerCase();
                    browserType = (scopeDevice.get(i).Browser_Type__c == null) ? '' : scopeDevice.get(i).Browser_Type__c.toLowerCase();
                    bussinessUnit = (scopeDevice.get(i).Business_Unit__c == null) ? '' : scopeDevice.get(i).Business_Unit__c;
                    cameraResolution = (scopeDevice.get(i).Camera_Resolution__c == null) ? '' : scopeDevice.get(i).Camera_Resolution__c;
                    carrier = (scopeDevice.get(i).Carrier__c == null) ? '' : scopeDevice.get(i).Carrier__c.toLowerCase();
                    country = (scopeDevice.get(i).Country__c == null) ? '' : scopeDevice.get(i).Country__c.toLowerCase();
                    deviceType = (scopeDevice.get(i).Device_Type__c == null) ? '' : scopeDevice.get(i).Device_Type__c;
                    displayPixels = (scopeDevice.get(i).Display_Pixels__c == null) ? '' : scopeDevice.get(i).Display_Pixels__c.toLowerCase();
                    dtv = (scopeDevice.get(i).DTV__c == null) ? '' : scopeDevice.get(i).DTV__c.toLowerCase();
                    dualsim = (scopeDevice.get(i).Dual_SIM__c == null) ? '' : scopeDevice.get(i).Dual_SIM__c.toLowerCase();
                    email = (scopeDevice.get(i).Email__c == null) ? '' : scopeDevice.get(i).Email__c.toLowerCase();
                    messagingTypes = (scopeDevice.get(i).Messaging_Types__c == null) ? '' : scopeDevice.get(i).Messaging_Types__c.toLowerCase(); 
                    navigationControl = (scopeDevice.get(i).Navigation_Control__c == null) ? '' : scopeDevice.get(i).Navigation_Control__c.toLowerCase();
                    platform = (scopeDevice.get(i).Platform__c == null) ? '' : scopeDevice.get(i).Platform__c;
                    softwareFeatures = (scopeDevice.get(i).Software_Features__c == null) ? '' : scopeDevice.get(i).Software_Features__c.toLowerCase();
                    techDescription = (scopeDevice.get(i).Tech_Description__c == null) ? '' : scopeDevice.get(i).Tech_Description__c.toLowerCase();
                    technology = (scopeDevice.get(i).Technology__c == null) ? '' : scopeDevice.get(i).Technology__c.toLowerCase();
    
                    /**********************************************/
        
                    // Application Name: Kodak - Camera *IP-S*
                    // Application ID: 82SF00002090
                    appId = 'a0740000005LOyk';
                    
                    meetingCriteria = (cameraResolution != '');
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
                    
                    // Application Name: Newport Media Mobile TV Middleware
                    // Application ID: 82SF00178275
                    appId = 'a074000000Unhwv';
                    
                    meetingCriteria = (dtv.contains('true') && (country.contains('brazil')  || country.contains('argentina')));
                                                        
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/    
        
                    // Application Name: Telein Brazilian code requests
                    // Application ID: 82SF00178787
                    appId = 'a074000000Unng1';
                    
                    meetingCriteria = (dualsim.contains('true') && country.contains('brazil'));
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // Application Name: BR apps apk
                    // Application ID: 82SF00099606
                    appId = 'a074000000SB5U0';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices') && country.contains('brazil') && deviceType != 'wearable');
                                                
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // Application Name: Prip - Omega
                    // Application ID: 82SF00115786
                    appId = 'a074000000SjHpM';
                    
                    meetingCriteria = ((carrier.contains('nextel') || carrier.contains('iusacell')) && (country.contains('brazil') || country.contains('chile') || country.contains('mexico')));
                                                
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // VHD Ticket #106184
                    // Application Name: Flashpoint: Camera image post-processing *IP-S*
                    // Application ID: 82SF00006274
                    appId = 'a0740000009lGqo';
                    
                    meetingCriteria = (cameraResolution != '');
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // VHD Ticket #142179
                    // Application Name: CSIRO: WiFi *IP-S*
                    // Application ID: 82SF00054270
                    appId = 'a074000000K1wJb';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices') && techDescription.contains('wifi'));
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // VHD Ticket #142173
                    // Application Name: Advanced Audio Device: Audio Playback (decoding audio codec supported) *IP-S*
                    // Application ID: 82SF00051001
                    appId = 'a074000000Jzp5F';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices') && audioPlaybackCodecs != '');
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // VHD Ticket #142119
                    // Application Name: ADC Technology: Touch Screen for Smartphones only *IP-S*
                    // Application ID: 82SF00004529
                    appId = 'a0740000006ZIIZ';
                    
                    meetingCriteria = (deviceType.equalsIgnoreCase('Smart Phone') && navigationControl.contains('touch') && country.contains('united states'));
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // VHD Ticket #142217
                    // Application Name: Sisvel: .mp3 *IP-S*
                    // Application ID: 82SF00001947
                    appId = 'a0740000005JxES';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices') && audioPlaybackCodecs.contains('mp3'));
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // VHD Ticket #142185
                    // Application Name: Alliacense: Microprocessor & Other Hardware Design Techniques *IP-S*
                    // Application ID: 82SF00013300
                    appId = 'a074000000FmDUm';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices'));
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // VHD Ticket #142188
                    // Application Name: Smartphone Technologies: Advanced OS *IP-S*
                    // Application ID: 82SF00018462
                    appId = 'a074000000G72DI';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices') && platform.equalsIgnoreCase('Android'));
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // VHD Ticket #142206
                    // Application Name: MyPort - Camera *IP-S*
                    // Application ID: 82SF00051598
                    appId = 'a074000000K0ZSW';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices') && cameraResolution != '');
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // VHD Ticket #142208
                    // Application Name: Personal Audio: Audio Codec *IP-S*
                    // Application ID: 82SF00072862
                    appId = 'a074000000MVS57';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices') && audioPlaybackCodecs != '');
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // VHD Ticket #142211
                    // Application Name: Minerva Industries: Camera & Internet *IP-S*
                    // Application ID: 82SF00002906
                    appId = 'a0740000005iiEe';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices') 
                                       && cameraResolution != ''
                                       && (techDescription.contains('cdma') || techDescription.contains('edge') 
                                          || techDescription.contains('gprs') || techDescription.contains('hsdpa') 
                                          || techDescription.contains('hsupa') || techDescription.contains('lte')));
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // VHD Ticket #142213
                    // Application Name: WiAV - AMR Audio Codec *IP-S*
                    // Application ID: 82SF00051599
                    appId = 'a074000000K0ZSb';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices') && audioPlaybackCodecs.contains('amr'));
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // VHD Ticket #142216
                    // Application Name: Thomson: mp3 *IP-S*
                    // Application ID: 82SF00002006
                    appId = 'a0740000005KdsB';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices') && audioPlaybackCodecs.contains('mp3'));
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // VHD Ticket #146914
                    // Application Name: Intellect Wireless: MMS *IP-S*
                    // Application ID: 82SF00002087
                    appId = 'a0740000005LLzs';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices') 
                                       && messagingTypes.contains('mms')
                                       && !technology.contains('wifi')
                                       && country.contains('united states'));
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
    
                    /**********************************************/
        
                    // VHD Ticket #146909
                    // Application Name: MMIT: 5-way Navigation HW (4 directional + CSK) no Touchscreen-only UI *IP-S*
                    // Application ID: 82SF00051600
                    appId = 'a074000000K0ZSg';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices') && navigationControl.contains('5way'));
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // VHD Ticket #146906
                    // Application Name: WiLan2 - Bluetooth *IP-S*
                    // Application ID: 82SF00018464
                    appId = 'a074000000G72DX';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices') && techDescription.contains('bluetooth'));
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // VHD Ticket #146905
                    // Application Name: Dataquill: Cellular Internet Browsing no WiFi-only *IP-S*
                    // Application ID: 82SF00001952
                    appId = 'a0740000005KEVt';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices') 
                                       && !technology.contains('wifi')
                                       && (techDescription.contains('iden') || techDescription.contains('1x') 
                                          || techDescription.contains('ev') || techDescription.contains('lte') 
                                          || techDescription.contains('edge') || techDescription.contains('gprs')
                                          || techDescription.contains('hsdpa') || techDescription.contains('hsupa'))
                                       && country.contains('united states'));
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // VHD Ticket #152158
                    // Application Name: Datascape: non-iDEN - WAP Browser for MDb *IP-S*
                    // Application ID: 82SF00001965
                    appId = 'a0740000005KQ33';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices') 
                                       && browserType.contains('wap')
                                       && !techDescription.contains('iden'));
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // VHD Ticket #152159
                    // Application Name: Datascape: iDEN - WAP Browser for iDEN *IP-S*
                    // Application ID: 82SF00001953
                    appId = 'a0740000005KF0I';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices') 
                                       && browserType.contains('wap')
                                       && techDescription.contains('iden'));
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
    
                    /**********************************************/
        
                    // VHD Ticket #152160
                    // Application Name: Intellect Wireless: Helferich: Messaging *IP-S*
                    // Application ID: 82SF00045010
                    appId = 'a074000000Hyczs';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices')
                                       && (messagingTypes.contains('sms') || messagingTypes.contains('ems') 
                                          || messagingTypes.contains('mms') || messagingTypes.contains('picturemail 4.5') 
                                          || messagingTypes.contains('picturemail 5.1')) 
                                       && (email.contains('app') || email.contains('pop3/imap embedded') 
                                          || email.contains('u-imap') || email.contains('push email') 
                                          || email.contains('motorola-proprietary') || email.contains('pocket outlook')
                                          || email.contains('rim client'))
                                       );
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
    
                    /**********************************************/
        
                    // VHD Ticket #152162
                    // Application Name: Graphics Properties - Display/Apps Processor *IP-S*
                    // Application ID: 82SF00058628
                    appId = 'a074000000KWtBP';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices') 
                                       && adjunctChipset != ''
                                       && displayPixels != '');
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // VHD Ticket #152166
                    // Application Name: Intertrust: Trusted or Secured Computing *IP-S*
                    // Application ID: 82SF00002088
                    appId = 'a0740000005LM0n';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices'));
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
        
                    /**********************************************/
        
                    // VHD Ticket #152172
                    // Application Name: MSTG - WCDMA-CDMA-TD-SCDMA derived *IP-S*
                    // Application ID: 82SF00004550
                    appId = 'a0740000007WL8G';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices') 
                                       && (techDescription.contains('cdma') || techDescription.contains('td-scdma') || techDescription.contains('wcdma')));
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
    
                    /**********************************************/
    
                    // VHD Ticket #169948
                    // Date: 17/Jan/2013
                    // Application Name: Cingular Wireless: Country-specific - Cellular Transmission and/or PIM *IP-S*
                    // Application ID: 82SF00001949
                    appId = 'a0740000005K9Ue';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices') 
                                       && (techDescription.contains('cdma') || techDescription.contains('td-scdma') || techDescription.contains('wcdma'))
                                       && softwareFeatures.contains('pm')
                                       && (country.contains('united states') || country.contains('canada') || country.contains('chile') 
                                           || country.contains('france') || country.contains('georgia') || country.contains('germany') 
                                           || country.contains('hong kong') || country.contains('japan') || country.contains('mexico') 
                                           || country.contains('united kingdom'))
                                      );
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
    
                    /**********************************************/
        
                    // VHD Ticket #169976
                    // Date: 17/Jan/2013
                    // Application Name: Immersion - Basic Haptics
                    // Application ID: 82SF00082115
                    appId = 'a074000000LpgLd';
                    
                    meetingCriteria = (bussinessUnit.equalsIgnoreCase('Mobile Devices') 
                                       && navigationControl.contains('touch') 
                                       && deviceType.equalsIgnoreCase('Smart Phone') 
                                       && !country.contains('brazil')
                                       && !basebandChipset.contains('msm8960 pro')
                                       && !adjunctChipset.contains('msm8960 pro'));
                    
                    addOrRemoveDevApps(meetingCriteria, devAppAssocMap, devId, appId, devAppsToAdd, devAppsToRemove);
    
                    /**********************************************/
            }
            
            if(!devAppsToAdd.isEmpty())
                insert devAppsToAdd;
            
            if(!devAppsToRemove.isEmpty())
                delete devAppsToRemove;
        }
        
        global void finish(Database.BatchableContext BC) { 
            AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                                TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
                                
            // Send an email to the Apex job's submitter
            // notifying of job completion.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Record Clean Up Status: ' + a.Status);
            mail.setPlainTextBody
            ('The batch Apex job processed ' + a.TotalJobItems +
            ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        
        
        private static void addOrRemoveDevApps(Boolean meetingCriteria, 
                                           Map<String,DeviceApplicationAssoc__c> devAppAssocMap,
                                           String devId,
                                           String appId,
                                           List<DeviceApplicationAssoc__c> devAppsToAdd, 
                                           List<DeviceApplicationAssoc__c> devAppsToRemove) {
            String key = devId + '|' + appId;
            
            if(meetingCriteria && !devAppAssocMap.containsKey(key)) {
                devAppsToAdd.add(new DeviceApplicationAssoc__c(Device__c = devId, Application__c = appId, Approval_Status__c = 'Approved'));
            } else if(!meetingCriteria && devAppAssocMap.containsKey(key)) {
                devAppsToRemove.add(devAppAssocMap.get(key));
            }
        }
  }