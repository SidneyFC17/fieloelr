({
    doInit : function(component, event, helper) {
        try{
            helper.getAttributes(component);
            var config = JSON.parse(component.get('v.config'));
            var record = component.get('v.record');
            var activeViewName = component.get('v.activeViewName');
            var courseStatus = component.get('v.courseStatus');
            var fieldMeta = component.get('v.fieldMeta');
            var csFieldMeta = component.get('v.csFieldMeta');
            
            if (config.fields) {
                var fields = config.fields.split(',');
                var field, objectName, apiNames, pointsEarned = 0, pointField, courseField, course = [], pointFieldAdded = false;
                fields.forEach(function(fullApiName) {
                    apiNames = fullApiName.split('.');
                    if (apiNames.length == 1) {
                        objectName = 'FieloELR__Course__c';
                        field = apiNames[0];
                    } else {
                        objectName = apiNames[0];
                        field = apiNames[1];
                    }
                    courseField = {};
                    courseField.objectName = objectName;
                    courseField.name = field;
                    // COURSE
                    if (objectName.toLowerCase() == 'fieloelr__course__c') {
                        if (field == 'FieloELR__Modules__r') {
                            courseField.label = $A.get('$Label.c.Modules');
                            if (record[field]) {
                                if (courseStatus) {
                                    if (courseStatus['FieloELR__ApprovedModules__c']) {
                                        courseField.value = courseStatus['FieloELR__ApprovedModules__c'] + ' / ';
                                    } else {
                                        courseField.value = '';
                                    }
                                } else {
                                    courseField.value = '';
                                }
                                if (record[field].records) {
                                    courseField.value += record[field].records.length;
                                }
                            }
                        } else {
                            courseField.label = fieldMeta[field].attributes.label;
                            if (record[field]) {
                                courseField.value = record[field];
                            }
                        }
                        course.push(courseField);
                    }
                    if (objectName.toLowerCase() == 'fieloelr__coursestatus__c') {
                        if (field == 'FieloELR__Transactions__r' || field == 'FieloELR__Trackers__r') {
                            pointField = course.filter(function(f) {
                                return f.name == 'points';
                            });
                            if (pointField.length > 0) {
                                pointField = pointField[0]
                            } else {
                                pointField = null;
                            }
                            if (!pointField) {
                                pointField = {};
                                pointField.label = $A.get('$Label.c.PointsEarned');
                                pointField.name = 'points';
                            }
                            if (!pointsEarned) {
                                pointsEarned = 0;
                            }
                            if (courseStatus) {
                                if (courseStatus[field]) {
                                    if (courseStatus[field].records) {
                                        courseStatus[field].records.forEach(function(row) {
                                            if (field == 'FieloELR__Transactions__r') {
                                                if (row.FieloPLT__Points__c) {
                                                    pointsEarned += row.FieloPLT__Points__c;    
                                                }
                                            } else {
                                                if (row.FieloPLT__Transaction__r) {
                                                    if (row.FieloPLT__Transaction__r.FieloPLT__Points__c) {
                                                        pointsEarned += row.FieloPLT__Transaction__r.FieloPLT__Points__c;
                                                    }
                                                }
                                            }
                                        });
                                        pointField.value = pointsEarned;;
                                    }
                                }
                            }
                            if (pointField && activeViewName.toLowerCase() == 'mycourses' && !pointFieldAdded){
                                pointFieldAdded = true;
                                course.push(pointField);
                            }
                        } else if (field == 'FieloELR__Progress__c') {
                            if (courseStatus) {
                                course.push({
                                    'label': $A.get('$Label.c.Progress'),
                                    'name': field,
                                    'value': courseStatus[field]
                                });
                            }
                        } else {
                            course.push({
                                'label': csFieldMeta[field] ? csFieldMeta[field].attributes.label : field,
                                'name': field,
                                'value': courseStatus[field] ? courseStatus[field] : ''
                            });
                        }
                    }
                });
                component.set('v.fields', course);
                if(record.FieloELR__Status__c) {
                    if (record.FieloELR__Status__c == 'Scheduled') {
                        component.set('v.className', ' fielo-section--scheduled');
                    } else if(record.FieloELR__Status__c == 'Completed') {
                        component.set('v.className', ' fielo-section--completed');
                    } else {
                        component.set('v.className', ' fielo-section--active');
                        if (courseStatus) {
                            if (courseStatus.FieloELR__Progress__c) {
                                if (courseStatus.FieloELR__Progress__c >= 100) {
                                    component.set('v.className', ' fielo-section--finished');
                                }
                            }
                        }
                    }
                }
            }    
        } catch(e) {
            console.log(e);
        }
    }
})