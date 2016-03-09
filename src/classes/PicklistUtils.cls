public with sharing class PicklistUtils {
	
	public static Map<String,List<String>> GetDependentOptions(String pObjName, String pControllingFieldName, String pDependentFieldName){
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        //get the string to sobject global map
        Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
        if (!Schema.getGlobalDescribe().containsKey(pObjName))
            return objResults;
        //get the type being dealt with
        Schema.SObjectType pType = Schema.getGlobalDescribe().get(pObjName);
        return GetDependentOptionsImpl(pType,pControllingFieldName,pDependentFieldName);        
    }
    
    public static Map<String,List<String>> GetDependentOptionsImpl(Schema.SObjectType pType, String pControllingFieldName, String pDependentFieldName){
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        if (pType==null)
            return objResults;
        Bitset BitSetInstance = new Bitset();
        Map<String, Schema.SObjectField> objFieldMap = pType.getDescribe().fields.getMap();
        //verify field names
        if (!objFieldMap.containsKey(pControllingFieldName) || !objFieldMap.containsKey(pDependentFieldName))
            return objResults;     
        //get the control values   
        List<Schema.PicklistEntry> ctrl_ple = objFieldMap.get(pControllingFieldName).getDescribe().getPicklistValues();
        //get the dependent values
        List<Schema.PicklistEntry> dep_ple = objFieldMap.get(pDependentFieldName).getDescribe().getPicklistValues();
        objFieldMap = null;
        List<Integer> lstControllingIndexes = new List<Integer>();
        //iterate through the values and get the ones valid for the controlling field name
        //set up the results
        for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){
            //get the pointer to the entry
            Schema.PicklistEntry ctrl_entry = ctrl_ple[pControllingIndex];
            //get the label
            String pControllingLabel = ctrl_entry.getLabel();
            //create the entry with the label
            objResults.put(pControllingLabel,new List<String>());
            //keep track of the controlling indexes
            lstControllingIndexes.add(pControllingIndex);
        }
        //cater for null and empty
        objResults.put('',new List<String>());
        objResults.put(null,new List<String>());
        //load all dep entries
        List<Schema.PicklistEntry> objEntries = new List<Schema.PicklistEntry>();
        List<TPicklistEntry> objDS_Entries = new List<TPicklistEntry>();
        //add all entries
        for(Integer pDependentIndex=0; pDependentIndex<dep_ple.size(); pDependentIndex++){        	
            //get the pointer to the dependent index
           	Schema.PicklistEntry dep_entry = dep_ple[pDependentIndex];
           	objEntries.add(dep_entry);
           	
        } 
        //serialize once        
        objDS_Entries = (List<TPicklistEntry>)JSON.deserialize(JSON.serialize(objEntries), List<TPicklistEntry>.class);
        List<Integer> validIndexes;
        for (TPicklistEntry objDepPLE : objDS_Entries){
        	//if valid for is empty, skip    
            if (objDepPLE.validFor==null || objDepPLE.validFor==''){
                continue;
            }
            //get the test for the controlling indexes
            validIndexes = BitSetInstance.testBits(objDepPLE.validFor,lstControllingIndexes);
            for (Integer validIndex : validIndexes){            	
	            //get the label
	            String pControllingLabel = ctrl_ple[validIndex].getLabel();
                objResults.get(pControllingLabel).add(objDepPLE.label);
            }
        }
        objEntries = null;
        objDS_Entries = null;
        return objResults;
    }
	
	
	public class Bitset{
        public Map<String,Integer> AlphaNumCharCodes {get;set;}
        public Map<String, Integer> Base64CharCodes { get; set; }
        public Bitset(){
            LoadCharCodes();
        }
        //Method loads the char codes
        private void LoadCharCodes(){
            AlphaNumCharCodes = new Map<String,Integer>{
                'A'=>65,'B'=>66,'C'=>67,'D'=>68,'E'=>69,'F'=>70,'G'=>71,'H'=>72,'I'=>73,'J'=>74,
                'K'=>75,'L'=>76,'M'=>77,'N'=>78,'O'=>79,'P'=>80,'Q'=>81,'R'=>82,'S'=>83,'T'=>84,
                'U'=>85,'V'=> 86,'W'=>87,'X'=>88,'Y'=>89,'Z'=>90,'/'=>47 ,'+'=>43 
            };
            Base64CharCodes = new Map<String, Integer>();
            //lower case
            Set<String> pUpperCase = AlphaNumCharCodes.keySet();
            for(String pKey : pUpperCase){
                //the difference between upper case and lower case is 32
                AlphaNumCharCodes.put(pKey.toLowerCase(),AlphaNumCharCodes.get(pKey)+32);
                //Base 64 alpha starts from 0 (The ascii charcodes started from 65)
                Base64CharCodes.put(pKey,AlphaNumCharCodes.get(pKey) - 65);
                Base64CharCodes.put(pKey.toLowerCase(),AlphaNumCharCodes.get(pKey) - (65) + 26);
            }
            //numerics
            for (Integer i=0; i<=9; i++){
                AlphaNumCharCodes.put(string.valueOf(i),i+48);
                //base 64 numeric starts from 52
                Base64CharCodes.put(string.valueOf(i), i + 52);
            }
        }
        public List<Integer> testBits(String pValidFor,List<Integer> nList){
            List<Integer> results = new List<Integer>();
            //the list of bytes (not derived from n)
            List<Integer> pBytes = new List<Integer>();
            //multiply by 6 since base 64 uses 6 bits (not derived form n)
            Integer bytesBeingUsed = (pValidFor.length() * 6)/8;
            //will be used to hold the full decimal value (not derived from n)
            Integer pFullValue = 0;
            //must be more than 1 byte
            if (bytesBeingUsed <= 1)
                return results;
            //get the base64bytes
            for(Integer i=0;i<pValidFor.length();i++){
                //get currenct character value
                System.debug('Valid for: ' + (pValidFor.Substring(i, i+1)));
                pBytes.Add((Base64CharCodes.get((pValidFor.Substring(i, i+1)))));
            }   
            //calculate the full decimal value
            for (Integer i = 0; i < pBytes.size(); i++)
            {
            	Integer pShiftAmount;
            	try{
                	pShiftAmount = (pBytes.size()-(i+1))*6;//used to shift by a factor 6 bits to get the value
                pFullValue = pFullValue + (pBytes[i] << (pShiftAmount));
            	}
            	catch(Exception e){
            		System.debug('pShiftAmount: ' + pShiftAmount);
            		System.debug('pFullValue: ' + pFullValue);
            		System.debug('pBytes: ' + pBytes);
            		System.debug('pBytes[i]: ' + pBytes[i]);
            		System.debug('i: ' + i);
            	}
            }
            //now we don't want to always be declaring memory, so let's set the initial 
            //variables
            Integer bit;
            Integer targetOctet;
            Integer shiftBits;
            Integer tBitVal;
            Integer n;
            Integer nListSize = nList.size();
            for(Integer i=0; i<nListSize; i++){
                n = nList[i];
                //calculate the target bit for comparison
                bit = 7 - (Math.mod(n,8)); 
                //calculate the octet that has in the target bit
                targetOctet = (bytesBeingUsed - 1) - (n >> bytesBeingUsed); 
                //the number of bits to shift by until we find the bit to compare for true or false
                shiftBits = (targetOctet * 8) + bit;
                //& is to set the same set of bits for testing
                //shift to the bit which will dictate true or false
                //Math.Pow(2, shiftBits) == 2 << (shiftBits+1)
                tBitVal = ((Integer)(2 << (shiftBits-1)) & pFullValue) >> shiftBits;
                if (tBitVal==1)
                    results.add(n);
            }
            return results;
        }
    }
	
	
	public class TPicklistEntry{
        public string active {get;set;}
        public string defaultValue {get;set;}
        public string label {get;set;}
        public string value {get;set;}
        public string validFor {get;set;}
        public TPicklistEntry(){
            
        }
    }
}