({
    getConfig: function (component) {
        try {
            console.log('getConfig');
            var action = component.get('c.getConfig');
            action.setParams({
                'recordId': component.get('v.recordId'),
                'memberId': component.get('v.member').Id,
                'csFields': 'FieloELR__Transactions__r,FieloELR__Trackers__r,FieloELR__Course_Accomplished__c'
            });
            action.setCallback(this, function (response) {
                var spinner = $A.get("e.c:ToggleSpinnerEvent");
                var toastEvent = $A.get("e.force:showToast");
                var state = response.getState();
                if (component.isValid() && state === 'SUCCESS') {
                    console.log('getConfig'+ response.getReturnValue()); //DELETE
                    var config = JSON.parse(response.getReturnValue());
                    component.set('v.compConfig', config);
                    if (config.joinedCourse) {
                        component.set('v.activeViewName', 'myCourses');
                        //component.set('v.courseStatus', config.courseStatus);
                        //console.log(config.courseStatus);//DELETE
                    }
                    console.log(JSON.stringify(config, null, 2));
                    this.loadCourseStatus(component);
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
    },


    setFieldSet: function (component) {
        console.log("setFieldSet CourseDetailsHelper"); //DELETE
        //FIELDSET
        try {
            var fieldList = component.get('v.fields');
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
                        'fieldsMeta': component.get('v.courseDetailFieldMeta'),
                        'courseStatus': component.get('v.courseStatus')
                    }
                )
            });

            console.log(fieldset); //DELETE
            component.set('v.fieldset', fieldset);
            this.getFieldNames(component);
        } catch (e) {
            console.log(e);
        }
    },

    loadCourseStatus: function (component) {
        console.log("loadCourseStatus"); //DELETE
        try {
            var courseId = component.get('v.recordId');
            var member = component.get('v.member');
            var action = component.get('c.getCourseStatus');
            var params = {
                'member': member,
                'courseId': courseId,
                'includePoints': false
            };
            action.setParams(params);
            action.setCallback(this, function (response) {
                var spinner = $A.get("e.c:ToggleSpinnerEvent");
                var toastEvent = $A.get("e.force:showToast");
                var state = response.getState();
                console.log(state); //DELETE
                var moduleResponses = JSON.parse(response.getReturnValue());
                console.log(moduleResponses); //DELETE
                if (moduleResponses.length !== 0) {
                    component.set('v.moduleResponses', moduleResponses);
                    console.log(moduleResponses[0].FieloELR__CourseStatus__r); //DELETE
                    var courseStatus = moduleResponses[0].FieloELR__CourseStatus__r;
                    if (courseStatus.length !== 0) {
                        component.set('v.courseStatus', courseStatus);
                    }
                    else {
                        console.log('Course Not Joined 1');
                    };

                } else {

                    console.log('Course Not Joined 2');
                 
                }
                this.setFieldSet(component);
            });
            $A.enqueueAction(action);
        } catch (e) {
            console.log(e);
        }
    },

    getFieldNames: function (component) {
        console.log('getFieldNames'); //DELETE
        var fieldNames = [];
        var fieldset = component.get('v.fieldset');
        fieldset.forEach((fieldInfo) => {
            if (fieldNames.indexOf(fieldInfo.apiName) == -1) {
                fieldNames.push(fieldInfo.apiName);
            }

        });

        var courseDetailFields = component.get('v.courseDetailFields');
        courseDetailFields = courseDetailFields.split(' , ');
        courseDetailFields.forEach(function (fieldName) {
            if (fieldNames.indexOf(fieldName) == -1) {
                fieldNames.push(fieldName);
            }
        });

        component.set('v.fields', fieldNames.join(' , '));
        this.retrieveCourse(component);
        console.log(fieldNames); //DELETE
    },

    retrieveCourse: function (component) {
        try {
            console.log('retrieveCourse');
            var action = component.get('c.getCourseRecord');
            var fieldNames = component.get('v.fields');
            this.requiredFields.forEach(function (fieldName) {
                if (fieldNames.toLowerCase().indexOf(fieldName.toLowerCase()) == -1) {
                    fieldNames += ',' + fieldName;
                }
            });
            action.setParams({
                'recordId': component.get('v.recordId'),
                'fields': fieldNames
            });
            action.setCallback(this, function (response) {
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
                        if (spinner) {
                            spinner.setParam('show', false);
                            spinner.fire();
                        }
                    }
                } catch (e) {
                    console.log(e);
                }
            });
            $A.enqueueAction(action);
        } catch (e) {
            console.log(e);
        }
        this.setButtons(component);
    },

    setButtons: function (component) {
        console.log('buttons'); //DELETE
        var buttons = [{
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
        }]
        component.set("v.buttons", buttons);
        this.setCardColor(component);
    },

    setCardColor: function (component) {
        var status = component.get('v.course.FieloELR__Status__c');
        console.log(status);
        if (status == 'Completed'){
            component.set('v.classNameCard', 'fielo-closed-course')
        }
    }
})