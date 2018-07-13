({
    setButtons : function(component) {
        
        var buttons = [{
            
                "type": "subcomponent",
                "subcomponent": "c:courseDetailsBtnViewModule",
                "apiName": "Name",
                "label": {},
                "showLabel": true,
                "config": {
                    "type": "btn",
                    "variant": "neutral",
                    "label": "View Modules"
            	 }
            }]
        component.set("v.buttons",buttons);     
	}, 
    setFieldSet: function(component) {
        console.log("setFieldSet CourseDetailsHelper"); //DELETE
        //FIELDSET
        try{
            var fieldList = component.get('v.fields');
            var fieldset = [];
            var nameAndType, apiName, type;
            
            //COURSE DESCRIPTION SUBCOMPONENT
            fieldset.push({
                "apiName": "FieloELR__Description__c",
                "type": "subcomponent",
                "subcomponent": "c:CourseDescription",
                "label": {
                    "type": "default"
                },
                "showLabel": false
                
            })
            //DATE SUBCOMPONENT 
            fieldset.push({
                "apiName": "FieloELR__StartDate__c",
                "type": "subcomponent",
                "subcomponent": "c:CourseDatesContainer",
                "label": {
                    "type": "default"
                },
                "showLabel": "false",
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
            
            console.log(fieldset); //DELETE
            component.set('v.fieldset', fieldset);
            this.getFieldNames(component);
        } catch(e) {
            console.log(e);
        }        
    },

    getFieldNames: function (component) {
        var fieldNames = [];
        var fieldset = component.get('v.fieldset');
        fieldset.forEach((fieldInfo) => {  
            if (fieldNames.indexOf(fieldInfo.apiName) == -1){
                fieldNames.push(fieldInfo.apiName);
            }
            
        });

        var courseDetailFields = component.get('v.courseDetailFields');
        courseDetailFields = courseDetailFields.split(' , ');
        courseDetailFields.forEach(function(fieldName){
            if(fieldNames.indexOf(fieldName) == -1) {
                fieldNames.push(fieldName);
            }
        });

        component.set('v.fields', fieldNames.join(' , '));
        console.log(fieldNames);
    }
    
/*
    getConfiguration: function (component) {
        try {
            console.log('getConfig');
            var action = component.get('c.getConfig');
            action.setCallback(this, function (response) {
                var spinner = $A.get("e.c:ToggleSpinnerEvent");
                var toastEvent = $A.get("e.force:showToast");
                var state = response.getState();
                if (component.isValid() && state === 'SUCCESS') {
                    var config = response.getReturnValue();
                    console.log(JSON.parse(config));
                    component.set('v.compConfig', config);

                    this.getCourseFieldSet(component);
                } else {
                    var errorMsg = response.getError()[0].message;
                    toastEvent.setParams({
                        "title": errorMsg,
                        "message": " ",
                        "type": "error"
                    });
                    toastEvent.fire();
                    if (spinner) {
                        spinner.setParam('show', false);
                        spinner.fire();
                    }

                }
            });
            $A.enqueueAction(action);
        } catch (e) {
            console.log(e);
        }
    } */
})