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

        // Validate that course predecessor has a course status progress at 100%
        validateCourseStatusPredesessorCompleted(records);    
    }

    public static void validateCourseStatusPredesessorCompleted(List<CourseStatus__c> records){
        // Courses to validate
        Set<Id> courseIds = new Set<Id>();
        for (CourseStatus__c courseStatus : records){
            courseIds.add(courseStatus.Course__c);
        }

        // Receive courses with predecessor
        Map<Id,Course__c> coursesMap = new Map<Id,Course__c>(new CoursesSelector(new Set<String>{'Id'}).selectByIdHavingPredecessor(courseIds));
        Set<Id> coursesProcessedIds = new Set<Id>();
        Set<String> mrKeysRequired = new Set<String>();
        Map<String,CourseStatus__c> newCourseStatusMap = new Map<String,CourseStatus__c>();

        Set<Id> courseStatusIds = new Set<Id>();
        Set<String> coursesNotCompletedKeys = new Set<String>();
        Set<Id> coursesWithoutPredecessors = new Set<Id>();
        // For new Course Status
        for (CourseStatus__c courseStatus : records){ 
            // Check if course Id has been processed before       
            if(!coursesProcessedIds.contains(courseStatus.Course__c)){
                for(CourseDependency__c cd : coursesMap.get(courseStatus.Course__c).PredecessorCourses__r){
                   // Course ID of Predecessor +  Member ID of New Course Status                
                   mrKeysRequired.add(String.valueOf(cd.Predecessor__c).subString(0,15) + String.valueOf(courseStatus.Member__c).subString(0,15));                
                   System.debug('Entro MR KEYS');
                   System.debug('Entro course key: ' + String.valueOf(cd.Predecessor__c).subString(0,15) + String.valueOf(courseStatus.Member__c).subString(0,15));
                   System.debug('Entro course id predecessor: ' + cd.Predecessor__c);
                   
                   newCourseStatusMap.put(String.valueOf(cd.Predecessor__c).subString(0,15) + String.valueOf(courseStatus.Member__c).subString(0,15), courseStatus);
                }
                // Check if the Course doesn not have a predecessor at all
                if (coursesMap.get(courseStatus.Course__c).PredecessorCourses__r.isEmpty()) coursesWithoutPredecessors.add(courseStatus.Course__c);
                coursesProcessedIds.add(courseStatus.Course__c);
            }
        }
        
        System.debug('Entro MR KEYS esta vacio?: ' + mrKeysRequired.isEmpty());
        if (coursesWithoutPredecessors.isEmpty()){
            // Check if Course Status containing keys (CourseID+MemberID) have Progress__c != 100
            List<CourseStatus__c> predecessorCoursesCompleted = new CourseStatusSelector(new Set<String>{'Id,Progress__c,Key__c,Course__c'}).selectByKey(mrKeysRequired);
            System.debug('Entro predecessorCoursesCompleted esta vacio?: ' + predecessorCoursesCompleted.isEmpty());
            
            if (!predecessorCoursesCompleted.isEmpty()){
               for(CourseStatus__c courseStatus : predecessorCoursesCompleted){
                    if (courseStatus.Progress__c < 100 || courseStatus.Progress__c == null){
                     courseStatusIds.add(courseStatus.Id);
                     coursesNotCompletedKeys.add(courseStatus.Key__c);
                     System.debug('Entro courseStatusIds+= ' + courseStatus.Id);
                     System.debug('Entro != 100% ' + courseStatus.Key__c);                     
                    }
                    else newCourseStatusMap.remove(courseStatus.Key__c);
                }   
            }
             

            for (CourseStatus__c cs : records){
                if (predecessorCoursesCompleted.isEmpty()){
                    cs.addError('Predecessor Course must be completed before this one.');
                }
                else{
                    for (String key : newCourseStatusMap.keySet()){
                        if (cs.Id == newCourseStatusMap.get(key).Id){
                         cs.addError('Course was not completed at 100 per cent.');
                            }
                    } 
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
        /////
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