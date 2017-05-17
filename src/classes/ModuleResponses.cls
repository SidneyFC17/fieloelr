public class ModuleResponses extends SObjectDomain {
    public static Set<Id> processedIds = new Set<Id>();
    public static Boolean validateAdminFields = true;

    public ModuleResponses(List<ModuleResponse__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<ModuleResponse__c> sObjectList) {
            //If has Admin Permission allow "validateAdminFields"
            if(FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()) != null && FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()).FieloPLT__To__c >= system.now()){
                validateAdminFields = false;
            }

            return new ModuleResponses(sObjectList);
        }
    }

    public override void onApplyDefaults() {
        for(ModuleResponse__c moduleResponse : (List<ModuleResponse__c>)records){
            moduleResponse.IsSubmitted__c = false;
            moduleResponse.IsApproved__c = false;
        }
    }

    public override void onValidate(){
        //store module Ids
        Set<Id> moduleIds = new Set<Id>();
        for(ModuleResponse__c moduleResponse : (List<ModuleResponse__c>)records){
            moduleIds.add(moduleResponse.Module__c);                
        }

        //Creates a set to know wich are the required modules to be approved for each of the related members
        Map<Id,Module__c> modulesMap = new Map<Id,Module__c>(new ModulesSelector(new Set<String>{'Id,Course__c,Course__r.SubscriptionMode__c'}).selectByIdHavingDependencies(moduleIds));
        Set<String> mrKeysRequired = new Set<String>();
        Set<String> csKeysRequired = new Set<String>();
        Set<Id> modulesProcessedIds = new Set<Id>();
        for(ModuleResponse__c moduleResponse : (List<ModuleResponse__c>)records){
            if(!modulesProcessedIds.contains(moduleResponse.Module__c)){
                for(ModuleDependency__c md : modulesMap.get(moduleResponse.Module__c).PredecessorModules__r){
                    mrKeysRequired.add(String.valueOf(md.Predecessor__c).subString(0,15) + String.valueOf(moduleResponse.Member__c).subString(0,15));
                }
                modulesProcessedIds.add(moduleResponse.Module__c);
            }

            //checks manual courses to verify if the status was already created
            if(modulesMap.get(moduleResponse.Module__c).Course__r.SubscriptionMode__c == 'Manual'){
                csKeysRequired.add(String.valueOf(modulesMap.get(moduleResponse.Module__c).Course__c).subString(0,15) + String.valueOf(moduleResponse.Member__c).subString(0,15));
            }
        }

        //query in the database only the moduleResponses that were approved for the related members
        List<ModuleResponse__c> predecessorModuleResponses = new ModuleResponsesSelector(new Set<String>{'Key__c'}).selectByKeyAndApproved(mrKeysRequired);
        Set<String> approvedMRKeys = new Set<String>();
        for(ModuleResponse__c mr : predecessorModuleResponses){
            approvedMRKeys.add(mr.Key__c);
        }

        //query in the database only the courseStatus that exist for the related members
        List<CourseStatus__c> manualCourseStatus = new CourseStatusSelector(new Set<String>{'Key__c'}).selectByKey(csKeysRequired);
        Set<String> existingCSKeys = new Set<String>();
        for(CourseStatus__c cs : manualCourseStatus){
            existingCSKeys.add(cs.Key__c);
        }

        //verifies for each module response if the related modules where approved for the member
        Set<String> mrKeysWithError = new Set<String>();
        for(ModuleResponse__c moduleResponse : (List<ModuleResponse__c>)records){
            String cskey = String.valueOf(modulesMap.get(moduleResponse.Module__c).Course__c).subString(0,15) + String.valueOf(moduleResponse.Member__c).subString(0,15);
            if(!existingCSKeys.contains(cskey)){
                moduleResponse.addError('The member is not registered in the related course.');
            }

            String mrkey = String.valueOf(moduleResponse.Module__c).subString(0,15) + String.valueOf(moduleResponse.Member__c).subString(0,15);
            if(mrKeysWithError.contains(mrkey)){
                moduleResponse.addError('The member didn\'t approve the dependent Modules');
                continue;
            }
            
            for(ModuleDependency__c md : modulesMap.get(moduleResponse.Module__c).PredecessorModules__r){
                String dependentKey = String.valueOf(md.Predecessor__c).subString(0,15) + String.valueOf(moduleResponse.Member__c).subString(0,15);
                if(!approvedMRKeys.contains(dependentKey)){
                    moduleResponse.addError('The member didn\'t approve the dependent Modules');
                    mrKeysWithError.add(mrkey);
                    break;
                }
            }            
        }
    }

    public override void onValidate(Map<Id,SObject> existingRecords){
        if(validateAdminFields){
            for(ModuleResponse__c moduleResponse : (List<ModuleResponse__c>)records){
                if(((ModuleResponse__c)existingRecords.get(moduleResponse.Id)).IsSubmitted__c){
                    moduleResponse.addError('Cannot modify a moduleResponse that was already submitted.');
                }
                if(moduleResponse.IsApproved__c && !((ModuleResponse__c)existingRecords.get(moduleResponse.Id)).IsSubmitted__c){
                    moduleResponse.IsApproved__c = false;
                }
            }
        }
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
        List<ModuleResponse__c> submittedRecords = new List<ModuleResponse__c>();

        for(ModuleResponse__c moduleResp: (List<ModuleResponse__c>)records){
            //Add only submitted records.
            if( moduleResp.IsSubmitted__c ){
                if( !((ModuleResponse__c)existingRecords.get(moduleResp.Id)).IsSubmitted__c){
                    submittedRecords.add(moduleResp);
                }
            }
        }

        if(!submittedRecords.isEmpty()){
            setGradeAndApprovalFlag(submittedRecords);
        }
    }

    public override void onAfterUpdate(Map<Id,SObject> existingRecords) {
        List<ModuleResponse__c> recordsToProcess = new List<ModuleResponse__c>();
        Map<Id,ModuleResponse__c> mapExistingRecordsToProcess = new Map<Id,ModuleResponse__c>();

        for(ModuleResponse__c record : (List<ModuleResponse__c>)records){
            if(!processedIds.contains(record.Id)){
                recordsToProcess.add(record);
                mapExistingRecordsToProcess.put(record.Id,(ModuleResponse__c)existingRecords.get(record.Id));
                processedIds.add(record.Id);
            }
        }
        if(!recordsToProcess.isEmpty()){
            FieloPLT.SObjectService.processRecords(recordsToProcess, mapExistingRecordsToProcess);
        }
    }

    public override void onBeforeDelete(){
        if(validateAdminFields){
            for(ModuleResponse__c moduleResponse : (List<ModuleResponse__c>)records){
                if(moduleResponse.IsSubmitted__c){
                    moduleResponse.addError('Cannot modify a moduleResponse that was already submitted.');
                }
            }
        }
    }

    public static void setGradeAndApprovalFlag(List<ModuleResponse__c> records) {
        Set<Id> moduleResponseIds = new Map<Id,ModuleResponse__c>(records).keySet();
        Set<Id> moduleIds = new Set<Id>();
        for(ModuleResponse__c moduleResponse: records) {
            moduleIds.add(moduleResponse.Module__c);
        }
        Map<Id,ModuleResponse__c> existingModuleResponseMap = new Map<Id,ModuleResponse__c>(new ModuleResponsesSelector().selectByIdWithQuestionResponses(moduleResponseIds));
        Map<Id,Module__c> modulesMap = new Map<Id,Module__c>(new ModulesSelector().selectByIdWithQuestions(moduleIds));
        Map<Id,Question__c> questionMap;

        List<QuestionResponse__c> unsubmitedQuestionResponses = new List<QuestionResponse__c>();
        // Checking for unsubmitted questions
        for (ModuleResponse__c moduleResponse: existingModuleResponseMap.values()) {
            for (QuestionResponse__c questionResponse: moduleResponse.QuestionResponses__r) {
                if ( !questionResponse.IsSubmitted__c ) {
                    unsubmitedQuestionResponses.add(questionResponse);
                }
            }
        }

        if (!unsubmitedQuestionResponses.isEmpty()) {
            QuestionResponses.disableSubmit = true;
            QuestionResponses.setIsCorrect(unsubmitedQuestionResponses);

            SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{QuestionResponse__c.SObjectType});
            for(QuestionResponse__c questionResponse : unsubmitedQuestionResponses){
                questionResponse.IsSubmitted__c = true;
                uow.registerDirty(questionResponse);
            }
            uow.commitWork();
            QuestionResponses.disableSubmit = false;
        }

        for (ModuleResponse__c moduleResponse: (List<ModuleResponse__c>)records) {
            moduleResponse.GradeValue__c = 0.0;
            questionMap = new Map<Id,Question__c>(modulesMap.get(moduleResponse.Module__c).Questions__r);

            for (QuestionResponse__c questionResponse: existingModuleResponseMap.get(moduleResponse.Id).QuestionResponses__r) {
                moduleResponse.GradeValue__c += questionResponse.PartialGradevalue__c;
            }
            moduleResponse.GradePercent__c = (moduleResponse.GradeValue__c / modulesMap.get(moduleResponse.Module__c).TotalValue__c) * 100;
            moduleResponse.IsApproved__c = moduleResponse.GradePercent__c >= modulesMap.get(moduleResponse.Module__c).ApprovalGrade__c;
        }
    }
}