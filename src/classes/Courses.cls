public class Courses extends SObjectDomain{
	
	public Courses(List<FieloELR__Course__c> records) {
		super(records);
	}

	public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<FieloELR__Course__c> sObjectList) {
            return new Courses(sObjectList);
        }
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
    }
    
    public override void onBeforeDelete() {
    }	
}