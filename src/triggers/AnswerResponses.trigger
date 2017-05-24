trigger AnswerResponses on AnswerResponse__c (before insert) {
	SObjectDomain.triggerHandler(AnswerResponses.class);
}