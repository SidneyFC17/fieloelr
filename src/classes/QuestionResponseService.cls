public with sharing class QuestionResponseService {
	
	public static void setIsCorrect(List<QuestionResponse__c> records) {
		Set<Id> questionResponseIds =
			new Map<Id,QuestionResponse__c>(records).keySet();
		List<QuestionResponse__c> questionResponses =
			new QuestionsResponsesSelector().selectByIdWithAnswersResponses(questionResponseIds);
		Map<Id,Question__c> questionsMap = new Map<Id,Question__c>(
			new QuestionsSelector().selectByQuestionResponseIdWithCorrectAnswers(questionResponseIds));

		for (QuestionResponse__c questionResponse: questionResponses) {
			questionResponse.IsCorrect__c = true;
			if (questionsMap.containsKey(questionResponse.Question__c)) {
				if( questionsMap.get(questionResponse.Question__c).Type__c == 'Checkbox' ||
				questionsMap.get(questionResponse.Question__c).Type__c == 'Radio'){
					if (questionResponse.AnswersResponses__r.size() ==
						questionsMap.get(questionResponse.Question__c).Answers__r.size()) {
						for(AnswerResponse__c answerResponse: questionResponse.AnswersResponses__r) {
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
				if (questionsMap.get(questionResponse.Question__c).Type__c == 'Text') {
					if (questionsMap.get(questionResponse.Question__c).TextValue__c !=
						questionResponse.TextValue__c) {
						questionResponse.IsCorrect__c = false;
					}
				}
			} else {
				questionResponse.IsCorrect__c = false;
			}
			new Map<Id,QuestionResponse__c>(records).get(questionResponse.Id).IsCorrect__c =
				questionResponse.IsCorrect__c;
		}
	}
}