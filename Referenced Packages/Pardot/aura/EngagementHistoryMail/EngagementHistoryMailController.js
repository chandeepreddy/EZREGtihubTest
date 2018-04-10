({
	doInit : function(component, event, helper) {
		if (component && component.isValid()) {
			helper.buildComponents(component).then($A.getCallback(function(cmps) {
				component.set("v.select", cmps.select);
				component.set("v.history", cmps.history);
				if (component.get("v.people")) {
					helper.loadForPeople(component, component.get("v.people"));
				}
			})).catch($A.getCallback(function(reason) {
				//error creating components
				console.log(reason);
			}));
		}
	},
	handlePeopleChanged : function(component, event, helper) {
		if (component && component.isValid()) {
			helper.loadForPeople(component, component.get("v.people"));
		}
	},
	handleSelectChange : function(component, event, helper) {
		if (component && component.isValid()) {
			var params = event.getParam("arguments");
			component.get("v.history").setRecord(params.id, params.type);
		}
	}
})