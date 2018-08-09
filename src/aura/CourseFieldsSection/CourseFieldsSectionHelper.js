({
    getAttributes: function(component) {
        try{
            var config = JSON.parse(component.get('v.config'));
            var record = component.get('v.record');
            var activeViewName;
            var fieldMeta;
            var courseStatusList;
            var courseStatus;
            var fieldMap;
            if (config) {
                if (config.activeViewName) {
                    component.set('v.activeViewName', config.activeViewName);
                }
                if (config.fieldMeta instanceof String) {
                    config.fieldMeta = JSON.parse(config.fieldMeta);
                }
                if (config.fieldMeta) {
                    if (config.fieldMeta instanceof Array) {
                        var fieldsMeta = {};
                        config.fieldMeta.forEach(function(fieldInfo) {
                            fieldsMeta[fieldInfo.attributes.name] = fieldInfo;
                        });
                        component.set('v.fieldMeta', fieldsMeta);    
                    }
                    if (config.fieldMeta instanceof Object) {
                        component.set('v.fieldMeta', fieldsMeta);    
                    }
                }
                if (config.csFieldMeta) {
                    component.set('v.csFieldMeta', config.csFieldMeta);
                }
                if (config.courseStatus) {
                    courseStatusList = JSON.parse(config.courseStatus);
                    courseStatus = courseStatusList.filter(function(cs) {
                        return cs.FieloELR__Course__c == record.Id;
                    });
                    if (courseStatus instanceof Array) {
                        courseStatus = courseStatus[0];
                    }
                    if (courseStatus) {
                        component.set('v.courseStatus', courseStatus);
                    }
                }
            }
        } catch(e) {
            console.log(e);
        }
    }
})