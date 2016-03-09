@isTest
private class TaskAlertBatchTest {
    @isTest
    static void testTaskAlertBatch(){
        Test.startTest();
        User user = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        Date activityDate = Date.today().addDays(1);
        Task task = new Task(Subject = 'Test Task Reminder', OwnerId = user.Id, ActivityDate = activityDate, Status = 'Not Started');
        insert task;
        Date today = Date.today();
        String query = 'select Id, OwnerId, ActivityDate, Owner.Name, Subject, Status from Task where ActivityDate > :today';
        TaskAlertBatch batch = new TaskAlertBatch(query, today);
        Database.executeBatch(batch, 25);
        Test.stopTest();
    }
}