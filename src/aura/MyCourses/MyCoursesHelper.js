({
	loadCourses : function(component, event, helper) {
        var spinner = $A.get("e.c:ToggleSpinnerEvent");
        if(spinner){
            spinner.setParam('show', true);
            spinner.fire();    
        }       
        var member = component.get('v.member');                
        if(member){            
            var action = component.get('c.getMyCourses');
            action.setParams({
                'member': member
            })
            // Add callback behavior for when response is received
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state === 'SUCCESS') {                    
                    var myCourses = JSON.parse(response.getReturnValue());
                    component.set('v.myCourses', myCourses); 
                    component.set('v.showMyCourses', false);
                    component.set('v.showMyCourses', true);
                }else {
                    console.log('Failed with state: ' + state);
                }
            });      
            // Send action off to be executed
            $A.enqueueAction(action);   
        }
	}
})