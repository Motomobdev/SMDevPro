global class ScheduleBOMExplosionBatch implements Schedulable{
	global void execute(SchedulableContext sc) {
      BOMExplosionBatch bomExpBatch = new BOMExplosionBatch();
      Integer batchSize = 50;
      BOM_Explosion_Settings__c bomSettings = BOM_Explosion_Settings__c.getInstance('BOMExplosionSetting');
	  if (bomSettings != null) {
		 batchSize = Integer.valueOf(bomSettings.Batch_Size__c);
	  }
	  ID batchprocessid = Database.executeBatch(bomExpBatch, batchSize);
   } 
}