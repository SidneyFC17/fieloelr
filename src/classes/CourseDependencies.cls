public class CourseDependencies extends SObjectDomain{
    
    public CourseDependencies(List<CourseDependency__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<CourseDependency__c> sObjectList) {
            return new CourseDependencies(sObjectList);
        }
    }

    public override void onApplyDefaults(){
        for(CourseDependency__c courseDependency : (List<CourseDependency__c>)records){
            courseDependency.Key__c = ((string)courseDependency.Course__c).substring(0, 15) + ((string)courseDependency.Predecessor__c).substring(0, 15);
        }
    }

    public override void onValidate() {
        //before insert
    }

    public override void onValidate(Map<Id,SObject> existingRecords) {
        //before update
    }

    public override void onBeforeDelete() {

    }
    public override void onBeforeInsert() {

    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {

    }

    public override void onAfterInsert() {
        SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{Course__c.SObjectType});
        updateCourses(records, uow);
        uow.commitWork();
    }

    public override void onAfterDelete() {
        SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{Course__c.SObjectType});
        updateCourses(records, uow);
        uow.commitWork();
    }  

    private void updateCourses(List<CourseDependency__c> courseDependencies, SObjectUnitOfWork uow) {

        Set<Id> courseIds = new Set<Id>();
        for(CourseDependency__c coursedependency : courseDependencies) {
            courseIds.add(coursedependency.Course__c);
        }
        Map<Id, Course__c> coursesMap = 
                    new Map<Id, Course__c>(new CoursesSelector(new Set<String> {'Id', 'HasDependencies__c', 'KeyDependencies__c'}).selectById(courseIds));
        Course__c course;
        String predecessor;
        List<String> Keys;

        for(CourseDependency__c coursedependency : courseDependencies) {
            course = coursesMap.get(coursedependency.Course__c);
            predecessor = coursedependency.Predecessor__c;
            if(Trigger.IsInsert) {
                // Add key
                if(String.IsBlank(course.KeyDependencies__c)) {
                    course.KeyDependencies__c = predecessor;
                } else {
                    Keys = course.KeyDependencies__c.split(',');
                    Keys.add(predecessor);
                    Keys.sort();            
                    course.KeyDependencies__c = String.join(Keys, ',');
                }   
                // If a course dependency is inserted and course has no dependencies yet, the attribute must be updated
                if(!(course.HasDependencies__c)) {
                    course.HasDependencies__c = true;
                }
            } else if(Trigger.IsDelete) {
                if(!String.isBlank(course.KeyDependencies__c)){
                    // Remove key
                    course.KeyDependencies__c = course.KeyDependencies__c.replace(predecessor + ',', '').replace(',' + predecessor, '').replace(predecessor, '');
                }
                // If a course dependency is deleted and course has no more dependencies, the attribute must be updated
                if(String.isBlank(course.KeyDependencies__c) && course.HasDependencies__c) {
                    course.HasDependencies__c = false;
                }                
            }
            uow.registerDirty(course); 
        }
    }  
}