trigger CourseStatus on CourseStatus__c (before insert, before update) {
  SObjectDomain.triggerHandler(CourseStatus.class);
}