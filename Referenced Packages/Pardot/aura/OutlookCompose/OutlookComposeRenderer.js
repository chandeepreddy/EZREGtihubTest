({
    afterRender: function(component, helper){
        var eo = component.get("v.eo");
        helper.registerRemoteActionEventHander(component);
        if(eo.init) {
            eo.init(component.getElement());
        }
    }
})