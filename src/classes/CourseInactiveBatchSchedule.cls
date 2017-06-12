public class CourseInactiveBatchSchedule implements Database.Batchable<sobject>, Schedulable {

    public void execute(SchedulableContext SC) {
        Database.executeBatch(new CourseInactiveBatchSchedule());
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('Select Id From Course__c where EndDate__c <= ' + DateTime.now().format('yyyy-MM-dd'));
    }

    public void execute(Database.BatchableContext BC, List<sobject> scope) {

        Set<Id> courseIds = new Set<Id>();
        for(Sobject o : scope) {
        	courseIds.add(((Course__c)o).Id);
        }

        if(!courseIds.isEmpty()){
			CourseService.setCourseStatus(courseIds, 'Inactive');
        }    	


    }

    public void finish(Database.BatchableContext BC) {
    }
}