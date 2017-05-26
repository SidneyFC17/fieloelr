public with sharing class AnswerOptionsSelector extends SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                AnswerOption__c.Id,
                AnswerOption__c.Name,
                AnswerOption__c.IsCorrect__c,
                AnswerOption__c.Question__c
            };
    }

    public AnswerOptionsSelector(Set<String> fields){
        super(fields);
    }

    public AnswerOptionsSelector(){
        super();
    }

    public Schema.SObjectType getSObjectType(){
        return AnswerOption__c.sObjectType;
    }

    public List<AnswerOption__c> selectById(Set<Id> answerOptionIds) {
        return (List<AnswerOption__c>) selectSObjectsById(answerOptionIds);
    }
}