public class ModuleResponses extends SObjectDomain {
	public static Set<Id> processedIds = new Set<Id>();
    public static Boolean validateAdminFields = true;

	public ModuleResponses(List<ModuleResponse__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<ModuleResponse__c> sObjectList) {
            return new ModuleResponses(sObjectList);
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

    public static void setGradeAndApprovalFlag(List<ModuleResponse__c> records) {
        Set<Id> moduleResponseIds = new Map<Id,ModuleResponse__c>(records).keySet();
        Set<Id> moduleIds = new Set<Id>();
        for(ModuleResponse__c moduleResponse: records) {
            moduleIds.add(moduleResponse.Module__c);
        }
        Map<Id,ModuleResponse__c> existingModuleResponseMap = new Map<Id,ModuleResponse__c>(new ModuleResponsesSelector().selectByIdWithQuestionResponses(moduleResponseIds));
        Map<Id,Module__c> modulesMap = new Map<Id,Module__c>(new ModulesSelector().selectByIdWithQuestions(moduleIds));
        Map<Id,Question__c> questionMap;

        Double incorrectWeight;
        Double questionWeight;
        Double penaltyPerQuestion;
        Integer isCorrectInt;
        Integer questionRespAttempts;
        String penaltyMode;

        List<QuestionResponse__c> unsubmitedQuestionResponses = new List<QuestionResponse__c>();
        // Checking for unsubmitted questions
        for (ModuleResponse__c moduleResponse: existingModuleResponseMap.values()) {
            // if (moduleResponse.UnsubmittedQuestions__c > 0) {
                for (QuestionResponse__c questionResponse: moduleResponse.QuestionResponses__r) {
                    if ( !questionResponse.IsSubmitted__c ) {
                        unsubmitedQuestionResponses.add(questionResponse);
                    }
                }
            // }
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
            moduleResponse.GradePercent__c =
                (moduleResponse.GradeValue__c / modulesMap.get(moduleResponse.Module__c).TotalValue__c) * 100;
            moduleResponse.IsApproved__c =
                moduleResponse.GradePercent__c >= modulesMap.get(moduleResponse.Module__c).ApprovalGrade__c;

        }
    }
}