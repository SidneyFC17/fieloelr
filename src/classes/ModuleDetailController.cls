public with sharing class ModuleDetailController {
	@AuraEnabled
	public static String getModule(String moduleId, String fields) {
		try{
			Set<String> fieldSet = new Set<String>();
			if (fields!='') {
				fieldSet.addAll(fields.split(','));
			}

			String query = 'SELECT ' +
				String.join(new List<String>(fieldSet), ',') +
				' FROM FieloELR__Module__c WHERE Id = :moduleId';

			List<sObject> records = Database.query(query);

			// public ModuleWrapper(Module__c module, List<ModuleResponse__c> moduleResponses, List<ModuleDependency__c> dependencies)


			return JSON.serialize(records[0]);
		} catch(DMLException e) {
           	throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
	}
}