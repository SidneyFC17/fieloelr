({
    loadCourses : function(component, event, helper) {
        var spinner = $A.get("e.c:ToggleSpinnerEvent");
        if(spinner){
            spinner.setParam('show', true);
            spinner.fire();    
        }           
        var member = component.get('v.member');        
        var fieldset = ['Name','FieloELR__Description__c'];
        if(member){            
            var action = component.get('c.getCourses');
            action.setParams({
                'member': member,
                'fieldset': fieldset
            })
            // Add callback behavior for when response is received
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state === 'SUCCESS') {
                    component.set('v.courses', response.getReturnValue());
                    component.set('v.showCoursesList', false);
                    component.set('v.showCoursesList', true);
                    console.log(response.getReturnValue());
                }else {
                    console.log('Failed with state: ' + state);
                }
            });      
            // Send action off to be executed
            $A.enqueueAction(action);   
        }
    }
})