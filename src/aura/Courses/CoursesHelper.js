({
    getFilterFieldSet: function(component) {
        try{
            console.log('getFilterFieldSet');
            var action = component.get('c.getFilterFieldset');
            action.setParams({
                'objectName': 'FieloELR__Course__c',
                'fieldNames': component.get('v.courseFilterFields'),
                'rangedFields': component.get('v.courseRangedFilterFields'),
                'useStandardStatusList': false
            });
            action.setCallback(this, function(response) {
                var spinner = $A.get("e.c:ToggleSpinnerEvent");
                var toastEvent = $A.get("e.force:showToast");
                var state = response.getState();                
                if (component.isValid() && state === 'SUCCESS') {                    
                    var objectInfo = JSON.parse(response.getReturnValue());
                    component.set('v.filterFieldSet',objectInfo.fields);
                }else {
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
    getCourseFieldSet: function(component) {
        try{
            console.log('getFilterFieldSet');
            var action = component.get('c.getCourseFieldsData');
            action.setParams({
                'objectName': 'FieloELR__Course__c',
                'fieldNames': component.get('v.courseDetailFields')
            });
            action.setCallback(this, function(response) {
                var spinner = $A.get("e.c:ToggleSpinnerEvent");
                var toastEvent = $A.get("e.force:showToast");
                var state = response.getState();                
                if (component.isValid() && state === 'SUCCESS') {                    
                    var objectInfo = JSON.parse(response.getReturnValue());
                    console.log(objectInfo.fields);
                    component.set('v.courseDetailFieldMeta',objectInfo.fields);
                    
                    var getFieldsetAction = component.get('c.getFieldSet');
                    $A.enqueueAction(getFieldsetAction);
                }else {
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
    loadCourses : function(component, event, helper, offset) {
        try{
            var spinner = $A.get("e.c:ToggleSpinnerEvent");
            var quantity = component.get('v.quantity');
            if(spinner){
                spinner.setParam('show', true);
                spinner.fire();    
            }           
            var member = component.get('v.member');
            var fieldset = component.get('v.fieldset');
            fieldset = helper.getFieldset(fieldset).fieldset;
            if(fieldset != ''){
                fieldset += ',FieloELR__SubscriptionMode__c,FieloELR__Status__c';
            }
            if(fieldset.toLowerCase().indexOf('fieloelr__image__c') == -1) {
                fieldset += ',FieloELR__Image__c'
            }
            if(fieldset.toLowerCase().indexOf('fieloelr__externalurl__c') == -1) {
                fieldset += ',FieloELR__ExternalURL__c'
            }
            if(fieldset.toLowerCase().indexOf('fieloelr__description__c') == -1) {
                fieldset += ',FieloELR__Description__c'
            }
            if(fieldset.toLowerCase().indexOf('fieloelr__startdate__c') == -1) {
                fieldset += ',FieloELR__StartDate__c'
            }
            if(fieldset.toLowerCase().indexOf('fieloelr__enddate__c') == -1) {
                fieldset += ',FieloELR__EndDate__c'
            }
            var modulesFieldset = component.get('v.courseFieldset');
            modulesFieldset = helper.getFieldset(modulesFieldset).fieldset.join(',');        
            if(modulesFieldset != '' && modulesFieldset.indexOf('FieloELR__AttemptsAllowed__c') == -1){
                modulesFieldset += ',FieloELR__AttemptsAllowed__c';
            }
            var dynamicFilterString = component.get('v.dynamicFilterString');
            console.log(dynamicFilterString);
            var sortByClause = component.get('v.sortByClause');
            if(member){            
                var action = component.get('c.getCourses');
                var params = {
                    'member': member,
                    'coursesFieldset': fieldset,
                    'modulesFieldset': modulesFieldset,
                    'quantity': quantity + 1,
                    'offset': offset,
                    'sortByClause': sortByClause,
                    'dynamicFilter': dynamicFilterString
                };
                action.setParams(params);
                // Add callback behavior for when response is received
                action.setCallback(this, function(response) {
                    var spinner = $A.get("e.c:ToggleSpinnerEvent");
                    var toastEvent = $A.get("e.force:showToast");
                    var state = response.getState();                
                    if (component.isValid() && state === 'SUCCESS') {                    
                        var member = component.get('v.member');
                        var memberId = member.Id;                                     
                        var coursesList = JSON.parse(response.getReturnValue());
                        component.set('v.coursesList', coursesList);
                        component.set('v.showCourse', false);
                        component.set('v.showModule', false);
                        component.set('v.showModuleResponse', false);
                        component.set('v.showCoursesList', true);
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
                // Send action off to be executed
                $A.enqueueAction(action);   
            }            
        } catch(e) {
            console.log(e);
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
                if(field.apiName != 'Name'){
                    fields.fieldset.push(field.apiName);        
                }                
            } else {
                fields.subcomponents.push(field);    
            }           
        })      
        return fields;
    },
    setCourseInfo: function(component, event, helper, courseInfo){        
        var memberId = component.get('v.member').Id;
        var courseRecord;
        if(courseInfo){
            courseRecord = courseInfo;   
        } else {
            courseRecord = event.getParam('record');    
        }        
        var courseId = courseRecord.Id;
        var modulesList = [];
        var modules = courseRecord.modules;
        var courseCache = JSON.parse(window.localStorage.getItem('coursesStatus'));
        for(var i = 0; i < modules.length; i++){
            var newModule = modules[i].module;
            newModule.moduleResponses = modules[i].moduleResponses;
            newModule.numberOfAttempts = modules[i].numberOfAttempts;
            newModule.isApproved = modules[i].isApproved;            
            newModule.showBtn = !courseCache[memberId][courseId];
            modulesList.push(newModule);
        }                        
        component.set('v.courseTitle', courseRecord.Name);        
        component.set('v.modules', modulesList);        
        component.set('v.showCourse', true);
        component.set('v.showCoursesList', false);        
        window.localStorage.setItem('actualCourse', JSON.stringify(courseRecord));
    },
    getConfiguration: function(component) {
        try{
            console.log('getConfig');
            var action = component.get('c.getConfig');
            action.setCallback(this, function(response) {
                var spinner = $A.get("e.c:ToggleSpinnerEvent");
                var toastEvent = $A.get("e.force:showToast");
                var state = response.getState();                
                if (component.isValid() && state === 'SUCCESS') {                    
                    var config = response.getReturnValue();
                    console.log(JSON.parse(config));
                    component.set('v.compConfig',config);
                    
                    this.getCourseFieldSet(component);
                }else {
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
    }
})