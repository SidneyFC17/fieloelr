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

        // Validate that course predecessor has a course status progress at 100 per cent
        validateCourseStatusPredesessorCompleted(records);    
        
        // The course status cannot be created if the subscription mode of the course is "Automatic"
        // Can be skipped if Admin       
        if(validateAdminFields) {
            validateCourseStatusSubscriptionMode(records);
        }      
    }

    public static void validateCourseStatusSubscriptionMode(List<CourseStatus__c> records){
        Set<Id> courseIds = new Set<Id>();
        Set<Id> courseAutomaticIds = new Set<Id>();
        for (CourseStatus__c courseStatus : records){
            courseIds.add(courseStatus.Course__c);
        }
        
        // List of courses with subscription field
        Map<Id,Course__c> coursesMap = new Map<Id,Course__c>(new CoursesSelector(new Set<String>{'Id, SubscriptionMode__c'}).selectByIdBeingAutomatic(courseIds));        
               
        // Adding errors if those courses are in a course status
        for (CourseStatus__c courseStatus : records){
            if (coursesMap.containsKey(courseStatus.Course__c)){
                courseStatus.addError(Label.ValidateCourseStatusErrorSubscriptionMode);
            }
        }
        
    }
    
    public static void validateCourseStatusPredesessorCompleted(List<CourseStatus__c> records){
        // Courses to validate
        Set<Id> courseIds = new Set<Id>();
        for (CourseStatus__c courseStatus : records){
            courseIds.add(courseStatus.Course__c);
        }

        // Receive courses with predecessor
        Map<Id,Course__c> coursesMap = new Map<Id,Course__c>(new CoursesSelector(new Set<String>{'Id'}).selectByIdHavingPredecessor(courseIds));
        Set<String> keysPredecessors = new Set<String>();   
        
        // Iterate over new Course Status
         for (CourseStatus__c courseStatus : records){             
            for(CourseDependency__c cd : coursesMap.get(courseStatus.Course__c).PredecessorCourses__r){
               // Course ID of Predecessor +  Member ID of New Course Status
               String cskey = String.valueOf(cd.Predecessor__c).subString(0,15) + String.valueOf(courseStatus.Member__c).subString(0,15);          
               keysPredecessors.add(cskey);
            }      
         }               
       
         // Query to get all the course status of the predecessors 100 per cent
         List<CourseStatus__c> predecessorCourses = new CourseStatusSelector(new Set<String>{'Id,Progress__c,Key__c,Course__c'}).selectByKeyCompleted(keysPredecessors);
         Set<String> keysPredecessorsCompleted = new Set<String>();

         for(CourseStatus__c cs : predecessorCourses){
            keysPredecessorsCompleted.add(cs.Key__c);
         }
            
         //Adding errors
         Set<String> keysPredecessorsError = new Set<String>();
         for (CourseStatus__c courseStatus : records){             
             for(CourseDependency__c cd : coursesMap.get(courseStatus.Course__c).PredecessorCourses__r){
                String cskey = String.valueOf(cd.Predecessor__c).subString(0,15) + String.valueOf(courseStatus.Member__c).subString(0,15);
                if(!keysPredecessorsCompleted.contains(cskey)){
                    courseStatus.addError(Label.ValidateCourseStatusErrorPredecessorIncomplete);
                    break;
                }
             }            
         }        
    }
  
    public override void onValidate(Map<Id,SObject> existingRecords) {
        //before update
    }

    public override void onApplyDefaults() {
        for(CourseStatus__c cStatus : (List<CourseStatus__c>)records){
            cStatus.ApprovedModules__c = 0;
            cStatus.Key__c = String.valueOf(cStatus.Course__c).subString(0,15) + String.valueOf(cStatus.Member__c).subString(0,15);
        }
    }
        
    public override void onBeforeDelete() {
            Set<Id> coursesIds = new Set<Id>();
            Set<Id> courseValidateIds = new Set<Id>();
            
            for(CourseStatus__c cs : (List<CourseStatus__c>)records){
                coursesIds.add(cs.Course__c);
            }

            List<ModuleResponse__c> modulesList = new List<ModuleResponse__c>(new ModuleResponsesSelector(new Set<String>{'Id','Module__r.Course__c'}).selectModuleResponseIds(coursesIds));
            
            for(ModuleResponse__c mr : modulesList){
                courseValidateIds.add(mr.Module__r.Course__c); 
            }
            
            for(CourseStatus__c cs : (List<CourseStatus__c>)records){
                if(courseValidateIds.contains(cs.Course__c)){
                    cs.addError('You cannot delete a course status if you have a related module response  for any of the related modules  to the course');
                }
            }

        }
}