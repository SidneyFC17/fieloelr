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

   		List<Module__c> activatedModules = new List<Module__c>();
    	List<Module__c> inactivatedModules = new List<Module__c>();

		for(Module__c module : (List<Module__c>)records) {
			// Select only modules that are being activated
			if(!(((Module__c)(existingRecords.get(module.Id))).IsActive__c) && module.IsActive__c) {
				activatedModules.add(module);
			}
			// Select only modules that are being inactivated
			if(((Module__c)(existingRecords.get(module.Id))).IsActive__c && !(module.IsActive__c)) {
				inactivatedModules.add(module);
			}	
		}

		// When the module is changed to active, must validate that has at least one question.
   		checkQuestions(activatedModules);

		// An active module with related module responses cannot be inactivated.
		checkModuleResponses(inactivatedModules);

   		// When the module is activated, should verify, for the question types "statement" and "single choice", that it has a correct answer.

    }

	public override void onBeforeDelete() {

   		List<Module__c> activeModules = new List<Module__c>();

		for(Module__c module : (List<Module__c>)records) {
   			// Select only active modules
			if(module.IsActive__c) {
				activeModules.add(module);
			}
		}

		// An active module with related module responses cannot be deleted.
     	checkModuleResponses(activeModules);
    }

	// Check the questions for a list of modules
    private void checkQuestions(List<Module__c> activatedModules) {
		
	    Map<Id,Module__c> modulesMap = new Map<Id, Module__c>(activatedModules);

	    List<Module__c> modulesWithQuestion = new ModulesSelector(new Set<String> {'Id'}).selectByIdHavingQuestions(modulesMap.KeySet()); 
	    																		
	    for(Module__c module : modulesWithQuestion) {
	        if(module.Questions__r.isEmpty()){
	        	modulesMap.get(module.Id).addError('Cannot activate a module without any question.');        
	        }        
	    }
    }

	// Check the responses for a list of modules
    private void checkModuleResponses(List<Module__c> inactivatedModules) {
		
	    Map<Id,Module__c> modulesMap = new Map<Id, Module__c>(inactivatedModules);

	    List<Module__c> modulesWithResponse = new ModulesSelector(new Set<String> {'Id'}).selectByIdHavingModuleResponses(modulesMap.KeySet()); 
	    																		
	    for(Module__c module : modulesWithResponse) {
	        if(!module.ModuleResponses__r.isEmpty()){
	        	modulesMap.get(module.Id).addError('Cannot delete or inactivate a module with response.');        
	        }        
	    }
    }

	// Check the answers for a list of modules
    private void checkAnswers(List<Question__c> questions) {
		
	    Map<Id,Question__c> modulesMap = new Map<Id, Question__c>(questions);

	    List<Question__c> modulesWithAnswer = new ModulesSelector(new Set<String> {'Id'}).selectByIdHavingCorrectAnswers(modulesMap.KeySet()); 
	    																		
	    for(Question__c module : modulesWithAnswer) {
	        if(module.Answers__r.isEmpty()){
	        	modulesMap.get(module.Id).addError('Cannot activate a module without any question.');    //TODO: Message    
	        }        
	    }
    }

}