public class Questions extends SObjectDomain {

	public Questions(List<Question__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<Question__c> sObjectList) {
            return new Questions(sObjectList);
        }
    }

    public override void onApplyDefaults() {
    	// If both IncorrectWeight or PenaltyPerAttempt are null, replace them by 0 (zero)
    	checkNullValues(records);
    }

    public override void onBeforeInsert() {
		// If the module is active, questions cannot be deleted, updated or added.
    	checkModule(records);
    	
    	// Do some module related actions upon insert
		onInsertModuleRelatedActions(records);
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
		// If the module is active, questions cannot be deleted, updated or added.																		
		checkModule(records);

		// If both IncorrectWeight or PenaltyPerAttempt are null, replace them by 0 (zero)
    	checkNullValues(records);
    }


	public override void onBeforeDelete() {
		// If the module is active, questions cannot be deleted, updated or added.																		
     	checkModule(records);
    }

    public override void onAfterDelete() {
    	// Delete related answers upon question delete
    	deleteRelatedAnswers(records);
    }

	// Check the modules
    private void checkModule(List<Question__c> questions) {

	    Set<Id> modules = new Set<Id>();
	    for(Question__c question : questions) {
			modules.add(question.Module__c);
	    }

		Map<Id, Module__c> modulesMap = new Map<Id, Module__c>(new ModulesSelector(new Set<String> {'Id'}).selectByIdActive(modules));

		// If the module is active, questions cannot be deleted, updated or added.																		
	    for(Question__c question : questions) {
	    	if(modulesMap.containsKey(question.Module__c)) {
	        	question.addError('Active modules cannot have changes in their set of questions.');             
	    	}
	    }
    }

    // Set fields to zero if null
    private void checkNullValues(List<Question__c> questions) {
    	for (Question__c question: questions) {
    		question.IncorrectWeight__c = question.IncorrectWeight__c == null ?
    			0.0 :
    			question.IncorrectWeight__c;
    		question.PenaltyPerAttempt__c = question.PenaltyPerAttempt__c == null ?
    			0.0 :
    			question.PenaltyPerAttempt__c;
    	}
    }

    //Module related actions on Insert
    private void onInsertModuleRelatedActions(List<Question__c> questions) {

    	Set<Id> modules = new Set<Id>();
	    for(Question__c question : questions) {
			modules.add(question.Module__c);
	    }

		Map<Id, Module__c> modulesMap = new Map<Id, Module__c>(
			new ModulesSelector(new Set<String> {'Id','WeightedQuestions__c'}).selectByIdWithQuestions(modules));

    	for (Question__c question: questions) {
    		// If Module.WeightedQuestions is false, CorrectWeight = 1
    		question.CorrectWeight__c = modulesMap.get(question.Module__c).WeightedQuestions__c ?
    			question.CorrectWeight__c :
    			1;

    		// If Order is null, calculate it automatically
    		if(question.Order__c == null) {
    			question.Order__c = modulesMap.get(question.Module__c).Questions__r.size() + 1;
    		}
    	}	
    }

    private void deleteRelatedAnswers(List<Question__c> questions) {
    	Map<Id, Question__c> existingQuestions = new Map<Id, Question__c>(
    		new QuestionsSelector().selectByModuleHavingAnswers(new Map<Id,Question__c>(questions).keySet()));

    	List<Answer__c> existingAnswers = new List<Answer__c>();

    	for (Question__c question: questions) {
    		if(existingQuestions.get(question.Id).Answers__r.size()>0) {
    			existingAnswers.addAll(existingQuestions.get(question.Id).Answers__r);
    		}
    	}

    	if (!existingAnswers.isEmpty()) {
    		delete existingAnswers;
    	}
    }
}