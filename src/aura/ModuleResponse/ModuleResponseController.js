({
    doInit : function(component, event, helper) {        
        var moduleResponse = component.get('v.moduleResponse');                
        var spinner = $A.get("e.c:ToggleSpinnerEvent");        
        if(spinner){
            spinner.setParam('show', true);
            spinner.fire();    
        }                   
        var action = component.get('c.getModuleResponse');
        action.setParams({
            'moduleResponseId': moduleResponse.Id
        })
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {           
            var message;
            var state = response.getState();         
            var spinner = $A.get("e.c:ToggleSpinnerEvent");                
            if (component.isValid() && state === 'SUCCESS') {                    
                var moduleResponse = JSON.parse(response.getReturnValue());                
                component.set('v.moduleResponseQuestions', moduleResponse);                
                helper.loadQuestionResponses(component);
                if(moduleResponse.moduleResponse.FieloELR__IsApproved__c){
                    message = '¡Felicitaciones!¡Aprobaste!';
                } else {
                    message = '¡No Aprobaste!';
                }
                component.set('v.responseMessage', message);
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