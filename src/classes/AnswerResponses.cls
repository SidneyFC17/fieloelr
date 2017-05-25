public class AnswerResponses extends SObjectDomain {

	public AnswerResponses(List<AnswerResponse__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<AnswerResponse__c> sObjectList) {
            return new AnswerResponses(sObjectList);
        }
    }

    public override void onBeforeInsert() {
    	validateRecords((List<AnswerResponse__c>) records);
 		setKeys((List<AnswerResponse__c>) records);
    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
		validateRecords((List<AnswerResponse__c>) records);
    }

    public override void onBeforeDelete() {
		validateRecords((List<AnswerResponse__c>) records);
	}

	private void validateRecords(List<AnswerResponse__c> answerResponses) {
	    
	    Set<Id> questionResponses = new Set<Id>();
	    for(AnswerResponse__c answerResponse : answerResponses) {
			questionResponses.add(answerResponse.QuestionResponse__c);
	    }
	    Map<Id, QuestionResponse__c> submittedQuestionResponsesMap = new Map<Id, QuestionResponse__c>(
	    												new QuestionResponsesSelector(new Set<String> {'Id', 'IsSubmitted__c'}).selectByKeyAndSubmitted(questionResponses)); 

	    for(AnswerResponse__c answerResponse : answerResponses) {
			// If the related Question Response was already submitted, the answer response cannot be deleted or updated (Only with Admin Permissions) or create new ones.    																		    	
	    	if(submittedQuestionResponsesMap.containsKey(answerResponse.QuestionResponse__c)) {
	        	answerResponse.addError('Question responses already submitted cannot have any modification in their set of answer responses.');             
	    	}   
	    }

	}

    private void setKeys(List<AnswerResponse__c> records) {
    	for(AnswerResponse__c answerResponse : records) {
			if(answerResponse.QuestionResponse__c != null && answerResponse.Answer__c != null) {
				answerResponse.Key__c = String.valueOf(answerResponse.QuestionResponse__c).substring(0, 15) + String.valueOf(answerResponse.Answer__c).substring(0, 15);   
    		}
    	}
    }

}