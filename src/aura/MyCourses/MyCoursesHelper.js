({
    loadCourses : function(component, event, helper) {
        var member = component.get('v.member');
        var fieldset = ['Name','FieloELR__Description__c'];
        if(member){
            var spinner = $A.get("e.c:ToggleSpinnerEvent");
            if(spinner){
                spinner.setParam('show', true);
                spinner.fire();    
            }                
            var action = component.get('c.getCourses');
            action.setParams({
                'member': member,
                'fieldset': fieldset
            })
            // Add callback behavior for when response is received
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state === 'SUCCESS') {                    
                    var myCourses = [];
                    var courses = JSON.parse(response.getReturnValue());
                    console.log(courses);
                    courses.forEach(function(course){
                        if(course.courseStatus){
                            var newCourse = course.courseStatus;
                            newCourse.Name = course.course.Name;
                            newCourse.modules = course.modules;
                            myCourses.push(newCourse);
                        }
                    })
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