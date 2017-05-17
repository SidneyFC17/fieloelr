public class Answers extends SObjectDomain {

	public Answers(List<Answer__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<Answer__c> sObjectList) {
            return new Answers(sObjectList);
        }
    }


	// Check the modules for a list of answers
    private void checkModule(List<Answer__c> answers) {
		
	    Set<Id> questions = new Set<Id>();
	    for(Answer__c answer : answers) {
			questions.add(answer.Question__c);
	    }

		Map<Id, Question__c> questionsMap = new Map<Id, Question__c>(new QuestionsSelector(new Set<String> {'Id'}).selectByIdWithActiveModule(questions));

		// If the module is Active cannot be deleted, updated or added new answers.																		
	    for(Answer__c answer : answers) {
	    	if(questionsMap.containsKey(answer.Question__c) != null) {
	        	answer.addError('Active modules cannot have changes in their answers.');             
	    	}
	    }
    }

}