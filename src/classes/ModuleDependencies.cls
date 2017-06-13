public class ModuleDependencies extends SObjectDomain {

	public ModuleDependencies(List<ModuleDependency__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<ModuleDependency__c> sObjectList) {
            return new ModuleDependencies(sObjectList);
        }
    }

    public override void onBeforeInsert() {
 		setKeys((List<ModuleDependency__c>) records);
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
    	setKeys((List<ModuleDependency__c>) records);
    }

    private void setKeys(List<ModuleDependency__c> records) {
    	for(ModuleDependency__c moduleDependency : records) {
			if(moduleDependency.Predecessor__c != null && moduleDependency.Module__c != null) {
				moduleDependency.Key__c = String.valueOf(moduleDependency.Predecessor__c).substring(0, 15) + String.valueOf(moduleDependency.Module__c).substring(0, 15);   
    		}
    	}
    }

    public override void onAfterInsert() {
        SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{Module__c.SObjectType});
        updateModules(records, uow);
        uow.commitWork();
    }

    public override void onAfterDelete() {
        SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{Module__c.SObjectType});
        updateModules(records, uow);
        uow.commitWork();
    }  

    private void updateModules(List<ModuleDependency__c> moduleDependencies, SObjectUnitOfWork uow) {

        Set<Id> moduleIds = new Set<Id>();
        for(ModuleDependency__c moduledependency : moduleDependencies) {
            moduleIds.add(moduledependency.Module__c);
        }
        Map<Id, Module__c> modulesMap = 
                    new Map<Id, Module__c>(new ModulesSelector(new Set<String> {'Id', 'HasDependencies__c', 'KeyDependencies__c'}).selectById(moduleIds));
        Module__c module;
        String predecessor;
        List<String> Keys;

        for(ModuleDependency__c moduledependency : moduleDependencies) {
            module = modulesMap.get(moduledependency.Module__c);
            predecessor = moduledependency.Predecessor__c;
            if(Trigger.IsInsert) {
                // Add key
                if(String.IsBlank(module.KeyDependencies__c)) {
                    module.KeyDependencies__c = predecessor;
                } else {
                    Keys = module.KeyDependencies__c.split(',');
                    Keys.add(predecessor);
                    Keys.sort();            
                    module.KeyDependencies__c = String.join(Keys, ',');
                }   
                // If a module dependency is inserted and module has no dependencies yet, the attribute must be updated
                if(!(module.HasDependencies__c)) {
                    module.HasDependencies__c = true;
                }
            } else if(Trigger.IsDelete) {
                if(!String.isBlank(module.KeyDependencies__c)){
                    // Remove key
                    module.KeyDependencies__c = module.KeyDependencies__c.replace(predecessor + ',', '').replace(',' + predecessor, '').replace(predecessor, '');
                }
                // If a module dependency is deleted and module has no more dependencies, the attribute must be updated
                if(String.isBlank(module.KeyDependencies__c)) {
                    module.HasDependencies__c = false;
                }                
            }
            uow.registerDirty(module); 
        }
    }  

}