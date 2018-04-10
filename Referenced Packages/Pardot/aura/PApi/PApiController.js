({
    doCommand : function(component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {   
            
            var command = params.command;
            var args = params.args;
            var callback = params.callback;
			
            var action = component.get('c.doCommandRequest');
            action.setParams({command: command, args: args});
            action.setCallback(this, callback);
            $A.enqueueAction(action);   
        }
    }
})