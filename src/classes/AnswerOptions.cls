public class AnswerOptions extends SObjectDomain {

	public AnswerOptions(List<AnswerOption__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<AnswerOption__c> sObjectList) {
            return new AnswerOptions(sObjectList);
        }
    }

    public override void onBeforeInsert() {
    	validateAnswers(records, true);
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
		validateAnswers(records, true);
    }


	public override void onBeforeDelete() {
     	validateAnswers(records, false);
    }


	// General validations for a list of answers
    private void validateAnswers(List<AnswerOption__c> answerOptions, Boolean validateFormat) {
		
	    Set<Id> questions = new Set<Id>();
	    for(AnswerOption__c answerOption : answerOptions) {
			questions.add(answerOption.Question__c);
	    }

		Map<Id, Question__c> questionsMap = new Map<Id, Question__c>(
			new QuestionsSelector(new Set<String> {'Id', 'Module__r.IsActive__c', 'Type__c'}).selectByIdWithAnswers(questions));

	    for(AnswerOption__c answerOption : answerOptions) {

			// If the module is active, answers cannot be deleted, updated or added.																		
	    	if(questionsMap.get(answerOption.Question__c).Module__r.IsActive__c) {
	        	answerOption.addError('Active modules cannot have changes in their set of answer options.');             
	    	}

    		// If the question type is "Matching Options", the format for Answer Text must be validated as {"xx":"yy"}
  			if(validateFormat && questionsMap.get(answerOption.Question__c).Type__c == 'Matching Options') {
				try {
					// If the question type is Matching, the Answer text must be in the format {"string1":"string2"}
				    Map<String, String> deserializedAnswer = (Map<String,String>)JSON.deserializeStrict(answerOption.AnswerOptionText__c,Map<String,String>.class);
				    System.debug(deserializedAnswer.size() == 1);	    
				} catch(Exception e) {
		        	answerOption.addError('Answer Option is in the wrong format. It should be {"abc":"xyz"}.');             
				}
	    	}

	    	// If Order__c field is null, calculate it automatically
    		if( Trigger.isInsert && answerOption.Order__c == null) {
    			answerOption.Order__c = questionsMap.get(answerOption.Question__c).AnswerOptions__r.size() + 1;
    		}
	    }
    }

}