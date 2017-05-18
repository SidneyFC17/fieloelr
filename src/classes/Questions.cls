public class Questions extends SObjectDomain {

	public Questions(List<Question__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<Question__c> sObjectList) {
            return new Questions(sObjectList);
        }
    }

    public override void onBeforeInsert() {
		// If the module is active, questions cannot be deleted, updated or added.																		
    	checkModule(records);
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
		// If the module is active, questions cannot be deleted, updated or added.																		
		checkModule(records);
    }


	public override void onBeforeDelete() {
		// If the module is active, questions cannot be deleted, updated or added.																		
     	checkModule(records);
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

}