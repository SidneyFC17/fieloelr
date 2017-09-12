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
                    var myCourses = [];
                    var courses = JSON.parse(response.getReturnValue());
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