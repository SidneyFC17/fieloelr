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

    public override void onValidate() {
        if(validateAdminFields){
            for(Course__c course : (List<Course__c>)records){
                if (course.StartDate__c != null) {
                    if (course.StartDate__c < System.today()) {
                        course.addError(Label.CourseFutureDatesNotAllowed);
                    }
                }
                if (course.EndDate__c != null) {
                    if (course.EndDate__c < System.today()) {
                        course.addError(Label.CourseFutureDatesNotAllowed);
                    }
                }
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

                if(course.Status__c != oldCourse.Status__c) {
                    course.Status__c = oldCourse.Status__c;
                }

               //get PublicSettings field that check if Edit Courses is authorized
               FieloPLT__PublicSettings__c courseSettings = FieloPLT__PublicSettings__c.getInstance();
               Boolean editCourseSettings = courseSettings.EnableEditingWhileActive__c;
               //If the field is true, there is no check 
               if(editCourseSettings == false  ){
                    if((oldCourse.Status__c == 'Active' && course.Status__c == 'Active') ||
                        (oldCourse.Status__c == 'Scheduled' && course.Status__c == 'Scheduled') ||
                        (oldCourse.Status__c == 'Completed' && course.Status__c == 'Completed')) {
                        addError(course, Label.ActiveCourseCannotBeEdited);
                    }
                }else if((course.FieloELR__ActiveModules__c != oldCourse.FieloELR__ActiveModules__c) ||
                    (course.FieloELR__HasDependencies__c != oldCourse.FieloELR__HasDependencies__c) ||
                    (course.FieloELR__KeyDependencies__c != oldCourse.FieloELR__KeyDependencies__c)){
                    addError(course,'This field can\'t be edited');
                }

                // Date validation
                if (course.StartDate__c != null) {
                    if (course.StartDate__c < System.today()) {
                        addError(course, Label.CourseFutureDatesNotAllowed);
                    }
                }
                if (course.EndDate__c != null) {
                    if (course.EndDate__c < System.today()) {
                        addError(course, Label.CourseFutureDatesNotAllowed);
                    }
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

        if(Schema.sObjectType.Course__c.isDeletable()){
           uow.commitWork();
          }else{
            throw new FieloException(Label.CannotInsertUpdateRecords);
          }
        

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

    public override void onAfterUpdate(Map<Id,SObject> existingRecords){
        List<Course__c> activatedCourses = new List<Course__c>();
        List<Course__c> inactivatedCourses = new List<Course__c>();

        Course__c oldCourse;

        for(Course__c course : (List<Course__c>)records) {
            oldCourse = (Course__c)(existingRecords.get(course.Id));

            // Select only courses that are being activated
            if(!(oldCourse.Status__c=='Active') && (course.Status__c=='Active' || course.Status__c=='Scheduled') ) {
                activatedCourses.add(course);
            }
            // Select only courses that are being inactivated
            if(oldCourse.Status__c=='Active' && !(course.Status__c=='Active')) {
                inactivatedCourses.add(course);
            }
        }

        if (!activatedCourses.isEmpty()) {
            validateAdminFields = false;
            addCourseDependency(activatedCourses);
        }

        if (!inactivatedCourses.isEmpty()) {
            validateAdminFields = false;
            removeCourseDependency(inactivatedCourses);
        }
    }

    private void removeCourseDependency(List<Course__c> inactivatedCourses) {
        Set<Id> inactiveCoursesIds = new Map<Id,Course__c>(inactivatedCourses).keySet();
        List<Course__c> courses = new CoursesSelector(new Set<String>{'Id','KeyDependencies__c'}).selectByPredecessor(inactiveCoursesIds);

        Set<String> keySetDependencies;
        List<String> keyDependencies;
        Map<Id,Course__c> coursesMap = new Map<Id,Course__c>();
        for(Course__c course: courses) {
            if (course.KeyDependencies__c != null) {
                if (!coursesMap.containsKey(course.Id)) {
                    coursesMap.put(course.Id, course);
                }
                keySetDependencies = new Set<String>(course.KeyDependencies__c.split(','));

                for (String key: keySetDependencies) {
                    if (inactiveCoursesIds.contains(key)) {
                        keySetDependencies.remove(key);
                    }
                }
                keyDependencies = new List<String>(keySetDependencies);
                keyDependencies.sort();
                coursesMap.get(course.Id).KeyDependencies__c = String.join(keyDependencies,',');
                coursesMap.get(course.Id).HasDependencies__c = coursesMap.get(course.Id).KeyDependencies__c != '' &&
                    coursesMap.get(course.Id).KeyDependencies__c != null;
            }
            
        } 
        
        if(!coursesMap.values().isEmpty()) {
            SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{Course__c.SObjectType});
            uow.registerDirty(coursesMap.values());

            if(Schema.sObjectType.Course__c.isUpdateable()){
                uow.commitWork();
          }else{
            throw new FieloException(Label.CannotInsertUpdateRecords);
          }
        }
    }

    private void addCourseDependency(List<Course__c> activatedCourses) {
        Set<Id> activatedCoursesIds = new Map<Id,Course__c>(activatedCourses).keySet();
        List<CourseDependency__c> cds = new CourseDependenciesSelector(new Set<String>{'Predecessor__c','Course__c','Course__r.KeyDependencies__c'}).selectByPredecessor(activatedCoursesIds);

        Set<String> keySetDependencies;
        List<String> keyDependencies;
        Map<Id,Course__c> coursesMap = new Map<Id,Course__c>();
        for(CourseDependency__c cd: cds) {
            if (cd.Course__r.KeyDependencies__c == null) {
                cd.Course__r.KeyDependencies__c = String.valueOf(cd.Predecessor__c);
                cd.Course__r.HasDependencies__c = true;
                coursesMap.put(cd.Course__c, cd.Course__r);
            } else {
                keySetDependencies = new Set<String>(cd.Course__r.KeyDependencies__c.split(','));

                if (!keySetDependencies.contains(String.valueOf(cd.Predecessor__c))) {
                    if (!coursesMap.containsKey(cd.Course__c)) {
                        coursesMap.put(cd.Course__c, cd.Course__r);
                    }

                    keySetDependencies.add(String.valueOf(cd.Predecessor__c));
                
                    keyDependencies = new List<String>(keySetDependencies);
                    keyDependencies.sort();
                    coursesMap.get(cd.Course__c).KeyDependencies__c = String.join(keyDependencies,',');
                    coursesMap.get(cd.Course__c).HasDependencies__c = true;
                }
            }
        }
        
        if (!coursesMap.values().isEmpty()) {
            SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{Course__c.SObjectType});
            uow.registerDirty(coursesMap.values());

             if(Schema.sObjectType.Course__c.isUpdateable()){
                uow.commitWork();
          }else{
            throw new FieloException(Label.CannotInsertUpdateRecords);
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