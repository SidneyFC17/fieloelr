global with sharing class QuestionService {
	
	/*public static List<Question__c> getQuestions(Id moduleId,
									  Set<Id> excludedQuestionIds,
									  Set<String> fieldsQuestion,
									  Set<String> fieldsAnswerOption,
									  Integer quantity,
									  Integer offset) {
		String questionQuery = 'SELECT ' + String.join(new List<String>(fieldsQuestion), ',');
		if(fieldsAnswerOption != null){
			questionQuery += ' ,(SELECT ' + String.join(new List<String>(fieldsAnswerOption), ',') + ' FROM AnswerOptions__r ORDER BY OrderFormula__c)';
		}
		questionQuery += ' FROM Question__c WHERE Module__c =: moduleId';
		if(excludedQuestionIds != null){
			questionQuery += ' AND Id NOT in : excludedQuestionIds';
		}
		questionQuery += ' ORDER BY OrderFormula__c';
		
		Module__c module = [SELECT QuestionPool__c FROM Module__c WHERE Id =: moduleId];

		if(module.QuestionPool__c != null){
			if(quantity != null && quantity < module.QuestionPool__c){
				questionQuery += ' LIMIT ' + quantity;
			}else{
				questionQuery += ' LIMIT ' + module.QuestionPool__c;
			}
		}else{
			if(quantity != null){
				questionQuery += ' LIMIT ' + quantity;
			}
		}

		if(offset != null){
			questionQuery += ' OFFSET ' + offset;
		}

		return Database.query(questionQuery);
	}*/

	global class QuestionResponseWrapper{
		public QuestionResponse__c questionResponse {get; set;}
		public List<Answer__c> answers {get; private set;}
		private String questionType;

		global QuestionResponseWrapper(Id moduleResponseId, Question__c question){
			questionResponse = new QuestionResponse__c(ModuleResponse__c = moduleResponseId, Question__c = question.Id);
			answers = new List<Answer__c>();
			questionType = question.Type__c;
		}

		global void setShortAnswer(String answer){
			if(questionType != 'Short Answer'){
				questionResponse.TextValue__c = answer;
			}else{
				throw new FieloPLT.FieloException('This method is only for Short Answer questions.');
			}
		}

		global void setAnswer(AnswerOption__c answerOption){
			if(questionType != 'Single Choice' && questionType != 'Statement'){
				answers.add(new Answer__c(AnswerOption__c = answerOption.Id));
			}else{
				throw new FieloPLT.FieloException('This method is only for Single Choice or Statement questions.');
			}
		}

		global void setAnswers(List<AnswerOption__c> answerOptions){
			if(questionType != 'Multiple Choice' && questionType != 'Matching Options'){
				for(AnswerOption__c answerOption : answerOptions){
					answers.add(new Answer__c(AnswerOption__c = answerOption.Id));
				}
			}else{
				throw new FieloPLT.FieloException('This method is only for Multiple Choice or Matching Option questions.');
			}
		}
	}

	global static Boolean submitQuestion (QuestionResponseWrapper questionResponseWrapper){
		SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SobjectType>{QuestionResponse__c.SObjectType, Answer__c.SObjectType});
		uow.registerNew(questionResponseWrapper.questionResponse);
		for(Answer__c answer : questionResponseWrapper.answers){
			uow.registerNew(answer, Answer__c.QuestionResponse__c, questionResponseWrapper.questionResponse);
		}

		SavePoint sp = Database.setSavePoint();
		try{
			uow.commitWork();
		}catch(Exception e){
			Database.rollback(sp);
			throw e;
		}

		uow = new SObjectUnitOfWork(new List<Schema.SobjectType>{QuestionResponse__c.SObjectType});
		questionResponseWrapper.questionResponse.IsSubmitted__c = true;
		uow.registerDirty(questionResponseWrapper.questionResponse);
		try{
			uow.commitWork();
		}catch(Exception e){
			Database.rollback(sp);
			throw e;
		}

		//questionResponseWrapper.questionResponse = [SELECT Id, Name, ModuleResponse__c, NumberOfAttempt__c, Question__r.Module__r.QuestionPool__c, Question__c, IsSubmitted__c, IsCorrect__c FROM QuestionResponse__c WHERE Id =: questionResponseWrapper.questionResponse.Id];
		return questionResponseWrapper.questionResponse.IsCorrect__c || questionResponseWrapper.questionResponse.NumberOfAttempt__c >= questionResponseWrapper.questionResponse.Question__r.Module__r.QuestionPool__c;
	}
	
}