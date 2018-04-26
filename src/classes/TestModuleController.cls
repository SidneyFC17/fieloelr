@isTest
public with sharing class TestModuleController {
	@testSetup static void setup(){
        MockUpFactory.InsertTestData();
        MockUpFactory.activateCourse();
		
    }
	@isTest
	static void TestModuleController() {
	FieloELR__Module__c	 module = [SELECT Id FROM FieloELR__Module__c LIMIT 1];

	//Perguntar sobre o Content e Content type
	 SObject content = ModuleController.getContent(
	 	,module.Id);
	}
}