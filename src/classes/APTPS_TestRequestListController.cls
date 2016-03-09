@isTest(SeeAllData=True)
public class APTPS_TestRequestListController
{
static testmethod void unittest()
{

string agreementFeeIDString;
string[] idArray;

set<id> agreementFeeId = new set<id>();
Apttus_Approval__Approval_Request__c aprove1=new Apttus_Approval__Approval_Request__c();
                                 aprove1.APTPS_Is_Suspended__c=true;
                                 aprove1.Apttus_Approval__Approval_Status__c ='Assigned';
                                 aprove1.Apttus_Approval__Approver_Comments__c = 'Suspended on ' + System.NOW()+ '\n (' + UserInfo.getName()+ ')';
                                 insert aprove1;
Apttus_Approval__Approval_Request__c aprove2=new Apttus_Approval__Approval_Request__c();
                                 aprove2.APTPS_Is_Suspended__c=true;
                                 aprove2.Apttus_Approval__Approval_Status__c ='Assigned';
                                 aprove2.Apttus_Approval__Approver_Comments__c = 'Suspended on ' + System.NOW()+ '\n (' + UserInfo.getName()+ ')';
                                 insert aprove2;
                                 
Account acct = new Account(Name='Test Account');
            
            acct.BillingStreet = '1400 Fashion Island Blvd';
            acct.BillingCity = 'San Mateo';
            acct.BillingState = 'CA';
            acct.BillingCountry = 'US';
            acct.BillingPostalCode = '94404'; 
            acct.phone='12345';
            acct.industry='banking';
            acct.type='personel';

        insert acct; 

Opportunity opp = new Opportunity(name='Test Oppty',StageName='Discover',Amount=100000,CloseDate=Date.today());
        opp.AccountId = acct.id;
 
        insert opp;
 
                 
 Apttus__APTS_Agreement__c agrmt1 =new Apttus__APTS_Agreement__c(
                         Name='Test2',
                         Apttus__Related_Opportunity__c=opp.Id);

                insert agrmt1;    
 Apttus__APTS_Agreement__c agrmt2 =new Apttus__APTS_Agreement__c(
                         Name='Test3',
                         Apttus__Related_Opportunity__c=opp.Id);    
                   insert agrmt2;             
    string s = aprove1.id+','+aprove2.id;
//    PageReference currPage = new PageReference('/apex/APTPS_MassApprovalAction?IDList ='+s);
    PageReference currPage = new PageReference('/apex/APTPS_ApprovalRequestListPage?IDList ='+s);
    
    Test.setCurrentPage(currPage);
                                             
       // PageReference currPage = Page.APTPS_MassApprovalAction;
        ApexPages.StandardController cont = new ApexPages.Standardcontroller(aprove1);    
//        APTPS_MassApprovalController testController = new APTPS_MassApprovalController(cont);
   //     APTPS_RequestListController testController = new APTPS_RequestListController(cont);
        APTPS_RequestListController testController = new APTPS_RequestListController();
        
//agreementFeeIDString = apexpages.currentpage().getparameters().get('IDList ');


  //      testController.getAgreementFeeIDSet(agreementFeeIDString );
    //    idArray = agreementFeeIDString.split(',',-2);
 //   for(string id : idArray ){
   //  agreementFeeId.add(id);
    // }
        testController.GetApprovalRequests();
        testController.getCheckedRecords();
      //  testController.getTextComment();
      //  testController.setTextComment('Test');
        testController.doSuspend();
        testController.doApprove();
        testController.doReject();
        testController.doAddComment();
        testController.doCancel();
        testController.GoBack();
        }
        }