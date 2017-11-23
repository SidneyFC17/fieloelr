({
    doInit : function(component, event, helper) {        
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
            var module = config.Module;
            if(module && module.content){            
                component.set('v.moduleContent', module.content);                
            }
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
        window.localStorage.setItem('member', JSON.stringify(member));         
        helper.loadCourses(component, event, helper);        
    },
    showCourse: function(component, event, helper, course){
        helper.setCourseInfo(component, event, helper, false);
    },
    showCoursesList: function(component, event, helper){
        component.set('v.showCoursesList', true);        
        component.set('v.showCourse', false); 
    },
    takeModule: function(component, event, helper){
        component.set('v.showCourse', false); 
        var moduleRecord = event.getParam('module');
        component.set('v.moduleRecord', moduleRecord);
        component.set('v.moduleTitle', moduleRecord.module.Name);
        component.set('v.showModule', true); 
    },
    showCourseInformation: function(component, event, helper){
        component.set('v.showModule', false); 
        component.set('v.showModuleResponse', false); 
        component.set('v.showCourse', true); 
    },
    showModuleResponse: function(component, event, helper){
        var moduleResponse = event.getParam('moduleResponse');
        var view = event.getParam('view');
        var moduleName = event.getParam('name');
        if(moduleName){
            component.set('v.moduleTitle', moduleName);
        }
        component.set('v.viewAnswer', view);
        component.set('v.moduleResponse', moduleResponse);
        component.set('v.showCourse', false); 
        component.set('v.showModule', false);
        component.set('v.showModuleResponse', true);
    },
    reloadCourses: function(component, event, helper){
        helper.loadCourses(component, event, helper);        
        //var courseData = window.localStorage.getItem('actualCourse');
        //helper.setCourseInfo(component, event, helper, JSON.parse(courseData));
    }
})