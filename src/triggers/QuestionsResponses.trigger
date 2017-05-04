trigger QuestionsResponses on FieloELR__QuestionResponse__c (before insert, after insert, before update, after update, before delete, after delete) {
	SObjectDomain.triggerHandler(QuestionsResponses.class);
}