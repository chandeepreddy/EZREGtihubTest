({
    doRemoteAction: function(component, actionName, params){
        var helper = this
        return new Promise($A.getCallback(function(resolve, reject){
            if(!component.isValid()) {
                return;
            }

            var action = component.get(actionName)
            action.setParams(params)
            action.setCallback(helper, function(response) {
                var state = response.getState()
                if(state === 'SUCCESS') {
                    resolve(response.getReturnValue())
                } else {
                    reject(response.error)
                }
            });
            $A.enqueueAction(action);
        }))
    },
    registerRemoteActionEventHander: function(component){
        var element = component.getElement()
        var helper = this;

        element.addEventListener('doRemoteActionRequest', function handle(event){
            event.stopPropagation()

            var detail = event.detail;
            var actionName = 'c.' + detail.actionName;
            var params = detail.params;
            var id = detail.id;

            helper.doRemoteAction(component, actionName, params).then(function(result){
                helper.dispatchResponseEvent(component, id, { result: result })
            }).catch(function(error){
                helper.dispatchResponseEvent(component, id, { error: error })
            })
        }, false);
    },
    dispatchResponseEvent: function(component, id, data){
        var name = 'doRemoteActionResponse'
        var detail = {
            id: id,
            result: data.result,
            error: data.error,
        }
        var eo = component.get("v.eo");
        if (eo.createCustomEvent) {
            var event = eo.createCustomEvent(name, detail);
            component.getElement().dispatchEvent(event);
        }
    }
})