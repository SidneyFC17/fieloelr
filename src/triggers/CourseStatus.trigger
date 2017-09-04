trigger CourseStatus on CourseStatus__c (before insert, after insert, before update, after update) {
  SObjectDomain.triggerHandler(CourseStatus.class);
}