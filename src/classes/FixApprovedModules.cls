global class FixApprovedModules implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, FieloELR__ApprovedModules__c, '+ 
            '(SELECT Id from FieloELR__ModuleResponses__r WHERE FieloELR__IsApproved__c = TRUE '+ 
            'AND FieloELR__Module__r.FieloELR__IsActive__c = true) '+ 
            'FROM FieloELR__CourseStatus__c WHERE FieloELR__Progress__c > 1'
        );
    }
    global void execute(Database.BatchableContext bc, List<FieloELR__CourseStatus__c> csTemp){
        List<FieloELR__CourseStatus__c> csList = new List<FieloELR__CourseStatus__c>();
        
        for(FieloELR__CourseStatus__c c: csTemp) {
            c.FieloELR__ApprovedModules__c = c.FieloELR__ModuleResponses__r.size();
           	csList.add(c);
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