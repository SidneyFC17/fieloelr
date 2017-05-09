public class QuestionResponses extends SObjectDomain {
	public static Set<Id> processedIds = new Set<Id>();
    public static Boolean validateAdminFields = true;

	public QuestionResponses(List<QuestionResponse__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<QuestionResponse__c> sObjectList) {
            return new QuestionResponses(sObjectList);
        }
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
        List<QuestionResponse__c> submittedRecords = new List<QuestionResponse__c>();

        for(QuestionResponse__c questionResp: (List<QuestionResponse__c>)records){
            //Add only submitted records.
            if( questionResp.IsSubmitted__c ){
            	if( !((QuestionResponse__c)existingRecords.get(questionResp.Id)).IsSubmitted__c ||
                    ((QuestionResponse__c)existingRecords.get(questionResp.Id)).IsSubmitted__c == null){
	                submittedRecords.add(questionResp);
            	}
            }
        }

        if(!submittedRecords.isEmpty()){
            setIsCorrect(submittedRecords);
        }
    }

    public static void setIsCorrect(List<QuestionResponse__c> records) {
        Set<Id> questionResponseIds = new Map<Id,QuestionResponse__c>(records).keySet();
        Set<Id> questionIds = new Set<Id>();
        for (QuestionResponse__c questionResponse:records) {
            questionIds.add(questionResponse.Question__c);
        }
        Map<Id,QuestionResponse__c> existingQuestionResponses = new Map<Id,QuestionResponse__c>(new QuestionResponsesSelector().selectByIdWithAnswersResponses(questionResponseIds));
        Map<Id,Question__c> questionsMap = new Map<Id,Question__c>(new QuestionsSelector().selectByIdWithCorrectAnswers(questionIds));

        Double incorrectWeight;
        Double questionWeight;
        Double penaltyPerQuestion;
        Integer isCorrectInt;
        Integer questionRespAttempts;

        for (QuestionResponse__c questionResponse: records) {
            questionResponse.IsCorrect__c = true;
            if (questionsMap.containsKey(questionResponse.Question__c)) {
                if( questionsMap.get(questionResponse.Question__c).Type__c == 'Multiple Choice' ||
                questionsMap.get(questionResponse.Question__c).Type__c == 'Single Choice'){
                    if (existingQuestionResponses.get(questionResponse.Id).AnswerResponses__r.size() ==
                        questionsMap.get(questionResponse.Question__c).Answers__r.size()) {
                        for(AnswerResponse__c answerResponse: existingQuestionResponses.get(questionResponse.Id).AnswerResponses__r) {
                            if (!(new Map<Id,Answer__c>(
                                questionsMap.get(questionResponse.Question__c).Answers__r)
                                    .containsKey(answerResponse.Answer__c))) {
                                questionResponse.IsCorrect__c = false;
                            }
                        }
                    } else {
                        questionResponse.IsCorrect__c = false;
                    }
                }
                if (questionsMap.get(questionResponse.Question__c).Type__c == 'Short Answer') {
                    questionResponse.IsCorrect__c = false;
                    for (Answer__c answer: questionsMap.get(questionResponse.Question__c).Answers__r) {
                        if (answer.AnswerText__c == questionResponse.TextValue__c) {
                            questionResponse.IsCorrect__c = true;
                            break;
                        }
                    }
                }
            } else {
                questionResponse.IsCorrect__c = false;
            }

            incorrectWeight = questionsMap.get(questionResponse.Question__c).IncorrectWeight__c;
            questionWeight = questionsMap.get(questionResponse.Question__c).CorrectWeight__c;
            penaltyPerQuestion = questionsMap.get(questionResponse.Question__c).PenaltyPerAttempt__c;
            isCorrectInt = questionResponse.IsCorrect__c ? 1 : 0;
            questionRespAttempts = Integer.valueOf(questionResponse.NumberOfAttempts__c);

            questionResponse.PartialGradeValue__c =
                penaltyPerQuestion != null ?
                    isCorrectInt * (questionWeight * Math.pow((1 - penaltyPerQuestion / 100),questionRespAttempts-1)) :
                    (isCorrectInt * questionWeight + (isCorrectInt - 1) * incorrectWeight);
        }
    }
}