({
    doInit : function(component, event, helper){        
        var module = component.get('v.record');       
        component.set('v.takeModule', module.showBtn);        
    },
    takeModule: function(component, event, helper){
        var spinner = $A.get("e.c:ToggleSpinnerEvent");
        if(spinner){
            spinner.setParam('show', true);
            spinner.fire();    
        }           
        var member = window.localStorage.getItem('member');        
        if(member){                        
            var action = component.get('c.memberTakeModule');
            var moduleId = component.get('v.record').Id;
            action.setParams({
                'memberId': JSON.parse(member).Id,
                'moduleId': moduleId
            })
            // Add callback behavior for when response is received
            action.setCallback(this, function(response) {
                var spinner = $A.get("e.c:ToggleSpinnerEvent");
                var takeModuleEvent = $A.get("e.c:TakeModuleEvent");
                var state = response.getState();
                if (component.isValid() && state === 'SUCCESS') {
                    var moduleWrapper = JSON.parse(response.getReturnValue());                                                            
                }else {
                    console.log('Failed with state: ' + state);
                }                
                if(spinner){
                    spinner.setParam('show', false);
                    spinner.fire();    
                }           
                if(takeModuleEvent){
                    takeModuleEvent.setParam('module', moduleWrapper);
                    takeModuleEvent.fire();    
                }
            });      
            // Send action off to be executed
            $A.enqueueAction(action);  
        }
    }
})