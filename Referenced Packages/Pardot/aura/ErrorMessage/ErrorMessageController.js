({
	doInit : function(component, event, helper) {
		var params = {
			iconName : "utility:warning",
			size : "x-small"
		}
		$A.createComponent('lightning:icon', params, function(icon, status, error) {
			if (status === "SUCCESS" && component.isValid()) {
				component.set("v.icon", icon);
			}
		})
	}
})