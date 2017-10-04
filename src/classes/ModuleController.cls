public with sharing class ModuleController {
	@auraEnabled
	public static sObject getContent(String contentField, String contentType, String moduleId){       
    	return database.query('SELECT ' + contentField + ', ' + contentType + ' FROM FieloELR__Module__c WHERE Id = \'' + moduleId + '\'')[0];
  }
}