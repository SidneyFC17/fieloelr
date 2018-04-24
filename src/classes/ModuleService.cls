
global class ModuleService {
	
	global class ModuleWrapper{
		global Module__c module {get; private set;}
		global ModuleResponse__c moduleResponse {get; private set;}
		global List<Question__c> questions {get; private set;}

		public ModuleWrapper(Module__c module, ModuleResponse__c moduleResponse, List<Question__c> questions){
			//this(module);
			this.module = module;
			this.moduleResponse = moduleResponse;
			this.questions = questions;
		}
	}

	//Take module
	global static ModuleWrapper takeModule(Id moduleId, Id memberId, Set<String> fieldsModule, Set<String> fieldsQuestion, Set<String> fieldsAnswerOption) {
		
		SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{ModuleResponse__c.SObjectType});
		ModuleResponse__c moduleResponse;
		try{
			moduleResponse = [SELECT Module__c, Member__c, NumberOfAttempt__c FROM ModuleResponse__c WHERE Module__c =: moduleId AND Member__c =: memberId AND IsSubmitted__c = false];
			moduleResponse.NumberOfAttempt__c++;
			
			if(!Schema.sObjectType.ModuleResponse__c.isUpdateable())
                throw new FieloPLT.FieloException('Insufficient permission to update module response.');

			uow.registerDirty(moduleResponse);
		}catch(Exception e){
			moduleResponse = new ModuleResponse__c(Module__c = moduleId, Member__c = memberId);

			if(!Schema.sObjectType.ModuleResponse__c.isCreateable())
                throw new FieloPLT.FieloException('Insufficient permission to create module response.');

			uow.registerNew(moduleResponse);
		}
		uow.commitWork();

		Set<String> fieldsModuleClone = new Set<String>(fieldsModule);
		fieldsModuleClone.add('FieloELR__QuestionPool__c');
		String moduleQuery = 'SELECT ' + String.join(new List<String>(fieldsModuleClone), ',');
		moduleQuery += ' FROM Module__c WHERE Id =: moduleId ';
		Module__c module = Database.query(moduleQuery);

		Set<String> fieldsQuestionClone = new Set<String>(fieldsQuestion);
		fieldsQuestionClone.add('FieloELR__Type__c');
		String questionQuery = 'SELECT ' + String.join(new List<String>(fieldsQuestionClone), ',');

		Set<String> fieldsAnswerOptionClone = new Set<String>(fieldsAnswerOption);
		fieldsAnswerOptionClone.add('FieloELR__IsCorrect__c');
		questionQuery += ' ,(SELECT ' + String.join(new List<String>(fieldsAnswerOptionClone), ',') + ' FROM AnswerOptions__r ORDER BY OrderFormula__c)';

		questionQuery += ' FROM Question__c WHERE Module__c =: moduleId ORDER BY OrderFormula__c';
		
		if(module.QuestionPool__c != null){
			questionQuery += ' LIMIT ' + module.QuestionPool__c;
		}

		List<Question__c> questions = Database.query(questionQuery);

		if(fieldsAnswerOption != null){
			Integer currentIndex;
	    	string currentMatchingText;
	    	Integer randomIndex;
			for(Question__c q : questions){
				// Shuffle Answer Options Matching Text
				if(q.Type__c == 'Matching Options'){
					currentIndex = q.AnswerOptions__r.size();
					while (currentIndex != 0) {
			    		randomIndex = Math.floor(Math.random() * currentIndex).intValue();
			      		currentIndex -= 1;
			      		currentMatchingText = q.AnswerOptions__r.get(currentIndex).MatchingText__c;
			      		q.AnswerOptions__r.get(currentIndex).MatchingText__c = q.AnswerOptions__r.get(randomIndex).MatchingText__c;
			      		q.AnswerOptions__r.get(randomIndex).MatchingText__c = currentMatchingText;
			    	}
				}
			}
		}

		return new ModuleWrapper(module, moduleResponse, questions);
	}

	global static ModuleResponse__c submitModuleResponse (ModuleResponse__c moduleResponse){
		return submitModuleResponse (moduleResponse, null);
	}

	global static ModuleResponse__c submitModuleResponse (ModuleResponse__c moduleResponse, List<QuestionService.QuestionResponseWrapper> questionWrappers){
		SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SobjectType>{QuestionResponse__c.SObjectType, Answer__c.SObjectType, ModuleResponse__c.SObjectType});
		if(questionWrappers != null){
			
			if(!Schema.sObjectType.QuestionResponse__c.isUpdateable())
                throw new FieloPLT.FieloException('Insufficient permission to update question response.');

            if(!Schema.sObjectType.Answer__c.isUpdateable())
                throw new FieloPLT.FieloException('Insufficient permission to update answer.');

			for(QuestionService.QuestionResponseWrapper qw : questionWrappers){
				uow.registerNew(qw.questionResponse, QuestionResponse__c.ModuleResponse__c, moduleResponse);
				for(Answer__c answer : qw.answers){
					uow.registerNew(answer, Answer__c.QuestionResponse__c, qw.questionResponse);
				}
			}
		}

		SavePoint sp = Database.setSavePoint();
		moduleResponse.IsSubmitted__c = true;
		
		if(!Schema.sObjectType.ModuleResponse__c.isUpdateable())
            throw new FieloPLT.FieloException('Insufficient permission to update module response.');

		uow.registerDirty(moduleResponse);
		try{
			uow.commitWork();
		}catch(Exception e){
			Database.rollback(sp);
			throw e;
		}

		return [SELECT Id, Name, Member__c, Module__c, IsSubmitted__c, IsApproved__c, GradePercent__c FROM ModuleResponse__c WHERE Id =: moduleResponse.Id];
	}

	global class ModuleResponseResult{
		global ModuleResponse__c moduleResponse {get; private set;}
		global List<QuestionService.QuestionResponseResult> questions {get; private set;}

		public ModuleResponseResult(ModuleResponse__c moduleResponse){
			this.moduleResponse = moduleResponse;
			this.questions = new List<QuestionService.QuestionResponseResult>();
		}

		public void addQuestion(QuestionService.QuestionResponseResult qWrapper){
			this.questions.add(qWrapper);
		}
	}
	
	global static ModuleResponseResult getModuleResponse(Id moduleResponseId,
									  Set<String> fieldsModuleResponse,
									  Set<String> fieldsQuestion,
									  Set<String> fieldsAnswerOption) {
		
		if(!Schema.sObjectType.ModuleResponse__c.isAccessible())
            throw new FieloPLT.FieloException('Insufficient permission to read module response.');

		Set<String> fieldsModuleResponseClone = new Set<String>(fieldsModuleResponse);
		fieldsModuleResponseClone.add('FieloELR__Module__r.FieloELR__AttemptsAllowed__c');
		fieldsModuleResponseClone.add('FieloELR__NumberOfAttempt__c');
		fieldsModuleResponseClone.add('FieloELR__IsApproved__c');
		String moduleResponseQuery = 'SELECT ' + String.join(new List<String>(fieldsModuleResponseClone), ',');
		moduleResponseQuery += ' FROM ModuleResponse__c WHERE Id =: moduleResponseId ';
		ModuleResponse__c moduleResponse = Database.query(moduleResponseQuery);
		ModuleResponseResult moduleResponseWrapper = new ModuleResponseResult(moduleResponse);

		if(fieldsQuestion != null){
			Set<String> fieldsQuestionResponse = new Set<String>{'Question__c','TextValue__c','IsCorrect__c','PartialGradeValue__c'};
			String questionResponseQuery = 'SELECT ' + String.join(new List<String>(fieldsQuestionResponse), ',');
			Set<String> fieldsAnswer = new Set<String>{'AnswerOption__c','TextValue__c'};
			questionResponseQuery += ' ,(SELECT ' + String.join(new List<String>(fieldsAnswer), ',') + ' FROM Answers__r)';
			questionResponseQuery += ' FROM QuestionResponse__c WHERE ModuleResponse__c =: moduleResponseId ORDER BY NumberOfAttempt__c';
			List<QuestionResponse__c> questionResponses = Database.query(questionResponseQuery);

			Map<Id,List<QuestionResponse__c>> responsesByQuestion = new Map<Id,List<QuestionResponse__c>>();
			for(QuestionResponse__c qr : questionResponses){
				if(responsesByQuestion.containsKey(qr.Question__c)){
					responsesByQuestion.get(qr.Question__c).add(qr);
				}else{
					responsesByQuestion.put(qr.Question__c, new List<QuestionResponse__c>{qr});
				}
			}
			
			Set<String> fieldsQuestionClone = new Set<String>(fieldsQuestion);
			fieldsQuestionClone.add('FieloELR__Type__c');
			fieldsQuestionClone.add('FieloELR__Module__r.FieloELR__PenaltyMode__c');
			String questionQuery = 'SELECT ' + String.join(new List<String>(fieldsQuestionClone), ',');
			
			Set<String> fieldsAnswerOptionClone = new Set<String>(fieldsAnswerOption);
			fieldsAnswerOption.add('FieloELR__IsCorrect__c');
			fieldsAnswerOption.add('FieloELR__AnswerOptionText__c');
			questionQuery += ' ,(SELECT ' + String.join(new List<String>(fieldsAnswerOption), ',') + ' FROM AnswerOptions__r)';
			Set<Id> questionIds = responsesByQuestion.keySet();
			questionQuery += ' FROM Question__c WHERE Id in : questionIds';

			Boolean showDetailedAnswers; 
			for(Question__c question : Database.query(questionQuery)){
				showDetailedAnswers =
					responsesByQuestion.get(question.Id)[responsesByQuestion.get(question.Id).size()-1].IsCorrect__c;
				moduleResponseWrapper.addQuestion(new QuestionService.QuestionResponseResult(question, responsesByQuestion.get(question.Id), showDetailedAnswers));
			}
		}

		return moduleResponseWrapper;
	}

}