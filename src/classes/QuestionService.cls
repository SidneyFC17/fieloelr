public with sharing class QuestionService {
	
	public static List<Question__c> getQuestions(Id moduleId,
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
	}

	public static QuestionResponse__c submitQuestion (QuestionResponse__c questionResponse, List<Answer__c> answers){
		SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SobjectType>{QuestionResponse__c.SObjectType, Answer__c.SObjectType});
		uow.registerNew(questionResponse);
		for(Answer__c answer : answers){
			uow.registerNew(answer, Answer__c.QuestionResponse__c, questionResponse);
		}

		SavePoint sp = Database.setSavePoint();
		try{
			uow.commitWork();
		}catch(Exception e){
			Database.rollback(sp);
			throw e;
		}

		uow = new SObjectUnitOfWork(new List<Schema.SobjectType>{QuestionResponse__c.SObjectType});
		questionResponse.IsSubmitted__c = true;
		uow.registerDirty(questionResponse);
		try{
			uow.commitWork();
		}catch(Exception e){
			Database.rollback(sp);
			throw e;
		}

		return [SELECT Id, Name, ModuleResponse__c, Question__c, IsSubmitted__c, IsCorrect__c FROM QuestionResponse__c WHERE Id =: questionResponse.Id];
	}
	
}