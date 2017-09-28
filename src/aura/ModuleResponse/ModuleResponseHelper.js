({
    loadQuestionResponses : function(component) {
        var questionsModule = [];
        var moduleResponse = component.get('v.moduleResponseQuestions');
        var questions = moduleResponse.questions;        
        questions.forEach(function(ques){            
            var newQuestion = {};
            newQuestion = ques.question;            
            newQuestion.FieloELR__IsCorrect__c = ques.questionResponse.FieloELR__IsCorrect__c;                
            if(newQuestion.FieloELR__Type__c == 'Short Answer'){
                newQuestion.FieloELR__TextValue__c = ques.questionResponse.FieloELR__TextValue__c;
            }else{
                newQuestion.Answers = ques.questionResponse.FieloELR__Answers__r.records;               
            }
            questionsModule.push(newQuestion);
        });      
        component.set('v.questionsModule', questionsModule);
        component.set('v.showAnswers', true);
    }
})