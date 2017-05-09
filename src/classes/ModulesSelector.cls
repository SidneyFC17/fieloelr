public with sharing class ModulesSelector extends SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                Module__c.Id,
                Module__c.Name,
                Module__c.ApprovalGrade__c,
                Module__c.AttemptsAllowed__c,
                Module__c.AttemptsAllowedPerQuestion__c,
                Module__c.Description__c,
                Module__c.IsActive__c,
                Module__c.QuestionPool__c,
                Module__c.Order__c,
                Module__c.ShuffleQuestions__c,
                Module__c.TotalValue__c
            };
    }

    public ModulesSelector(Set<String> fields){
        super(fields);
    }

    public ModulesSelector(){
        super();
    }

    public Schema.SObjectType getSObjectType(){
        return Module__c.sObjectType;
    }

    public List<Module__c> selectById(Set<Id> moduleIds){
        return (List<Module__c>) selectSObjectsById(moduleIds);
    }

    public List<Module__c> selectByModuleResponseIdWithQuestions(Set<Id> moduleResponseIds) {
    	return (List<Module__c>) Database.query(String.format(
                'SELECT {0} ' +
                  ', (SELECT Id, ' +
                  	'IncorrectWeight__c, ' +
                  	'Module__c, ' +
                  	'Order__c, ' +
                  	'PenaltyPerAttempt__c, ' +
                  	'TextValue__c, ' +
                  	'Type__c, ' +
                  	'Value__c, ' +
                  	'Weight__c, ' +
                  	'Name FROM Questions__r) ' +
                  'FROM {1} ' +
                  'WHERE Id IN (SELECT Module__c FROM ModuleResponse__c WHERE Id IN :moduleResponseIds) ' +
                  'ORDER BY {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<Module__c> selectByIdWithQuestions(Set<Id> moduleIds) {
      return (List<Module__c>) Database.query(String.format(
                'SELECT {0} ' +
                  ', (SELECT Id, ' +
                    'IncorrectWeight__c, ' +
                    'Module__c, ' +
                    'Order__c, ' +
                    'PenaltyPerAttempt__c, ' +
                    'TextValue__c, ' +
                    'Type__c, ' +
                    'Value__c, ' +
                    'Weight__c, ' +
                    'Name FROM Questions__r) ' +
                  'FROM {1} ' +
                  'WHERE Id IN :moduleIds ' +
                  'ORDER BY {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }
}