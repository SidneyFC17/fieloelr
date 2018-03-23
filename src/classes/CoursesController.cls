public with sharing class CoursesController {
    @auraEnabled
    public static String getCourses(FieloPLT__Member__c member, List<String> coursesFieldset, List<String> modulesFieldset, Integer quantity, Integer offset){
        try{
            Set<String> fieldsCourse = new Set<String>(coursesFieldset); 
            Set<String> fieldsModule = new Set<String>(modulesFieldset); 
            Set<String> fieldsCourseStatus = new Set<String>{'Name'};
            Set<String> fieldsModuleResponse = new Set<String>{'Name'};
            Id memberId = member.Id;
            List<FieloELR.CourseService.CourseWrapper> courseWrappers = FieloELR.CourseService.getCoursesMap(
                                                                                                fieldsCourse,
                                                                                                fieldsCourseStatus,
                                                                                                fieldsModule,
                                                                                                fieldsModuleResponse,
                                                                                                null,
                                                                                                member.FieloPLT__Program__c,
                                                                                                memberId,
                                                                                                false,
                                                                                                false,
                                                                                                quantity,
                                                                                                offset,
                                                                                                'FieloELR__Order__c',
                                                                                                ''
                                                                                                );
    
            return JSON.serialize(courseWrappers);        
       } catch(DMLException e) {
           throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e){
             throw new AuraHandledException(e.getMessage());
        }  
    }        
}