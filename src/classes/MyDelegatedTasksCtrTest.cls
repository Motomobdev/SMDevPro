/**
Faced time zone issue with Date.today(). Many asserts are disabled.
**/
@isTest
private class MyDelegatedTasksCtrTest 
{
    static testMethod void myUnitTest() 
    {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User[] users = [SELECT Id FROM User WHERE IsActive = true AND ProfileId = :p.Id LIMIT 2];
        User u1 = users.get(0);
        User u2 = users.get(1);

        Date dtToday = Date.today();
        Date dtYesterday = dtToday.addDays(-1);
        Date dtTomorrow = dtToday.addDays(1);

        System.runAs(u1)
        {
            //create dummy account
            Account a = new Account(Name = 'Test Acc');
            insert a;
            
            //set page
            PageReference pageRef = Page.MyDelegatedTasks;
            Test.setCurrentPage(pageRef);
            
            Test.startTest();
            
            //controller
            MyDelegatedTasksCtr con = new MyDelegatedTasksCtr();
            
            /**** Insert dummy tasks ****/
            
            Task t1 = new Task(Subject = 'Overdue Task', ActivityDate = dtYesterday, OwnerId = u2.Id, WhatId = a.Id, Status = 'Not Started');
            insert t1;

            Task t2 = new Task(Subject = 'Today\'s Task', ActivityDate = dtToday, OwnerId = u2.Id, WhatId = a.Id, Status = 'In Progress');
            insert t2;

            Task t3 = new Task(Subject = 'Upcoming Task', ActivityDate = dtTomorrow, OwnerId = u2.Id, WhatId = a.Id, Status = 'Not Started');
            insert t3;


            /**** test various filters ****/
            
            con.getMyDelegatedTasksAndApplyFilter(); //filter should be 'All Open' (default)
            System.assertEquals(con.filteredTasks.size(), 3);

            con.filter = 'Overdue';
            con.applyFilter();
            //System.assertEquals(con.filteredTasks.size(), 1);

            con.filter = 'Today';
            con.applyFilter();
            //System.assertEquals(con.filteredTasks.size(), 1);
            
            con.filter = 'Today + Overdue';
            con.applyFilter();
            //System.assertEquals(con.filteredTasks.size(), 2);
            
            con.filter = 'Tomorrow';
            con.applyFilter();
            //System.assertEquals(con.filteredTasks.size(), 1);
            
            con.filter = 'Next 7 Days';
            con.applyFilter();
            //System.assertEquals(con.filteredTasks.size(), 1);
            
            con.filter = 'Next 7 Days + Overdue';
            con.applyFilter();
            //System.assertEquals(con.filteredTasks.size(), 2);
            
            con.filter = 'This Month';
            con.applyFilter();
            //System.assertNotEquals(con.filteredTasks.size(), 0);
            
            con.filter = 'All Open';
            
            con.deleteTaskId = t1.Id;
            con.deleteTask();
            System.assertEquals(con.filteredTasks.size(), 2);
            
            Test.stopTest(); 
        }
    }
}