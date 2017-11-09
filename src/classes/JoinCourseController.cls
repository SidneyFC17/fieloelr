public with sharing class JoinCourseController {

    @auraEnabled
    public static String memberJoinCourse(Id memberId, Id courseId){
        try{
            SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{FieloELR__CourseStatus__c.SObjectType});
            uow.registerNew(new FieloELR__CourseStatus__c(FieloELR__Member__c = memberId, FieloELR__Course__c = courseId));
            uow.commitWork();
        } catch (DMLException e) {
            throw new AuraHandledException(e.getDMLMessage(0));
        }
        return 'Success';       
    }
    
}