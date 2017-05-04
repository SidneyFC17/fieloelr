public class CoursesResponses extends SObjectDomain {
	public CoursesResponses(List<CourseResponse__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<SObject> sObjectList) {
            return new CoursesResponses(sObjectList);
        }
    }
}