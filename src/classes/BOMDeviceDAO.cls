/**
 * Device__c DAO
 * @author: Jimens Lima - jimens@motorola.com
 */
public class BOMDeviceDAO {
	
    /**
     * Search a Device by form filters.
     * @param BOMDeviceFilter - A filter with the value of BOMSearchDevice form fields
     * @return a List of Device__c based on criteria.
     */
    public List<Device__c> searchDevices(BOMDeviceFilter deviceFilter){
        try{
            
            String query = buildQuery(deviceFilter);
            
            if(String.isEmpty(query)){
                throw new ApplicationException('Please fill the filters.');
            }

            List<Device__c> devices = Database.query(query);
            
            return devices;
        }catch(Exception e){
            throw e;
        }
        
        return null;
    }
    
    /**
     * @param String IN SQL Statement
     * @return A List of Device__c
     */
    public List<Device__c> searchDevicesByInStmt(String inStmt) {
        try{
            String query  = getDeviceQuery() + ' WHERE Id ' +inStmt;
            
            List<Device__c> devices = Database.query(query);
            return devices;
        }catch(Exception e){
            throw e;
        }
    }
    
    /**
     * Helper method to create a custom where clause
     * based on BOMDeviceFilter properties.
     **/
    private String buildQuery(BOMDeviceFilter deviceFilter){

        try{
            
            System.debug('BOMDeviceDAO.buildQuery');
            Map<String,String> parameters = new Map<String,String>();
            
            if(!String.isEmpty(deviceFilter.internalName)){
                String param = '\'%'+deviceFilter.internalName+'%\'';
                parameters.put('internalName',' Name like '+param);
            }
            if(!String.isEmpty(deviceFilter.launchType)){
                String param = '\'%'+deviceFilter.launchType+'%\'';
                parameters.put('launchType',' SA_Release_Type__c like '+param);
            }
            if(!String.isEmpty(deviceFilter.swKit)){
                String param = '\''+deviceFilter.swKit+'\'';
                parameters.put('swKit',' SW_Kit__r.Name = '+param);
            }
            if(!String.isEmpty(deviceFilter.saStatus)){
                String param = '\'%'+deviceFilter.saStatus+'%\'';
                parameters.put('saStatus',' SA_STATUS__c like '+param);
            }
            if(!String.isEmpty(deviceFilter.deviceId)){
                
                String param = '';
                
                if(deviceFilter.deviceId.containsAny(',')){
                    List<String> devices = deviceFilter.deviceId.split('\\,');

                    for(String str: devices){
                        param += '\''+str.trim()+'\',';
                    }
                    param = param.substring(0, param.length()-1);
                    
                    param = ' Device_ID__c in ('+param+')';
                }else{
                    param = ' Device_ID__c = \''+deviceFilter.deviceId+'\'';
                }

                parameters.put('deviceId',param);
            }
            if(!String.isEmpty(deviceFilter.carrierName)){
                String param = '';
                
                if(deviceFilter.carrierName.containsAny(',')){

                    List<String> carriers = deviceFilter.carrierName.split('\\,');
                    for(String str: carriers){
                        param += '\''+str.trim()+'\',';
                    }
                    param = param.substring(0, param.length()-1);
                    param = ' Carrier__c in ('+param+')';

                }else{
                    param = ' Carrier__c like \'%'+deviceFilter.carrierName+'%\'';
                }
                
                parameters.put('carrierName',param);
            }
            if(!String.isEmpty(deviceFilter.countryCode)){
                String param = '';
                
                if(deviceFilter.countryCode.containsAny(',')){
                    
                    List<String> countries = deviceFilter.countryCode.split('\\,');
                    for(String str: countries){
                        param += '\''+str.trim()+'\',';
                    }
                    param = param.substring(0, param.length()-1);
                    param = ' Country_Code__c in ('+param+')';
                    
                }else{
                    param = ' Country_Code__c = \''+deviceFilter.countryCode+'\'';    
                }
                
                parameters.put('countryCode',param);
            }
            if(!parameters.isEmpty()){
                
                String sql = getDeviceQuery();
                String whereClause = 'WHERE ';
                
                Integer count = 0;
                for(String paramName: parameters.keySet()){
                   whereClause += parameters.get(paramName) + ' AND';    
                }
                
                whereClause = whereClause.substring(0, whereClause.length()-4);
                sql += whereClause + ' AND (SA_Status__c != \'Canceled\' AND SA_Status__c != \'deleted\')  LIMIT 500 FOR UPDATE';

                return sql;
            }
        }catch(Exception e){
            throw e;
        }
        
        return null;
    }
    
    /**
     * Update a Device with a Stable and Core Device Package
     */
    public void updateDeviceWithCoreAndStables(List<Device__c> devices, List<Stable__c> stables, List<Core_Device_Package__c> corePacks,List<Program__c> programs){
        try{
            
            List<Device__c> devicesToUpdate  = new List<Device__c>();
            List<Program_Device__c> progDevs = new List<Program_Device__c>();
            for(Device__c device: devices){
				
                if(stables!=null && !stables.isEmpty()){
                    Stable__c stable = stables.get(0);
                    device.Stable__c = stable.Id;
                }
                
                if(corePacks!=null && !corePacks.isEmpty()){
                    Core_Device_Package__c corePack = corePacks.get(0);
                    device.Core_Device_Package__c = corePack.Id;
                }
                
                if(programs!=null && !programs.isEmpty()){
                    
                    for(Program__c program: programs){
                        
                        Program_Device__c progDev = new Program_Device__c();
                        progDev.Device__c  = device.Id;
                        progDev.Program__c = program.Id;
                        progDev.Created_on_BOM__c = true;
                        progDevs.add(progDev);
                    }
                }
                devicesToUpdate.add(device);
            }
			
            if(!progDevs.isEmpty()){
                System.debug('progDevs:'+progDevs);
                insert progDevs;
            }
            Database.update(devicesToUpdate);

        }catch(Exception e){
 			throw e;           
        }
    }
    
    
    /**
     * Approve selected Devices.
     */
    public void approveDevices(List<Device__c> devices){
		
        try{
            List<Device__c> devicesToApprove = new List<Device__c>();
            
            for(Device__c device : devices){
                device.SWBOM_Reviewed_and_Approved__c = 'Yes';
                device.SW_BOM_List_Approver__c        = UserInfo.getUserId();
                devicesToApprove.add(device);
            }
            
            Database.update(devicesToApprove);
            
        }catch(Exception e){
            throw e;
        }     
    }
    
    /**
     * @return Default Device__c query
     */
    private String getDeviceQuery(){
        String query  = 'SELECT Id,Name,Device_ID__c,Description__c,SA_Status__c,SA_Date__c,';
               query += 'Carrier__c,Core_Device_Package__c, Stable__c,Stable_Line__c,';
               query += 'SA_Release_Type__c,Percent_BOM_SD_Apps_w_Executed_Contract__c,Product_PMD__c,';
           	   query += 'of_Apps_Approved_on_BOM__c, of_3rd_Party_Approvals_Completed__c,Number_of_Apps_on_BOM__c,';
               query += 'SW_Kit__c, SWBOM_Reviewed_and_Approved__c,SW_BOM_List_Approver__c,Sales_Model_List_Concatenated__c FROM Device__c ';
        
        return query;
    }
}