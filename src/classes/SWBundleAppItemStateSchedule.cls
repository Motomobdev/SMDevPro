/******************************************************************************************************
CREATED BY : Neel Desai
CREATED ON : 07-Aug-2013
PURPOSE    : Schedulable interface implementation for the class SWBundleAppItemState
TEST CLASS : SWBundleAppItemStateScheduleTest
*******************************************************************************************************/
global class SWBundleAppItemStateSchedule implements Schedulable
{
     global void execute(SchedulableContext sc)
     {
        SWBundleAppItemState sb = new SWBundleAppItemState();
        Database.executeBatch(sb);
     }
}