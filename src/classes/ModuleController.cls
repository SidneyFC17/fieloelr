public with sharing class ModuleController {
	@auraEnabled
	public static sObject getContent(String contentField, String contentType, String moduleId){       
    	if( !Module__c.sObjectType.getDescribe().isAccessible() )
    		throw new FieloPLT.FieloException('Insufficient permission to access modules.');

    	return database.query('SELECT ' + contentField + ', ' + contentType + ' FROM FieloELR__Module__c WHERE Id = \'' + moduleId + '\'')[0];
  	}
}