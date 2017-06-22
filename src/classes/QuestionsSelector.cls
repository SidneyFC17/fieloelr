public with sharing class QuestionsSelector extends SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                Question__c.Id,
                Question__c.Name,
                Question__c.FieloELR__IncorrectWeight__c,
                Question__c.FieloELR__Module__c,
                Question__c.FieloELR__Order__c,
                Question__c.FieloELR__PenaltyPerAttempt__c,
                Question__c.FieloELR__Type__c,
                Question__c.FieloELR__CorrectWeight__c
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

    public List<Question__c> selectByIdWithCorrectAnswers(Set<Id> questionIds) {
        return (List<Question__c>) Database.query(String.format(
                'SELECT {0} ' +
                  ', (SELECT Id, Name, AnswerOptionText__c, MatchingText__c FROM AnswerOptions__r WHERE IsCorrect__c = true) ' +
                  'FROM {1} ' +
                  'WHERE Id IN :questionIds ' +
                  'ORDER BY {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<Question__c> selectByIdWithAnswersAndQuestionResponses(Set<Id> questionIds) {
        return (List<Question__c>) Database.query(String.format(
                'SELECT {0} ' +
                  ', (SELECT Id, Name, AnswerOptionText__c, IsCorrect__c FROM AnswerOptions__r) ' +
                  ', (SELECT Id FROM QuestionsResponses__r LIMIT 1) ' +
                  'FROM {1} ' +
                  'WHERE Id IN :questionIds ' +
                  'ORDER BY {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<Question__c> selectByModuleHavingAnswers(Set<Id> moduleIds) {
      return (List<Question__c>) Database.query(String.format(
                'SELECT {0} ' +
                  ', (SELECT Id, IsCorrect__c ' +
                  '   FROM AnswerOptions__r ' +
                  '   ORDER BY IsCorrect__c DESC ' +
                  '   LIMIT 1) ' +
                  'FROM {1} ' +
                  'WHERE Module__c IN :moduleIds ' +
                  'ORDER BY {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<Question__c> selectByIdWithActiveModule(Set<Id> questionIds) {
        return (List<Question__c>) Database.query(String.format(
                'SELECT {0} ' +
                  'FROM {1} ' +
                  'WHERE Module__r.IsActive__c = true ' +
                  'ORDER BY {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }

     public List<Question__c> selectByModule(Set<Id> moduleIds) {
      return (List<Question__c>) Database.query(String.format(
                'SELECT {0} ' +
                  'FROM {1} ' +
                  'WHERE (Module__c IN :moduleIds) ' +
                  'ORDER BY {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<Question__c> selectByModuleHavingAnswerOptions(Set<Id> moduleIds, Set<String> answerOptionFields) {
      return (List<Question__c>) Database.query(String.format('SELECT {0} ' +
                   ', (SELECT {1} FROM AnswerOptions__r) ' +
                  'FROM {2} ' +
                  'WHERE Module__c IN :moduleIds ' +
                  'ORDER BY {3}',
                new List<String> {
                    getFieldListString(),
                    String.join(new List<String>(answerOptionFields),','),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<AggregateResult> selectByModuleGroupByModule(Set<Id> moduleIds) {
        return [SELECT MAX(Order__c) order, Module__c FROM Question__c WHERE Module__c in : moduleIds GROUP BY Module__c];
    }
}