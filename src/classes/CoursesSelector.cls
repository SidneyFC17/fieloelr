public with sharing class CoursesSelector extends SObjectSelector{
	public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                Course__c.Id,
                Course__c.Name,
                Course__c.Description__c,
                Course__c.EndDate__c,
                Course__c.Program__c,
                Course__c.Segment__c,
                Course__c.StartDate__c,
                Course__c.Status__c,
                Course__c.SubscriptionMode__c    
            };
    }

    public CoursesSelector(Set<String> fields){
        super(fields);
    }

    public CoursesSelector(){
        super();
    }

    public Schema.SObjectType getSObjectType(){
        return Course__c.sObjectType;
    }

    public List<Course__c> selectById(Set<Id> CourseIds){
        return (List<Course__c>) selectSObjectsById(CourseIds);
    }
}