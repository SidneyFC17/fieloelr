({
    loadCourses : function(component, event, helper, offset) {        
        var spinner = $A.get("e.FieloELR:ToggleSpinnerEvent");
        var quantity = component.get('v.quantity');
        if(spinner){
            spinner.setParam('show', true);
            spinner.fire();    
        }           
        var member = component.get('v.member');        
        var fieldset = component.get('v.fieldset');
        fieldset = helper.getFieldset(fieldset).fieldset;
        if(fieldset != ''){
            fieldset += ',FieloELR__SubscriptionMode__c';
        }
        var modulesFieldset = component.get('v.courseFieldset');
        modulesFieldset = helper.getFieldset(modulesFieldset).fieldset;
        if(modulesFieldset != ''){
            modulesFieldset += ',FieloELR__AttemptsAllowed__c';
        }
        if(member){            
            var action = component.get('c.getCourses');
            action.setParams({
                'member': member,
                'coursesFieldset': fieldset,
                'modulesFieldset': modulesFieldset,
                'quantity': quantity + 1,
                'offset': offset
            })
            // Add callback behavior for when response is received
            action.setCallback(this, function(response) {
                var spinner = $A.get("e.FieloELR:ToggleSpinnerEvent");
                var toastEvent = $A.get("e.force:showToast");
                var state = response.getState();                
                if (component.isValid() && state === 'SUCCESS') {                    
                    var member = component.get('v.member');
                    var memberId = member.Id;                                     
                    var coursesList = [];
                    var coursesWrapper = JSON.parse(response.getReturnValue());
                    var courseDependencies = {};                    
                    var coursesCompleted = {};
                    var moduleDependencies = {};                    
                    var modulesCompleted = {};
                    coursesWrapper.forEach(function(course){
                        var newCourse = course.course;
                        newCourse.courseStatus = course.courseStatus ;
                        var courseId = newCourse.Id;                                     
                        var courseCache = JSON.parse(window.localStorage.getItem('coursesStatus'));                                                                        
                        if(!courseCache[memberId]){
                            courseCache[memberId] = {};    
                        }                        
                        var showJoinBtn;                          
                        if (courseCache[memberId][courseId]) {                            
                            showJoinBtn = courseCache[memberId][courseId];                            
                        } else {                            
                            showJoinBtn = !newCourse.courseStatus && newCourse.FieloELR__SubscriptionMode__c == 'Manual';
                            courseCache[memberId][courseId] = showJoinBtn;
                            window.localStorage.setItem('coursesStatus', JSON.stringify(courseCache));                            
                        }                                                
                        newCourse.modules = course.modules;
                        newCourse.modules.forEach(function(module){
                            var courseModule = module.module;
                            if(courseModule.FieloELR__HasDependencies__c){
                                moduleDependencies[courseModule.Id] = {disabled: true, dependencies: []};
                                var dependencies = courseModule.FieloELR__KeyDependencies__c.split(',');
                                dependencies.forEach(function(dep){
                                    moduleDependencies[courseModule.Id].dependencies.push(dep.substr(0,15));
                                })
                            }                            
                            if(module.isApproved){                                
                                modulesCompleted[courseModule.Id.substr(0,15)] = true;
                            } else {
                                modulesCompleted[courseModule.Id.substr(0,15)] = false;
                            }                                                        
                            
                        })                             
                        coursesList.push(newCourse);
                        if(newCourse.FieloELR__HasDependencies__c){
                            courseDependencies[newCourse.Id] = {disabled: true, dependencies: []};
                            var dependencies = newCourse.FieloELR__KeyDependencies__c.split(',');
                            dependencies.forEach(function(dep){
                                courseDependencies[newCourse.Id].dependencies.push(dep.substr(0,15));
                            })
                        }
                        if(newCourse.courseStatus && newCourse.courseStatus.FieloELR__Progress__c == 100){
                            
                            coursesCompleted[newCourse.Id.substr(0,15)] = true;
                        } else {
                            coursesCompleted[newCourse.Id.substr(0,15)] = false;
                        }
                    });
                    for(var id in courseDependencies){
                        var res = true;
                        courseDependencies[id].dependencies.forEach(function(dep){
                            res = res && coursesCompleted[dep];
                        })
                        courseDependencies[id].disabled = !res;
                    }
                    for(var id in moduleDependencies){
                        var res = true;
                        moduleDependencies[id].dependencies.forEach(function(dep){
                            res = res && modulesCompleted[dep];
                        })
                        moduleDependencies[id].disabled = !res;
                    }
                    coursesList.forEach(function(course){
                        if(courseDependencies[course.Id]){
                            course.disabled = courseDependencies[course.Id].disabled;
                        }
                        course.modules.forEach(function(module){
                            var courseModule = module.module;
                            if(moduleDependencies[courseModule.Id]){
                                courseModule.disabled = moduleDependencies[courseModule.Id].disabled;                                
                            }
                        })
                    })
                    component.set('v.coursesList', coursesList);                    
                    component.set('v.showCourse', false);
                    component.set('v.showModule', false);                                        
                    component.set('v.showModuleResponse', false);
                    component.set('v.showCoursesList', true);                     
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
            // Send action off to be executed
            $A.enqueueAction(action);   
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
    }
})