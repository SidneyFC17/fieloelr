public with sharing class CourseAction {
	@AuraEnabled
	public static String joinCourse(String memberId, String courseId) {
		try{
            if (true) {
				SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{CourseStatus__c.SObjectType});
				CourseStatus__c cs = new CourseStatus__c(
					Course__c = courseId,
					Member__c = memberId
				);
				uow.registerNew(cs);
            	uow.commitWork();

				return courseId;
			}
        } catch (DmlException e) {
            throw new AuraHandledException(e.getDmlMessage(0));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return null;
	}
}