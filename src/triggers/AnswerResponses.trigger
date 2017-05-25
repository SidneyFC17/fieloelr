trigger AnswerResponses on AnswerResponse__c (before insert, before delete) {
	SObjectDomain.triggerHandler(AnswerResponses.class);
}