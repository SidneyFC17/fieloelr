({
    doInit: function(component, event, helper){
        var title, fields, fieldset;
        var config = component.get('v.configDefault');
        
        try{
            config = JSON.parse(config);                        
            // CHECK IF BASIC CONFIG OVERRIDES ADVANCED CONFIG
            
            // TITLE
            var titleValue = component.get('v.titleValue').trim();
            if(titleValue.length > 0){
                if (titleValue.indexOf('{') == 0) {
                    title = JSON.parse(titleValue);
                } else {
                    title = {
                        "value": component.get('v.titleValue'),
                        "type": "text"
                    };                    
                }
            }
            if (title) {
                titleValue = '';
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
            // TITLE
            // FIELDSET
            fieldset = [], fields = [];                        
            var fieldsConfig = component.get('v.fields').trim();
            if(fieldsConfig.length == 0){
                fieldset = config.fieldset;                
            } else if (fieldsConfig.indexOf('[') == 0) {
                fieldset = JSON.parse(fieldsConfig);
            } else {
                fieldset.push({
                  "apiName": "Name",
                  "type": "subcomponent",
                  "subcomponent": "FieloELR:ShowRecord",
                  "label": {
                    "type": "default"
                  },
                  "showLabel": true
                });
                var newField, nameAndType, apiName, type;
                var fieldsList = fieldsConfig.split(',');
                fieldsList.forEach(function(field){
                    nameAndType = field.split('/');
                    apiName = nameAndType[0].trim();
                    if(apiName != 'Name'){
                        type = nameAndType[1] ? nameAndType[1].trim().toLowerCase() : 'output';
                        newField = {
                            'apiName': apiName,
                            'type': type,
                            'label': {
                                "type": "default"
                            },
                            'showLabel': true
                        }
                        fieldset.push(newField);                        
                    }
                })
                if(component.get('v.showCourseProgress')){
                    fieldset.push({
                      "apiName": "FieloELR__Progress__c",
                      "type": "subcomponent",
                      "subcomponent": "FieloELR:ProgressBar",
                      "config": {
                        "layout": "bar"
                      },
                      "label": {
                        "type": "text",
                        "value": "Progress"
                      },
                      "showLabel": true
                    });
                }
            }
            component.set('v.fieldset', fieldset);
            // MODULE FIELDSET
            fieldset = [], fields = [];                        
            var moduleFieldsConfig = component.get('v.courseDetailFields').trim();
            if(moduleFieldsConfig.length == 0){
                fieldset = config.Course.fieldset;                
            } else if (moduleFieldsConfig.indexOf('[') == 0) {
                fieldset = JSON.parse(moduleFieldsConfig);
            } else {                
                var newField, nameAndType, apiName, type;
                var fieldsList = moduleFieldsConfig.split(',');
                fieldsList.forEach(function(field){
                    nameAndType = field.split('/');
                    apiName = nameAndType[0].trim();
                    type = nameAndType[1] ? nameAndType[1].trim().toLowerCase() : 'output';
                    newField = {
                        'apiName': apiName,
                        'type': type,
                        'label': {                                
                        },
                        'showLabel': true
                    }
                    fieldset.push(newField);                    
                })
                fieldset.push({
                    "apiName": "Name",
                    "type": "subcomponent",
                    "subcomponent": "FieloELR:ModuleCheck",
                    "label": {
                      "type": "label",
                      "value": "c.SuccessfullyCompleted"
                    },
                    "showLabel": true
                  })
                fieldset.push({"apiName":"TakeModule",
                               "type":"subcomponent",
                               "subcomponent":"FieloELR:TakeModule",
                               "label":{"type":"text","value":""},
                               "showLabel":false
                              })
            }            
            component.set('v.courseFieldset', fieldset);

            // MODULE RESPONSE FIELDSET
            fieldset = [], fields = [];                        
            var moduleResponseFieldsConfig = component.get('v.moduleResponseFields').trim();
            if(moduleResponseFieldsConfig.length == 0){
                fieldset = config.Course.moduleResponse;
                component.set('v.moduleResponseFields', 'FieloELR__NumberOfAttempt__c');
            } else if (moduleResponseFieldsConfig.indexOf('[') == 0) {
                fieldset = JSON.parse(moduleResponseFieldsConfig);
            } else {                
                var newField, nameAndType, apiName, type;
                var fieldsList = moduleResponseFieldsConfig.split(',');
                fieldsList.forEach(function(field){
                    nameAndType = field.split('/');
                    apiName = nameAndType[0].trim();
                    type = nameAndType[1] ? nameAndType[1].trim().toLowerCase() : 'output';
                    newField = {
                        'apiName': apiName,
                        'type': type,
                        'label': {
                            "type": "default"
                        },
                        'showLabel': true
                    }
                    fieldset.push(newField);                    
                })
            }            
            component.set('v.moduleResponseFieldset', fieldset);
            
            window.localStorage.setItem('coursesStatus', '{}');                        
        } catch(e) {
            component.set('v.error', e);
            component.set('v.showError', true);
        }            
    },
    updateMember: function(component, event, helper){        
        var member = event.getParam('member');        
        component.set('v.member', member);        
        helper.loadCourses(component, event, helper, 0);        
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
        component.set('v.showModuleResponse', false); 
        component.set('v.showCourse', true);            
    },
    showCoursesList: function(component, event, helper){
        component.set('v.showMyCourses', true);        
        component.set('v.showCourse', false); 
    },
    paginator: function(component, event, helper){
        var offset = event.getParam("offset");        
        helper.loadCourses(component, event, helper, offset);
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
    }
})