public class QuestionsResponses extends SObjectDomain {
	public static Set<Id> processedIds = new Set<Id>();
    public static Boolean validateAdminFields = true;

	public QuestionsResponses(List<QuestionResponse__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<QuestionResponse__c> sObjectList) {
            return new QuestionsResponses(sObjectList);
        }
    }

    public override void onAfterUpdate(Map<Id,SObject> existingRecords) {
    	List<QuestionResponse__c> recordsToProcess = new List<QuestionResponse__c>();
        Map<Id,QuestionResponse__c> mapExistingRecordsToProcess = new Map<Id,QuestionResponse__c>();

        for(QuestionResponse__c record : (List<QuestionResponse__c>)records){
            if(!processedIds.contains(record.Id)){
                recordsToProcess.add(record);
                mapExistingRecordsToProcess.put(record.Id,(QuestionResponse__c)existingRecords.get(record.Id));
                processedIds.add(record.Id);
            }
        }
        if(!recordsToProcess.isEmpty()){
            FieloPLT.SObjectService.processRecords(recordsToProcess, mapExistingRecordsToProcess);
        }
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
        List<QuestionResponse__c> submittedRecords = new List<QuestionResponse__c>();

        //Check for updates that may affect TotalPrice
        for(QuestionResponse__c questionResp: (List<QuestionResponse__c>)records){
            //Add only submitted records.
            if( questionResp.IsSubmitted__c ){
            	if( !((QuestionResponse__c)existingRecords.get(questionResp.Id)).IsSubmitted__c ){
	                submittedRecords.add(questionResp);
            	}
            }
        }

        if(!submittedRecords.isEmpty()){
            QuestionResponseService.setIsCorrect(submittedRecords);
        }
    }
}