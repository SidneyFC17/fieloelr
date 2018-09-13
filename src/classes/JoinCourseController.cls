public with sharing class JoinCourseController {

    @auraEnabled
    public static String memberJoinCourse(Id memberId, Id courseId){
        try{
            SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{FieloELR__CourseStatus__c.SObjectType});
            
            if(!Schema.sObjectType.CourseStatus__c.isCreateable())
                throw new FieloPLT.FieloException('Insufficient permission to create course status.');

            uow.registerNew(new FieloELR__CourseStatus__c(FieloELR__Member__c = memberId, FieloELR__Course__c = courseId));
           
                    if(Schema.sObjectType.FieloELR__CourseStatus__c.isCreateable()){
                        uow.commitWork();
                    }else{
                        throw new FieloException(Label.CannotInsertUpdateRecords);
                    }
           
            
        } catch (DMLException e) {
            throw new AuraHandledException(e.getDMLMessage(0));
        }
        return 'Success';       
    }
    
}