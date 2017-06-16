global with sharing class ModuleService {
	
	global class ModuleWrapper{
		global Module__c module {get; private set;}
		global ModuleResponse__c moduleResponse {get; private set;}
		global List<Question__c> questions {get; private set;}

		//global List<QuestionResponse__c> questionResponses {get; private set;}
		/*public ModuleWrapper(Module__c module){
			this.module = module;
		}*/

		public ModuleWrapper(Module__c module, ModuleResponse__c moduleResponse, List<Question__c> questions){
			//this(module);
			this.module = module;
			this.moduleResponse = moduleResponse;
			this.questions = questions;
		}
	}

	//Take module
	global static ModuleWrapper takeModule(Id moduleId, Id memberId, Set<String> fieldsModule, Set<String> fieldsQuestion, Set<String> fieldsAnswerOption) {
		//insert module response

		//query module

		//return module, quesitoons (shuffle), answer options, 
	//}

		SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{ModuleResponse__c.SObjectType});
		ModuleResponse__c moduleResponse = new ModuleResponse__c(Module__c = moduleId, Member__c = memberId);
		uow.registerNew(moduleResponse);
		uow.commitWork();

	//global static ModuleWrapper getModule(Id moduleId, Set<String> fieldsModule, Set<String> fieldsModuleDependency, Set<String> fieldsQuestion, Set<String> fieldsAnswerOption) {   
		Set<String> fieldsModuleClone = new Set<String>(fieldsModule);
		fieldsModuleClone.add('QuestionPool__c');
		String moduleQuery = 'SELECT ' + String.join(new List<String>(fieldsModuleClone), ',');
		moduleQuery += ' FROM Module__c WHERE Id =: moduleId ';
		Module__c module = Database.query(moduleQuery);

		//if(fieldsQuestion != null){
			Set<String> fieldsQuestionClone = new Set<String>(fieldsQuestion);
			fieldsQuestionClone.add('Type__c');
			String questionQuery = 'SELECT ' + String.join(new List<String>(fieldsQuestionClone), ',');
			if(fieldsAnswerOption != null){
				questionQuery += ' ,(SELECT ' + String.join(new List<String>(fieldsAnswerOption), ',') + ' FROM AnswerOptions__r ORDER BY OrderFormula__c)';
			}
			questionQuery += ' FROM Question__c WHERE Module__c =: moduleId ORDER BY OrderFormula__c';
			
			if(module.QuestionPool__c != null){
				questionQuery += ' LIMIT ' + module.QuestionPool__c;
			}

			List<Question__c> questions = Database.query(questionQuery);

			if(fieldsAnswerOption != null){
				for(Question__c q : questions){
					if(q.Type__c == 'Matching'){
						List<String> matchesOptions = new List<String>();
						for(AnswerOption__c ao : q.AnswerOptions__r){
							matchesOptions.add(ao.MatchingText__c);
						}

						for(AnswerOption__c ao : q.AnswerOptions__r){
							Integer randomPosition = Math.floor(Math.random() * matchesOptions.size()).intValue();
							ao.MatchingText__c = matchesOptions[randomPosition];
							matchesOptions.remove(randomPosition);
						}
					}
				}
			}

			return new ModuleWrapper(module, moduleResponse, questions);
		/*}else{
			return new ModuleWrapper(module);
		}*/

	}

	global static ModuleResponse__c submitModuleResponse (ModuleResponse__c moduleResponse){
		return submitModuleResponse (moduleResponse, null);
	}

	global static ModuleResponse__c submitModuleResponse (ModuleResponse__c moduleResponse, List<QuestionService.QuestionResponseWrapper> questionWrappers){
		SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SobjectType>{ModuleResponse__c.SObjectType, QuestionResponse__c.SObjectType, Answer__c.SObjectType});
		/*if(moduleResponse.Id != null){
			uow.registerNew(moduleResponse);
		}else{*/
			//uow.registerDirty(moduleResponse);
		//}
		if(questionWrappers != null){
			for(QuestionService.QuestionResponseWrapper qw : questionWrappers){
				uow.registerNew(qw.questionResponse, QuestionResponse__c.ModuleResponse__c, moduleResponse);
				for(Answer__c answer : qw.answers){
					uow.registerNew(answer, Answer__c.QuestionResponse__c, qw.questionResponse);
				}
			}
		}

		SavePoint sp = Database.setSavePoint();
		/*try{
			uow.commitWork();
		}catch(Exception e){
			Database.rollback(sp);
			throw e;
		}*/

		//uow = new SObjectUnitOfWork(new List<Schema.SobjectType>{ModuleResponse__c.SObjectType, QuestionResponse__c.SObjectType, Answer__c.SObjectType});
		moduleResponse.IsSubmitted__c = true;
		uow.registerDirty(moduleResponse);
		try{
			uow.commitWork();
		}catch(Exception e){
			Database.rollback(sp);
			throw e;
		}

		return [SELECT Id, Name, Member__c, Module__c, IsSubmitted__c, IsApproved__c, GradePercent__c FROM ModuleResponse__c WHERE Id =: moduleResponse.Id];
	}

	global class ModuleResponseWrapper{
		global ModuleResponse__c moduleResponse {get; private set;}
		global List<QuestionWrapper> questions {get; private set;}

		public ModuleResponseWrapper(ModuleResponse__c moduleResponse){
			this.moduleResponse = moduleResponse;
			this.questions = new List<QuestionWrapper>();
		}

		public void addQuestion(QuestionWrapper qWrapper){
			this.questions.add(qWrapper);
		}
	}
	
	global class QuestionWrapper{
		global Question__c question {get; private set;}
		global List<QuestionResponse__c> questionResponses {get; private set;}

		public QuestionWrapper(Question__c question, List<QuestionResponse__c> questionResponses){
			this.question = question;
			this.questionResponses = questionResponses;
		}
	}

	global static ModuleResponseWrapper getModuleResponse(Id moduleResponseId,
									  Set<String> fieldsModuleResponse,
									  Set<String> fieldsQuestion,
									  Set<String> fieldsQuestionResponse,
									  Set<String> fieldsAnswerOption,
									  Set<String> fieldsAnswer) {		
		String moduleResponseQuery = 'SELECT ' + String.join(new List<String>(fieldsModuleResponse), ',');
		moduleResponseQuery += ' FROM ModuleResponse__c WHERE Id =: moduleResponseId ';
		ModuleResponseWrapper moduleResponseWrapper = new ModuleResponseWrapper(Database.query(moduleResponseQuery));

		if(fieldsQuestionResponse != null){
			Set<String> fieldsQuestionResponseClone = new Set<String>(fieldsQuestionResponse);
			fieldsQuestionResponseClone.add('Question__c');
			String questionResponseQuery = 'SELECT ' + String.join(new List<String>(fieldsQuestionResponseClone), ',');
			if(fieldsAnswer != null){
				questionResponseQuery += ' ,(SELECT ' + String.join(new List<String>(fieldsAnswer), ',') + ' FROM Answers__r)';
			}
			questionResponseQuery += ' FROM QuestionResponse__c WHERE ModuleResponse__c =: moduleResponseId';
			List<QuestionResponse__c> questionResponses = Database.query(questionResponseQuery);

			Map<Id,List<QuestionResponse__c>> responsesByQuestion = new Map<Id,List<QuestionResponse__c>>();
			for(QuestionResponse__c qr : questionResponses){
				if(responsesByQuestion.containsKey(qr.Question__c)){
					responsesByQuestion.get(qr.Question__c).add(qr);
				}else{
					responsesByQuestion.put(qr.Question__c, new List<QuestionResponse__c>{qr});
				}
			}
			
			String questionQuery = 'SELECT ' + String.join(new List<String>(fieldsQuestion), ',');
			if(fieldsAnswerOption != null){
				questionQuery += ' ,(SELECT ' + String.join(new List<String>(fieldsAnswerOption), ',') + ' FROM AnswerOptions__r)';
			}
			Set<Id> questionIds = responsesByQuestion.keySet();
			questionQuery += ' FROM Question__c WHERE Id in : questionIds';
			
			for(Question__c question : Database.query(questionQuery)){
				moduleResponseWrapper.addQuestion(new QuestionWrapper(question, responsesByQuestion.get(question.Id)));
			}
		}

		return moduleResponseWrapper;
	}

}