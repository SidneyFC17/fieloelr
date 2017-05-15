public class Modules extends SObjectDomain {

	public Modules(List<Module__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<Module__c> sObjectList) {
            return new Modules(sObjectList);
        }
    }

    // When the module is changed to active, must validate that has at least one question

    public override void onValidate() {
    }

    public override void onValidate(Map<Id,SObject> existingRecords) {
    }

    public override void onBeforeInsert() {
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {

    	List<Module__c> inactivatedModules = new List<Module__c>();
   		List<Module__c> activatedModules = new List<Module__c>();

   		// When the module is changed to active, must validate that has at least one question
   		// An active module with related module responses cannot be deleted or inactivated.
		for(Module__c module : (List<Module__c>)records) {
			// Select only active modules that are being activated
			if(!(((Module__c)(existingRecords.get(module.Id))).IsActive__c) && module.IsActive__c) {
				inactivatedModules.add(module);
			}
			if(((Module__c)(existingRecords.get(module.Id))).IsActive__c && !(module.IsActive__c)) {
				activatedModules.add(module);
			}	
		}   		
   		getQuestions(inactivatedModules);
		getModuleResponses(activatedModules);
    }

	public override void onBeforeDelete() {

   		List<Module__c> activeModules = new List<Module__c>();

		// An active module with related module responses cannot be deleted or inactivated.
		for(Module__c module : (List<Module__c>)records) {
   			// Select only active modules
			if(module.IsActive__c) {
				activeModules.add(module);
			}
		}
     	getModuleResponses(activeModules);
    }

	// Returns the questions for a list of modules
    private void getQuestions(List<Module__c> inactiveModules) {
		
	    Map<Id,Module__c> modulesMap = new Map<Id, Module__c>(inactiveModules);

	    List<Module__c> modulesWithQuestion = new ModulesSelector(new Set<String> {'Id'}).selectByIdWithQuestions(modulesMap.KeySet()); 
	    																		
	    for(Module__c module : modulesWithQuestion) {
	        if(module.Questions__r.isEmpty()){
	        	modulesMap.get(module.Id).addError('Cannot activate a module without any question.');        
	        }        
	    }
    }

	// Returns the responses for a list of modules
    private void getModuleResponses(List<Module__c> activeModules) {
		
	    Map<Id,Module__c> modulesMap = new Map<Id, Module__c>(activeModules);

	    List<Module__c> modulesWithResponse = new ModulesSelector(new Set<String> {'Id'}).selectByIdWithModuleResponses(modulesMap.KeySet()); 
	    																		
	    for(Module__c module : modulesWithResponse) {
	        if(!module.ModuleResponses__r.isEmpty()){
	        	modulesMap.get(module.Id).addError('Cannot delete or inactivate a module with response.');        
	        }        
	    }
    }

}