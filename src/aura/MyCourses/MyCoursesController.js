({
    doInit: function(component, event, helper){
        var config = component.get('v.config');      
        if(config){
            config = JSON.parse(config);
            var fieldset = config.fieldset;
            var courseFieldset = config.Course.fieldset;
            component.set('v.fieldset', fieldset);
            component.set('v.courseFieldset', courseFieldset);
            var titleValue = '';
            var title = config.title;
            if(title){
                var type = title.type.toLowerCase();
                var value = title.value;
                if(type == 'label'){
                    var label = '$Label.' + value;
                    titleValue = $A.get(label);
                    component.set('v.title', titleValue);                
                }else{
                    titleValue = value;
                    component.set('v.title', titleValue);
                }
            }      
            component.set('v.layout', config.layout.toLowerCase());        
            component.set('v.columns', config.columns);            
            component.set('v.courseLayout', config.Course.layout.toLowerCase());                    
            component.set('v.courseColumns', config.Course.columns);                      
            window.localStorage.setItem('coursesStatus', '{}');   
            
            var courseLabelValues = component.get("c.getCourseLabels");            
            
            // Add callback behavior for when response is received
            courseLabelValues.setCallback(this, function(response) {
                var state = response.getState();        
                if (component.isValid() && state === "SUCCESS") {
                    //success                                                                            
                    var courseLabels = response.getReturnValue();                    
                    config.fieldset.forEach(function(field){
                        var labelType = field.label.type;                        
                        if(labelType == 'default'){                        
                            field.label = courseLabels[field.apiName];
                        } else if(labelType == 'label'){
                            var customLabel = '$Label.' + field.label.value;                                         
                            field.label = $A.get(customLabel);
                        }else{
                            field.label = field.label.value;
                        }    
                    })                                                    
                } else {
                    var errorMsg = response.getError()[0].message;
                    toastEvent.setParams({
                        "title": errorMsg,
                        "message": " ",
                        "type": "error"
                    });
                    toastEvent.fire();                     
                }     
            });            
            // Send action off to be executed
            
            $A.enqueueAction(courseLabelValues);


            var moduleLabelValues = component.get("c.getModuleLabels");            
            
            // Add callback behavior for when response is received
            moduleLabelValues.setCallback(this, function(response) {
                var state = response.getState();        
                if (component.isValid() && state === "SUCCESS") {
                    //success                                                                            
                    var moduleLabels = response.getReturnValue();                    
                    config.Course.fieldset.forEach(function(field){
                        var labelType = field.label.type;                        
                        if(labelType == 'default'){                        
                            field.label = moduleLabels[field.apiName];
                        } else if(labelType == 'label'){
                            var customLabel = '$Label.' + field.label.value;                                         
                            field.label = $A.get(customLabel);
                        }else{
                            field.label = field.label.value;
                        }    
                    })                                                    
                } else {
                    var errorMsg = response.getError()[0].message;
                    toastEvent.setParams({
                        "title": errorMsg,
                        "message": " ",
                        "type": "error"
                    });
                    toastEvent.fire();                     
                }     
            });            
            // Send action off to be executed
            
            $A.enqueueAction(moduleLabelValues);         
        }        
    },
    updateMember: function(component, event, helper){        
        var member = event.getParam('member');        
        component.set('v.member', member);        
        helper.loadCourses(component, event, helper);        
    },
    showCourse: function(component, event, helper){         
        var course = event.getParam('record');        
        var modulesList = [];
        var modules = course.modules;        
        for(var i = 0; i < modules.length; i++){
            var newModule = modules[i].module;
            newModule.moduleResponses = modules[i].moduleResponses;
            newModule.numberOfAttempts = modules[i].numberOfAttempts;
            newModule.isApproved = modules[i].isApproved;
            modulesList.push(newModule);
        }                
        component.set('v.modules', modulesList);
        component.set('v.courseTitle', course.Name);
        component.set('v.showMyCourses', false);
        component.set('v.showCourse', true);            
    },
    showCoursesList: function(component, event, helper){
        component.set('v.showMyCourses', true);        
        component.set('v.showCourse', false); 
    }
})