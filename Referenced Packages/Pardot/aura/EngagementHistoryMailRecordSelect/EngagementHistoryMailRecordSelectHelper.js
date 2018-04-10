({
	getRecordDetailLinkForTheme : function(component, selected) {
		return new Promise($A.getCallback(function(resolve, reject) {
			var action = component.get("c.getRecordDetailUrl");
			action.setParams({recordId:selected.Id});
			action.setCallback(this, function(response){
				if (response.getState() !== "SUCCESS") {
					reject()
				} else {
					resolve(response.getReturnValue());
				}
			})
			action.setStorable();
			$A.enqueueAction(action);
		}));
	},
	handleSelectionChange : function(component, selected) {
		if (selected !== component.get("v.selected")) {
			component.set("v.selected", selected);
			component.set("v.recordDetailLink", null);
			var handler = component.get("v.handler");
			if (selected && selected.Id && selected.Type) {
				handler.notifySelectChange(selected.Id, selected.Type);
				this.getRecordDetailLinkForTheme(component, selected)
					.then($A.getCallback(function(link) {
						if (link) {
							component.set("v.recordDetailLink", link);
						}
					})
				);
			} else {
				component.set("v.recordDetailLink", null);
				handler.notifySelectChange();
			}
		}
	},
	toggleOptions : function(component) {
		var elem = component.find('eh-record-select');
		if (elem) {
			$A.util.toggleClass(elem, 'slds-is-open');
		}
	},
	objectsAreEqual : function(a, b) {
		// traverse the object properties and do a comparison
		var aProps = Object.getOwnPropertyNames(a) || [];
		var bProps = Object.getOwnPropertyNames(b) || [];

		if (aProps.length !== bProps.length) {
			return false;
		} else {
			for (var i=0;i<aProps.length;i++) {
				var prop = aProps[i];
				if (typeof a[prop] === "object") {
					return this.objectsAreEqual(a[prop], b[prop]);
				} else if (a[prop] !== b[prop]) {
					return false;
					break;
				}
			}
		}
		return true
	},
	determineSelection : function(component, people) {
		var current = component.get("v.selected")
		if (!people || people.length === 0) {
			//no people
			return;
		}
		if (!current) {
			//no selection, grab the first
			return people[0];
		}
		//check that people contains selected
		for (var i=0;i<people.length;i++) {
			if (this.objectsAreEqual(people[i], current)) {
				return people[i];
				break;
			}
		}
		return people[0];
	},
	buildOptionComponents : function(component, people, selected) {
		/*
		* Build all of the components for the select.  This will include
		* the selectable records and the email address grouping.  There will
		* only be one email label component added and it will only be added
		* if there is a match to be rendered.  The matches will be filtered
		* by any search criteria.
		*/
		var that = this;
		return new Promise($A.getCallback(function(resolve, reject) {
			var uniqueEmails = '';
			var componentPromises = [];
			for (var i=0; i<people.length; i++) {
				var person = people[i];
				if (that.matchesSearchTerm(component, person)) {
					if (uniqueEmails.indexOf(person.Email) === -1) {
						uniqueEmails = uniqueEmails.concat(person.Email + '|');
						var attrs = {
							value: person.Email,
							class: "slds-p-around_small divider"
						}
						componentPromises.push(that.buildOptionComponent("ui:outputText", attrs));
					}
					var name = "pi:EngagementHistoryMailRecordSelectOption";
					var attrs = {
						person: person,
						index: i,
						selected: that.objectsAreEqual(person, selected)
					};
					componentPromises.push(that.buildOptionComponent(name, attrs));
				}
			}
			Promise.all(componentPromises).then(resolve).catch(reject);
		}));
	},
	buildOptionComponent : function(name, attrs) {
		return new Promise($A.getCallback(function(resolve, reject) {
			$A.createComponent(name, attrs, $A.getCallback(function(cmp, stat, err) {
				if (stat !== "SUCCESS") {
					reject(err)
				} else {
					resolve(cmp)
				}
			}))
		}));
	},
	matchesSearchTerm: function(component, person) {
		var termCmp = component.find("ehm-search-term");
		if (!termCmp) {
			return true;
		} else {
			var term = (termCmp.get("v.value") || '').toUpperCase();
			var match = false;
			if (person.Name && person.Name.toUpperCase().indexOf(term) > -1) {
				match = true;
			}
			if (person.Email && person.Email.toUpperCase().indexOf(term) > -1) {
				match = true;
			}
			return match;
		}
	}
})