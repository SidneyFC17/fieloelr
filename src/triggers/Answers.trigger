trigger Answers on Answer__c (before insert, before delete) {
	SObjectDomain.triggerHandler(Answers.class);
}