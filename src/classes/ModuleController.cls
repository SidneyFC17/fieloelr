public with sharing class ModuleController {
	@auraEnabled
	public static sObject getContent(String contentField, String moduleId){       
    	return database.query('SELECT ' + contentField + ' FROM FieloELR__Module__c WHERE Id = \'' + moduleId + '\'')[0];
  }
}