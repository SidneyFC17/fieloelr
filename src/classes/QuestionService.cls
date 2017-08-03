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
		public Question__c question {get; set;}
		public List<Answer__c> answers {get; private set;}
		
		global QuestionResponseWrapper(Id moduleResponseId, Question__c question){
			this.question = question;
			this.questionResponse = new QuestionResponse__c(ModuleResponse__c = moduleResponseId, Question__c = question.Id, NumberOfAttempt__c = null);
			this.answers = new List<Answer__c>();
		}

		global void setShortAnswer(String answer){
			if(question.Type__c == 'Short Answer'){
				questionResponse.TextValue__c = answer;
			}else{
				throw new FieloPLT.FieloException('This method is only for Short Answer questions.');
			}
		}

		global void setAnswer(AnswerOption__c answerOption){
			if(question.Type__c == 'Single Choice' || question.Type__c == 'Statement'){
				answers.add(new Answer__c(AnswerOption__c = answerOption.Id));
			}else{
				throw new FieloPLT.FieloException('This method is only for Single Choice or Statement questions.');
			}
		}

		global void setAnswers(List<AnswerOption__c> answerOptions){
			if(question.Type__c == 'Multiple Choice'){
				for(AnswerOption__c answerOption : answerOptions){
					answers.add(new Answer__c(AnswerOption__c = answerOption.Id));
				}
			}else{
				throw new FieloPLT.FieloException('This method is only for Multiple Choice questions.');
			}
		}

		global void setMatchingAnswers(Map<Id,String> answersMap){
			if(question.Type__c == 'Matching Options'){
				for(Id answerOptionId : answersMap.keySet()){
					answers.add(new Answer__c(AnswerOption__c = answerOptionId, TextValue__c = answersMap.get(answerOptionId)));
				}
			}else{
				throw new FieloPLT.FieloException('This method is only for Matching Option questions.');
			}
		}
	}

	global class QuestionResponseResult{
		global Question__c question {get; private set;}
		global Integer numberOfAttempts {get; private set;}
		global QuestionResponse__c questionResponse {get; private set;}
		global List<AnswerWrapper> answerWrappers {get; private set;}
		global Boolean canRepeatQuestion {get; private set;}
		global String correctedAnswers {get; private set;}
		private Boolean showDetailedAnswers;

		public QuestionResponseResult(Question__c question, List<QuestionResponse__c> questionResponses, Boolean showDetailedAnswers){
			this.question = question;
			this.numberOfAttempts = questionResponses.size();
			this.questionResponse = this.numberOfAttempts > 0 ? questionResponses.get(this.numberOfAttempts - 1) : null;
			this.showDetailedAnswers = showDetailedAnswers;
			setAnswers();
		}

		public QuestionResponseResult(Question__c question, QuestionResponse__c questionResponse, List<Answer__c> answers){
			this.question = question;
			this.numberOfAttempts = questionResponse.NumberOfAttempt__c.intValue();
			this.questionResponse = questionResponse;
			this.showDetailedAnswers = false;
			setAnswers();
		}

		private void setAnswers(){
			if(question.Type__c != 'Short Answer'){
				setAnswerWrappers(this.questionResponse.Answers__r);
			}
			
			if(this.showDetailedAnswers){
				if(question.Type__c == 'Short Answer'){
					setShortAnswerDescription();
				}else if(question.Type__c == 'Matching Options'){
					setMatchingDescription();
				}
			}
		}

		public void setRepeatQuestion(Boolean canRepeatQuestion){
			this.canRepeatQuestion = canRepeatQuestion;
		}

		private void setAnswerWrappers(List<Answer__c> answers){
			Map<Id,Answer__c> answersByOption = new Map<Id,Answer__c>();
			if(this.questionResponse != null){
				for(Answer__c answer : answers){
					answersByOption.put(answer.AnswerOption__c, answer);
				}
			}

			this.answerWrappers = new List<AnswerWrapper>();
			for(AnswerOption__c answerOption : question.AnswerOptions__r){
				answerWrappers.add(new AnswerWrapper(answerOption, answersByOption.get(answerOption.Id), question.Type__c, showDetailedAnswers));
			}
		}
		
		private void setShortAnswerDescription(){
			List<String> correctedOptions = new List<String>();
			for(AnswerOption__c answerOption : question.AnswerOptions__r){
				correctedOptions.add(answerOption.AnswerOptionText__c);
			}
			this.correctedAnswers = String.join(correctedOptions,' , ');
		}

		private void setMatchingDescription(){
			List<String> correctedOptions = new List<String>();
			for(AnswerOption__c answerOption : question.AnswerOptions__r){
				if (answerOption.IsCorrect__c) {
					correctedOptions.add(answerOption.AnswerOptionText__c + ' -- ' + answerOption.MatchingText__c);
				}
			}
			this.correctedAnswers = String.join(correctedOptions,' , ');
		}
	}

	global class AnswerWrapper{
		global AnswerOption__c answerOption {get; private set;}
		global String answerStatus {get; private set;}

		public AnswerWrapper(AnswerOption__c answerOption, Answer__c answer, String questionType, Boolean showDetailedAnswers){
			this.answerOption = answerOption;
			if(questionType != 'Matching Options'){
				if(answer != null){
					this.answerStatus = answerOption.IsCorrect__c ? 'Correct' : 'Incorrect';
				}else{
					if(showDetailedAnswers){
						this.answerStatus = answerOption.IsCorrect__c ? 'Missing' : 'Neutral';
					}else{
						this.answerStatus = 'Neutral';
					}
				}
			}else{
				if(answerOption.IsCorrect__c){
					if(this.answerOption.MatchingText__c == answer.TextValue__c){
						this.answerStatus = 'Correct';
					}else{
						this.answerStatus = 'Incorrect';
					}
				}else{
					this.answerStatus = 'Neutral';
				}
				if (answer != null) {
					this.answerOption.MatchingText__c = answer.TextValue__c;
				}
			}
		}
	}

	global static QuestionResponseResult submitQuestion (QuestionResponseWrapper questionResponseWrapper){
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
		// Done this way becouse the commit the UOW doesnt refreshes the entire object, just the ID.
		QuestionResponse__c qResponseQuery = [SELECT Id, PartialGradeValue__c, NumberOfAttempt__c, IsCorrect__c, IsSubmitted__c, Question__r.Module__r.FieloELR__AttemptsAllowedPerQuestion__c FROM QuestionResponse__c WHERE Id =: questionResponseWrapper.questionResponse.Id];
		qResponseQuery.IsSubmitted__c = true;
		uow.registerDirty(qResponseQuery);
		try{
			QuestionResponses.validateAdminFields = false;
			uow.commitWork();
		}catch(Exception e){
			Database.rollback(sp);
			throw e;
		}

		// Done this way becouse the commit the UOW doesnt refreshes the entire object, just the ID.
		qResponseQuery = [SELECT Id, PartialGradeValue__c, NumberOfAttempt__c, IsCorrect__c, IsSubmitted__c, Question__r.Module__r.FieloELR__AttemptsAllowedPerQuestion__c FROM QuestionResponse__c WHERE Id =: questionResponseWrapper.questionResponse.Id];
		QuestionResponseResult qrResult = new QuestionResponseResult(questionResponseWrapper.question, qResponseQuery, questionResponseWrapper.answers);
		qrResult.setRepeatQuestion(!qResponseQuery.IsCorrect__c && (qResponseQuery.NumberOfAttempt__c < qResponseQuery.Question__r.Module__r.FieloELR__AttemptsAllowedPerQuestion__c || qResponseQuery.Question__r.Module__r.FieloELR__AttemptsAllowedPerQuestion__c == null));
		return qrResult;
	}
	
}