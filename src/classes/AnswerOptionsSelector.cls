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

        if(SecurityUtils.canInsert(AnswerOption__c.sObjectType, new List<String>{'Question__c', 'Order__c'})){
                   List<AggregateResult> listAggre = [SELECT MAX(Order__c) order, Question__c FROM AnswerOption__c WHERE Question__c in : questionIds GROUP BY Question__c];
                    return listAggre;
                }else{
                    throw new FieloPLT.FieloException(Label.FieloPLT.CannotInsertUpdateRecords);
                    return null;
                }
    }
}