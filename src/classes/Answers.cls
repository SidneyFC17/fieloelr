public class Answers extends SObjectDomain {

	public Answers(List<Answer__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<Answer__c> sObjectList) {
            return new Answers(sObjectList);
        }
    }

    public override void onBeforeInsert() {
		// If the module is active, answers cannot be deleted, updated or added.																		
    	checkModule(records);
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
		// If the module is active, answers cannot be deleted, updated or added.																		
		checkModule(records);
    }


	public override void onBeforeDelete() {
		// If the module is active, answers cannot be deleted, updated or added.																		
     	checkModule(records);
    }


	// Check the modules for a list of answers
    private void checkModule(List<Answer__c> answers) {
		
	    Set<Id> questions = new Set<Id>();
	    for(Answer__c answer : answers) {
			questions.add(answer.Question__c);
	    }

		Map<Id, Question__c> questionsMap = new Map<Id, Question__c>(new QuestionsSelector(new Set<String> {'Id'}).selectByIdWithActiveModule(questions));

		// If the module is active, answers cannot be deleted, updated or added.																		
	    for(Answer__c answer : answers) {
	    	if(questionsMap.containsKey(answer.Question__c)) {
	        	answer.addError('Active modules cannot have changes in their set of answers.');             
	    	}
	    }
    }

}