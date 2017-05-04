public with sharing class QuestionsSelector extends SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                Question__c.Id,
                Question__c.Name,
                Question__c.FieloELR__Course__c,
                Question__c.FieloELR__Order__c,
                Question__c.FieloELR__Type__c,
                Question__c.FieloELR__Value__c,
                Question__c.FieloELR__TextValue__c
            };
    }

    public QuestionsSelector(Set<String> fields){
        super(fields);
    }

    public QuestionsSelector(){
        super();
    }

    public Schema.SObjectType getSObjectType(){
        return Question__c.sObjectType;
    }

    public List<Question__c> selectById(Set<Id> questionIds) {
        return (List<Question__c>) selectSObjectsById(questionIds);
    }

    public List<Question__c> selectByQuestionResponseIdWithCorrectAnswers(Set<Id> questionResponseIds) {
    	return (List<Question__c>) Database.query(String.format(
                'SELECT {0} ' +
                  ', (SELECT Id, Name FROM Answers__r WHERE IsCorrect__c = true) ' +
                  'FROM {1} ' +
                  'WHERE Id IN (SELECT Question__c FROM QuestionResponse__c WHERE Id in :questionResponseIds) ' +
                  'ORDER BY {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }
}