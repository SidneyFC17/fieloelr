public with sharing class QuizController {

    @AuraEnabled
    public static String submitQuiz(String moduleWrapperJson, String quizAnswer){
       try{
           FieloELR.ModuleService.ModuleWrapper moduleWrapper = (FieloELR.ModuleService.ModuleWrapper) JSON.deserializeStrict(moduleWrapperJson, FieloELR.ModuleService.ModuleWrapper.class);
        FieloELR__Module__c module = moduleWrapper.module;
        FieloELR__ModuleResponse__c moduleResponse = moduleWrapper.moduleResponse; //record created for the member, will be send by parameter in submit method
        List<FieloELR__Question__c> questions = moduleWrapper.questions; //includes answer options related lists
        //Finish operation to take module//

        Map<String,Object> answersMap = (Map<String,Object>)JSON.deserializeUntyped(quizAnswer);

        //Submit module operation//
        List<FieloELR.QuestionService.QuestionResponseWrapper> questionWrappers = new List<FieloELR.QuestionService.QuestionResponseWrapper>();
        for(FieloELR__Question__c question : moduleWrapper.questions){
            FieloELR.QuestionService.QuestionResponseWrapper questionWrapper = new FieloELR.QuestionService.QuestionResponseWrapper(moduleResponse.Id, question);
            
            Object answerObject = answersMap.get(question.Id);

            if(question.FieloELR__Type__c == 'Short Answer'){
                String answerText = (String)answerObject;
                questionWrapper.setShortAnswer(answerText);
            }else if(question.FieloELR__Type__c == 'Single Choice' || question.FieloELR__Type__c == 'Statement'){
                Id answerOptionSelected = (Id)answerObject;
                questionWrapper.setAnswer(new FieloELR__AnswerOption__c(Id = answerOptionSelected));
            }else if(question.FieloELR__Type__c == 'Multiple Choice'){
                Map<String,Object> answerOptionsSelected = (Map<String,Object>)answerObject;
                List<FieloELR__AnswerOption__c> answerOptions = new List<FieloELR__AnswerOption__c>();
                for(String awId : answerOptionsSelected.keySet()) answerOptions.add(new FieloELR__AnswerOption__c(Id = awId));
                questionWrapper.setAnswers(answerOptions);
            }else if(question.FieloELR__Type__c == 'Matching Options'){
                Map<Id,String> answerOptionsSelected = new Map<Id,String>();
                Map<String,Object> answerOptionsString = (Map<String,Object>)answerObject;
                for(String key : answerOptionsString.keyset()) answerOptionsSelected.put((Id)key, (String)answerOptionsString.get(key));
                questionWrapper.setMatchingAnswers(answerOptionsSelected);
            }
            questionWrappers.add(questionWrapper);
        }
        FieloELR__ModuleResponse__c submittedMResponse = FieloELR.ModuleService.submitModuleResponse (moduleResponse, questionWrappers);
        return JSON.serialize(submittedMResponse);
        } catch(DMLException e) {
          throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e){
          throw new AuraHandledException(e.getMessage());
        }     
    }
    
    @AuraEnabled
    public static String submitQuestion(QuestionService.QuestionResponseWrapper questionResponseWrapper) {
        try{
			return JSON.serialize(QuestionService.submitQuestion(questionResponseWrapper));
		} catch(DMLException e) {
           	throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String submitModuleResponse(FieloELR__ModuleResponse__c moduleResponse) {
        try{
			return JSON.serialize(ModuleService.submitModuleResponse(moduleResponse));
		} catch(DMLException e) {
           	throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String submitModuleAndQuestionResponses(ModuleResponse__c moduleResponse, List<QuestionService.QuestionResponseWrapper> questionWrappers) {
        try{
			return JSON.serialize(ModuleService.submitModuleResponse(moduleResponse, questionWrappers));
		} catch(DMLException e) {
           	throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}