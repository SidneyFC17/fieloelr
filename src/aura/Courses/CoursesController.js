({
    doInit : function(component, event, helper) {        
        var config = component.get('v.config');      
        if(config){
            config = JSON.parse(config);
            var fieldset = config.Fieldset;
            var courseFieldset = config.Course.Fieldset;
            component.set('v.fieldset', fieldset);
            component.set('v.courseFieldset', courseFieldset);
            component.set('v.title', config.Title);        
            component.set('v.layout', config.Layout.toLowerCase());        
            component.set('v.columns', config.Columns);        
            component.set('v.courseLayout', config.Course.Layout.toLowerCase());        
            component.set('v.courseColumns', config.Course.Columns);
            var module = config.Module;
            if(module && module.Content){            
                component.set('v.moduleContent', module.Content);                
            }
            window.localStorage.setItem('coursesStatus', '{}');
        }
    },
    updateMember: function(component, event, helper){
        var member = event.getParam('member');        
        component.set('v.member', member);                
        helper.loadCourses(component, event, helper);        
    },
    showCourse: function(component, event, helper){
        var memberId = component.get('v.member').Id;        
        var courseRecord = event.getParam('record');
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
        component.set('v.showCoursesList', false);        
        component.set('v.modules', modulesList);        
        component.set('v.showCourse', true);        
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
        component.set('v.showModuleResponse', false);
    }
})