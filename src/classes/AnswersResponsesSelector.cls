public with sharing class AnswersResponsesSelector extends SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                AnswerResponse__c.Id,
                AnswerResponse__c.Name,
                AnswerResponse__c.Answer__c,
                AnswerResponse__c.QuestionResponse__c

            };
    }

    public AnswersResponsesSelector(Set<String> fields){
        super(fields);
    }

    public AnswersResponsesSelector(){
        super();
    }

    public Schema.SObjectType getSObjectType(){
        return AnswerResponse__c.sObjectType;
    }

    public List<AnswerResponse__c> selectById(Set<Id> answerResponseIds) {
        return (List<AnswerResponse__c>) selectSObjectsById(answerResponseIds);
    }
}