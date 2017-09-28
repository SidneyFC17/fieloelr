public with sharing class JoinCourseController {

    @auraEnabled
    public static String memberJoinCourse(Id memberId, Id courseId){
        try{
            insert new FieloELR__CourseStatus__c(FieloELR__Member__c = memberId, FieloELR__Course__c = courseId);
        } catch (DMLException e) {
            throw new AuraHandledException(e.getDMLMessage(0));
        }
        return 'Success';       
    }
    
}