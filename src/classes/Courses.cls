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

        // Check Courses before update 
        checkCoursesWithStatus(existingRecords, 'update'); 
   } 

    public override void onBeforeDelete() {
        // Check Courses before delete
        checkCoursesWithStatus(null, 'delete'); 

        // When the course is deleted, must delete course dependencies. 
        deleteCourseDependencies();

        // When the course is deleted, must delete related modules
        deleteCourseModules();
    }

    private void deleteCourseModules(){
        // Map with NEW records       
        Map<Id,Course__c> coursesMap = new Map<Id, Course__c>((List<Course__c>)records);
       
        // Looks up for courses IDs contained in modules
        List<Module__c> modulesToDelete = new ModulesSelector(new Set<String>{'Id'}).selectByIdHavingCourses(coursesMap.KeySet());  
  
        // Delete related modules
        SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{Module__c.SObjectType});
        uow.registerDeleted(modulesToDelete);      
        uow.commitWork();
    }
    
    private void deleteCourseDependencies(){        
        // Map with NEW records       
        Map<Id,Course__c> coursesMap = new Map<Id, Course__c>((List<Course__c>)records);
       
        // Looks up for courses IDs contained in course dependencies and predecessors
        List<CourseDependency__c> dependenciesToDelete = new CourseDependenciesSelector(new Set<String>{'Course__c,Predecessor__c'}).selectDependenciesAndPredecessors(coursesMap.KeySet());
  
        // Delete related dependencies
        SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{CourseDependency__c.SObjectType});
        uow.registerDeleted(dependenciesToDelete);      
        uow.commitWork();
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
                    if (event == 'update'){                        
                         // Check OLD records (existingRecords) to see if any of these fields were modified       
                        if( (((Course__c)(existingRecords.get(course.Id))).SubscriptionMode__c) != coursesMap.get(course.Id).SubscriptionMode__c ){
                            coursesMap.get(course.Id).addError(Label.ValidateCourseErrorSubscriptionMode);
                        }              
                        if( (((Course__c)(existingRecords.get(course.Id))).Segment__c) != coursesMap.get(course.Id).Segment__c ) {
                            coursesMap.get(course.Id).addError(Label.ValidateCourseErrorSegment);
                        }                  
                        if( (((Course__c)(existingRecords.get(course.Id))).StartDate__c) != coursesMap.get(course.Id).StartDate__c ) {
                            coursesMap.get(course.Id).addError(Label.ValidateCourseStartDate);
                        }                       
                        if( (((Course__c)(existingRecords.get(course.Id))).EndDate__c) != coursesMap.get(course.Id).EndDate__c ) {
                            coursesMap.get(course.Id).addError(Label.ValidateCourseEndDate);
                        }          
                    }else if (event == 'delete'){
                        coursesMap.get(course.Id).addError(Label.ValidateCourseErrorDelete);
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