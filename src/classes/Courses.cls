public class Courses extends SObjectDomain{
	
    public static Boolean validateAdminFields = true;

	public Courses(List<Course__c> records) {
		super(records);
	}

	public class Constructor implements SObjectDomain.IConstructable {

        public SObjectDomain construct(List<Course__c> sObjectList) {            
            //If has Admin Permission allow "validateAdminFields"
            if(FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()) != null && FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()).FieloPLT__To__c >= system.now()){
                validateAdminFields = false;
            }
            return new Courses(sObjectList);
        }
    }

    public override void onApplyDefaults() {
        for(Course__c course : (List<Course__c>)records){
            course.ActiveModules__c = 0;
        }
    }

    public override void onValidate() {
    	//before insert
    }

    public override void onValidate(Map<Id,SObject> existingRecords) {
    	//before update
        if(validateAdminFields){
            for(Course__c course : (List<Course__c>)records){
                if(course.ActiveModules__c != ((Course__c)(existingRecords.get(course.Id))).ActiveModules__c) {
                    course.ActiveModules__c = ((Course__c)(existingRecords.get(course.Id))).ActiveModules__c;
                }
            }
        }
    }

    public override void onBeforeDelete(){

    }     
}