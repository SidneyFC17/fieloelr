public class ModuleDependenciesSelector extends SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                ModuleDependency__c.Id,
                ModuleDependency__c.Name,
                ModuleDependency__c.Module__c,
                ModuleDependency__c.Predecessor__c,
                ModuleDependency__c.ExternalKey__c
            };
    }

    public ModuleDependenciesSelector(Set<String> fields){
        super(fields);
    }

    public ModuleDependenciesSelector(){
        super();
    }

    public Schema.SObjectType getSObjectType(){
        return ModuleDependency__c.sObjectType;
    }

    public List<ModuleDependency__c> selectById(Set<Id> moduleDependencyIds){
        return (List<ModuleDependency__c>) selectSObjectsById(moduleDependencyIds);
    }

    public List<ModuleDependency__c> selectByModule(Set<Id> moduleIds) {
        return (List<ModuleDependency__c>) Database.query(String.format(
                'SELECT {0} ' +
                  'FROM {1} ' +
                  'WHERE (Module__c IN :moduleIds OR Predecessor__c IN :moduleIds) ' +
                  'ORDER BY {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<ModuleDependency__c> selectByPredecessor(Set<Id> moduleIds) {
        return (List<ModuleDependency__c>) Database.query(String.format(
                'SELECT {0} ' +
                  'FROM {1} ' +
                  'WHERE Predecessor__c IN :moduleIds ' +
                  'ORDER BY {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }
}