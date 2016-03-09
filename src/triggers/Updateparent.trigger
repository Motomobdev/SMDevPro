trigger Updateparent on Campaign (after insert,after update) {
        Campaign[] childcamp = Trigger.new;

       List<ID> parentids = new List<ID>();

       for(Campaign s : childcamp)

       {
            System.debug('temp1');
        parentids.add(s.Parentid);

       }
        
       List <Campaign>parentCamp = [Select id,StartDate,EndDate,Parentid FROM Campaign WHERE Id IN :parentids];
      
 for (Campaign p: parentCamp){
        
            for(Campaign s : childcamp )
                {
                
                if(s.parentId==p.Id){
                
                     System.debug('temp3');
                     system.debug(s.RecordType.Name=='Promotion');
                     system.debug(s.StartDate > p.StartDate);
                     system.debug(s.EndDate > p.EndDate);
                     System.debug('temp6'+s.RecordTypeId);
                   if(p.StartDate==null && p.EndDate==null )
                    {
                        if(s.RecordTypeId=='01240000000DuXbAAK' && trigger.isInsert)
                            {
                                System.debug('temp45');
                                p.StartDate=s.StartDate;                                                         
                                p.EndDate=s.EndDate;
                            }
                    }       
                    else{
                               if (trigger.isUpdate || trigger.isInsert){
                                 if((s.StartDate < p.StartDate) && s.RecordTypeId=='01240000000DuXbAAK')
                                {
                                
                                System.debug('temp4');
                                p.StartDate=s.StartDate;
                                   
                                }
                                if(s.EndDate > p.EndDate && s.RecordTypeId=='01240000000DuXbAAK'){
                                 p.EndDate=s.EndDate;
                                  System.debug('temp5');
                                    }
                                }
                                
                        }
                                update p;
                        
                }
                       
    }
    }
    }