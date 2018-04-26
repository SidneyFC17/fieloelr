@isTest
public with sharing class TestModuleResponseController {
@testSetup static void setup(){
        MockUpFactory.InsertTestData();
        MockUpFactory.activateCourse();
		
    }

	@isTest
	static void TestModuleResponseController() {
	FieloELR__Module__c module = [SELECT Id FROM FieloELR__Module__c LIMIT 1];
	FieloPLT__Member__c member = [SELECT Id FROM FieloPLT__Member__c LIMIT 1];
	FieloELR__ModuleResponse modResponse 


	String getModResp = ModuleResponseController.getModuleResponse(
		modResponse.Id
		,new List<String>{
			'CourseStatus__c'
			});

	}
}