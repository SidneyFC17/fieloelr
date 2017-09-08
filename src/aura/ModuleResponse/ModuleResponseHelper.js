({
	loadQuestionResponses : function(component) {
        var questionsModule = {};
        var moduleResponse = component.get('v.moduleResponseQuestions');
        var questions = moduleResponse.questions;        

        questions.forEach(function(ques){  
            
            var question = ques.question;
            var questionResponse = ques.questionResponse;
            questionsModule[question.Id] = {FieloELR__Type__c: question.FieloELR__Type__c, FieloELR__QuestionText__c: question.FieloELR__QuestionText__c, FieloELR__AnswerOptions__r: question.FieloELR__AnswerOptions__r, FieloELR__IsCorrect__c: questionResponse.FieloELR__IsCorrect__c, FieloELR__Answers__r: questionResponse.FieloELR__Answers__r.records};
        })        
        console.log(questionsModule);
	}
})
