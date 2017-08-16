public with sharing class CoursesController {
    @auraEnabled
    public static List<FieloELR__Course__c> getCourses(FieloPLT__Member__c member, List<String> fieldset){
        
        Set<String> fieldsCourse = new Set<String>(fieldset); 
        Set<String> fieldsModule = new Set<String>{'Name','FieloELR__Description__c', 'FieloELR__ApprovalGrade__c'}; 
        Set<String> fieldsCourseStatus = new Set<String>{'Name'};
        Set<String> fieldsModuleResponse = new Set<String>{'Name'};
        //List<FieloELR.CourseService.CourseWrapper> courseWrappers = FieloELR.CourseService.getCoursesMap(fieldsCourse, fieldsCourseStatus,fieldsModule,fieldsModuleResponse,null,member.FieloPLT__Program__c, null, false, false, 10, 0, 'FieloELR__Order__c','');
        List<FieloELR__Course__c> courses = FieloELR.CourseService.getCourses(fieldsCourse, null,fieldsModule,null, member.FieloPLT__Program__c, null, false, false, false, 10, 0,'FieloELR__Order__c', '');
        return courses;        
    }

    public class TestAura{
        String t1{get;set;}
        String t2{get;set;}
    }

    @auraEnabled
    public static String getTest(FieloPLT__Member__c member, List<String> fieldset){
        
        Set<String> fieldsCourse = new Set<String>(fieldset); 
        Set<String> fieldsModule = new Set<String>{'Name','FieloELR__Description__c', 'FieloELR__ApprovalGrade__c'}; 
        Set<String> fieldsCourseStatus = new Set<String>{'Name'};
        Set<String> fieldsModuleResponse = new Set<String>{'Name'};
        List<FieloELR.CourseService.CourseWrapper> courseWrappers = FieloELR.CourseService.getCoursesMap(fieldsCourse, fieldsCourseStatus,fieldsModule,fieldsModuleResponse,null,member.FieloPLT__Program__c, null, false, false, 10, 0, 'FieloELR__Order__c','');

        TestAura t = new TestAura();
        t.t1 = 'nico';
        t.t2 = 'asd';
        return JSON.serialize(t);
    }
}