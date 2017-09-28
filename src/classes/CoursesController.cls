public with sharing class CoursesController {
    @auraEnabled
    public static String getCourses(FieloPLT__Member__c member, List<String> coursesFieldset, List<String> modulesFieldset){
        try{
            Set<String> fieldsCourse = new Set<String>(coursesFieldset); 
            Set<String> fieldsModule = new Set<String>(modulesFieldset); 
            Set<String> fieldsCourseStatus = new Set<String>{'Name'};
            Set<String> fieldsModuleResponse = new Set<String>{'Name'};
            Id memberId = member.Id;
            List<FieloELR.CourseService.CourseWrapper> courseWrappers = FieloELR.CourseService.getCoursesMap(fieldsCourse, fieldsCourseStatus,fieldsModule,fieldsModuleResponse,null,member.FieloPLT__Program__c, memberId, false, false, 10, 0, 'FieloELR__Order__c','');
    
            return JSON.serialize(courseWrappers);        
       } catch(DMLException e) {
           throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e){
             throw new AuraHandledException(e.getMessage());
        }  
    }

    @auraEnabled
    public static String getMyCourses(FieloPLT__Member__c member){
        try{
            Set<String> fieldsCourseStatus = new Set<String>{'Name','Progress__c','Course__r.Name'}; 
            Set<String> fieldsModuleResponse = new Set<String>{'Name','GradeValue__c', 'Module__r.Name'}; 
            Id memberId = member.Id;
            List<FieloELR__CourseStatus__c> memberCourses = FieloELR.CourseService.getCourseStatus(fieldsCourseStatus, fieldsModuleResponse,null, memberId,10, 0, 'Name');
            return JSON.serialize(memberCourses);        
        } catch(DMLException e) {
           throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e){
             throw new AuraHandledException(e.getMessage());
        }  
    }
    
}