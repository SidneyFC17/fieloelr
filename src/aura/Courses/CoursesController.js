({
    doInit : function(component, event, helper) {    

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
                            'label': {},
                            'showLabel': true
                        }
                        fieldset.push(newField);                        
                    }
                })
                fieldset.push({
                  "apiName": "JoinCourse",
                  "type": "subcomponent",
                  "subcomponent": "FieloELR:JoinCourse",
                  "label": {
                    "type": "text",
                    "value": "Join Course"
                  },
                  "showLabel": false
                })
            }
            component.set('v.fieldset', fieldset);            
            // MODULE FIELDSET
            fieldset = [], fields = [];                        
            var moduleFieldsConfig = component.get('v.courseDetailFields').trim();
            if(moduleFieldsConfig.length == 0){
                fieldset = config.fieldset;                
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
                    "apiName": "TakeModule",
                    "type": "subcomponent",
                    "subcomponent": "FieloELR:TakeModule",
                    "label": {
                      "type": "text",
                      "value": ""
                    },
                    "showLabel": false
                  })
            }            
            component.set('v.courseFieldset', fieldset);

            component.set('v.moduleContent', {
                'type': 'FieloELR__ContentType__c',
                'field': 'FieloELR__Content__c'
            })            
            window.localStorage.setItem('coursesStatus', '{}');                        
        } catch(e) {
            component.set('v.error', e);
            component.set('v.showError', true);
        }
    },
    updateMember: function(component, event, helper){
        var member = event.getParam('member');        
        component.set('v.member', member);       
        window.localStorage.setItem('member', JSON.stringify(member));         
        helper.loadCourses(component, event, helper, 0);
    },
    showCourse: function(component, event, helper, course){
        helper.setCourseInfo(component, event, helper, false);
    },
    showCoursesList: function(component, event, helper){
        helper.loadCourses(component, event, helper, 0);        
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
        helper.loadCourses(component, event, helper, 0);        
    },
    paginator: function(component, event, helper){
        var offset = event.getParam("offset");        
        helper.loadCourses(component, event, helper, offset);
    }
})