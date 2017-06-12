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

    public List<Course__c> selectByIdHavingCourseStatus(Set<Id> courseIds) {
      return (List<Course__c>) Database.query(String.format(
                'SELECT {0} ' +
                  ', (SELECT Id ' +
                  '   FROM CoursesStatus__r LIMIT 1) ' +
                  'FROM {1} ' +
                  'WHERE Id IN :courseIds ' +
                  'ORDER BY {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }
    
      public List<Course__c> selectAllByIdHavingCourseStatus(Set<Id> courseIds) {
      return (List<Course__c>) Database.query(String.format(
                'SELECT {0} ' +
                  ', (SELECT Id ' +
                  '   FROM CoursesStatus__r) ' +
                  'FROM {1} ' +
                  'WHERE Id IN :courseIds',
                new List<String> {
                    getFieldListString(),
                    getSObjectName() } ));
    }

    public List<Course__c> selectByIdHavingDependentCourses(Set<Id> courseIds) {
      return (List<Course__c>) Database.query(String.format(
                'SELECT {0} ' +
                  ', (SELECT Id ' +
                  '   FROM DependentCourses__r LIMIT 1) ' +
                  'FROM {1} ' +
                  'WHERE Id IN :courseIds ' +
                  'ORDER BY {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }
    public List<Course__c> selectByIdHavingPredecessorCourses(Set<Id> courseIds) {
      return (List<Course__c>) Database.query(String.format(
                'SELECT {0} ' +
                  ', (SELECT Id ' +
                  '   FROM PredecessorCourses__r LIMIT 1) ' +
                  'FROM {1} ' +
                  'WHERE Id IN :courseIds ' +
                  'ORDER BY {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<Course__c> selectByIdHavingPredecessor(Set<Id> courseIds, Set<String> courseDependencyFields) {
      return (List<Course__c>) Database.query(String.format('SELECT {0} ' +
                   ', (SELECT {1} FROM PredecessorCourses__r) ' +
                  'FROM {2} ' +
                  'WHERE Id IN :courseIds ' +
                  'ORDER BY {3}',
                new List<String> {
                    getFieldListString(),
                    String.join(new List<String>(courseDependencyFields),','),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<Course__c> selectByProgramHavingPredecessor(Id programId, Set<String> courseDependencyFields) {
      return (List<Course__c>) Database.query(String.format('SELECT {0} ' +
                   ', (SELECT {1} FROM PredecessorCourses__r) ' +
                  'FROM {2} ' +
                  'WHERE Program__c =: programId ' +
                  'ORDER BY {3}',
                new List<String> {
                    getFieldListString(),
                    String.join(new List<String>(courseDependencyFields),','),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<Course__c> selectByIdHavingPredecessor(Set<Id> courseIds) {
      return (List<Course__c>) Database.query(String.format(
               'SELECT {0} ' +
                   ', (SELECT Course__c, Predecessor__c ' +
                  '   FROM PredecessorCourses__r) ' +
                  'FROM {1} ' +
                  'WHERE Id IN :courseIds ' +
                  'ORDER BY {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }

      public List<Course__c> selectByIdBeingAutomatic(Set<Id> courseIds) {
      String automatic = 'Automatic';
      return (List<Course__c>) Database.query(String.format(       
               'SELECT {0} ' +                
                  'FROM {1} ' +
                  'WHERE Id IN : courseIds and SubscriptionMode__c = :automatic ' +
                  'ORDER BY {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }
}