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
}