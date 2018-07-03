({
    doInit : function(component, event, helper) {
        try{
            helper.getFilterFieldSet(component);
            helper.getCourseFieldSet(component);
            helper.getConfiguration(component);
            var title, fields, fieldset;
        } catch(e) {
            component.set('v.error', e);
            component.set('v.showError', true);
        }
    },
    getFieldSet: function(component, event, helper) {
        try{
            console.log('getFieldsetAction');
            var config = component.get('v.configDefault');
            var title, fields, fieldset;
            config = JSON.parse(config);
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
            var courseDetailFields = component.get('v.courseDetailFields').trim();
            if(fieldsConfig.length == 0){
                fieldset = config.fieldset;                
            } else if (fieldsConfig.indexOf('[') == 0) {
                fieldset = JSON.parse(fieldsConfig);
            } else {
                var newField, nameAndType, apiName, type;
                var fieldsList = fieldsConfig.split(',');
                var detailFieldsList = courseDetailFields.split(',');
                fieldsList.join(detailFieldsList);
                fieldset.push({
                    "apiName": "FieloELR__ExternalURL__c",
                    "type": "subcomponent",
                    "subcomponent": "c:CourseContent",
                    "label": {
                        "type": "default"
                    },
                    "showLabel": false,
                    "config": component.get('v.compConfig')
                });
                fieldsList.forEach(function(field){
                    nameAndType = field.split('/');
                    apiName = nameAndType[0].trim();
                    type = nameAndType[1] ? nameAndType[1].trim().toLowerCase() : 'output';
                    if (apiName.toLowerCase() != 'name' && apiName.toLowerCase() != 'fieloelr__description__c') {
                        newField = {
                            'apiName': apiName,
                            'type': type,
                            'label': {},
                            'showLabel': true
                        }
                        fieldset.push(newField);
                    } else if (apiName.toLowerCase() == 'fieloelr__description__c') {
                        fieldset.push({
                            "apiName": "FieloELR__Description__c",
                            "type": "subcomponent",
                            "subcomponent": "c:CourseDescription",
                            "label": {
                                "type": "default"
                            },
                            "showLabel": false
                        });
                    }
                });
                fieldset.push({
                    "apiName": "FieloELR__StartDate__c",
                    "type": "subcomponent",
                    "subcomponent": "c:CourseDatesContainer",
                    "label": {
                        "type": "default"
                    },
                    "showLabel": false,
                    "config": JSON.stringify(
                        {
                            "daysToBeConsideredNew": component.get('v.daysToBeConsideredNew'),
                            "daysToBeConsideredWarning": component.get('v.daysToBeConsideredWarning')
                    	}
                    )
                });
                fieldset.push({
                    "apiName": "Id",
                    "type": "subcomponent",
                    "subcomponent": "c:FieldsSection",
                    "label": {
                        "type": "default"
                    },
                    "showLabel": false,
                    "config": JSON.stringify(
                        {
                            'fields': component.get('v.courseDetailFields').trim(),
                            'fieldsMeta': component.get('v.courseDetailFieldMeta')
                        }
                    )
                });
            }
            component.set('v.fieldset', fieldset);
        } catch(e) {
            console.log(e);
        }
    },
    updateMember: function(component, event, helper){
        try{
            console.log('updateMember');
            var member = event.getParam('member');
            component.set('v.member', member);       
            window.localStorage.setItem('member', JSON.stringify(member));
            helper.loadCourses(component, event, helper, 0);   
        } catch(e) {
            console.log(e);
        }
    },
    handleFilterRecords: function(component, event, helper) {
        var dynamicFilterString = event.getParam('dynamicFilter');
        var sortByClause = event.getParam('sortByClause');
        component.set('v.dynamicFilterString', dynamicFilterString);
        component.set('v.sortByClause', sortByClause);
        helper.loadCourses(component, event, helper, 0);
    },
    handleCourseViewSelected: function(component, event, helper){
        try{
            event.stopPropagation();
            var viewName = event.getParam('viewName');
            console.log(viewName);
            component.set('v.activeViewName', viewName);
        } catch(e) {
            console.log(e);
        }
    },
    reloadCourses: function(component, event, helper){
        helper.loadCourses(component, event, helper, 0);        
    },
    paginator: function(component, event, helper){
        var offset = event.getParam("offset");        
        helper.loadCourses(component, event, helper, offset);
    }
})