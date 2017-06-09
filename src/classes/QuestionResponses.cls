public class QuestionResponses extends SObjectDomain {
    public static Set<Id> processedIds = new Set<Id>();
    public static Boolean disableSubmit = false;
    public static Boolean validateAdminFields = true;

    public QuestionResponses(List<QuestionResponse__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<QuestionResponse__c> sObjectList) {
            //If has Admin Permission allow "validateAdminFields"
            if(FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()) != null && FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()).FieloPLT__To__c >= system.now()){
                validateAdminFields = false;
            }

            return new QuestionResponses(sObjectList);
        }
    }

    public override void onApplyDefaults(){
        Set<String> qrKeys = new Set<String>();
        for(QuestionResponse__c questionResp : (List<QuestionResponse__c>)records){
            questionResp.IsSubmitted__c = false;
            questionResp.IsCorrect__c = false;
            questionResp.Key__c = String.valueOf(questionResp.Question__c).subString(0,15) + String.valueOf(questionResp.ModuleResponse__c).subString(0,15);
            qrKeys.add(questionResp.Key__c);
        }

        List<AggregateResult> aggResult = [SELECT MAX(NumberOfAttempt__c) attemptNumber, Key__c FROM QuestionResponse__c WHERE Key__c in : qrKeys GROUP BY Key__c];
        Map<String,Decimal> maxNumbByKey = new Map<String,Decimal>();
        for(AggregateResult qr : aggResult){
            maxNumbByKey.put((String)qr.get('FieloELR__Key__c'), (Decimal)qr.get('attemptNumber'));
        }
        
        for(QuestionResponse__c questionResp : (List<QuestionResponse__c>)records){
            if(maxNumbByKey.containsKey(questionResp.Key__c)){
                Decimal maxAttempt = maxNumbByKey.get(questionResp.Key__c);
                questionResp.NumberOfAttempt__c = ++maxAttempt;
                maxNumbByKey.put(questionResp.Key__c, maxAttempt);
            }else{
                questionResp.NumberOfAttempt__c = 1;
                maxNumbByKey.put(questionResp.Key__c, 1);
            }
        }
    }

    public override void onValidate(){
        if(validateAdminFields){
            validateModuleSubmitted(records);
        }
    }

    public override void onValidate(Map<Id,SObject> existingRecords){
        if(validateAdminFields){
            for(QuestionResponse__c questionResp : (List<QuestionResponse__c>)records){
                if(((QuestionResponse__c)existingRecords.get(questionResp.Id)).IsSubmitted__c){
                    questionResp.addError(Label.ValidateQuestionResponse);
                }

                if(questionResp.IsCorrect__c != ((QuestionResponse__c)existingRecords.get(questionResp.Id)).IsCorrect__c){
                    questionResp.IsCorrect__c = ((QuestionResponse__c)existingRecords.get(questionResp.Id)).IsCorrect__c;
                }
                if(questionResp.NumberOfAttempt__c != ((QuestionResponse__c)existingRecords.get(questionResp.Id)).NumberOfAttempt__c){
                    questionResp.NumberOfAttempt__c = ((QuestionResponse__c)existingRecords.get(questionResp.Id)).NumberOfAttempt__c;
                }
                if(questionResp.PartialGradeValue__c != ((QuestionResponse__c)existingRecords.get(questionResp.Id)).PartialGradeValue__c){
                    questionResp.PartialGradeValue__c = ((QuestionResponse__c)existingRecords.get(questionResp.Id)).PartialGradeValue__c;
                }
                if(questionResp.Key__c != ((QuestionResponse__c)existingRecords.get(questionResp.Id)).Key__c){
                    questionResp.Key__c = ((QuestionResponse__c)existingRecords.get(questionResp.Id)).Key__c;
                }
            }
        }

        List<QuestionResponse__c> submittedRecords = new List<QuestionResponse__c>();
        Set<String> submittedKeys = new Set<String>();
        for(QuestionResponse__c questionResp : (List<QuestionResponse__c>)records){
            //Add only submitted records.
            if( questionResp.IsSubmitted__c && !((QuestionResponse__c)existingRecords.get(questionResp.Id)).IsSubmitted__c){
                submittedRecords.add(questionResp);
                submittedKeys.add(questionResp.Key__c);
            }
        }

        List<QuestionResponse__c> correctedQuestionResponses = new QuestionResponsesSelector().selectByKeyAndCorrect(submittedKeys);
        Set<String> existingSubmittedResponses = new Set<String>();
        for(QuestionResponse__c qr : correctedQuestionResponses){
            existingSubmittedResponses.add(qr.Key__c);
        }

        for(QuestionResponse__c questionResp : submittedRecords){
            if(existingSubmittedResponses.contains(questionResp.Key__c)){
                questionResp.addError(Label.ValidateQuestionResponseSubmit);
            }
        }
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
        Map<Id,QuestionResponse__c> submittedRecords = new Map<Id,QuestionResponse__c>();

        for(QuestionResponse__c questionResp: (List<QuestionResponse__c>)records){
            //Add only submitted records.
            if( questionResp.IsSubmitted__c ){
                if( !((QuestionResponse__c)existingRecords.get(questionResp.Id)).IsSubmitted__c ||
                    ((QuestionResponse__c)existingRecords.get(questionResp.Id)).IsSubmitted__c == null){
                    submittedRecords.put(questionResp.Id, questionResp);
                }
            }
        }

        if(!submittedRecords.isEmpty() && !disableSubmit){
            Map<Id,String> mapErrors = setIsCorrect(submittedRecords.values());
            if(!mapErrors.isEmpty()){
                for(Id qrId : mapErrors.keySet()){
                    submittedRecords.get(qrId).addError(mapErrors.get(qrId));
                }
            }
        }
    }

    public override void onBeforeDelete(){
        if(validateAdminFields){
            validateModuleSubmitted(records);
        }
    }

    private static void validateModuleSubmitted(List<QuestionResponse__c> questionResponses){
        Set<Id> moduleResponseIds = new Set<Id>();
        for(QuestionResponse__c questionResp : questionResponses){
            if(questionResp.IsSubmitted__c){
                questionResp.addError(Label.ValidateQuestionResponseDelete);
            }
        }
    }

    public static Map<Id,String> setIsCorrect(List<QuestionResponse__c> records) {
        Map<Id,String> mapErrors = new Map<Id,String>();
        Set<Id> questionResponseIds = new Map<Id,QuestionResponse__c>(records).keySet();
        Set<Id> questionIds = new Set<Id>();
        for (QuestionResponse__c questionResponse:records) {
            questionIds.add(questionResponse.Question__c);
        }
        Map<Id,QuestionResponse__c> existingQuestionResponses = new Map<Id,QuestionResponse__c>(new QuestionResponsesSelector().selectByIdWithAnswers(questionResponseIds));
        Map<Id,Question__c> questionsMap = new Map<Id,Question__c>(new QuestionsSelector(new Set<String>{'PenaltyPerAttempt__c','CorrectWeight__c','IncorrectWeight__c','Type__c','Module__r.PenaltyMode__c'}).selectByIdWithCorrectAnswers(questionIds));

        Double incorrectWeight;
        Double questionWeight;
        Double penaltyPerQuestion;
        Integer isCorrectInt;
        Integer questionRespAttempts;
        String penaltyMode;

        Set<String> correctKeys = new Set<String>();
        for (QuestionResponse__c questionResponse: records) {
            if (questionsMap.containsKey(questionResponse.Question__c)) {
                Question__c question = questionsMap.get(questionResponse.Question__c);
                if(question.Type__c == 'Multiple Choice' || question.Type__c == 'Single Choice' || question.Type__c == 'Statement'){
                    questionResponse.IsCorrect__c = true;
                    //verifies if the number of answers are the same as the correct ones
                    List<Answer__c> answers = existingQuestionResponses.get(questionResponse.Id).answers__r;
                    if (answers.size() == questionsMap.get(questionResponse.Question__c).AnswerOptions__r.size()) {
                        Set<Id> correctAnswerIds = new Map<Id,AnswerOption__c>(question.AnswerOptions__r).keySet();
                        
                        //loop the answers and verify that all of them are related to correct answer options
                        for(Answer__c answer : existingQuestionResponses.get(questionResponse.Id).answers__r) {
                            if (!correctAnswerIds.contains(answer.AnswerOption__c)) {
                                questionResponse.IsCorrect__c = false;
                                break;
                            }
                        }
                    } else {
                        questionResponse.IsCorrect__c = false;
                    }
                }else if (question.Type__c == 'Short Answer') {
                    questionResponse.IsCorrect__c = false;
                    for (AnswerOption__c answerOption: questionsMap.get(questionResponse.Question__c).AnswerOptions__r) {
                        if (answerOption.AnswerOptionText__c == questionResponse.TextValue__c) {
                            questionResponse.IsCorrect__c = true;
                            break;
                        }
                    }
                }/*else if (question.Type__c == 'Fill in the Blanks') {
                    questionResponse.IsCorrect__c = question.AnswerText__c == questionResponse.TextValue__c;
                }*/else if (question.Type__c == 'Matching Options') {

                    questionResponse.IsCorrect__c = true;
                    List<Answer__c> answers = existingQuestionResponses.get(questionResponse.Id).answers__r;
                    Map<Id,AnswerOption__c> correctAnswerIds = new Map<Id,AnswerOption__c>();
                    //verifies if the number of answers are the same as the correct answer options
                    if (answers.size() == questionsMap.get(questionResponse.Question__c).AnswerOptions__r.size()) {
                        correctAnswerIds = new Map<Id,AnswerOption__c>(questionsMap.get(questionResponse.Question__c).AnswerOptions__r);

                        //loop the answers and verify that all of them are related to correct answer options
                        for(Answer__c answer : existingQuestionResponses.get(questionResponse.Id).answers__r) {
                            if (!correctAnswerIds.containsKey(answer.AnswerOption__c)) {
                                questionResponse.IsCorrect__c = false;
                                break;
                            //If answer corresponds to a correct answer option, verifies if the match is correct
                            } else if(answer.TextValue__c != correctAnswerIds.get(answer.AnswerOption__c).MatchingText__c) {
                                questionResponse.IsCorrect__c = false;
                                break;
                            }
                        }                      
                    } else {
                        questionResponse.IsCorrect__c = false;
                    }
                }

                if(questionResponse.IsCorrect__c && correctKeys.contains(questionResponse.Key__c)){
                    mapErrors.put(questionResponse.Id, 'This question was already answered correctly.');
                    //questionResponse.addError('This question was already answered correct.');
                }else{
                    if(questionResponse.IsCorrect__c){
                        correctKeys.add(questionResponse.Key__c);                        
                    }
                
                    incorrectWeight = question.IncorrectWeight__c;
                    questionWeight = question.CorrectWeight__c;
                    penaltyPerQuestion = question.PenaltyPerAttempt__c;
                    isCorrectInt = questionResponse.IsCorrect__c ? 1 : 0;
                    questionRespAttempts = Integer.valueOf(questionResponse.NumberOfAttempt__c);
                    penaltyMode = question.Module__r.PenaltyMode__c;

                    questionResponse.PartialGradeValue__c =
                        penaltyMode == 'Percent Decrease' ?
                                isCorrectInt * (questionWeight * Math.pow((1 - penaltyPerQuestion / 100),questionRespAttempts-1)) :
                                penaltyMode == 'Negative Weight' ?
                                    (isCorrectInt * questionWeight + (1 - isCorrectInt) * incorrectWeight) :
                                    isCorrectInt * questionWeight;
                }
            }
        }
        return mapErrors;
    }
}