({
    // Load expenses from Salesforce
    doInit: function(component, event, helper) {
        
        var buttons;
        var recordDetailConfig;
              
        // Create the action
        var action = component.get("c.getCourse");
        //Add Parameter with de current Page Record Id
        action.setParams({courseId:component.get("v.recordId")});
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('chegou aqui:'+ state);   
            if (state === "SUCCESS") {
                console.log(response.getReturnValue()); //DELETE]
                var courses = [];
                var course = response.getReturnValue();
                courses.push(course);
                component.set("v.course", course);
                component.set("v.courses", courses);
                console.log(courses)
            	helper.setFieldSet(component);
                helper.setRecordConfig(component);
                helper.setButtons(component);
            }
            
            
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);

        
    }
})