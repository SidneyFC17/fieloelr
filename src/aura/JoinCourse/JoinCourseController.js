({
    doInit : function(component, event, helper){        
        var course = component.get('v.record');
        var memberId = JSON.parse(window.localStorage.getItem('member')).Id;
        var courseCache = JSON.parse(window.localStorage.getItem('coursesStatus'));        
        component.set('v.join', courseCache[memberId][course.Id]);        
    },
    joinCourse : function(component, event, helper) {         
        var toastEvent = $A.get("e.force:showToast");
        var course = component.get('v.record');
        var courseId = course.Id;
        var courseName = course.Name;
        var memberId = JSON.parse(window.localStorage.getItem('member')).Id;
        
        if(memberId && courseId){       
            var spinner = $A.get("e.c:ToggleSpinnerEvent");
            if(spinner){
                spinner.setParam('show', true);
                spinner.fire();    
            }    
            var joinCourseAction = component.get('c.memberJoinCourse');
            joinCourseAction.setParams({
                'memberId': memberId,
                'courseId': courseId
            })
            // Add callback behavior for when response is received
            joinCourseAction.setCallback(this, function(response) {
                var course = component.get('v.record');
                var spinner = $A.get("e.c:ToggleSpinnerEvent");
                var state = response.getState();
                if (component.isValid() && state === 'SUCCESS') {                    
                    toastEvent.setParams({
                        "title": "Thanks for joining " + courseName + "!",
                        "message": "Now you can complete it",
                        "type": "success"
                    });
                    toastEvent.fire();                    
                    component.set('v.join', false);
                    var courseCache = JSON.parse(window.localStorage.getItem('coursesStatus'));
                    courseCache[memberId][courseId] = false;
                    window.localStorage.setItem('coursesStatus', JSON.stringify(courseCache));                    
                }else {
                    console.log('Failed with state: ' + state);
                }
                if(spinner){
                    spinner.setParam('show', false);
                    spinner.fire();
                }
            });      
            // Send action off to be executed
            $A.enqueueAction(joinCourseAction);   
        }
        
    }
})