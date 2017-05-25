public class CourseStatus extends SObjectDomain {
	
    public static Boolean validateAdminFields = true;
    
	public CourseStatus(List<CourseStatus__c> records) {
		super(records);
	}

	public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<CourseStatus__c> sObjectList) {
            //If has Admin Permission allow "validateAdminFields"
            if(FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()) != null && FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()).FieloPLT__To__c >= system.now()){
                validateAdminFields = false;
            }
            return new CourseStatus(sObjectList);
        }
    }

    public override void onValidate() {
    	//before insert
    }

    public override void onValidate(Map<Id,SObject> existingRecords) {
    	//before update
    }

    public override void onApplyDefaults() {
        for(CourseStatus__c cStatus : (List<CourseStatus__c>)records){
            cStatus.ApprovedModules__c = 0;
        }
    }
        
    public override void onBeforeDelete() {
            Set<Id> coursesIds = new Set<Id>();
            Set<Id> courseValidateIds = new Set<Id>();
            
            for(CourseStatus__c cs : (List<CourseStatus__c>)records){
                coursesIds.add(cs.Course__c);
            }

            List<ModuleResponse__c> modulesList = new List<ModuleResponse__c>(new ModuleResponsesSelector(new Set<String>{'Id','Module__r.Course__c'}).selectModuleResponseIds(coursesIds));
            
            for(ModuleResponse__c mr : modulesList){
                courseValidateIds.add(mr.Module__r.Course__c); 
            }
            
            for(CourseStatus__c cs : (List<CourseStatus__c>)records){
                if(courseValidateIds.contains(cs.Course__c)){
                    cs.addError('You cannot delete a course status if you have a related module response  for any of the related modules  to the course');
                }
            }

        }
}