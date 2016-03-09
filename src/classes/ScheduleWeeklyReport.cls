global class ScheduleWeeklyReport implements Schedulable {
/**
Author: Bineet Mishra
Create Date: Jan 23, 2014 
Description: Schedule Weekly Report generation.
 */
    global void execute(SchedulableContext ctx) {     
        WeeklyReport wr = new WeeklyReport();
        integer batchSize = 10;
        database.executebatch(wr, batchSize);   
    }
}