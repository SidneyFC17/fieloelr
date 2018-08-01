({
    getConfig: function(component){
        try{
            console.log('getConfig');
            var action = component.get('c.getConfig');
            action.setParams({
                'courseId': component.get('v.recordId'),
                'memberId': component.get('v.member').Id,
                'csFields': 'FieloELR__Transactions__r,FieloELR__Trackers__r'
            });
            action.setCallback(this, function(response) {
                var spinner = $A.get("e.c:ToggleSpinnerEvent");
                var toastEvent = $A.get("e.force:showToast");
                var state = response.getState();
                if (component.isValid() && state === 'SUCCESS') {
                    var config = JSON.parse(response.getReturnValue());
                    component.set('v.compConfig',config);
                    if (config.joinedCourse) {
                        component.set('v.activeViewName', 'myCourses');
                        component.set('v.courseStatus', config.courseStatus);
                    }
                    this.getFieldSet(component);
                } else {
                    var errorMsg = response.getError()[0].message;
                    toastEvent.setParams({
                        "title": errorMsg,
                        "message": " ",
                        "type": "error"
                    });
                    toastEvent.fire();
                    if(spinner){
                        spinner.setParam('show', false);
                        spinner.fire();    
                    }           
                    
                }
            });
            $A.enqueueAction(action);
        } catch(e) {
            console.log(e);
        }
    },
    getFieldSet: function(component) {
        console.log('getFieldSet');
        var fieldset = [];
        fieldset.push({
            "apiName": "Id",
            "type": "subcomponent",
            "subcomponent": "c:CourseContent",
            "label": {
                "type": "default"
            },
            "showLabel": false,
            "config": JSON.stringify(component.get('v.compConfig'))
        });
        fieldset.push({
            "apiName": "FieloELR__Description__c",
            "type": "subcomponent",
            "subcomponent": "c:CourseDescription",
            "label": {
                "type": "default"
            },
            "showLabel": false
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
            "subcomponent": "c:CourseFieldsSection",
            "label": {
                "type": "default"
            },
            "showLabel": false,
            "config": JSON.stringify(
                {
                    'fields': component.get('v.courseDetailFields').trim(),
                    'fieldsMeta': component.get('v.courseDetailFieldMeta'),
                    'activeViewName': component.get('v.activeViewName'),
                    'courseStatus': component.get('v.courseStatus')
                }
            )
        });
        component.set('v.fieldset', fieldset);
        this.getFieldNames(component);
    },
    getFieldNames: function(component) {
        console.log('getFieldNames');
        var fieldNames = [];
        var fieldset = component.get('v.fieldset');
        fieldset.forEach(function(fieldInfo) {
            if (fieldNames.indexOf(fieldInfo.apiName)==-1) {
                fieldNames.push(fieldInfo.apiName);
            }
        });
        
        var courseDetailFields = component.get('v.courseDetailFields');
        courseDetailFields = courseDetailFields.split(',');
        courseDetailFields.forEach(function(fieldName) {
            if (fieldNames.indexOf(fieldName)==-1) {
                fieldNames.push(fieldName);
            }
        });
        
        component.set('v.fields', fieldNames.join(','));
        this.retrieveCourse(component);
    },
    retrieveCourse: function(component) {
        try{
            console.log('retrieveCourse');
            var action = component.get('c.getCourseRecord');
            var fieldNames = component.get('v.fields');
            this.requiredFields.forEach( function(fieldName) {
                if (fieldNames.toLowerCase().indexOf(fieldName.toLowerCase()) == -1) {
                    fieldNames += ',' + fieldName;
                }
            });
            action.setParams({
                'recordId': component.get('v.recordId'),
                'fields': fieldNames
            });
            action.setCallback(this, function(response) {
                try {
                    var spinner = $A.get("e.c:ToggleSpinnerEvent");
                    var toastEvent = $A.get("e.force:showToast");
                    var state = response.getState();
                    if (component.isValid() && state === 'SUCCESS') {
                        var record = JSON.parse(response.getReturnValue());
                        component.set('v.record', record);
                        component.set('v.displayCard', true);
                        this.updateButtons(component);
                    } else {
                        var errorMsg = response.getError()[0].message;
                        toastEvent.setParams({
                            "title": errorMsg,
                            "message": " ",
                            "type": "error"
                        });
                        toastEvent.fire(); 
                        if(spinner){
                            spinner.setParam('show', false);
                            spinner.fire();    
                        }
                    }   
                } catch(e) {
                    console.log(e);
                }
            });
            $A.enqueueAction(action);
        } catch(e) {
            console.log(e);
        }
    },
    updateButtons: function(component) {
        var compConfig = component.get('v.compConfig');
        var buttons = [];
        buttons.push(
            {
                "type": "subcomponent",
                "subcomponent": "c:CourseAction",
                "apiName": "Id",
                "label": {},
                "showLabel": true,
                "config": {
                    "label_viewModule": $A.get('$Label.c.ViewModule'),
                    "label_joinCourse": $A.get('$Label.c.JoinCourse'),
                    "activeViewName": component.get('v.activeViewName'),
                    "variant": "brand",
                    "memberId": component.get('v.member').Id
                }
            }
        );
        console.log(buttons);
        component.set('v.buttons', buttons);
    },
    requiredFields: [
        'Name',
        'FieloELR__SubscriptionMode__c',
        'FieloELR__Status__c',
        'FieloELR__Image__c',
        'FieloELR__ExternalURL__c',
        'FieloELR__Description__c',
        'FieloELR__StartDate__c',
        'FieloELR__EndDate__c'
    ]
})