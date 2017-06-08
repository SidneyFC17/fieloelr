trigger CourseStatus on CourseStatus__c (before insert, before update, before delete) {
  SObjectDomain.triggerHandler(CourseStatus.class);
}