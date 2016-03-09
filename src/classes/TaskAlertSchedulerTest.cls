@isTest
private class TaskAlertSchedulerTest {
	@isTest 
    static void testTaskAlertScheduler(){
        Test.startTest();
        User user = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        Date activityDate = Date.today().addDays(1);
        Task task = new Task(Subject = 'Test Task Reminder', OwnerId = user.Id, ActivityDate = activityDate, Status = 'Not Started');
        insert task;
        TaskAlertScheduler sch = new TaskAlertScheduler();
        String str = '0 5 7 * * ?';
        System.schedule('Test Task Email Reminder', str, sch);
        Test.stopTest();
    }
}