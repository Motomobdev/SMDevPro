/**
 * DeviceApplicationAssoc__c Junction DAO
 * @author: Jimens Lima - jimens@motorola.com
 * @since: 21/01/2015
 */ 
public class BOMDevAppDAO {
    
    //Used to count the total of assynchronous jobs started to create the relation between devices and apps, to show the percentage on screen
    //private Decimal numberOfJobs;
    
    /**
     * Create DevApp Junction based on previous analyses.
     * @param - devices A List of Device__c object
     * @param - appApprovals A List of BOMApplicationApproval, that has DevApp business rules.
     * @return BOMDevAppResult - The size of Devices and Application
     */
    public BOMDevAppResult createDevAppJunction(List<Device__c> devices, List<BOMApplicationApproval> appApprovals){

        Integer iterationCount = 0;
        
        try{
            
            Integer LIMIT_OF_RECORDS = BOMUtils.getMassCreationRecordsLimit();
			Set<ID> devIDs = new Set<ID>();
            Set<ID> appIDs = new Set<ID>();
            
            BOMDevAppResult devAppResult = new BOMDevAppResult();
            
            List<DeviceApplicationAssoc__c> devApps = new List<DeviceApplicationAssoc__c>();

            for(Device__c dev: devices){
                
                devIDs.add(dev.Id);
                
                for(BOMApplicationApproval appApproval : appApprovals){
                    DeviceApplicationAssoc__c devApp = new DeviceApplicationAssoc__c();
                    devApp.Device__c      = dev.Id;
                    devApp.Application__c = appApproval.application.Id;
                	
                    appIDs.add(appApproval.application.Id);
                    
                    if(appApproval.autoApprove){
                        devApp.Approval_Status__c = 'Approved';
                    }
                    
                    if(appApproval.includeInBOM==false){
                        devApp.Include_in_BOM__c = false;
                    }else{
                    	devApp.Include_in_BOM__c = TRUE;    
                    }
                    
                    if(appApproval.getSourceID()!=null){
                       devApp.Source_Id__c   = appApproval.getSourceID();
                       devApp.Source_Name__c = appApproval.getSourceName();
                    }
                    
                    devApps.add(devApp);
                }
            }
            
            devAppResult.devIDs = devIDs;
            devAppResult.appIDs = appIDs;
                
            if(devApps.size()<LIMIT_OF_RECORDS){
                insert devApps;
            }else{
                List<List<DeviceApplicationAssoc__c>> splittedList = (List<List<DeviceApplicationAssoc__c>>)BOMUtils.subList(devApps,LIMIT_OF_RECORDS);
                
                Integer seconds = 0;
                Integer currentSecond = 0;
				
                Datetime startJobsTime = Datetime.now();
                Integer year   = startJobsTime.year();
                Integer month  = startJobsTime.month();
                Integer day    = startJobsTime.day();
                Integer hour   = startJobsTime.hour();
                Integer minute = startJobsTime.minute();
                
				devAppResult.scheduledTime = startJobsTime;
                devAppResult.numberOfJobs  = splittedList.size();
                for(List<DeviceApplicationAssoc__c> devAppsList : splittedList){
                    
				    Integer second = Datetime.now().second();

                    Datetime currentDate = Datetime.newInstance(year,month,day,hour,minute,second);

                    if(seconds>50){
                        seconds = 0;
                        currentDate = currentDate.addMinutes(1);
                        minute = currentDate.minute();
                    }
                    
			        seconds += 10;
                    currentDate = currentDate.addSeconds(seconds);
                    
                    String cronExp = currentDate.second() + ' ' + currentDate.minute() + ' ' + currentDate.hour() + ' '+currentDate.day()+' '+currentDate.month()+' ? '+currentDate.year();
                    
                    //Used to avoid duplicated schedules between users
                    String UUID = String.valueOf(Crypto.getRandomInteger());
        
                    iterationCount++;
                    
                    System.schedule('BOMDevAppScheduler_' +iterationCount+ '_' + UUID, cronExp, new BOMDevAppScheduler(devAppsList));
                }
            }
            
            return devAppResult;

        }catch(Exception e){
            String stackTrace = BOMUtils.getStackTrace(e);
            stackTrace += ' Happened at iteration '+iterationCount;
            System.debug('Exception on BOMDevAppDAO: '+stackTrace);
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, stackTrace); 
            ApexPages.addMessage(msg);
            
            throw e;
        }
        
        return null;
    }

    public Long getPercentageOfJobsDone(Decimal numberOfJobs,Datetime startJobsTime){
          
       try{
            List<AsyncApexJob> jobsDone = [SELECT Id FROM AsyncApexJob where
                                CreatedBy.Email= :UserInfo.getUserEmail() and
                                ApexClass.Name='BOMDevAppScheduler' and
                                Status = 'Aborted' and
                                CreatedDate >= :startJobsTime];
        
        	Long percentage = Math.roundToLong((jobsDone.size()/numberOfJobs) * 100);
  
            return percentage;
        }catch(Exception e){
             System.debug(BOMUtils.getStackTrace(e));
        }
       	return 0;
    }
}