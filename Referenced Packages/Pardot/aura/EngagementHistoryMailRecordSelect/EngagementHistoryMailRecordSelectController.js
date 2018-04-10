({
	onRender : function (component, event, helper) {
		var browser = $A.get("$Browser");
		if (browser.isIE11) {
			$A.util.addClass(component, "ie11");
		}
	},
	handleSearchBoxClicked : function(component, event, helper) {
		if (component && component.isValid()) {
			helper.toggleOptions(component);
		}
	},
	handleSetPeople : function(component, event, helper) {
		if (component && component.isValid()) {
			var params = event.getParam("arguments") || {};
			var people = params.people;
			component.set("v.people", people);

			var selected = helper.determineSelection(component, people);

			helper.buildOptionComponents(component, people, selected).then($A.getCallback(function(options) {
				component.set("v.optionComponents", options);
				helper.handleSelectionChange(component, selected);
			}));
		}
	},
	handleSearchBoxChange : function(component, event, helper) {
		if (component && component.isValid()) {
			var selected = component.get("v.selected");
			var people = component.get("v.people");
			helper.buildOptionComponents(component, people, selected).then($A.getCallback(function(options) {
				if (options.length === 0) {
					var name = "ui:outputText";
					var attrs = {
						value: "No Matches"
					};
					helper.buildOptionComponent(name, attrs).then($A.getCallback(function(option) {
						component.set("v.optionComponents", [option]);
					}));
				} else {
					component.set("v.optionComponents", options);
				}
			}));
		}
	},
	handleOptionSelected : function(component, event, helper) {
		var index = event.getParam("index");
		var people = component.get("v.people");
		var selected = people[index];
		helper.toggleOptions(component);
		helper.buildOptionComponents(component, people, selected).then($A.getCallback(function(options) {
			component.set("v.optionComponents", options);
			helper.handleSelectionChange(component, selected);
		}));
	}
})