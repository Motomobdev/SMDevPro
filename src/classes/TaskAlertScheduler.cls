global class TaskAlertScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        Date today = Date.today();
        String query = 'select Id, OwnerId, ActivityDate, Owner.Name, Subject, Status from Task where ActivityDate > :today';
        TaskAlertBatch batch = new TaskAlertBatch(query, today);
        Database.executeBatch(batch, 25);
    }
}