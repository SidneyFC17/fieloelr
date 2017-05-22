public with sharing class CourseDependenciesSelector extends SObjectSelector{
    
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                CourseDependency__c.Id,
                CourseDependency__c.Name,
                CourseDependency__c.Course__c,
                CourseDependency__c.Predecessor__c                  
            };
    }

    public CourseDependenciesSelector(Set<String> fields){
        super(fields);
    }

    public CourseDependenciesSelector(){
        super();
    }

    public Schema.SObjectType getSObjectType(){
        return CourseDependency__c.sObjectType;
    }

    public List<CourseDependency__c> selectById(Set<Id> CourseDependenciesIds){
        return (List<CourseDependency__c>) selectSObjectsById(CourseDependenciesIds);
    }

    public List<CourseDependency__c> selectDependenciesAndPredecessors(Set<Id> recordIds) {
      return (List<CourseDependency__c>) Database.query(String.format(
                'SELECT {0} ' +               
                  'FROM {1} ' +
                  'WHERE Course__c IN :recordIds OR Predecessor__c IN :recordIds' ,
                 
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }


}