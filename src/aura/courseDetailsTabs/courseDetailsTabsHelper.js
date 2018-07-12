({
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