public class Courses extends SObjectDomain{
    
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
            if(String.isBlank(course.SubscriptionMode__c)){
                course.SubscriptionMode__c = 'Manual';
            }
        }
    }

    public override void onValidate() {
        //before insert
    }

    public override void onValidate(Map<Id,SObject> existingRecords) {
        //before update
        for(Course__c course : (List<Course__c>)records){
            if(String.isBlank(course.SubscriptionMode__c)){
                course.SubscriptionMode__c = 'Manual';
            }        
            if(validateAdminFields){
                if(course.ActiveModules__c != ((Course__c)(existingRecords.get(course.Id))).ActiveModules__c) {
                    course.ActiveModules__c = ((Course__c)(existingRecords.get(course.Id))).ActiveModules__c;
                }
            }
        }

        // Check Courses before update 
        checkCoursesWithStatus(existingRecords, 'update'); 
   } 

    public override void onBeforeDelete() {
        isDelete = true;

        // Check Courses before delete
        checkCoursesWithStatus(null, 'delete'); 

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
        // Looks up for courses IDs contained in modules
        List<Module__c> modulesToDelete = new ModulesSelector(new Set<String>{'Id','Course__c'}).selectByIdHavingCourses(coursesMap.KeySet());  
  
        // Delete related modules
        uow.registerDeleted(modulesToDelete);
    }
    
    private void deleteCourseDependencies(Map<Id,Course__c> coursesMap, SObjectUnitOfWork uow){        
        // Looks up for courses IDs contained in course dependencies and predecessors
        List<CourseDependency__c> dependenciesToDelete = new CourseDependenciesSelector(new Set<String>{'Course__c,Predecessor__c'}).selectDependenciesAndPredecessors(coursesMap.KeySet());
  
        // Delete related dependencies
        uow.registerDeleted(dependenciesToDelete);      
    }
        
    // If the course is active, has at least 1 related course status, 
    // and any of the following fields was modified the Course cannot be edited or deleted.
    private void checkCoursesWithStatus(Map<Id,SObject> existingRecords, String event){
        // Map with NEW records       
        Map<Id,Course__c> coursesMap = new Map<Id, Course__c>((List<Course__c>)records);
        // Course has at least 1 related Course Status
        List<Course__c> coursesWithStatus = new CoursesSelector(new Set<String>{'Id,Status__c,SubscriptionMode__c,Segment__c,StartDate__c,EndDate__c'}).selectByIdHavingCourseStatus(coursesMap.KeySet());

        for (Course__c course : coursesWithStatus){
            if(!course.CoursesStatus__r.isEmpty()){
                if (course.Status__c == 'Active'){
                    if (event == 'delete'){
                        coursesMap.get(course.Id).addError(Label.ValidateCourseErrorDelete);
                    }                                                                        
                }
            }
            if (event == 'update'){                        
                // The only update possible is for the Status
                if( (((Course__c)(existingRecords.get(course.Id))).Status__c) == coursesMap.get(course.Id).Status__c ) {
                    if (coursesMap.get(course.Id).Status__c != 'Inactive') {
                        coursesMap.get(course.Id).addError(Label.ActiveCourseCannotBeEdited);
                    }
                }
            }
        }
    }
   
    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) { 
        
    }  

    public override void onBeforeInsert() {
    }   
}