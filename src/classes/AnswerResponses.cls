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
 		setKeys((List<AnswerResponse__c>) records);
    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
    }

    private void setKeys(List<AnswerResponse__c> records) {
    	for(AnswerResponse__c answerResponse : records) {
			if(answerResponse.QuestionResponse__c != null && answerResponse.Answer__c != null) {
				answerResponse.Key__c = String.valueOf(answerResponse.QuestionResponse__c).substring(0, 15) + String.valueOf(answerResponse.Answer__c).substring(0, 15);   
    		}
    	}
    }
}