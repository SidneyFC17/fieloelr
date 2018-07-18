public with sharing class ModuleDetailController {
	@AuraEnabled
	public static String getModule(FieloPLT__Member__c member, String moduleId, String moduleFields, String moduleResponseFields) {
		try{
			String memberId = member.Id;

			Set<String> moduleFieldSet = new Set<String>();
			if (moduleFields != '' && moduleFields != null) {
				moduleFieldSet.addAll(moduleFields.split(','));
			}

			String modulesQuery = 'SELECT ' +
				String.join(new List<String>(moduleFieldSet), ',') +
				' FROM FieloELR__Module__c WHERE Id = :moduleId';

			List<Module__c> modules = (List<Module__c>) Database.query(modulesQuery);
			
			Set<String> moduleResponseFieldSet = new Set<String>();
			if (moduleResponseFields != '' && moduleResponseFields != null) {
				moduleResponseFieldSet.addAll(moduleResponseFields.split(','));
			}

			String modulesResponseQuery = 'SELECT ' +
				String.join(new List<String>(moduleResponseFieldSet), ',') +
				' FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__c = :moduleId AND FieloELR__Member__c = :memberId AND FieloELR__IsSubmitted__c = true ORDER BY CreatedDate DESC';

			List<ModuleResponse__c> moduleResponses = (List<ModuleResponse__c>) Database.query(modulesResponseQuery);

			String moduleDependencyQuery = 'SELECT Id, ' +
				'FieloELR__Predecessor__r.Name ' +
				' FROM FieloELR__ModuleDependency__c ' +
				' WHERE FieloELR__Module__c = :moduleId AND FieloELR__Predecessor__r.FieloELR__IsActive__c = true';

			List<ModuleDependency__c> dependencies = (List<ModuleDependency__c>) Database.query(moduleDependencyQuery);

			CourseService.ModuleWrapper mw = new CourseService.ModuleWrapper(modules[0], moduleResponses, dependencies);

			return JSON.serialize(mw);
		} catch(DMLException e) {
           	throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
	}

	@AuraEnabled
	public static String getFieldData(String sObjectName, String fields) {
		try{
			return AuraService.getFieldData(sObjectName, fields);
		} catch(DMLException e) {
           	throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
	}
}