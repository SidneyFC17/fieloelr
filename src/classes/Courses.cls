public  class Courses extends SObjectDomain{
    
    public static Boolean validateAdminFields = true;
    public static Boolean isDelete = false;

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
            course.Status__c = 'Draft';
            course.KeyDependencies__c = '';
            if(String.isBlank(course.SubscriptionMode__c)){
                course.SubscriptionMode__c = 'Manual';
            }
        }
    }

    public override void onValidate(Map<Id,SObject> existingRecords) {
        if(validateAdminFields){
            //before update
            for(Course__c course : (List<Course__c>)records){
                Course__c oldCourse = (Course__c)existingRecords.get(course.Id);
                if(course.ActiveModules__c != oldCourse.ActiveModules__c) {
                    course.ActiveModules__c = oldCourse.ActiveModules__c;
                }

                // When Active, no field can be edited
                if(oldCourse.Status__c == 'Active' && course.Status__c == 'Active') {
                    addError(course, Label.ActiveCourseCannotBeEdited);
                }
            }
        }

   } 

    public override void onBeforeDelete() {
        isDelete = true;

        // Check Courses before delete
        checkCoursesWithStatus((List<Course__c>)records); 

        SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{CourseDependency__c.SObjectType, Module__c.SObjectType}, true);
        
        Map<Id,Course__c> coursesMap = new Map<Id, Course__c>((List<Course__c>)records);
        // When the course is deleted, must delete course dependencies. 
        deleteCourseDependencies(coursesMap, uow);
        // When the course is deleted, must delete related modules
        deleteCourseModules(coursesMap, uow);

        uow.commitWork();

        Map<Id,SObject> deletedModules = uow.m_deletedMapByType.get('FieloELR__Module__c');
        for (Database.DeleteResult dr : uow.getResults(Module__c.SObjectType).deleteResults) {
            if (!dr.isSuccess()) {
                // Operation failed, so get all errors                
                for(Database.Error err : dr.getErrors()) {
                    coursesMap.get(((Module__c)deletedModules.get(dr.getId())).Course__c).addError(err.getMessage());
                }
            }
        }
    }

    private void deleteCourseModules(Map<Id,Course__c> coursesMap, SObjectUnitOfWork uow){
        Set<Id> courseIds = coursesMap.KeySet();
        courseIds.removeAll(new List<Id>(RecordErrors));
        // Looks up for courses IDs contained in modules
        List<Module__c> modulesToDelete = new ModulesSelector(new Set<String>{'Id','Course__c'}).selectByIdHavingCourses(courseIds);  
  
        // Delete related modules
        uow.registerDeleted(modulesToDelete);
    }
    
    private void deleteCourseDependencies(Map<Id,Course__c> coursesMap, SObjectUnitOfWork uow){        
        Set<Id> courseIds = coursesMap.KeySet();
        courseIds.removeAll(new List<Id>(RecordErrors));
        // Looks up for courses IDs contained in course dependencies and predecessors
        List<CourseDependency__c> dependenciesToDelete = new CourseDependenciesSelector(new Set<String>{'Course__c,Predecessor__c'}).selectDependenciesAndPredecessors(coursesMap.KeySet());
  
        // Delete related dependencies
        uow.registerDeleted(dependenciesToDelete);      
    }
        
    // If the course is active, has at least 1 related course status, 
    // and any of the following fields was modified the Course cannot be edited or deleted.
    private void checkCoursesWithStatus(List<Course__c> courses){
        // Map with NEW records       
        Map<Id,Course__c> coursesMap = new Map<Id, Course__c>(courses);
        // Course has at least 1 related Course Status
        List<Course__c> coursesWithStatus = new CoursesSelector(new Set<String>{'Id,Status__c,SubscriptionMode__c,Segment__c,StartDate__c,EndDate__c'}).selectByIdHavingCourseStatus(coursesMap.KeySet());

        for (Course__c course : coursesWithStatus){
            if(!course.CoursesStatus__r.isEmpty()){
                coursesMap.get(course.Id).addError(Label.ActiveCourseCannotBeEdited);
            }
        }
    }
}