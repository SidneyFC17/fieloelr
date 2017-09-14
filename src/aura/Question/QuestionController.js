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
                options[i] = option.Id; 
                i++; 
            });
            component.set('v.matchingOptions', options);
        }
        if(component.get('v.mode') == 'view'){
            component.set('v.isCorrect', question.FieloELR__IsCorrect__c);
            component.set('v.className', 'disabled');
            
            if (type == 'Short Answer'){
                component.set('v.shortAnswer', question.FieloELR__TextValue__c);
            } else if (type == 'Matching Options'){
                
            } else {
                question.Answers.forEach(function(answer){                    
                    var id = answer.FieloELR__AnswerOption__c;
                    question.FieloELR__AnswerOptions__r.records.forEach(function(ans){
                        if(!ans.isSelected){
                            ans.isSelected = ans.Id == id ? true : false;
                        }

                    })
                })                
            }            
        }
    },
    setAnswer: function(component, event, helper){
        var answerLabel = event.getSource().get('v.label');
        var answerValue = event.getSource().get('v.value');        
        var answerText = event.getSource().get('v.text');        
        var moduleAnswer = window.localStorage.getItem('moduleAnswer');        
        moduleAnswer = JSON.parse(moduleAnswer);        
        var moduleId = component.get('v.moduleId');        
        var question = component.get('v.question').Id;
        var type = component.get('v.type');           
        
        if (type == 'Single Choice' || type == 'Statement') {                                    
            moduleAnswer[moduleId][question] =  answerText;
        } else if (type == 'Multiple Choice') {                        
            if(answerValue){
                var answer = moduleAnswer[moduleId][question] || {};            
                answer[answerText] = true;
                moduleAnswer[moduleId][question] =  answer;                
            } else {
                delete moduleAnswer[moduleId][question][answerText];
            }
            
        } else if (type == 'Short Answer') {
            var answer = component.get('v.shortAnswer');
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