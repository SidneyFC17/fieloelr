public class CourseInactiveBatchSchedule implements Database.Batchable<sobject>, Schedulable {

    public void execute(SchedulableContext SC) {
        Database.executeBatch(new CourseInactiveBatchSchedule());
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        Date timeNow = Date.today();
        return Database.getQueryLocator('Select Id From Course__c where EndDate__c <> null And EndDate__c <=: timeNow');
    }

    public void execute(Database.BatchableContext BC, List<sobject> scope) {

	    Map<Id,Course__c> coursesMap = new Map<Id,Course__c>((List<Course__c>)scope);

        if(!coursesMap.isEmpty()) {
			CourseService.setCourseStatus(coursesMap.keySet(), 'Inactive');
        }    	

    }

    public void finish(Database.BatchableContext BC) {
    }
}