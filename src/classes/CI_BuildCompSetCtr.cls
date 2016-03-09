/**************************************************************************
CREATED BY : Neel Desai
CREATED ON : June-2013
PURPOSE    : Competitive Intelligence - Saved Comp Set
TEST CLASS : CI_BuildCompSetCtrTest
**************************************************************************/
public with sharing class CI_BuildCompSetCtr 
{
    private Id motoProductRecordTypeId = null;
    private Id CompProductRecordTypeId = null;
    
    public List<SelectOption> motoProductOptions {get; set;}
    public List<SelectOption> regionOptions {get; set;}
    //public List<SelectOption> operatorOptions {get; set;}
    public List<SelectOption> brandOptions {get; set;}
    public List<SelectOption> osOptions {get; set;}
    public List<SelectOption> entryPeriodOptions {get; set;}
    public List<SelectOption> formFactorOptions {get; set;}
    public List<SelectOption> processorCoresOptions {get; set;}
    public List<SelectOption> displayResolutionsOptions {get; set;}
    public List<SelectOption> compProductOptions {get; set;}
    
    public String visibleSection {get; set;} //used to show/hide sections
    public String clientSideAlertMessage {get; set;} //setting value will show client side Alert msgbox
    public String compSetId {get; set;} //used to run report (pass parameter to popup window)
    public String compSetData {get; set;} //used to run report (pass parameter to popup window)
    public String compSetName {get; set;} //used for Add to Favourites
    public String motoProduct {get; set;}
    public List<String> region {get; set;}
    //public List<String> operator {get; set;}
    public List<String> brand {get; set;}
    public List<String> os {get; set;}
    public List<String> entryPeriod {get; set;}
    public List<String> formFactor {get; set;}
    public List<String> processorCores {get; set;}
    public List<String> displayResolutions {get; set;}
    public Boolean yes4G {get; set;}
    public Boolean no4G {get; set;}
    //public Boolean ipxx {get; set;}
    //public Boolean scratchResistant {get; set;}
    public Boolean nfc {get; set;}
    public Boolean fmRadio {get; set;}
    public Boolean dualSim {get; set;}
    public Boolean featurePhone {get; set;}
    public Boolean smartPhone {get; set;}
    public String minCameraMP {get; set;}
    public String maxCameraMP {get; set;}
    public String minSecCameraMP {get; set;}
    public String maxSecCameraMP {get; set;}
    public String minPrice {get; set;}
    public String maxPrice {get; set;}
    public String minScreenSize {get; set;}
    public String maxScreenSize {get; set;}
    public String minClockspeed {get; set;}
    public String maxClockspeed {get; set;}
    public String minRAM {get; set;}
    public String maxRAM {get; set;}
    public String minBatteryCapacity {get; set;}
    public String maxBatteryCapacity {get; set;}
    public List<String> compProducts {get; set;}
    
    private String regionFilter = '';
    /** Minimum, Maximum and Step values of the sliders **/
    public String minValCameraMP {get { return '0'; }}
    public String maxValCameraMP {get { return '17'; }}
    public String stepValCameraMP {get { return '1'; }}
    public String minValSecCameraMP {get { return '0'; }}
    public String maxValSecCameraMP {get { return '6'; }}
    public String stepValSecCameraMP {get { return '1'; }}
    public String minValPrice {get { return '0'; }}
    public String maxValPrice {get { return '425'; }}
    public String stepValPrice {get { return '25'; }}
    public String minValScreenSize {get { return '0.0'; }}
    public String maxValScreenSize {get { return '7.0'; }}
    public String stepValScreenSize {get { return '0.1'; }}
    public String minValClockspeed {get { return '0.0'; }}
    public String maxValClockspeed {get { return '2.5'; }}
    public String stepValClockspeed {get { return '0.1'; }}
    public String minValRAM {get { return '0'; }}
    public String maxValRAM {get { return '4224'; }}
    public String stepValRAM {get { return '128'; }}
    public String minValBatteryCapacity {get { return '1000'; }}
    public String maxValBatteryCapacity {get { return '4100'; }}
    public String stepValBatteryCapacity {get { return '100'; }}
    
    
    public CI_BuildCompSetCtr()
    {
        visibleSection = 'One'; //make only section 1 visible
        
        //set sliders initila values
        minCameraMP = minValCameraMP;
        maxCameraMP = maxValCameraMP;
        minSecCameraMP = minValSecCameraMP;
        maxSecCameraMP = maxValSecCameraMP;
        minPrice = minValPrice;
        maxPrice = maxValPrice;
        minScreenSize = minValScreenSize;
        maxScreenSize = maxValScreenSize;
        minClockspeed = minValClockspeed;
        maxClockspeed = maxValClockspeed;
        minRAM = minValRAM;
        maxRAM = maxValRAM;
        minBatteryCapacity = minValBatteryCapacity;
        maxBatteryCapacity = maxValBatteryCapacity;
        
        //get record type ids
        Map<String, Schema.RecordTypeInfo> rciList = Schema.SObjectType.Competitive_Product__c.getRecordTypeInfosByName();
        motoProductRecordTypeId = rciList.get('Motorola Product').getRecordTypeId();
        CompProductRecordTypeId = rciList.get('Competitor Product').getRecordTypeId();
        
        //populate Moto product and region list
        getMotoProducts();
        getRegions();
    }
    
    private void getMotoProducts()
    {
        motoProductOptions = new List<SelectOption>();
        /*
        String currQuarter, prevQuarter, nextQuarter, nextplusQuarter;
        String[] selectedQuarters;

        prevQuarter = DateUtil.getPrevQuarter();
        currQuarter = DateUtil.getCurrQuarter();
        nextQuarter = DateUtil.getNextQuarter();
        nextPlusQuarter = DateUtil.getNextPlusQuarter();
        
        selectedQuarters = new String[]{prevQuarter, currQuarter, nextQuarter, nextPlusQuarter};
		*/
       
        motoProductOptions.add(new SelectOption('- Select -','- Select -'));
        
        List<Competitive_Product__c> cpList = [SELECT   Name, Product__c, Entry_Period__c 
                                               FROM     Competitive_Product__c 
                                               WHERE    RecordTypeId = :motoProductRecordTypeId //only Motorola products
                                                  //AND Entry_Period__c IN :selectedQuarters
                                               ORDER BY Product__c];

        
        for(Competitive_Product__c cp : cpList)
        {
        	if(cp.Entry_Period__c == '' || cp.Entry_Period__c == 'Coming Soon' || cp.Entry_Period__c == 'Rumored'  || Integer.valueOf(cp.Entry_Period__c.split(' ',2)[1]) >= (Date.today().year() -1))
            	motoProductOptions.add(new SelectOption(cp.Name, cp.Product__c));
        }
    }

    private void getRegions()
    {
        regionOptions = new List<SelectOption>();
        //add available regions
        regionOptions.add(new SelectOption('Global','Global (All)'));
        regionOptions.add(new SelectOption('Asia','APAC'));
        regionOptions.add(new SelectOption('China','China'));
        regionOptions.add(new SelectOption('India','India'));
        regionOptions.add(new SelectOption('LATAM','LATAM'));
        regionOptions.add(new SelectOption('NAM','NAM'));
        //regionOptions.add(new SelectOption('NPI','NPI'));
        regionOptions.add(new SelectOption('WE','WE'));
    }

    public void filterByRegion()
    {
        clearParameterSelections();
        
        if(region.get(0) == 'Global') 
        {
            regionFilter = ''; // no filters for 'Global'
        }
        else
        {
            regionFilter = ' AND ( Region_Global__c = true OR Region_NPI__c = true'; //requirement - include Nulls in query result
            for(String reg : region)
            {
                regionFilter += ' OR Region_' + reg + '__c = true';
            }
            
            regionFilter += ')';
        }
        
        getParametersByRegion();

        visibleSection = 'Two';
    }
    
    private void getParametersByRegion()
    {
        //operatorOptions = new List<SelectOption>();
        brandOptions = new List<SelectOption>();
        osOptions = new List<SelectOption>();
        entryPeriodOptions = new List<SelectOption>();
        formFactorOptions = new List<SelectOption>();
        processorCoresOptions = new List<SelectOption>();
        displayResolutionsOptions = new List<SelectOption>();

        //Set<String> operatorSet = new Set<String>();
        Set<String> brandSet = new Set<String>();
        Set<String> osSet = new Set<String>();
        Set<String> entryPeriodSet = new Set<String>();
        Set<String> formFactorSet = new Set<String>();
        Set<String> processorCoresSet = new Set<String>();
        Set<String> displayResolutionsSet = new Set<String>();
        
        String query = 'SELECT Operator_ATT__c, Operator_Sprint__c, Operator_T_Mobile__c, Operator_US_Cellular__c, Operator_Verizon__c,' +
                       'Brand__c, OS__c, Entry_Period_Reversed__c, Form_Factor__c, Processor_Cores__c, Display_Resolution__c ' +
                       'FROM Competitive_Product__c ' +
                       'WHERE RecordTypeId = :CompProductRecordTypeId' + regionFilter; 
                                                               
        List<Competitive_Product__c> cpList = Database.query(query);
        
        for(Competitive_Product__c cp : cpList)
        {
        	/*
            if(cp.Operator_ATT__c)
                operatorSet.add('AT&T');

            if(cp.Operator_Sprint__c)
                operatorSet.add('Sprint');

            if(cp.Operator_T_Mobile__c)
                operatorSet.add('T-Mobile');

            if(cp.Operator_US_Cellular__c)
                operatorSet.add('US Cellular');

            if(cp.Operator_Verizon__c)
                operatorSet.add('Verizon');
			*/
            if(cp.Brand__c != null && cp.Brand__c != '')
                brandSet.add(cp.Brand__c);

            if(cp.OS__c != null && cp.OS__c != '')
                osSet.add(cp.OS__c);

            if(cp.Entry_Period_Reversed__c != null && cp.Entry_Period_Reversed__c != '') //Entry_Period_Reversed__c is used for easy sorting
                entryPeriodSet.add(cp.Entry_Period_Reversed__c);

            if(cp.Form_Factor__c != null && cp.Form_Factor__c != '')
                formFactorSet.add(cp.Form_Factor__c);

            if(cp.Processor_Cores__c != null && cp.Processor_Cores__c != '')
                processorCoresSet.add(cp.Processor_Cores__c);
                
            if(cp.Display_Resolution__c != null && cp.Display_Resolution__c != '')
            	displayResolutionsSet.add(cp.Display_Resolution__c);
        }
        
        //fillOptions(operatorSet, operatorOptions);
        fillOptions(brandSet, brandOptions);
        fillOptions(osSet, osOptions);
        //fillOptions(entryPeriodSet, EntryPeriodOptions);
        fillOptions(formFactorSet, formFactorOptions);
        fillOptions(processorCoresSet, processorCoresOptions);
        fillOptions(displayResolutionsSet, displayResolutionsOptions);
        
        
        /// Entry Period is reversed ie. '2013 Q2' instead of 'Q2 2013' so need to again reversed ///
        List<String> epList = new List<String>(entryPeriodSet);
        epList.sort();
        
        for(String ep : epList)
        {
            if(ep.endsWith('Q1') || ep.endsWith('Q2') || ep.endsWith('Q3') || ep.endsWith('Q4'))
               ep = ep.right(2) + ' ' + ep.left(4);
            
            EntryPeriodOptions.add(new SelectOption(ep, ep));
        }
    }
        
    private void fillOptions(Set<String> s, List<SelectOption> l)
    {
        List<String> items = new List<String>(s);
        items.sort();

        for(String item : items)
        {
            l.add(new SelectOption(item, item));
        }
    }
    
    public void backToRegionSelection()
    {
        visibleSection = 'One';
    }
    
    public void nextToProductSelection()
    {
        compProducts.clear();
        
        if(getCompProductsByParameters()){
        	clearParameterSelections();
            visibleSection = 'Three';
        }
    }
    
    public void clearParameterSelections()
    {
        //operator.clear();
        brand.clear();
        os.clear();
        entryPeriod.clear();
        formFactor.clear();
        processorCores.clear();
        displayResolutions.clear();
        yes4G = false;
        no4G = false;
        //ipxx = false;
        //scratchResistant = false;
        nfc = false;
        fmRadio = false;
        dualSim = false;
        featurePhone = false;
        smartPhone = false;
        minCameraMP = minValCameraMP;
        maxCameraMP = maxValCameraMP;
        minSecCameraMP = minValSecCameraMP;
        maxSecCameraMP = maxValSecCameraMP;
        minPrice = minValPrice;
        maxPrice = maxValPrice;
        minScreenSize = minValScreenSize;
        maxScreenSize = maxValScreenSize;
        minClockspeed = minValClockspeed;
        maxClockspeed = maxValClockspeed;
        minRAM = minValRAM;
        maxRAM = maxValRAM;
        minBatteryCapacity = minValBatteryCapacity;
        maxBatteryCapacity = maxValBatteryCapacity;
        
    }

    private Boolean getCompProductsByParameters()
    {
        compProductOptions = new List<SelectOption>();

        String query = 'SELECT Name, Brand__c, Product__c FROM Competitive_Product__c WHERE RecordTypeId = :CompProductRecordTypeId';
        /*
        if(operator != null && operator.size() > 0)
        {
            Boolean isFirst = true;
                
            for(String op : operator)
            {
                if(isFirst)
                {
                    query += ' AND (Operator_' + op.replace('&','').replaceAll('[ -]','_') + '__c = true';
                    isFirst = false;
                }
                else
                {
                    query += ' OR Operator_' + op.replace('&','').replaceAll('[ -]','_') + '__c = true';
                }
            }
                
            query += (isFirst == false) ? ')' : '' ;
        }
        */
        if(brand != null && brand.size() > 0)
        {
            query += ' AND Brand__c IN :brand';
        }
        if(os != null && os.size() > 0)
        {
            query += ' AND OS__c IN :os';
        }
        if(entryPeriod != null && entryPeriod.size() > 0)
        {
            query += ' AND Entry_Period__c IN :entryPeriod';
        }
        if(formFactor != null && formFactor.size() > 0)
        {
            query += ' AND Form_Factor__c IN :formFactor';
        }
        if(processorCores != null && processorCores.size() > 0)
        {
            query += ' AND Processor_Cores__c IN :processorCores';
        }
        if(displayResolutions != null && displayResolutions.size() > 0)
        {
            query += ' AND Display_Resolution__c IN :displayResolutions';
        }
        if(!(minCameraMP == minValCameraMP && maxCameraMP == maxValCameraMP))
        {
            if(minCameraMP == maxValCameraMP && maxCameraMP == maxValCameraMP)
                query += ' AND Camera__c >= ' + maxValCameraMP;
            else if(maxCameraMP == maxValCameraMP)
                query += ' AND Camera__c >= ' + minCameraMP;
            else if(minCameraMP == minValCameraMP)
                query += ' AND Camera__c <= ' + maxCameraMP;
            else
                query += ' AND (Camera__c >= ' + minCameraMP + ' AND Camera__c <= ' + maxCameraMP + ')';
        }
        if(!(minSecCameraMP == minValSecCameraMP && maxSecCameraMP == maxValSecCameraMP))
        {
            if(minSecCameraMP == maxValSecCameraMP && maxSecCameraMP == maxValSecCameraMP)
                query += ' AND Secondary_Camera__c >= ' + maxValSecCameraMP;
            else if(maxSecCameraMP == maxValSecCameraMP)
                query += ' AND Secondary_Camera__c >= ' + minSecCameraMP;
            else if(minSecCameraMP == minValSecCameraMP)
                query += ' AND Secondary_Camera__c <= ' + maxSecCameraMP;
            else
                query += ' AND (Secondary_Camera__c >= ' + minSecCameraMP + ' AND Secondary_Camera__c <= ' + maxSecCameraMP + ')';
        }
        if(!(minPrice == minValPrice && maxPrice == maxValPrice))
        {
            if(minPrice == maxValPrice && maxPrice == maxValPrice)
                query += ' AND ASP__c >= ' + maxValPrice;
            else if(maxPrice == maxValPrice)
                query += ' AND ASP__c >= ' + minPrice;
            else if(minPrice == minValPrice)
                query += ' AND ASP__c <= ' + maxPrice;
            else
                query += ' AND (ASP__c >= ' + minPrice + ' AND ASP__c <= ' + maxPrice + ')';
        }
        if(!(minScreenSize == minValScreenSize && maxScreenSize == maxValScreenSize))
        {
            if(minScreenSize == maxValScreenSize && maxScreenSize == maxValScreenSize)
                query += ' AND Display_Size__c >= ' + maxValScreenSize;
            else if(maxScreenSize == maxValScreenSize)
                query += ' AND Display_Size__c >= ' + minScreenSize;
            else if(minScreenSize == minValScreenSize)
                query += ' AND Display_Size__c <= ' + maxScreenSize;
            else
                query += ' AND (Display_Size__c >= ' + minScreenSize + ' AND Display_Size__c <= ' + maxScreenSize + ')';
        }
        if(!(minClockspeed == minValClockspeed && maxClockspeed == maxValClockspeed))
        {
            if(minClockspeed == maxValClockspeed && maxClockspeed == maxValClockspeed)
                query += ' AND Clockspeed__c >= ' + maxValClockspeed;
            else if(maxClockspeed == maxValClockspeed)
                query += ' AND Clockspeed__c >= ' + minClockspeed;
            else if(minClockspeed == minValClockspeed)
                query += ' AND Clockspeed__c <= ' + maxClockspeed;
            else
                query += ' AND (Clockspeed__c >= ' + minClockspeed + ' AND Clockspeed__c <= ' + maxClockspeed + ')';
        }
        if(!(minRAM == minValRAM && maxRAM == maxValRAM))
        {
            if(minRAM == maxValRAM && maxRAM == maxValRAM)
                query += ' AND RAM_Size__c >= ' + maxValRAM;
            else if(maxRAM == maxValRAM)
                query += ' AND RAM_Size__c >= ' + minRAM;
            else if(minRAM == minValRAM)
                query += ' AND RAM_Size__c <= ' + maxRAM;
            else
                query += ' AND (RAM_Size__c >= ' + minRAM + ' AND RAM_Size__c <= ' + maxRAM + ')';
        }
        if(!(minBatteryCapacity == minValBatteryCapacity && maxBatteryCapacity == maxValBatteryCapacity))
        {
            if(minBatteryCapacity == maxValBatteryCapacity && maxBatteryCapacity == maxValBatteryCapacity)
                query += ' AND Battery_Capacity__c >= ' + maxValBatteryCapacity;
            else if(maxBatteryCapacity == maxValBatteryCapacity)
                query += ' AND Battery_Capacity__c >= ' + minBatteryCapacity;
            else if(minBatteryCapacity == minValBatteryCapacity)
                query += ' AND Battery_Capacity__c <= ' + maxBatteryCapacity;
            else
                query += ' AND (Battery_Capacity__c >= ' + minBatteryCapacity + ' AND Battery_Capacity__c <= ' + maxBatteryCapacity + ')';
        }
        if(yes4G)
        {
            query += ' AND X4G__c != \'\'';
        }
        if(no4G)
        {
            query += ' AND X4G__c = \'\'';
        }
        /*
        if(ipxx)
        {
            query += ' AND IPXX__c != \'\'';
        }
        if(scratchResistant)
        {
            query += ' AND Scratch_Resistant__c = true';
        }
        */
        if(nfc)
        {
            query += ' AND NFC__c != \'\'';
        }        
        if(fmRadio)
        {
            query += ' AND Radio__c != \'\'';
        }
        if(dualSim)
        {
                query += ' AND Dual_SIM__c != \'\'';
        }
        if(featurePhone && smartPhone)
        {
        	query += ' AND Domain__c =\'\'';
        	if(smartPhone)
        	{
        		query += ' AND Domain__c = \'Smart Phones\'';
        	}
        	if(featurePhone)
        	{
        		query += ' AND Domain__c = \'Feature Phones\'';
        	}
        }
        
        
        query += regionFilter;
        query += ' ORDER BY Brand__c, Product__c LIMIT 1000'; //limit top 1000 records - picklist limit

        List<Competitive_Product__c> cpList = Database.query(query);
        
        if(cpList.size() == 0)
        {
            clientSideAlertMessage = 'No product matching your selections. Please widen your selections.'; //popup message
            return false;
        }
        
        for(Competitive_Product__c cp : cpList)
        {
            compProductOptions.add(new SelectOption(cp.Name, cp.Brand__c + ' ' + cp.Product__c));
        } 
        
        return true;
    }
        
    public void runReport()
    {
        if(compProducts.size() > 0 && compProducts.size() <= 15)
        {
        	/**** following replaced with encoded string parameter method ****/
            //Competitive_Product_Comp_Set__c compSet = new Competitive_Product_Comp_Set__c();
            //compSet.Name = UtilGUID.NewGUID();
            //compSet.Motorola_Product__c = motoProduct;
            //compSet.Competitor_Products__c = String.join(compProducts, ',');
            //
            //insert compSet;
            //
            //compSetId = compSet.Id;
            /****************************************************************/
            
            String products = motoProduct + ',' + String.join(compProducts, ',');
            compSetData = EncodingUtil.base64Encode(Blob.valueOf(products));
        }
        else
        {
        	clientSideAlertMessage = 'You can select only 15 prodcuts at one time.';
        }
    }
    
    public void addToFavourite()
    {
        if(compProducts.size() > 0 && compProducts.size() <= 15)
        {
            Competitive_Product_Comp_Set__c compSet = new Competitive_Product_Comp_Set__c();
            compSet.Name = compSetName;
            compSet.Motorola_Product__c = motoProduct;
            compSet.Competitor_Products__c = String.join(compProducts, ',');
            compSet.User__c = UserInfo.getUserId();
            
            insert compSet;
            
            compSetName = null;
            
            compSetId = compSet.Id;
            
            clientSideAlertMessage = 'Comp Set saved successfully. You can access it under Saved Comp Sets tab.';
        }
        else{
        	clientSideAlertMessage = 'You can select only 15 products at one time.';
        }
    }
    
    public void backToParamSelection()
    {
        visibleSection = 'Two';
    }
    
    public void buildNewCompSet()
    {
        motoProduct = null;
        region.clear();

        visibleSection = 'One';
    }
}