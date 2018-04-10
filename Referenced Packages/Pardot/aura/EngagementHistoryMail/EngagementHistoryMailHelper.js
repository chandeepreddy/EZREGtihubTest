({
	loadForPeople : function(component, people) {
		var emails = this.getEmailAddressesFromPeople(people);
		this.getMatches(component, emails).then($A.getCallback(function(matches) {
			if (component && component.isValid()) {
				component.get("v.select").setPeople(matches);
				if (matches.length > 0) {
					$A.util.addClass(component, "has-records");
				} else {
					$A.util.removeClass(component, "has-records");
				}
			}
		}));
	},
	getMatches : function(component, emails) {
		var that = this;
		return new Promise(function(resolve, reject) {
			var action = component.get("c.getMatches");
			action.setParams({
				"emails":emails
			});
			action.setCallback(that, function(response) {
				if (response.getState() !== "SUCCESS") {
					reject(response.getReturnValue());
				} else {
					// ensure that all email addresses have an entry
					var matches = this.mergeUnmatchedEmails(emails, response.getReturnValue());
					var sorted = [];
					// sort matches
					matches = this.sortMatches(matches);
					// add computed properties to matches
					matches = this.decorate(matches);
					// group the matches by email addresses
					var grouped = this.groupMatches(matches);
					// flatten the grouped object
					Object.keys(grouped).forEach(function(email) {
						sorted = sorted.concat(grouped[email]);
					})
					resolve(sorted);
				}
			});
			$A.enqueueAction(action);
		})
	},
	mergeUnmatchedEmails : function(emails, matches) {
		var merged = [];
		emails.forEach(function(email) {
			var included = false;
			matches.forEach(function(match) {
				if (match.Email === email) {
					included = true;
				}
			});

			if (!included) {
				merged.push({Email: email, Name: email});
			}
		});
		return merged.concat(matches);
	},
	groupMatches : function(matches) {
		// this will create an object like {email1:[records], email2:[records],...}
		// the order of the keys will match the order they appear in
		// the passed in collection
		var grouped = {};
		matches.forEach(function(match) {
			if (match.hasOwnProperty("Email")) {
				if (grouped[match.Email]) {
					grouped[match.Email].push(match);
				} else {
					grouped[match.Email] = [match];
				}
			}
		});
		return grouped;
	},
	sortMatches : function(matches) {
		// Order : LastActivity, Presense of match
		return matches.sort(function(a, b) {
			var value = 0;
			if (a.pi__last_activity__c > b.pi__last_activity__c) {
				value = -1;
			} else if (a.hasOwnProperty('Id') && !b.hasOwnProperty('Id')) {
				value = -1;
			} else if (!a.hasOwnProperty('Id') && b.hasOwnProperty('Id')) {
				value = 1
			}
			return value;
		});
	},
	decorate : function(matches) {
		return matches.map(function(match) {
			if (match.hasOwnProperty("Id")) {
				var prefix = match.Id.slice(0,3);
				switch (prefix) {
					case "003":
						match.Type = "Contact";
						break;
					case "00Q":
						match.Type = "Lead";
						break;
					default:
						break
				}
			}

			if (match.pi__last_activity__c) {
				match.pi__last_activity__c = Date.parse(match.pi__last_activity__c);
			}

			if (match.Company && match.Title) {
				match.Position = match.Title + " at " + match.Company;
			} else {
				match.Position = match.Title || match.Company;
			}

			return match;
		});
	},
	buildComponents : function(component) {
		var that = this;
		return that.buildSelectComponent(component).then($A.getCallback(function(sCmp) {
			return that.buildHistoryComponent(sCmp).then($A.getCallback(function(hCmp) {
				return {select: sCmp, history: hCmp};
			}));
		}));
	},
	buildSelectComponent : function(component) {
		return new Promise(function(resolve, reject) {
			var params = {
				people: [],
				handler: component
			};
			$A.createComponent("pi:EngagementHistoryMailRecordSelect", params, function(sCmp, stat, err) {
				if (stat !== "SUCCESS") {
					reject(err);
				} else {
					resolve(sCmp);
				}
			});
		});
	},
	buildHistoryComponent : function(sCmp) {
		return new Promise(function(resolve, reject) {
			params = {
				componentMode : "custom",
				selectComponent : sCmp,
				logo : "EH_component_Icon.png"
			};
			$A.createComponent("pi:EngagementHistoryList", params, function(hCmp, stat, err) {
				if (stat !== "SUCCESS") {
					reject(err);
				} else {
					resolve(hCmp);
				}
			});
		});
	},
	getEmailAddressesFromPeople: function(people) {
		var records = [];

		if (people.to) {
			records = records.concat(people.to);
		}
		
		if (people.cc) {
			records = records.concat(people.cc);
		}

		if (people.requiredAttendees) {
			records = records.concat(people.requiredAttendees);
		}

		if (people.optionalAttendees) {
			records = records.concat(people.optionalAttendees);
		}

		return records.map(function(record) { 
			return record.email 
		});
	}
})