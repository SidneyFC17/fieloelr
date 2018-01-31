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
            component.set('v.paging', config.paging);
            component.set('v.quantity', config.quantity);
            component.set('v.courseLayout', config.Course.layout.toLowerCase());        
            component.set('v.courseColumns', config.Course.columns);
            var module = config.Module;
            if(module && module.content){            
                component.set('v.moduleContent', module.content);                
            }
            window.localStorage.setItem('coursesStatus', '{}');
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