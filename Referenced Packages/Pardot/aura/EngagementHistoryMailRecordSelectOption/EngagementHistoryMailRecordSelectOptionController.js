({
	handleRecordClick : function(component, event, helper) {
		var evt = component.getEvent("EngagementHistoryPersonSelected");
		evt.setParams({index: component.get("v.index")});
		evt.fire();
	}
})