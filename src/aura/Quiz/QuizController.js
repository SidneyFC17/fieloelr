({
    doInit : function(component, event, helper) {
        var moduleId = component.get('v.module').Id;
        var answer = {};
        answer[moduleId] = {};
        window.localStorage.setItem('moduleAnswer', JSON.stringify(answer));
    },
    submitAnswer : function(component, event, helper) {        
        var spinner = $A.get("e.c:ToggleSpinnerEvent");        
        if(spinner){
            spinner.setParam('show', true);
            spinner.fire();    
        }           
        var moduleWrapper = component.get('v.moduleWrapper');
        var moduleId = component.get('v.module').Id;
        var quizAnswer = JSON.parse(window.localStorage.getItem('moduleAnswer'))[moduleId];
        var action = component.get('c.submitQuiz');
        action.setParams({
            'moduleWrapperJson': JSON.stringify(moduleWrapper),
            'quizAnswer': JSON.stringify(quizAnswer)
        })
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
        	var moduleResponseEvent = $A.get("e.c:ShowModuleResponse");            
            var state = response.getState();         
            var spinner = $A.get("e.c:ToggleSpinnerEvent");                
            if (component.isValid() && state === 'SUCCESS') {                    
                var moduleResponse = JSON.parse(response.getReturnValue());                
                if(moduleResponseEvent){
                    moduleResponseEvent.setParam('moduleResponse', moduleResponse);
                    moduleResponseEvent.fire();
                }                
            }else {
                console.log('Failed with state: ' + state);
            }
            if(spinner){
                spinner.setParam('show', false);
                spinner.fire();    
            }   
        });      
        // Send action off to be executed
        $A.enqueueAction(action);   
    }
})