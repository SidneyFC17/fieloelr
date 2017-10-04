({
    doInit : function(component, event, helper) {        
        var moduleResponse = component.get('v.moduleResponse');                
        var spinner = $A.get("e.FieloELR:ToggleSpinnerEvent");        
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
            var toastEvent = $A.get("e.force:showToast");
            var message;
            var state = response.getState();         
            var spinner = $A.get("e.FieloELR:ToggleSpinnerEvent");                
            if (component.isValid() && state === 'SUCCESS') {                    
                var moduleResponse = JSON.parse(response.getReturnValue());                
                component.set('v.moduleResponseQuestions', moduleResponse);                
                helper.loadQuestionResponses(component);
                if(moduleResponse.moduleResponse.FieloELR__IsApproved__c){
                    message = $A.get("$Label.FieloELR.Approved");
                } else {
                    message = $A.get("$Label.FieloELR.TryAgain");
                }
                component.set('v.responseMessage', message);
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
    }
})