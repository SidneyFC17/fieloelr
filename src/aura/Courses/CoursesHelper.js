({
    loadCourses : function(component, event, helper) {
        var spinner = $A.get("e.FieloELR:ToggleSpinnerEvent");
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
                    var coursesList = [];
                    var coursesWrapper = JSON.parse(response.getReturnValue());
                    coursesWrapper.forEach(function(course){
                        var newCourse = course.course;
                        newCourse.showJoinBtn = course.allowedForDependency && course.allowedForSegment && !course.courseStatus;                                            
                        newCourse.modules = course.modules;
                        coursesList.push(newCourse);
                    });
                    component.set('v.coursesList', coursesList);                                        
                    component.set('v.showCoursesList', false);
                    component.set('v.showCoursesList', true); 
                    console.log(coursesList);
                }else {
                    console.log('Failed with state: ' + state);
                }
            });      
            // Send action off to be executed
            $A.enqueueAction(action);   
        }
    }
})