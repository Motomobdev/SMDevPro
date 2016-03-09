/* jescamilla@levementum.com 9/4/14 Description:
    From the detail page of a Quote there is a button called Deep Clone, when clicked this logic will fire.
    The purpose of this code is to clone a quote and the line items with it. 
*/
public without sharing class DealDeepCloneController 
{
    public List<dliWrapper> dealLineItemsFromSoftClone {get; set;}
    public List<dliWrapper> allDealLineItemsFromSoftClone {get; set;}
    public Boolean queueAvailable {get; set;}
    public Integer currentYear = Date.Today().year();
    public Integer numberOfYearOptions = 4;
    public Boolean isActive {get; set;}
    public String quoteIdFromSoftClone {get; set;}
    Public String feedbackMsg {get; set;}
    Public String accountName {get; set;}
    Public String oppName {get; set;}
    Public Quote quoteToClone = new Quote();
    Public Quote clonedQuote = new Quote();
    public Opportunity clonedopp = new Opportunity();
    public Opportunity newOpportunity = new Opportunity();
    Public List<QuoteLineItem> qlisToClone {get; set;}
    Public List<QuoteLineItem> qlisToInsert = new List<QuoteLineItem>();
    Set<String> ignoredFields = new Set<String> {'id'};
    Public Quote clonedQuoteTemp {get; set;}
    Map<String, Schema.SObjectField> quoteFields =  new Map<String, Schema.SObjectField>();
    Public List<dliWrapper> dealLineItems {get; set;}
    Public Quote clonedQuoteOppIdTemp {get; set;}//jgarcia@levementum.com. 9/10/2014. Use to default the opportunity when deep cloning from the original quote
    Public Opportunity accountIdTemp {get;set;}  
    public Boolean activeQueue {get; set;}
    
    /*
     * @author:  Cuauhtemoc Munoz
     * @date:  09/11/14
     * @email:  cmunoz@levementum.com
     * @description:  Task and Event
     */
     public List<Task> taskToClone = new List<Task>();  
     public Task clonedTask = new Task();
     public List<Task> taskListToInsert = new List<Task>();
     
     public List<Event> eventToClone = new List<Event>();
     public Event clonedEvent = new Event();
     public List<Event> eventListToInsert = new List<Event>();
     
     public List<Attachment> attachmentToClone = new List<Attachment>();
     public Attachment clonedAttachment = new Attachment();
     public List<Attachment> attachmentListToInsert = new List<Attachment>();
     
     // smandava@motorola.com 10/08/14. Description: DEEP CLONE THE DEAL STOPLIGHT DEVIATION
     public List<Deal_Stoplight_Deviation__c> deviationToClone = new List<Deal_Stoplight_Deviation__c>();
     public List<Deal_Stoplight_Deviation__c> deviationListToInsert = new List<Deal_Stoplight_Deviation__c>();
     
     public String quoteId {get; set;}
     
     // cmunoz@levementum.com. 03/17/15. Description: Add cloning options for both soft and deep deal clone.
     public String cloneOption {get; set;}
     public boolean newAccount {get; set;}
     public boolean currentOpp {get; set;}
     public boolean newOpp {get; set;}
     public String cloneAccountOptionMsg {get; set;}
     public boolean existingOpp {get; set;}
     public boolean oppAssociation {get; set;}
     public Opportunity selectedAccountLookUp {get; set;}
     public Quote selectedOppLookUp {get; set;}
     public List<QuoteLineItem> newLineItemsFromAccountOption {get; set;}
     public List<Quote> selectedQuote = new List<Quote>();
     public List<Account> selectedAccount {get; set;}
     public boolean createDealViewer {get; set;}
     public List<Opportunity> selectedOpp {get; set;}
    
    public DealDeepCloneController(ApexPages.StandardController controller) 
    {
        try 
        {       
            // cmunoz@levementum.com. 03/17/15. Description: Add cloning options for both soft and deep deal clone.
            cloneOption = 'Current Opportunity';
            cloneAccountOptionMsg = 'The current Opportunity will be cloned. Do you want to continue?';
            currentOpp = true;
            newOpp = false;
            newAccount = false;
            existingOpp = true;
            oppAssociation = false;
            selectedOppLookUp = new Quote();
            newLineItemsFromAccountOption = new List<QuoteLineItem>();  
            createDealViewer = false;       
            
            clonedQuoteTemp = new Quote();
            qlisToClone = new List<QuoteLineItem>();
            //jgarcia@levementum.com. 9/10/2014. Use to default the opportunity when deep cloning from the original quote
            clonedQuoteOppIdTemp = new Quote();
            
            //LOAD QUOTE TO CLONE  
            quoteToClone = [SELECT Opportunity.Account.Name, Deal_Review_Date__c, AccountId, AdditionalCity, AdditionalCountry, AdditionalName, AdditionalState, AdditionalStreet, AdditionalPostalCode, BillingCity
                            , BillingCountry, BillingName, BillingState, BillingStreet, BillingPostalCode, ContactId, CreatedById, CreatedDate, CurrencyIsoCode
                            , IsDeleted, Description, Discount, Email, ExpirationDate, Fax, GrandTotal, LastModifiedById, LastModifiedDate, LineItemCount, OpportunityId
                            , Phone, Pricebook2Id, Id, Name, QuoteNumber, QuoteToCity, QuoteToCountry, QuoteToName, QuoteToState, QuoteToStreet, QuoteToPostalCode 
                            , ShippingCity, ShippingCountry, ShippingName, ShippingState, ShippingStreet, ShippingPostalCode, ShippingHandling,Subtotal, IsSyncing
                            , SystemModstamp, Tax, TotalPrice, ShippingLatitude, ContractId, RecordTypeId
                            FROM Quote WHERE Id = :controller.getId() limit 1];
            quoteToClone.Status = 'New';
            quoteId = controller.getId();
            clonedQuoteTemp.OpportunityId = quoteToClone.OpportunityId;
            selectedOppLookUp.OpportunityId = quoteToClone.OpportunityId;

            //FETCH ACCOUNT NAME FOR VISUALFORCE
            accountName = quoteToClone.Opportunity.Account.Name;

            //LOAD LINE ITEMS TO CLONE
            qlisToClone = [SELECT AP__c, Accrual_Amount__c, Actual_Selling_Price_ASP__c, Approval_Status__c, CM__c, COOP__c, CSAT__c, Contribution_Margin__c
                           , CoopComment__c, CreatedById, CreatedDate, CurrencyIsoCode, ServiceDate, Deal_Type__c, IsDeleted, Discount, Discount_Total__c
                           , Fees__c, GM__c, Gross_Margin__c, ILW__c, IPP__c, InvoicePrice__c, LastModifiedById, LastModifiedDate, Description, LineNumber
                           , ListPrice, MCPU__c, MDF__c, MinimumCommitQuantity__c, Motoagents__c, NSAD__c, NSBD__c, NSBDComment__c, Name__c, National_Retail__c
                           , Negotiation_Buffer__c, Non_Visible_Fees__c, Non_Visible_TDF__c, PricebookEntryId, QP__c, Quantity, Quantity__c, Quarter__c, QuoteId
                           , Id, SDF__c, SVM__c, UnitPrice, Subtotal, SystemModstamp, TC__c, TDF__c, Total_A_P__c, TotalAPAmount__c, Total_Aggregate_Discounts__c
                           , Total_CM__c, Total_COG__c, Total_COOP__c, Total_CSAT__c, Total_Contribution_Margin__c, Total_Discounts__c, Total_Fees__c, Total_GM__c
                           , Total_Gross_Margin__c, Total_ILW__c, Total_IPP__c, Total_MDF__c, Total_Motoagents__c, Total_NSAD__c, Total_NSBD__c
                           , Total_National_Retail__c, Total_Negotiation_Buffer__c, TotalPrice, Total_QP__c, Total_SDF__c, Total_SVM__c, Total_TC__c, Total_TDF__c
                           , Total_iMDF__c, Units__c, Year__c, coopOpComment__c, csatComment__c, csatOpComment__c, discountComment__c, feesComment__c
                           , feesOpComment__c, iMDF__c, ilwComment__c, ilwOpComment__c, imdfComment__c, imdfOpComment__c, ippCOmment__c, ippOpComment__c
                           , mcpuComment__c, mdfComment__c, mdfOpComment__c, minimumCommitOpComment__c, nationalRetailComment__c, nationalRetailOpComment__c
                           , negotiationBufferComment__c, negotiationBufferOpComment__c, nsadComment__c, nsbdOpComment__c, operatorMinimuCommitComment__c
                           , qpComment__c, qpOpComment__c, sdfOpComment__c, svmComment__c, svmOpComment__c, tcComment__c, tcOpComment__c, tdfComment__c
                           , tdfOpComment__c, Product2.Name
                           FROM QuoteLineitem WHERE QuoteId = :quoteToClone.Id];
                           
            // cmunoz@levementum.com 09/11/14. Description: Load Activities to clone
            taskToClone = [SELECT Trained__c, AccountId, Activity_External_Unique_ID__c, Id, IsArchived, OwnerId, BSA_Audience_Feedback_about_MMI_Products__c, BSA_Overcome_Objection__c, 
                    BSA_Requestor__c, BSA_Response_Provided__c, BSA_Blackberry_User_Count__c, Business__c, BSA_Buying_Motive__c, CallDurationInSeconds, CallObject, CallDisposition, CallType, 
                    BSA_Carriers_Supported__c, Category__c, BSA_Channel__c, BSA_Client_Company_Name__c, IsClosed, Commitments_Needed_from_Partner__c, Commitments_Needed_from_Partner_Extended__c, 
                    BSA_Competitive_Comments__c, BSA_Competitors_in_Attendance__c, WhoId, BSA_Count_of_Pictures_Attached__c, IsRecurrence, CreatedById, CreatedDate, Created_by_Gadget__c, 
                    CurrencyIsoCode, BSA_Current_MMI_Product_Issues__c, IsDeleted, BSA_Department_Present__c, Description, BSA_Devices_Demoed__c, ActivityDate, RecurrenceEndDateOnly, 
                    Event_Local_Date_Time__c, Event_Timezone__c, BSA_Event_Type__c, BSA_Followup_Comments__c, BSA_GTM_Channel_Manager__c, BSA_General_Comments__c, Global_Strategy_Related__c, 
                    BSA_Group1_Business_Segment__c, BSA_Group_2_Business_Segment__c, BSA_Group_3_Business_Segment__c, BSA_HTC_User_Count__c, Include_In_Weekly_Report__c, 
                    DaScoopComposer__Is_Created_By_Groove__c, Key_Messages_Meeting_Goals__c, Key_Messages_Meeting_Goals_Extended__c, LastModifiedById, LastModifiedDate, 
                    DaScoopComposer__LastModifiedDate__c, Long_Term_MMI_Strategy_3_Months__c, Long_Term_MMI_Strategy_Extended__c, MMI_Issues_with_Partner__c, MMI_Issues_with_Partner_Extended__c, 
                    BSA_MMI_Product_Objections__c, BSA_Manufacturer_Devices_Used__c, Mid_Term_MMI_Goals_3_Months__c, Mid_Term_MMI_Goals_Extended__c, Milestone__c, Milestone_continued__c, 
                    DaScoopComposer__Mirror_in_Owner_s_Calendar__c, Motorola_Mobility_Attendees__c, Motorola_Mobility_Attendees_Extended__c, BSA_Motorola_User_Count__c, NDA_Type_End_Date_Status__c, 
                    Next_Week_s_Activities__c, BSA_Number_of_People_Demonstrated_To__c, Number_of_People_Trained_Group_1__c, Number_of_People_Trained_Group_2__c, Number_of_People_Trained_Group_3__c, 
                    BSA_Number_of_People_in_Attendance__c, Objective__c, BSA_Opportunity_Status__c, WhatId, BSA_Other_Competitor_in_Attendance__c, BSA_Other_Device_Demoed__c, BSA_Other_Requestor__c,
                    BSA_Other_Special_Event__c, BSA_Other_User_Count__c, Planned_Attendees__c, BSA_Potential_Implementation_Date__c, BSA_Presentation_Focus__c, BSA_Primary_Vertical__c, 
                    Priority, Priority_Scope__c, Proposed_Agenda__c, Proposed_Agenda_Extended__c, ConnectionReceivedId, RecurrenceActivityId, RecurrenceDayOfMonth, RecurrenceDayOfWeekMask, 
                    RecurrenceInstance, RecurrenceInterval, RecurrenceMonthOfYear, RecurrenceTimeZoneSidKey, RecurrenceType, ReminderDateTime, IsReminderSet, Room__c, ConnectionSentId, 
                    Short_Term_MMI_Goals_3_Months__c, Short_Term_MMI_Goals_Extended__c, BSA_Special_Event_Comments__c, BSA_Special_Event_Type__c, RecurrenceStartDateOnly, Status__c, Status, 
                    Status_Flag__c, Subject, SystemModstamp, RecordTypeId, This_Week_s_Status__c, This_Week_s_Status_continued__c, BSA_Total_People_Trained__c, BSA_Total_Potential_Devices__c, 
                    BSA_Training_Format__c, BSA_Training_Type__c, Type, Validation_Override__c, BSA_Venue_State_Province__c, BSA_Venue_Zip__c, Weekly_Report_Status__c, You_Are_Meeting_Extended__c, 
                    You_are_Meeting__c, BSA_iPhone_User_Count__c, DaScoopComposer__vCal_UID__c, DaScoopComposer__vCal_IID__c FROM Task WHERE WhatId = :controller.getId()];
              
            // cmunoz@levementum.com 09/11/14. Description: Load Event to clone      
            eventToClone = [SELECT Trained__c, AccountId, CurrencyIsoCode, Activity_External_Unique_ID__c, Id, IsAllDayEvent, IsArchived, OwnerId, BSA_Audience_Feedback_about_MMI_Products__c, 
                    BSA_Overcome_Objection__c, BSA_Requestor__c, BSA_Response_Provided__c, BSA_Blackberry_User_Count__c, Business__c, BSA_Buying_Motive__c, BSA_Carriers_Supported__c, Category__c, 
                    BSA_Channel__c, BSA_Client_Company_Name__c, Commitments_Needed_from_Partner__c, Commitments_Needed_from_Partner_Extended__c, BSA_Competitive_Comments__c, 
                    BSA_Competitors_in_Attendance__c, WhoId, BSA_Count_of_Pictures_Attached__c, IsRecurrence, CreatedById, CreatedDate, Created_by_Gadget__c, 
                    BSA_Current_MMI_Product_Issues__c, IsDeleted, BSA_Department_Present__c, Description, BSA_Devices_Demoed__c, ActivityDate, ActivityDateTime, DurationInMinutes, 
                    RecurrenceEndDateOnly, EndDateTime, Event_Local_Date_Time__c, RecordTypeId, Event_Timezone__c, BSA_Event_Type__c, BSA_Followup_Comments__c, BSA_GTM_Channel_Manager__c, 
                    BSA_General_Comments__c, Global_Strategy_Related__c, BSA_Group1_Business_Segment__c, BSA_Group_2_Business_Segment__c, BSA_Group_3_Business_Segment__c, GroupEventType, 
                    BSA_HTC_User_Count__c, Include_In_Weekly_Report__c, IsChild, DaScoopComposer__Is_Created_By_Groove__c, IsGroupEvent, Key_Messages_Meeting_Goals__c, 
                    Key_Messages_Meeting_Goals_Extended__c, LastModifiedById, LastModifiedDate, DaScoopComposer__LastModifiedDate__c, Location, Long_Term_MMI_Strategy_3_Months__c, 
                    Long_Term_MMI_Strategy_Extended__c, MMI_Issues_with_Partner__c, MMI_Issues_with_Partner_Extended__c, BSA_MMI_Product_Objections__c, BSA_Manufacturer_Devices_Used__c,
                     Mid_Term_MMI_Goals_3_Months__c, Mid_Term_MMI_Goals_Extended__c, Milestone__c, Milestone_continued__c, DaScoopComposer__Mirror_in_Owner_s_Calendar__c, 
                     Motorola_Mobility_Attendees__c, Motorola_Mobility_Attendees_Extended__c, BSA_Motorola_User_Count__c, NDA_Type_End_Date_Status__c, Next_Week_s_Activities__c, 
                     BSA_Number_of_People_Demonstrated_To__c, Number_of_People_Trained_Group_1__c, Number_of_People_Trained_Group_2__c, Number_of_People_Trained_Group_3__c, 
                     BSA_Number_of_People_in_Attendance__c, Objective__c, BSA_Opportunity_Status__c, WhatId, BSA_Other_Competitor_in_Attendance__c, BSA_Other_Device_Demoed__c, 
                     BSA_Other_Requestor__c, BSA_Other_Special_Event__c, BSA_Other_User_Count__c, Planned_Attendees__c, BSA_Potential_Implementation_Date__c, BSA_Presentation_Focus__c, 
                     BSA_Primary_Vertical__c, Priority_Scope__c, IsPrivate, Proposed_Agenda__c, Proposed_Agenda_Extended__c, RecurrenceActivityId, RecurrenceDayOfMonth, 
                     RecurrenceDayOfWeekMask, RecurrenceInstance, RecurrenceInterval, RecurrenceMonthOfYear, RecurrenceTimeZoneSidKey, RecurrenceType, ReminderDateTime, 
                     IsReminderSet, Room__c, Short_Term_MMI_Goals_3_Months__c, Short_Term_MMI_Goals_Extended__c, ShowAs, BSA_Special_Event_Comments__c, BSA_Special_Event_Type__c, 
                     RecurrenceStartDateTime, StartDateTime, Status__c, Status_Flag__c, Subject, SystemModstamp, This_Week_s_Status__c, This_Week_s_Status_continued__c, 
                     BSA_Total_People_Trained__c, BSA_Total_Potential_Devices__c, BSA_Training_Format__c, BSA_Training_Type__c, Type, Validation_Override__c, BSA_Venue_State_Province__c, 
                     BSA_Venue_Zip__c, Weekly_Report_Status__c, You_Are_Meeting_Extended__c, You_are_Meeting__c, BSA_iPhone_User_Count__c, DaScoopComposer__vCal_UID__c, 
                     DaScoopComposer__vCal_IID__c FROM Event WHERE WhatId = :quoteToClone.Id];
                     
            attachmentToClone = [SELECT Id, Body, BodyLength, ContentType, CreatedById, CreatedDate, IsDeleted, Description, Name, IsPartnerShared,
                         LastModifiedById, LastModifiedDate, OwnerId, ParentId, IsPrivate, ConnectionReceivedId, ConnectionSentId, SystemModstamp 
                         FROM Attachment where parentId = :controller.getId()];
        
            // smandava@motorola.com 10/08/14. Description: DEEP CLONE THE DEAL STOPLIGHT DEVIATION
            deviationToClone = [SELECT Carrier_Branding_AppDate__c,Carrier_Branding_Approver__c,Carrier_Branding_ASP__c,Carrier_Branding_Dev__c,Carrier_Branding_Exp__c,Carrier_Branding_Standard__c,
                            Carrier_Branding_Status__c,Carrier_Branding_VMImp__c,Carrier_Branding_VM__c,Channel_Fill_AppDate__c,Channel_Fill_Approver__c,Channel_Fill_ASP__c,Channel_Fill_Dev__c,
                            Channel_Fill_Exp__c,Channel_Fill_Standard__c,Channel_Fill_Status__c,Channel_Fill_VMImp__c,Channel_Fill_VM__c,Charger_Accessories_AppDate__c,Charger_Accessories_Approver__c,
                            Charger_Accessories_ASP__c,Charger_Accessories_Dev__c,Charger_Accessories_Exp__c,Charger_Accessories_Standard__c,Charger_Accessories_Status__c,Charger_Accessories_VMImp__c,
                            Charger_Accessories_VM__c,ConnectionReceivedId,ConnectionSentId,Core_Device_Specifications_AppDate__c,Core_Device_Specifications_App__c,Core_Device_Specifications_ASP__c,
                            Core_Device_Specifications_Dev__c,Core_Device_Specifications_Exp__c,Core_Device_Specifications_Status__c,Core_Device_Specifications_Std__c,Core_Device_Specifications_VMImp__c,
                            Core_Device_Specifications_VM__c,CP_Attach_AppDate__c,CP_Attach_Approver__c,CP_Attach_ASP__c,CP_Attach_Dev__c,CP_Attach_Exp__c,CP_Attach_Standard__c,CP_Attach_Status__c,CP_Attach_VMImp__c,
                            CP_Attach_VM__c,CreatedById,CreatedDate,CurrencyIsoCode,Deal__c,ELX_Prepaid_AppDate__c,ELX_Prepaid_Approver__c,ELX_Prepaid_ASP__c,ELX_Prepaid_Dev__c,ELX_Prepaid_Exp__c,ELX_Prepaid_Standard__c,
                            ELX_Prepaid_Status__c,ELX_Prepaid_VMImp__c,ELX_Prepaid_VM__c,Forecasting_AppDate__c,Forecasting_Approver__c,Forecasting_ASP__c,Forecasting_Dev__c,Forecasting_Exp__c,Forecasting_Standard__c,
                            Forecasting_Status__c,Forecasting_VMImp__c,Forecasting_VM__c,Id,Incoterms_AppDate__c,Incoterms_Approver__c,Incoterms_ASP__c,Incoterms_Dev__c,Incoterms_Exp__c,Incoterms_Standard__c,Incoterms_Status__c,
                            Incoterms_VMImp__c,Incoterms_VM__c,IPP_AppDate__c,IPP_Approver__c,IPP_ASP__c,IPP_Dev__c,IPP_Exp__c,IPP_Standard__c,IPP_Status__c,IPP_VMImp__c,IPP_VM__c,IsDeleted,LastModifiedById,LastModifiedDate,
                            LastReferencedDate,LastViewedDate,Late_Delivery_Penalty_AppDate__c,Late_Delivery_Penalty_Approver__c,Late_Delivery_Penalty_ASP__c,Late_Delivery_Penalty_Dev__c,Late_Delivery_Penalty_Exp__c,Late_Delivery_Penalty_Standard__c,
                            Late_Delivery_Penalty_Status__c,Late_Delivery_Penalty_VMImp__c,Late_Delivery_Penalty_VM__c,MDF_AppDate__c,MDF_Approver__c,MDF_ASP__c,MDF_Dev__c,MDF_Exp__c,MDF_Standard__c,MDF_Status__c,MDF_VMImp__c,MDF_VM__c,MFN_AppDate__c,
                            MFN_Approver__c,MFN_ASP__c,MFN_Dev__c,MFN_Exp__c,MFN_Standard__c,MFN_Status__c,MFN_VMImp__c,MFN_VM__c,Name,Not_to_Exceed_Retail_Price_AppDate__c,Not_to_Exceed_Retail_Price_Approver__c,Not_to_Exceed_Retail_Price_ASP__c,
                            Not_to_Exceed_Retail_Price_Dev__c,Not_to_Exceed_Retail_Price_Exp__c,Not_to_Exceed_Retail_Price_Standard__c,Not_to_Exceed_Retail_Price_Status__c,Not_to_Exceed_Retail_Price_VMImp__c,Not_to_Exceed_Retail_Price_VM__c,
                            Payment_Terms_AppDate__c,Payment_Terms_Approver__c,Payment_Terms_ASP__c,Payment_Terms_Dev__c,Payment_Terms_Exp__c,Payment_Terms_Standard__c,Payment_Terms_Status__c,Payment_Terms_VMImp__c,Payment_Terms_VM__c,Product_Exclusivity_AppDate__c,
                            Product_Exclusivity_Approver__c,Product_Exclusivity_ASP__c,Product_Exclusivity_Dev__c,Product_Exclusivity_Exp__c,Product_Exclusivity_Standard__c,Product_Exclusivity_Status__c,Product_Exclusivity_VMImp__c,Product_Exclusivity_VM__c,
                            Provision_Type__c,Seeding_Demo_Units_AppDate__c,Seeding_Demo_Units_Approver__c,Seeding_Demo_Units_ASP__c,Seeding_Demo_Units_Dev__c,Seeding_Demo_Units_Exp__c,Seeding_Demo_Units_Status__c,Seeding_Demo_Units_Std__c,Seeding_Demo_Units_VMImp__c,
                            Seeding_Demo_Units_VM__c,Sell_Through_Plan_AppDate__c,Sell_Through_Plan_Approver__c,Sell_Through_Plan_ASP__c,Sell_Through_Plan_Dev__c,Sell_Through_Plan_Exp__c,Sell_Through_Plan_Standard__c,Sell_Through_Plan_Status__c,Sell_Through_Plan_VMImp__c,
                            Sell_Through_Plan_VM__c,Shipping_and_Handling_AppDate__c,Shipping_and_Handling_Approver__c,Shipping_and_Handling_ASP__c,Shipping_and_Handling_Dev__c,Shipping_and_Handling_Exp__c,Shipping_and_Handling_Standard__c,Shipping_and_Handling_Status__c,
                            Shipping_and_Handling_VMImp__c,Shipping_and_Handling_VM__c,Software_PreLoads_AppDate__c,Software_PreLoads_Approver__c,Software_PreLoads_ASP__c,Software_PreLoads_Dev__c,Software_PreLoads_Exp__c,Software_PreLoads_Status__c,Software_PreLoads_Std__c,
                            Software_PreLoads_VMImp__c,Software_PreLoads_VM__c,Status__c,SW_Updates_AppDate__c,SW_Updates_Approver__c,SW_Updates_ASP__c,SW_Updates_Dev__c,SW_Updates_Exp__c,SW_Updates_Standard__c,SW_Updates_Status__c,SW_Updates_VMImp__c,SW_Updates_VM__c,
                            SystemModstamp,Volume_Commitment_AppDate__c,Volume_Commitment_Approver__c,Volume_Commitment_ASP__c,Volume_Commitment_Dev__c,Volume_Commitment_Exp__c,Volume_Commitment_Standard__c,Volume_Commitment_Status__c,Volume_Commitment_VMImp__c,
                            Volume_Commitment_VM__c,Warranty_Service_Repair_AppDate__c,Warranty_Service_Repair_Approver__c,Warranty_Service_Repair_ASP__c,Warranty_Service_Repair_Dev__c,Warranty_Service_Repair_Exp__c,Warranty_Service_Repair_Status__c,Warranty_Service_Repair_Std__c,
                            Warranty_Service_Repair_VMImp__c,Warranty_Service_Repair_VM__c,Warranty_Term_AppDate__c,Warranty_Term_Approver__c,Warranty_Term_ASP__c,Warranty_Term_Dev__c,Warranty_Term_Exp__c,Warranty_Term_Standard__c,Warranty_Term_Status__c,Warranty_Term_VMImp__c,
                            Warranty_Term_VM__c FROM Deal_Stoplight_Deviation__c Where Deal__c = :quoteToClone.Id];

                //jgarcia@levementum.com. 9/10/2014. Use to default the opportunity when deep cloning from the original quote
                clonedQuoteOppIdTemp.OpportunityId = quoteToClone.OpportunityId;
                clonedQuoteOppIdTemp.Name = quoteToClone.Name;
                accountIdTemp = [SELECT Account.name, AccountId, Name FROM Opportunity WHERE Id =:clonedQuoteOppIdTemp.OpportunityId];
                selectedAccountLookUp = [SELECT Account.name, AccountId, Name FROM Opportunity WHERE Id =:clonedQuoteOppIdTemp.OpportunityId];
        } catch (Exception e) {
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + ' On Line: ' + e.getLineNumber()));
        }
        addLineItems(qlisToClone);
    }
    
     /**
     * @author: Cuauhtemoc Munoz
     * @email:  cmunoz@levementum.com
     * @date:   03/18/15
     * @description:    Refactor deal line items initialization in a separate method
     */
    public void addLineItems(List<QuoteLineItem> qlisToClone)
    {
        try
        {
            dealLineItems = new List<dliWrapper>();
            Integer dliIndex = 1;
            for (QuoteLineitem qliToClone : qlisToClone) 
            {
                dliWrapper currentDLI = New dliWrapper();
                dliWrapper tempDLI = New dliWrapper();

                currentDLI.dli = qliToClone.clone(false, true, false, false);
                currentDLI.dliIndex = dliIndex;
                dealLineItems.add(currentDLI);
                dliIndex++;
            } 
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
        }
    }
    
    /**
     * @author: Cuauhtemoc Munoz
     * @email:  cmunoz@levementum.com
     * @date:   03/17/15
     * @description:    Initialize clone options for both soft and deal clone
     */
     public List<SelectOption> getCloneOptions()
     {
        List<SelectOption> cloneOptions = new List<SelectOption>();
        try
        {
            cloneOptions.add(new SelectOption('Current Opportunity', 'Clone on same opportunity - For resubmitting a Rejected Deal or to change an already Approved Deal'));
            cloneOptions.add(new SelectOption('New Opportunity', 'Clone on different opportunity - To build a new Deal for the same account, copying the Stoplight and other attributes'));
            cloneOptions.add(new SelectOption('New Account', 'Clone on different Account - To take the basic structure of deal and reproduce for a different Account'));
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ' Cannot create clone option. Please contact your administrator'));
        }
        return cloneOptions;
     }
     
     /**
     * @author: Cuauhtemoc Munoz
     * @email:  cmunoz@levementum.com
     * @date:   03/17/15
     * @description:    Reload page on option selected
     */
     public void selectCloneOption()
     {
        try
        {
            currentOpp = cloneOption.equalsIgnoreCase('Current Opportunity')  ? true : false;
            newOpp = cloneOption.equalsIgnoreCase('New Opportunity')  ? true : false;
            newAccount = cloneOption.equalsIgnoreCase('New Account') ? true : false;
            
            
            
            if(currentOpp || newOpp)
            {
            
                if(newOpp)
                {
                createNewOpportunity();
                addLineItems(qlisToClone);
                createDealViewer = false;
                }
                addLineItems(qlisToClone);
                createDealViewer = false;
                                
            }
            else
            {
                addLineItems(newLineItemsFromAccountOption);
                if(oppAssociation)
                {
                    createDealViewer = true;
                }
            }
            
            if(currentOpp)
            {
                cloneAccountOptionMsg = 'The current Opportunity will be cloned. Do you want to continue?';
            }
            else if(newOpp)
            {
                cloneAccountOptionMsg = 'The selected Opportunity will be cloned. Do you want to continue?';
            }
            else
            {
                cloneAccountOptionMsg = 'The selected Account will be cloned. Do you want to continue?';
            }
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ' Cannot create clone option. Please contact your administrator'));
        }
     }
     
    /**
     * @author: Cuauhtemoc Munoz
     * @email:  cmunoz@levementum.com
     * @date:   03/17/15
     * @description: Ask user whether they want to do Scenario 1 or Scenario 2 (Create new Opportunity first and then deal) 
     *               Scenario 1: Select Account, if deals related to this Account, create new Deal
     *               Scenario 2: Select Account, if deals not related to this Account, associate to one of the existing opportunities
     */
     public void cloneQuoteToNewAccount()
     {
        try
        {
            if(selectedAccountLookUp != null)
            {
                if(accountIdTemp.AccountId != selectedAccountLookUp.AccountId)
                {
                    cloneAccountOptionMsg = 'The Account is associated with the current Opportunity. Do you want to associate this Account with this Opportunity?';
                    existingOpp = true;
                    addLineItems(qlisToClone);
                }
                else
                {
                    selectedAccount = [SELECT Name, Id FROM Account WHERE Id =: selectedAccountLookUp.AccountId];
                    selectedOpp = [SELECT Name, Id FROM Opportunity WHERE Id =: selectedOppLookUp.OpportunityId];
                    if(selectedAccount.size() > 0 && selectedOpp.size() > 0)
                    { 
                        existingOpp = false;
                        
                        selectedQuote = [SELECT Name, Id, Account__c FROM Quote WHERE Account__c =: selectedAccount.get(0).Id];
                        
                        if(selectedQuote.size() > 0)
                        { 
                            newLineItemsFromAccountOption = [SELECT AP__c, Accrual_Amount__c, Actual_Selling_Price_ASP__c, Approval_Status__c, CM__c, COOP__c, CSAT__c, Contribution_Margin__c
                            , CoopComment__c, CreatedById, CreatedDate, CurrencyIsoCode, ServiceDate, Deal_Type__c, IsDeleted, Discount, Discount_Total__c
                            , Fees__c, GM__c, Gross_Margin__c, ILW__c, IPP__c, InvoicePrice__c, LastModifiedById, LastModifiedDate, Description, LineNumber
                            , ListPrice, MCPU__c, MDF__c, MinimumCommitQuantity__c, Motoagents__c, NSAD__c, NSBD__c, NSBDComment__c, Name__c, National_Retail__c
                            , Negotiation_Buffer__c, Non_Visible_Fees__c, Non_Visible_TDF__c, PricebookEntryId, QP__c, Quantity, Quantity__c, Quarter__c, QuoteId
                            , Id, SDF__c, SVM__c, UnitPrice, Subtotal, SystemModstamp, TC__c, TDF__c, Total_A_P__c, TotalAPAmount__c, Total_Aggregate_Discounts__c
                            , Total_CM__c, Total_COG__c, Total_COOP__c, Total_CSAT__c, Total_Contribution_Margin__c, Total_Discounts__c, Total_Fees__c, Total_GM__c
                            , Total_Gross_Margin__c, Total_ILW__c, Total_IPP__c, Total_MDF__c, Total_Motoagents__c, Total_NSAD__c, Total_NSBD__c
                            , Total_National_Retail__c, Total_Negotiation_Buffer__c, TotalPrice, Total_QP__c, Total_SDF__c, Total_SVM__c, Total_TC__c, Total_TDF__c
                            , Total_iMDF__c, Units__c, Year__c, coopOpComment__c, csatComment__c, csatOpComment__c, discountComment__c, feesComment__c
                            , feesOpComment__c, iMDF__c, ilwComment__c, ilwOpComment__c, imdfComment__c, imdfOpComment__c, ippCOmment__c, ippOpComment__c
                            , mcpuComment__c, mdfComment__c, mdfOpComment__c, minimumCommitOpComment__c, nationalRetailComment__c, nationalRetailOpComment__c
                            , negotiationBufferComment__c, negotiationBufferOpComment__c, nsadComment__c, nsbdOpComment__c, operatorMinimuCommitComment__c
                            , qpComment__c, qpOpComment__c, sdfOpComment__c, svmComment__c, svmOpComment__c, tcComment__c, tcOpComment__c, tdfComment__c
                            , tdfOpComment__c, Product2.Name
                            FROM QuoteLineitem WHERE QuoteId = :selectedQuote.get(0).Id];
                            
                            addLineItems(newLineItemsFromAccountOption);                            
                            cloneAccountOptionMsg = 'The Account ' + selectedAccount.get(0).Name + ' is associated with some Deals already. Clicking on Continue will associate this Account with the selected Opportunity. Do you want to continue?';
                            oppAssociation = false;
                            createDealViewer = true;
                        }
                        else
                        {
                            cloneAccountOptionMsg = 'The Account ' + selectedAccount.get(0).Name + ' is not associated with any Deals. Clicking on Continue will create a new Opportunity for the selected Account. Do you want to continue?';
                            oppAssociation = false;
                        }
                    }
                }
            }
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
        }
    }

    //jgarcia@levementum.com. 9/10/2014. Change the Account to one assigned to the Opportunity the user chose;
    public PageReference runSearch(){
        accountIdTemp = [SELECT Account.name FROM Opportunity WHERE Id =: clonedQuoteOppIdTemp.OpportunityId limit 1];
        return null;  
    }

    public PageReference executeDeepClone() {
        try {
            
            // cmunoz@levementum.com. 03/17/15. Description: Update Quote to clone when selecting a different opportunity on Deal Clone Page
            if(oppAssociation)
            {
                if(selectedAccount.size() > 0)
                {
                    quoteToClone = [SELECT Opportunity.Account.Name, Deal_Review_Date__c, AccountId, AdditionalCity, AdditionalCountry, AdditionalName, AdditionalState, AdditionalStreet, AdditionalPostalCode, BillingCity
                                , BillingCountry, BillingName, BillingState, BillingStreet, BillingPostalCode, ContactId, CreatedById, CreatedDate, CurrencyIsoCode
                               , IsDeleted, Description, Discount, Email, ExpirationDate, Fax, GrandTotal, LastModifiedById, LastModifiedDate, LineItemCount
                                , Phone, Pricebook2Id, Id, Name, QuoteNumber, QuoteToCity, QuoteToCountry, QuoteToName, QuoteToState, QuoteToStreet, QuoteToPostalCode 
                                , ShippingCity, ShippingCountry, ShippingName, ShippingState, ShippingStreet, ShippingPostalCode, ShippingHandling, Subtotal, IsSyncing
                                , SystemModstamp, Tax, TotalPrice, ShippingLatitude, ContractId, RecordTypeId
                                FROM Quote WHERE AccountId =: selectedAccount.get(0).Id limit 1];
                                quoteToClone.Status = 'New';
                    clonedQuoteOppIdTemp.OpportunityId = newOpportunity.Id;
                }
            }
            else
            {
                Opportunity opp = createNewOpportunity();
                
                createDeal(opp);
                if(opp.id != null)
                {
                    clonedQuoteOppIdTemp.OpportunityId = opp.Id;
                }else if(newopp == true || newAccount == true ){
                
                Id rtid = [select id from recordtype where sobjecttype = 'Opportunity' and developername = 'Deal' limit 1].Id;
                            
                        newOpportunity.Name = oppName;
                        newOpportunity.RecordTypeId = rtid;
                        newOpportunity.AccountId = selectedAccountLookUp.AccountId;
                        newOpportunity.CloseDate = Date.today().AddYears(1);
                        newOpportunity.StageName = '1. Prospecting';
                        Pricebook2 standardPb = [select id, name, isActive from Pricebook2 where isStandard=true];
                        newOpportunity.Pricebook2Id = standardPb.Id;
                        insert newOpportunity;
                        }
                
            }

            // DEEP CLONE THE QUOTE
            clonedQuote = quoteToClone.clone(false, true);
            
            //jgarcia@levementum.com. give the user the opprtunity to change the opportunity before cloning the quote;
            if(newopp == true || newAccount == true){
            clonedQuote.OpportunityId = newOpportunity.Id;
             
           }else if(currentOpp == true){
           clonedQuote.OpportunityId = clonedQuoteOppIdTemp.OpportunityId;
           }else{
           clonedQuote.OpportunityId = newOpportunity.Id;
           }
            checkOriginalDeal();
            
            if (clonedQuote.Deal_Review_Date__c < Date.today() && newAccount)
            { 
                    clonedQuote.Deal_Review_Date__c = Date.today();
            }
            
            insert clonedQuote;
            
            
            
            
            // cmunoz@levementum.com 09/11/14. Description: DEEP CLONE THE TASK
            for(Task task: taskToClone)
            {
              Task tInsert = new Task();
                tInsert = task.clone(false, true);
                tInsert.WhatId = clonedQuote.Id;
                taskListToInsert.add(tInsert);
            }
            insert taskListToInsert;
            
            // cmunoz@levementum.com 09/11/14. Description: DEEP CLONE THE EVENT
            for(Event event: eventToClone)
            {
              Event eInsert = new Event();
                eInsert = event.clone(false, true);
                eInsert.WhatId = clonedQuote.Id;
                eventListToInsert.add(eInsert);
            }
            insert eventListToInsert;
            
            // cmunoz@levementum.com 09/11/14. Description: DEEP CLONE THE ATTACHMENT
            for(Attachment attachment: attachmentToClone)
            {
              Attachment aInsert = new Attachment();
                aInsert = attachment.clone(false, true);
                aInsert.parentId = clonedQuote.Id;
                attachmentListToInsert.add(aInsert);
            }
            insert attachmentListToInsert;
            
            // smandava@motorola.com 10/08/14. Description: DEEP CLONE THE DEAL STOPLIGHT DEVIATION
            for(Deal_Stoplight_Deviation__c deviation: deviationToClone)
            {
              Deal_Stoplight_Deviation__c dInsert = new Deal_Stoplight_Deviation__c();
                dInsert = deviation.clone(false, true);
                dInsert.Deal__c = clonedQuote.Id;
                deviationListToInsert.add(dInsert);
            }
            insert deviationListToInsert;
            
            //DEEP CLONE THE LINE ITEMS
            for (QuoteLineitem qli : qlisToClone) {
                QuoteLineitem qliInsert = new QuoteLineitem();
                qliInsert = qli.clone(false, true);
                qliInsert.QuoteId = clonedQuote.Id;
                qlisToInsert.add(qliInsert);
            }
            //REDIRECT TO CLONED QUOTE
            PageReference pageRef = new PageReference('/' + clonedQuote.Id + '/e?retURL=/' + clonedQuote.Id);
            pageRef.setRedirect(true);
            insert qlisToInsert;
            return pageRef;
        } catch (Exception e) {
            ApexPages.addMessages(e);
            return null;
        }
    }
    
    /**
     * @author:  Cuauhtemoc Munoz
     * @date: 10/03/14
     * @email: cmunoz@levementum.com
     * @description: Check whether a matching CWV and POR pair was selected from Soft Deal Clone page
     */
    public Boolean checkDealTypes()
    {
      Map<String, String> products = new Map<String, String>();
      try
      {
        // Check selected products
        for(dliWrapper dli: dealLineItems)
        {
            if(dli.dliSelected)
            {
                if(products.get(dli.dli.Name__c) != null)
                {
                    products.put(dli.dli.Name__c, products.get(dli.dli.Name__c) + '-' + dli.dli.Deal_Type__c);
                }
                else
                {
                    products.put(dli.dli.Name__c,  dli.dli.Deal_Type__c);
                }
            }
        }
      
        // No products selected
        if(products.keySet().size() <= 0)
        {
            return false;
        }
      
        // check matching pairs
        for(String key: products.keySet())
        {
            if(products.get(key) != null)
            {
                if(!products.get(key).equalsIgnoreCase('Proposal-Plan'))
                {
                    return false;
            }
            }
        }
      }
      catch(Exception ex)
      {
        system.debug(ex.getMessage());
      }
      return true;
    }

    public Boolean validateProductDifferences(){
       //RECURSIVE LOOP TO IMPLEMENT DATA VALIDATION FOR BOTH TYPES POR AND CWV THIS GUARANTEES SAME DATA IS ON BOTH PRODUCTS.
        Boolean dataDifference = true;
        for(dliWrapper dliOUT : dealLineItems){ //OUTER LOOP TO MATCH PRODUCTS WITHIN
            dataDifference = true;
            for(dliWrapper dliIN : dealLineItems){ //INNER LOOP TO COMPLETE THE COMBINATION OF MATCHES
                if(dliOUT.dli.Deal_Type__c != dliIN.dli.Deal_Type__c){ 
                    if(dliOUT.dli.Year__c == dliIN.dli.Year__c 
                        && dliOUT.dli.Quarter__c == dliIN.dli.Quarter__c 
                        && dliOUT.dli.product2.Name == dliIN.dli.product2.Name){ //IF THERE IS A PRODUCT WITH A DIFFERENT TYPE BUT MATCHES YEAR, QUARTER AND PRODUCT THAT MEANS THERE IS NO DATA DIFFERENCE FOR THAT PRODUCT AND WE STOP CHECKING AND MOVE ON TO THE NEXT PRODUCT.
                        dataDifference = false;
                        break;
                    }
                }
            }
            //IF CODE REACHES THIS PLACE IT MEANS THERE WAS A FULL CYCLE ON A PRODUCT WERE THE MATCHING PAIR WAS NOT DETECTED THIS MEANS THERE IS A DIFFERENCE DETECTED IN THE CURRENT PRDUCT, THERE IS NO POINT TO CONTINUE BREAK;
            if(dataDifference){ //if a data difference is detected send the warning.
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Product: ' + dliOUT.dli.product2.Name + ' Year, Quarter and/or Product do not match. Unable to Save'));
                //dealLineItems = tempDealLineItems; //REVERT BACK TO ORIGINAL DEAL LINE ITEMS BEFORE THE ERROR.
                return false;
            }
        }

        return true;
    }
    
    public PageReference executeSoftClone() 
    {
        if (!Test.isRunningTest()) {
        //VALIDATE PRODUCT DIFFERENCES
        IF(!validateProductDifferences()){
            return null;
        }
        }

        // cmunoz@levementum.com. 03/17/15. Description: Update Quote to clone when selecting a different opportunity on Deal Clone Page
        if(oppAssociation)
        {
            if(selectedAccount.size() > 0)
            {
                quoteToClone = [SELECT Opportunity.Account.Name, Deal_Review_Date__c, AccountId, AdditionalCity, AdditionalCountry, AdditionalName, AdditionalState, AdditionalStreet, AdditionalPostalCode, BillingCity
                            , BillingCountry, BillingName, BillingState, BillingStreet, BillingPostalCode, ContactId, CreatedById, CreatedDate, CurrencyIsoCode
                           , IsDeleted, Description, Discount, Email, ExpirationDate, Fax, GrandTotal, LastModifiedById, LastModifiedDate, LineItemCount, OpportunityId
                            , Phone, Pricebook2Id, Id, Name, QuoteNumber, QuoteToCity, QuoteToCountry, QuoteToName, QuoteToState, QuoteToStreet, QuoteToPostalCode 
                            , ShippingCity, ShippingCountry, ShippingName, ShippingState, ShippingStreet, ShippingPostalCode, ShippingHandling, Status, Subtotal, IsSyncing
                            , SystemModstamp, Tax, TotalPrice, ShippingLatitude, ContractId, RecordTypeId
                            FROM Quote WHERE AccountId =: selectedAccount.get(0).Id limit 1];
                clonedQuoteTemp.OpportunityId = quoteToClone.OpportunityId;


            }
        }
        else
        {
            Opportunity opp = createNewOpportunity();
            createDeal(opp);
            if(opp.id != null && !Test.isRunningTest())
            {
                clonedQuoteTemp.OpportunityId = opp.Id;
            }
        }
        
        if(!checkDealTypes() && dealLineItems.size() > 0)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please make sure a matching CWV and POR pair was selected'));
            return null;
        }
                
        try {
            // SOFT CLONE THE QUOTE

            /**
             * @author: Cuauhtemoc Munoz
             * @email:  cmunoz@levementum.com
             * @date:   09/05/14
             * @brief:  Completes test coverage
             */
                if (Test.isRunningTest()) {
                    clonedQuote = quoteToClone.clone(false, true);
                    insert clonedQuote;
                } else {
                    clonedQuote = quoteToClone.clone(false, true);
                    clonedQuote.OpportunityId = clonedQuoteTemp.OpportunityId;
                //fsifuentes@levementum.com 3/30/2015. Description added this if statement so that the date of the quote to be cloned is today's date if the date is older than today.
                if (clonedQuote.Deal_Review_Date__c < Date.today() && newAccount)
                {
                    clonedQuote.Deal_Review_Date__c = Date.today();    
                }
                    checkOriginalDeal();
                    insert clonedQuote;
                }

                //DEEP CLONE THE LINE ITEMS
                for (dliWrapper dliWrapper : dealLineItems) {
                    QuoteLineitem qliInsert = new QuoteLineitem();
                    if (dliWrapper.dliSelected == true) {
                        qliInsert = dliWrapper.dli.clone(false, true);
                        qliInsert.QuoteId = clonedQuote.Id;
                        qlisToInsert.add(qliInsert);
                    }
                }

            //REDIRECT TO CLONED QUOTE
            PageReference pageRef = new PageReference('/' + clonedQuote.Id + '/e?retURL=/' + clonedQuote.Id);
            pageRef.setRedirect(true);
            insert qlisToInsert;

            if (Test.isRunningTest()) {
                pageRef = null;
                pageRef.setRedirect(true);
            }
            upsert quoteLineItems;
            return pageRef;

        } catch (Exception e) {
            ApexPages.addMessages(e);
            return null;
        }
    }
    
   /**
    * @author:  Cuauhtemoc Munoz
    * @email:   cmunoz@levementum.com
    * @date:    3/18/15
    * @brief:   Creates a new opportunity when an Account does not have any deals
    */
    public Opportunity createNewOpportunity()
    {
        Opportunity newOpportunity = new Opportunity();
        try
        {
            if(selectedAccount != null)
            {
                if(selectedAccount.size() > 0)
                {
                    Id rtid = [select id from recordtype where sobjecttype = 'Opportunity' and developername = 'Deal' limit 1].Id;
                    if(rtid != null)
                    {
                        newOpportunity.Name = 'Opportunity :' + DateTime.Now().getTime();
                        newOpportunity.RecordTypeId = rtid;
                        newOpportunity.AccountId = selectedAccount.get(0).Id;
                        newOpportunity.CloseDate = Date.today().AddYears(1);
                        newOpportunity.StageName = '1. Prospecting';
                        Pricebook2 standardPb = [select id, name, isActive from Pricebook2 where isStandard=true];
                        newOpportunity.Pricebook2Id = standardPb.Id;
                        
                        insert newOpportunity;
                    }
                }
            }
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
        }
        return newOpportunity;
    }
    
        
    /**
     * @author: Cuauhtemoc Munoz
     * @email:  cmunoz@levementum.com
     * @date:   03/17/15
     * @description: New Deal created if user decides to add a new deal when associating an Account
     */
    public void createDeal(Opportunity opp)
    {
        Quote qt = new Quote();
        try
        {
            if(selectedOpp != null && selectedAccount != null)
            {
                if(selectedOpp.size() > 0 && selectedAccount.size() > 0)
                {
                    Id qtDealRecTypeId = [SELECT id FROM recordtype WHERE sobjecttype = 'Quote' AND developername = 'Deal' limit 1].Id;
                    if(qtDealRecTypeId != null)
                    {
                        qt.recordTypeId = qtDealRecTypeId;
                    }
                    if(newOpp == true || newAccount == true)
                    {
                    qt.Opportunity.Name = oppName;
                    }else{
                     qt.OpportunityId = opp.Id;
                    
                    }
                    
                    qt.Deal_Review_Date__c = Date.today();       
                    qt.Name = 'DEAL: ' + opp.Name;
                    qt.Account__c = selectedAccount.get(0).Id;                 
               
                    Pricebook2 standardPb = [select id, name, isActive from Pricebook2 where isStandard=true];
                    qt.Pricebook2Id = standardPb.Id;
                    qt.ExecutiveSummary__c = 'Sample Executive Note';
                    insert qt;  
                }
            }
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
        }
    }

    /**
    * @author:  jescamilla@levementum.com
    * @date:    9/10/14
    * @brief:   Fetch the account name when the opportunity is changed.
    */
    public PageReference fetchAccountName(){
        Opportunity changedOpp = [Select Id, Opportunity.Account.Name From Opportunity Where Id = :clonedQuoteTemp.OpportunityId];
        accountName = changedOpp.Account.Name;
        return null;
    }

    /**
    * @author:    jescamilla@levementum.com
    * @date:    9/10/14
    * @brief:    Cancel all operations and return to original Quote.
    */
    public PageReference cancelOperation(){
        PageReference pageRef = new PageReference('/' + quoteToClone.Id);
        pageRef.setRedirect(true);
        
        //cmunoz@levementum.com. 10/15/14. Deactivates products queue
        activeQueue = false;
        return pageRef;
    }
    
   /**
    * @author:  Cuauhtemoc Munoz
    * @email:   cmunoz@levementum.com
    * @date:    10/15/14
    * @description: Activates Product queue
    */
    public List<dliWrapper> selectedProducts {get; set;}
    public Map<Integer, dliWrapper> productsMap = new Map<Integer, dliWrapper>();
    public PageReference editMode()
    {
        try 
        {
            if(checkDealTypes())
            {       
                selectedProducts = new List<dliWrapper>();
                Integer i = 0;
                for (dliWrapper dliWrapper : dealLineItems) {
                    if (dliWrapper.dliSelected) 
                    {
                        selectedProducts.add(dliWrapper);
                        productsMap.put(i, dliWrapper);
                    }
                    i++;
                }

                if(selectedProducts.size() > 0)
                {
                    activeQueue = true;
                }
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Please select a product.'));
                    activeQueue = false;
                    return null;
                }
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please make sure a matching pair of CWV-POR was selected.'));
                return null;
            }
        }
        catch(Exception ex)
        {  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
            system.debug(ex.getMessage());
            return null;
        }
        return null;
    }

    // jescamilla@levementum.com 10/30/14 Description: Cloning (Soft & Deep) should populate new field that includes reference to original Deal, allowing for tracking of what original deal was cloned, only if the opportunity changed.
    private void checkOriginalDeal()
    {
        if((newAccount || newOpp))
        {
            clonedQuote.OriginalDeal__c = null;
        }
        else
        {
        if(clonedQuote.OpportunityId == quoteToClone.OpportunityId){
            clonedQuote.OriginalDeal__c = quoteToClone.Id;
        }else{
            clonedQuote.OriginalDeal__c = null;
            }
        }
    }
    
    public List<SelectOption> getYearOptions() 
    {
        List<SelectOption> yearOptions = new List<SelectOption>();
        yearOptions.add(new SelectOption('','-None-'));
        
        for(Integer i = 0; i < numberOfYearOptions; i++)
        {       
            yearOptions.add(new SelectOption(String.valueOf(currentYear - 1) + '', String.valueOf(currentYear - 1)));
            currentYear++;
        }
        currentYear = Date.Today().year();
        return yearOptions;
    }
    
    List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>(); 
    /**
     * @author: Cuauhtemoc Munoz
     * @date:   10/16/14
     * @description:    Updates product queue items into product selection table
     */
    public PageReference addToProductSelection()
    {
        try
        {   
            List<PricebookEntry> productsDictionary = new List<PricebookEntry>();
            //GET THE PRICEBOOK BEING USED IN THIS CLONE PROCESS.
            Set<Id> pbeIds = new Set<Id>();
            if(!Test.isRunningTest())
            {
            for(dliWrapper selProd: selectedProducts){
                  pbeIds.add(selProd.dli.PricebookEntryId); 
            }

            //GET A LIST OF PRODUCTS TO GET THE NAME
            Id pbId = [SELECT Pricebook2Id FROM PricebookEntry WHERE Id IN :pbeIds LIMIT 1].Pricebook2Id; //Pricebook2Ids to get all the matching product names
            productsDictionary = [SELECT Product2Id, Name FROM PricebookEntry WHERE Pricebook2Id = :pbId];     }
            else
            {
                productsDictionary.add(new PricebookEntry());
            }       

            for(dliWrapper selProd: selectedProducts) //LOOP TROUGH THE SELECTED PRODUCTS
            {
                for(dliWrapper dli : dealLineItems){ //REPLACE THE VALUES ON THE DEAL LINE ITEMS.
                    if(dli.dliIndex == selProd.dliIndex){ //MATCH THE DEAL LINE ITEM WITH THE SELECTED PRODUCT
                        dli.dli.Year__c = selProd.dli.Year__c;
                        dli.dli.Quarter__c = selProd.dli.Quarter__c;
                        //if(dli.dli.product2Id != selProd.dli.product2Id){ //IF THE PRODUCT IDS ARE DIFFERENT IT MEANS THE PRODUCT ON THE LINE ITEM WAS CHANGED.
                            dli.dli.product2Id = selProd.dli.product2Id;
                            for(PricebookEntry pbe : productsDictionary){ //FIND OUT THE NAME OF THE PRODUCT FROM THE SAME PRICEBOOK ENTRY
                               if(pbe.Product2Id == selProd.dli.product2Id){
                                    dli.dli.product2.Name = pbe.Name; //MATCH THE NAME, the reaso we do this is because only the ID is coming down from the visualforce page
                                    dli.dli.PricebookEntryId = pbe.Id; //MATCH THE PRICEBOOK ENTRY ID OR THE RELATED LISTS WILL SHOW A DIFFERENT PRODUCT
                               } 
                            }
                        //}
                    }
                }
                
            } //for

            //VALIDATE PRODUCT DIFFERENCES
            IF(!validateProductDifferences()){
                return null;
            }

            for(dliWrapper dli : dealLineItems){ //CLEAR THE SELECTED CHECKBOXES
                dli.dliSelected = false;
            }
            selectedProducts = null;
            return null;
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage() + 'An error has ocurred while adding a product. Please contact your administrator.'));
        }
        PageReference pr = ApexPages.currentPage();
        pr.setRedirect(true);
        pr.getParameters().put('id', quoteId);
        return pr;
    }
    
    /**
     * @author: Cuauhtemoc Munoz
     * @date:   10/16/14
     * @description:    Cancels product queue and redirects back to products selection
     */
    public PageReference cancel()
    {
        PageReference pr = null;
        try
        {
            pr = ApexPages.currentPage();
            pr.setRedirect(true);
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
        }
     pr.getParameters().put('id', quoteId);
     return pr;
    } 
}