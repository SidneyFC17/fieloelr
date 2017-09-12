({
    loadCourses : function(component, event, helper) {        
        var spinner = $A.get("e.c:ToggleSpinnerEvent");
        if(spinner){
            spinner.setParam('show', true);
            spinner.fire();    
        }           
        var member = component.get('v.member');        
        var fieldset = component.get('v.fieldset');
        fieldset = helper.getFieldset(fieldset).fieldset;
        var modulesFieldset = component.get('v.courseFieldset');
        modulesFieldset = helper.getFieldset(modulesFieldset).fieldset;        
        if(member){            
            var action = component.get('c.getCourses');
            action.setParams({
                'member': member,
                'coursesFieldset': fieldset,
                'modulesFieldset': modulesFieldset
            })
            // Add callback behavior for when response is received
            action.setCallback(this, function(response) {
                var state = response.getState();                
                if (component.isValid() && state === 'SUCCESS') {                    
                    var member = component.get('v.member');
                    var memberId = member.Id;                                     
                    var coursesList = [];
                    var coursesWrapper = JSON.parse(response.getReturnValue());
                    coursesWrapper.forEach(function(course){                        
                        var newCourse = course.course;
                        var courseId = newCourse.Id;                                     
                        var courseCache = JSON.parse(window.localStorage.getItem('coursesStatus'));                                                                        
                        if(!courseCache[memberId]){
                            courseCache[memberId] = {};    
                        }
                        var showJoinBtn;                          
                        if (courseCache[memberId][courseId]) {                            
                            showJoinBtn = courseCache[memberId][courseId];                            
                        } else {                            
                            showJoinBtn = course.allowedForDependency && course.allowedForSegment && !course.courseStatus;
                            courseCache[memberId][courseId] = showJoinBtn;
                            window.localStorage.setItem('coursesStatus', JSON.stringify(courseCache));                            
                        }                                                
                        newCourse.modules = course.modules;
                        coursesList.push(newCourse);
                    });
                    component.set('v.coursesList', coursesList);                                        
                    component.set('v.showCoursesList', false);
                    component.set('v.showCoursesList', true);                     
                }else {
                    console.log('Failed with state: ' + state);
                }
            });      
            // Send action off to be executed
            $A.enqueueAction(action);   
        }
    },
    updateCoursesCache: function(component, event, helper){        
        var coursesCache = window.localStorage.getItem('coursesCache');        
        var memberId = component.get('v.member');        
        memberId = memberId.Id;        
        if(coursesCache){
            coursesCache = JSON.parse(coursesCache);
            if(!coursesCache[memberId]){
                coursesCache[memberId] = {};
            }
        } else {
            coursesCache = {};
            coursesCache[memberId] = {};            
        }
        window.localStorage.setItem('coursesCache', JSON.stringify(coursesCache));        
    },
    getFieldset : function(fieldset) {
        var fields = {fieldset: ['Name'], subcomponents: []};
        fieldset.forEach(function(field){
            if(field.type != 'subcomponent'){
                fields.fieldset.push(field.apiName);    
            } else {
                fields.subcomponents.push(field);    
            }           
        })      
        return fields;
    }
})