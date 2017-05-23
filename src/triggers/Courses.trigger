trigger Courses on Course__c (before update, before delete, before insert) {
	SObjectDomain.triggerHandler(Courses.class);
}