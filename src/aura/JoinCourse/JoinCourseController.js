({
    doInit : function(component, event, helper){
        var course = component.get('v.record');
        var courseId = course.Id;
        var joinedCourses = window.localStorage.getItem('joinedCourses') || '{}';
        joinedCourses = JSON.parse(joinedCourses);
        if(joinedCourses[courseId]){
            component.set('v.join', false);
        }
    },
    joinCourse : function(component, event, helper) {         
        var toastEvent = $A.get("e.force:showToast");
        var course = component.get('v.record');
        var courseId = course.Id;
        var courseName = course.Name;
        var memberId = JSON.parse(window.localStorage.getItem('member')).Id;
        
        if(memberId && courseId){            
            var joinCourseAction = component.get('c.memberJoinCourse');
            var joinedCourses = window.localStorage.getItem('joinedCourses') || '{}';
            joinedCourses = JSON.parse(joinedCourses);
            joinCourseAction.setParams({
                'memberId': memberId,
                'courseId': courseId
            })
            // Add callback behavior for when response is received
            joinCourseAction.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state === 'SUCCESS') {
                    toastEvent.setParams({
                        "title": "Thanks for joining " + courseName + "!",
                        "message": "Now you can complete it"
                    });
                    toastEvent.fire();
                    joinedCourses[courseId] = true;
                    window.localStorage.setItem('joinedCourses', JSON.stringify(joinedCourses));
                    component.set('v.join', false);
                }else {
                    console.log('Failed with state: ' + state);
                }
            });      
            // Send action off to be executed
            $A.enqueueAction(joinCourseAction);   
        }
        
    }
})