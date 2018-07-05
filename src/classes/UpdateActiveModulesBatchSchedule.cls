global class UpdateActiveModulesBatchSchedule implements Database.Batchable<sObject>, Schedulable  {

    public void execute(SchedulableContext SC) {
        Database.executeBatch(new UpdateActiveModulesBatchSchedule());
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, FieloELR__ActiveModules__c, ' +
            '(SELECT Id from FieloELR__Modules__r WHERE  FieloELR__IsActive__c = true) ' +
            'FROM FieloELR__Course__c ORDER BY LastModifiedDate DESC LIMIT 50000000'
        );
    }

    global void execute(Database.BatchableContext bc, List<FieloELR__Course__c> scope) {
        List<FieloELR__Course__c> courses = new List<FieloELR__Course__c>();
        
        for(FieloELR__Course__c course: scope) {
            if (course.FieloELR__ActiveModules__c != course.FieloELR__Modules__r.size()) {
                course.FieloELR__ActiveModules__c = course.FieloELR__Modules__r.size();
           	    courses.add(course);
            }
        }
        
        CourseService.enableAdminPermission(true);
        update courses;
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