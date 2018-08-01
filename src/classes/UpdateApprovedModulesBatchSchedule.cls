global class UpdateApprovedModulesBatchSchedule implements Database.Batchable<sObject>, Schedulable  {

    public void execute(SchedulableContext SC) {
        Database.executeBatch(new UpdateApprovedModulesBatchSchedule());
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, FieloELR__ApprovedModules__c, ' +
            '(SELECT Id from FieloELR__ModuleResponses__r WHERE FieloELR__IsApproved__c = TRUE ' +
            'AND FieloELR__NumberOfApprove__c = 1 AND FieloELR__Module__r.FieloELR__IsActive__c = true) ' +
            'FROM FieloELR__CourseStatus__c ORDER BY FieloELR__Course__r.LastModifiedDate DESC LIMIT 50000000'
        );
    }

    global void execute(Database.BatchableContext bc, List<FieloELR__CourseStatus__c> scope) {
        List<FieloELR__CourseStatus__c> csList = new List<FieloELR__CourseStatus__c>();
        
        for(FieloELR__CourseStatus__c c: scope) {
            if (c.FieloELR__ModuleResponses__r != null) {
                if (c.FieloELR__ApprovedModules__c != c.FieloELR__ModuleResponses__r.size()) {
                    c.FieloELR__ApprovedModules__c = c.FieloELR__ModuleResponses__r.size();
                    csList.add(c);
                }
            }
        }
        
        CourseService.enableAdminPermission(true);
        update csList;
        CourseService.enableAdminPermission(false);
    }

    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
        System.debug(job);
    }
}