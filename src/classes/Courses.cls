public class Courses extends SObjectDomain{
	
	public Courses(List<Course__c> records) {
		super(records);
	}

	public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<Course__c> sObjectList) {
            return new Courses(sObjectList);
        }
    }

    public override void onValidate() {
    	//before insert
    }

    public override void onValidate(Map<Id,SObject> existingRecords) {
    	//before update
    }

    
}