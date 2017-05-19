trigger Courses on Course__c (before update, before delete) {
	SObjectDomain.triggerHandler(Courses.class);
}