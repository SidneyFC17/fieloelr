@isTest
public with sharing class TestCoursesController {
	@testSetup static void setup(){
        MockUpFactory.InsertTestData();
		
    }

	@isTest
	static void TestCoursesController() {
	FieloPLT__Member__c = member = [SELECT Id FROM FieloPLT__Member__c LIMIT 1];
	List<String> mdFieldset = new List<String>{'{"Name":"Information","Rows":[[{"Name":"FieloELR__Description__c","Type":"input"}],[{"Name":"FieloELR__ApprovalGrade__c","Type":"input"},{"Name":"FieloELR__QuestionPool__c","Type":"checkbox"}],[{"Name":"FieloELR__AttemptsAllowed__c","Type":"input"},{"Name":"FieloELR__AttemptsAllowedPerQuestion__c","Type":"input"}]]}}';


	CourseController.getCourses(
		member
		,);
	
	}
}