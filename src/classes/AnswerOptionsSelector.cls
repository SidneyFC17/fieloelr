public class AnswerOptionsSelector extends SObjectSelector {

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

    public List<AggregateResult> selectByQuestionGroupByQuestion(Set<Id> questionIds) {

        SObjectType convertType = Schema.getGlobalDescribe().get('fieloELR__AnswerOption__c');
        SecurityUtils.checkObjectIsReadable(convertType);

        return [SELECT MAX(Order__c) order, Question__c FROM AnswerOption__c WHERE Question__c in : questionIds GROUP BY Question__c];
    
    }
}