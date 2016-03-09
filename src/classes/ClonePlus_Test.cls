@istest
public class ClonePlus_Test {

public static testmethod void testcloneplus () {

//Create test data
Account ta = new Account (Name = 'Test A Original');
insert ta;

Contact tc = new Contact (LastName = 'Test C Original', AccountId = ta.Id);
insert tc;

//Go to Page

PageReference tpageRef = Page.ClonePlus;
Test.setCurrentPage(tpageRef);

//Set Parameters that would be passed in 
ApexPages.currentPage().getParameters().put('Id', ta.Id);
ApexPages.currentPage().getParameters().put('childobjecttypes', 'Contact');


// Instantiate a new controller with all parameters in place
ClonePlusController pcp = new ClonePlusController();

//Simulate intial action call on page
pcp.initialiseObjectsForCloning();

//Simulate Click Button
pcp.doClone();

//Check there are now two accounts
Account [] testresults = [Select Id, Name from Account WHERE NAME = 'Test A Original' ORDER BY CREATEDDATE ASC];
system.assertequals(2,testresults.size());

//Check there are now two contacts
Contact [] testcresults = [Select Id, LastName, AccountId from CONTACT WHERE AccountId IN :testresults ORDER BY CREATEDDATE ASC];
system.assertequals(2,testcresults.size());

//Confirm Contacts attached to different accounts
system.assertequals(testresults[0].Id, testcresults[0].AccountId);
system.assertequals(testresults[1].Id, testcresults[1].AccountId);
}
}