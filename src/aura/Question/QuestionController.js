({
    doInit : function(component, event, helper) {        
        var question = component.get('v.question');        
        component.set('v.title', question.FieloELR__QuestionText__c);
        component.set('v.options', question.FieloELR__AnswerOptions__r.records);        
        component.set('v.renderQuestion', true);
        var type = component.get('v.type');
        if (type == 'Matching Options') {
            var options = {};
            var i = 0;
            question.FieloELR__AnswerOptions__r.records.forEach(function(option){
               options[i] = option.FieloELR__AnswerOptionText__c; 
               i++;
            });
            component.set('v.matchingOptions', options);
        }
    },
    setAnswer: function(component, event, helper){
        var answerLabel = event.getSource().get('v.label');
        var answerValue = event.getSource().get('v.value');        
        var moduleAnswer = window.localStorage.getItem('moduleAnswer');        
        moduleAnswer = JSON.parse(moduleAnswer);        
        var moduleId = component.get('v.moduleId');        
        var question = component.get('v.question').Id;
        var type = component.get('v.type');           
        
        if (type == 'Single Choice' || type == 'Statement') {                                    
            moduleAnswer[moduleId][question] =  answerLabel;
        } else if (type == 'Multiple Choice') {                        
            if(answerValue){
                var answer = moduleAnswer[moduleId][question] || {};            
                answer[answerLabel] = answerValue;
                moduleAnswer[moduleId][question] =  answer;                
            } else {
                delete moduleAnswer[moduleId][question][answerLabel];
            }
            
        } else if (type == 'Short Answer') {
            var answer = component.get('v.answer');
            moduleAnswer[moduleId][question] =  answer;
        } else if (type == 'Matching Options') {            
            var matchingOptions = component.get('v.matchingOptions');
            var newAnswer = moduleAnswer[moduleId][question] || {};
            newAnswer[matchingOptions[answerValue]] = answerLabel;
            moduleAnswer[moduleId][question] = newAnswer;
        }
        window.localStorage.setItem('moduleAnswer', JSON.stringify(moduleAnswer));        
    }
})