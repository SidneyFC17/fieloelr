({
    selectView: function(component) {
        try{
            var viewName = component.get('v.selectedView');
            if (viewName == 'detail') {
                $A.util.removeClass(component.find('modulestab'), 'slds-is-active');
                $A.util.addClass(component.find('descriptiontab'), 'slds-is-active');
            } else {
                $A.util.addClass(component.find('modulestab'), 'slds-is-active');
                $A.util.removeClass(component.find('descriptiontab'), 'slds-is-active');
            }    
        } catch(e) {
            console.log(e);
        }
    }
    /*
    lazyLoadTabs: function (cmp, event) {
        var tab = event.getSource();
        switch (tab.get('v.id')) {
            case 'courseDescription' :
                this.injectComponent('c:', tab);
                break;
            case 'courseModules' :
                this.injectComponent('c:', tab);
                break;
        }
    },
    injectComponent: function (name, target) {
        $A.createComponent(name, {
        }, function (contentComponent, status, error) {
            if (status === "SUCCESS") {
                target.set('v.body', contentComponent);
            } else {
                throw new Error(error);
            }
        });
    }*/
})