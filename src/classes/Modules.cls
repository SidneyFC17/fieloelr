public class Modules extends SObjectDomain {

	public Modules(List<Module__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<Module__c> sObjectList) {
            return new Modules(sObjectList);
        }
    }

    public override void onValidate() {

    }

    public override void onValidate(Map<Id,SObject> existingRecords) {

    }

    public override void onBeforeInsert() {
 		
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
    	/*
    	List<Module__c> activeModules;
        // Select only active modules TODO: ACERTAR DE ACORDO COM UPDATE OU DELETE
        activeModules = new List<Module__c>([SELECT Id
                                                FROM Module__c 
                                                WHERE Id IN :records
                                                    AND IsActive__c = true]);   
		*/
    }

   public override void onBeforeDelete() {
    	
    }

	// An active module with related module responses cannot be deleted or inactivated.
    private List<Module__c> getModuleResponses(List<Module__c> activeModules) {
		
	    
	    List<Module__c> modulesWithResponse = new List<Module__c>([SELECT Id, (SELECT Id FROM ModuleResponses__r LIMIT 1)
	                                                   							FROM Module__c 
	                                                   							WHERE Id IN :activeModules]); 
	    for(Module__c module : modulesWithResponse) {
	        if(module.ModuleResponses__r.isEmpty()){
	        	module.addError('Cannot delete or inactivate a module with response.');        
	        }
	        
	    }
    
	    return modulesWithResponse;
    }

}