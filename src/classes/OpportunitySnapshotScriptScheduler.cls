global class OpportunitySnapshotScriptScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
        OpportunitySnapshotScript.SnapshotUpdateScript();
    }
}