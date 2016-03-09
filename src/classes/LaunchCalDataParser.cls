/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/27/2014
// Last Modified: José Elias Araújo
// Last Modified by: 04/01/2014 
//
// Description:
// This class is able to convert JSON file received from
// LaunchCal tool and generates a in a list of LaunchCal.
// 
// Test Class: 
// LaunchCalDataParserTest.cls
/**********************************************************/
public class LaunchCalDataParser{
    
    JsonToMapParser mapParser;
    
    // Description:  
	// Constructor method
	//
	// Input: none
	//
	// Returns: none
    public LaunchCalDataParser(){
        mapParser = new JsonToMapParser();
    }

    // Description:  
	// Create a list of LaunchCal object from a json ceptured
	// from LaunchCal tool.  
	//
	// Input: launchesJson (JSON with all launches)
	//
	// Returns: List<LaunchCal> of LaunchCal objects     
	public List<LaunchCal> getLaunches(String launchesJson){		
		List<LaunchCal> parsedLaunches = new List<LaunchCal>();		
        Map<String, Object> mapping = mapParser.parse('launches', launchesJson);
		List<Object> launches = (List<Object>)mapping.get('launches');	
		for (Object launch : launches){
			Map<String, Object> internalMap = (Map<String, Object>)launch;
			Set<String> internalMapKey = internalMap.keySet();
			
			LaunchCal launchObj = new LaunchCal();
			
			for (String key : internalMapKey){
				Object internalMapValue = internalMap.get(key);
				
				if (internalMapValue instanceof String){
					if (key.equals('id')){
						launchObj.uniqueId = (String)internalMapValue;
                    }else if (key.equals('status')){
						launchObj.status = (String)internalMapValue;
					}else if (key.equals('name')){
						launchObj.name = (String)internalMapValue;
					}else if (key.equals('description')){
						launchObj.description = (String)internalMapValue;
					}else if (key.equals('created')){
						Long statsTime = Long.valueOf((String)internalMapValue);
            	        Datetime dt = Datetime.newInstance(statsTime);
						launchObj.created = dt.date();
					}else if (key.equals('updated')){
						Long updatedTime = Long.valueOf((String)internalMapValue);
            	        Datetime dt = Datetime.newInstance(updatedTime);
						launchObj.created = dt.date();
					}else if (key.equals('launchDate')){						
						Pattern datePattern = Pattern.compile('[0-9]{4}-[0-9]{2}-[0-9]{2}');
						Matcher matcher = datePattern.matcher((String)internalMapValue);
						if (internalMapValue != null && matcher.matches()){
							String[] splitedDate = ((String)internalMapValue).split('-');
							Integer year = Integer.valueOf(splitedDate[0]);
							Integer month = Integer.valueOf(splitedDate[1]);
							Integer day = Integer.valueOf(splitedDate[2]);
							Date dt = Date.newInstance(year, month, day);
							launchObj.launchDate = dt;
						}
					}else if (key.equals('createdBy')){
						MotorolaCoreDirectory createdBy = new MotorolaCoreDirectory();
						createdBy.setEmail((String)internalMapValue);
						launchObj.createdBy = createdBy;
					}
				}else if (internalMapValue instanceof List<Object>){
					if (key.equals('subscribers')){
						LaunchCalMotorolaCoreDirectory subscriber;
						List<Object> subscribersList = (List<Object>)internalMapValue;
						Integer idCounter = 0;
						for (Integer i = 0; i < subscribersList.size(); i++){
							subscriber = LaunchCalMotorolaCoreDirectory.buildSubscriber();
							MotorolaCoreDirectory flippedBy = new MotorolaCoreDirectory();	
							flippedBy.setEmail((String)subscribersList.get(i));						
							subscriber.flippedBy = flippedBy;
							subscriber.uniqueID = String.valueOf(i);							
							launchObj.approvers.add(subscriber);
						}
					}					
				}else if (internalMapValue instanceof Map<String, Object>){
					if (key.equals('attributes')){
						Map<String, Object> attributesMap = (Map<String, Object>)internalMapValue;
						Set<String> internalAttributesMapKeys = attributesMap.keySet();
						for (String attributeKey : internalAttributesMapKeys){
							Object internalAttributeMapValue = attributesMap.get(attributeKey);
							//If the current object is the Salesfortce ID App
							if (attributeKey.equals('83001')){ 
								Application application = new Application();
								application.setApplicationID((String)internalAttributeMapValue);
								launchObj.application = application;
							}else if (attributeKey.equals('17001')){ 
                                launchObj.productManager = (String)internalAttributeMapValue;
                            //If the current attibute is the App version.
							}else if (attributeKey.equals('44001')){ 
								launchObj.version = (String)internalAttributeMapValue;                                
							}
						}
					}else if (key.equals('approvers')){
						Map<String, Object> approversMap = (Map<String, Object>)internalMapValue;
						Set<String> internalApproversMapKeys = approversMap.keySet();						
						for (String approverKey : internalApproversMapKeys){
							Map<String, Object> internalApproversMap = (Map<String, Object>)approversMap.get(approverKey);
							LaunchCalMotorolaCoreDirectory approver = LaunchCalMotorolaCoreDirectory.buildApprover();
						    Set<String> internalApproversInternalMapKeys = internalApproversMap.keySet();						
							for (String internalApproverMapKey : internalApproversInternalMapKeys){
								Object internalApproverMapValue = (Object)internalApproversMap.get(internalApproverMapKey);							
								if (internalApproverMapKey.equals('approvalStatus')){ 								
									approver.approvalStatus = (String)internalApproverMapValue;
								}else if (internalApproverMapKey.equals('flippedBy') && !((String)internalApproverMapValue).equals('null')){ 	
									MotorolaCoreDirectory flippedBy = new MotorolaCoreDirectory();	
									flippedBy.setEmail((String)internalApproverMapValue);						
									approver.flippedBy = flippedBy;
								}else if (internalApproverMapKey.equals('flippedOn') && !((String)internalApproverMapValue).equals('null')){ 	
									Long statsTime = Long.valueOf((String)internalApproverMapValue);
            		        		Datetime dt = Datetime.newInstance(statsTime);						
									approver.flippedOn = dt.date();
								}else if (internalApproverMapKey.equals('notes')){ 	
									approver.notes = (String)internalApproverMapValue;
								}else if (internalApproverMapKey.equals('approverDefinitionId')){ 	
									approver.uniqueID = (String)internalApproverMapValue;
								}
								
							}

							launchObj.approvers.add(approver);
						}
						
					}
				}
			}
			
			parsedLaunches.add(launchObj);
		}
		return parsedLaunches;
	}

}