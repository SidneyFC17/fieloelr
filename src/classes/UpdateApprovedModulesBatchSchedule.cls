global class UpdateApprovedModulesBatchSchedule implements Database.Batchable<sObject>, Schedulable  {

    public void execute(SchedulableContext SC) {
        Database.executeBatch(new UpdateApprovedModulesBatchSchedule());
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {

        Database.QueryLocator queryLocator;
        
        SecurityUtils.checkRead(Schema.sObjectType.CourseStatus__c.getSobjectType(), new List<String>{'FieloELR__ApprovedModules__c','FieloELR__Course__c'});
        SecurityUtils.checkRead(Schema.sObjectType.ModuleResponse__c.getSobjectType(), new List<String>{'FieloELR__IsApproved__c','FieloELR__NumberOfApprove__c','FieloELR__Module__c'});
        SecurityUtils.checkRead(Schema.sObjectType.Module__c.getSobjectType(), new List<String>{'FieloELR__IsActive__c'});
        SecurityUtils.checkRead(Schema.sObjectType.Course__c.getSobjectType(), new List<String>{'LastModifiedDate'});

        queryLocator = Database.getQueryLocator(
            'SELECT Id, FieloELR__ApprovedModules__c, ' +
            '(SELECT Id from FieloELR__ModuleResponses__r WHERE FieloELR__IsApproved__c = TRUE ' +
            'AND FieloELR__NumberOfApprove__c = 1 AND FieloELR__Module__r.FieloELR__IsActive__c = true) ' +
            'FROM FieloELR__CourseStatus__c ORDER BY FieloELR__Course__r.LastModifiedDate DESC LIMIT 50000000'
        );

        return queryLocator; 

    }

    global void execute(Database.BatchableContext bc, List<FieloELR__CourseStatus__c> scope) {
        List<FieloELR__CourseStatus__c> csList = new List<FieloELR__CourseStatus__c>();
        
        SecurityUtils.checkUpdate(Schema.sObjectType.CourseStatus__c.getSobjectType(), new List<String>{'FieloELR__ApprovedModules__c'});

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
        SecurityUtils.checkRead(Schema.sObjectType.AsyncApexJob.getSobjectType(), new List<String>{'Status','NumberOfErrors','JobItemsProcessed','TotalJobItems','CreatedBy'});
        SecurityUtils.checkRead(Schema.sObjectType.User.getSobjectType(), new List<String>{'Email'});

        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
        System.debug(job);
    }
}