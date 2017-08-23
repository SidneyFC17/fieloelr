public class CourseStatusBatchSchedule implements Database.Batchable<sobject>, Schedulable {

    public void execute(SchedulableContext SC) {
        Database.executeBatch(new CourseStatusBatchSchedule());
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        Date today = date.today();
        Date yesterday = date.today().addDays(-1);
        return Database.getQueryLocator('SELECT Id, FieloELR__Status__c FROM FieloELR__Course__c WHERE (FieloELR__Status__c = \'Scheduled\' AND FieloELR__StartDate__c <=: today) OR (FieloELR__Status__c = \'Active\' AND FieloELR__EndDate__c <=: yesterday)');
    }

    public void execute(Database.BatchableContext BC, List<sobject> scope) {
        SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{Course__c.SObjectType});
        for(Sobject course : scope){
            Course__c c = (Course__c)course;
            if( c.Status__c == 'Scheduled'){
                c.Status__c = 'Active';
            }else{
                c.Status__c = 'Completed';
            }
            uow.registerDirty(c);
        }
        SavePoint sp = Database.setSavePoint();
        try{
            Courses.validateAdminFields = false;
            uow.commitWork();
        }catch(Exception e){
            Database.rollback(sp);
            system.debug(e.getMessage());
        }
    }

    public void finish(Database.BatchableContext BC) {
    }
}