({
    doInit : function(component, event, helper) {
        var moduleId = component.get('v.module').Id;
        var answer = {};
        answer[moduleId] = {};
        window.localStorage.setItem('moduleAnswer', JSON.stringify(answer));
    },
    submitAnswer : function(component, event, helper) {        
        var spinner = $A.get("e.FieloELR:ToggleSpinnerEvent");        
        if(spinner){
            spinner.setParam('show', true);
            spinner.fire();    
        }           
        var moduleWrapper = component.get('v.moduleWrapper');
        var moduleId = component.get('v.module').Id;
        var quizAnswer = JSON.parse(window.localStorage.getItem('moduleAnswer'))[moduleId];
        var questions = component.get('v.questions');
        if(questions.length == Object.keys(quizAnswer).length){
            var action = component.get('c.submitQuiz');     
            
            moduleWrapper.questions.forEach(function(question){
                question.FieloELR__AnswerOptions__r.records.forEach(function(answer){
                    delete answer.isSelected;
                })
            })
            action.setParams({
                'moduleWrapperJson': JSON.stringify(moduleWrapper),
                'quizAnswer': JSON.stringify(quizAnswer)
            })
            // Add callback behavior for when response is received
            action.setCallback(this, function(response) {
                var toastEvent = $A.get("e.force:showToast");
                var moduleResponseEvent = $A.get("e.FieloELR:ShowModuleResponseEvent");            
                var state = response.getState();         
                var spinner = $A.get("e.FieloELR:ToggleSpinnerEvent");                
                if (component.isValid() && state === 'SUCCESS') {                    
                    var moduleResponse = JSON.parse(response.getReturnValue());                
                    if(moduleResponseEvent){
                        moduleResponseEvent.setParam('moduleResponse', moduleResponse);
                        moduleResponseEvent.setParam('view', false);
                        moduleResponseEvent.fire();
                    }                
                }else {
                    var errorMsg = response.getError()[0].message;
                    toastEvent.setParams({
                        "title": errorMsg,
                        "message": " ",
                        "type": "error"
                    });
                    toastEvent.fire(); 
                }
                if(spinner){
                    spinner.setParam('show', false);
                    spinner.fire();    
                }   
            });      
            // Send action off to be executed
            $A.enqueueAction(action);               
        } else {
            var toastEvent = $A.get("e.force:showToast");
            var spinner = $A.get("e.FieloELR:ToggleSpinnerEvent");                
            if(spinner){
                spinner.setParam('show', false);
                spinner.fire();    
            }   
            toastEvent.setParams({
                "title": "Error!",
                "message": $A.get("$Label.FieloELR.CompleteAllQuestions"),
                "type": "error"
            });
            toastEvent.fire();
        }
        
    }
})