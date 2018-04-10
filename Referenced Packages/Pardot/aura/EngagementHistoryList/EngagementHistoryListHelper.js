({
	UNSUPPORTED_ENTITY : "This component is only supported on Lead, Contact, and Person Account record pages",
	GENERIC_ERROR : "An error has occurred",
	NO_HISTORY : "No engagement history to display",
	fill : function(component) {
		if (!component.get("v.recordId")) {
			this.setTextMessage(this.NO_HISTORY, component);
			return;
		}

		// record usage only for lead/contact layout
		if (component.get("v.componentMode").toLowerCase().trim() !== "custom") {
			var recordUsage = component.get("c.recordComponentUsage");
			$A.enqueueAction(recordUsage);
		}

		this.toggleSpinner(component);
		this.toggleBody(component);

		var action = component.get("c.getActions");

		if (component.get("v.componentMode").toLowerCase().trim() !== "custom") {
			component.set("v.recordType", "other");
		}

		action.setParams({
			"recordId": component.get("v.recordId"),
			"recordType": component.get("v.recordType"),
			"sObjectName": component.get("v.sObjectName")
		});

		action.setCallback(this, function(response) {
			if (!component.isValid()) {
				return;
			}

			this.toggleSpinner(component);
			this.toggleBody(component);

			if (response.getState() !== 'SUCCESS') {
				var error = response.getError();
				var message = this.GENERIC_ERROR;
				var messageParams = {};
				if (error && error.length > 0) {
					if (error[0].message === 'PardotSalesforceSSONotSet') {
						messageParams.showUnlinkedAccountMessage = true;
					} else if (error[0].message === 'PardotApiTimeoutError') {
						messageParams.showPardotApiTimeoutMessage = true;
					}
				}
				this.setMessage(message, component, messageParams);
			} else {
				var limit = component.get("v.limit");
				var data = response.getReturnValue() || [];

				component.set("v.totalPages", Math.ceil(data.length / limit));
				component.set("v.data", data);
				component.set("v.page", 1);
				component.set("v.historyComponents", []);

				if (data.length === 0) {
					this.setTextMessage(this.NO_HISTORY, component);
				} else {
					this.showActivities(component, 1);
				}
			}
		});
		$A.enqueueAction(action);
	},
	setTextMessage : function(message, component) {
		if (message && component && component.isValid()) {
			component.set('v.messageText', message);
		}
	},
	setMessage : function(message, component, params) {
		params = params || {};
		$A.createComponent("pi:ErrorMessage", {
				"title": params.title || "",
				"severity": params.severity || "error",
				"message": message,
				"showUnlinkedAccountMessage": params.showUnlinkedAccountMessage || false,
				"showPardotApiTimeoutMessage": params.showPardotApiTimeoutMessage || false
			},
			function (messageComponent, status) {
				if (status === "SUCCESS" && component.isValid()) {
					component.set("v.messageComponent", messageComponent);
				}
			}
		);
	},
	supportedObjectNames : [
		'Lead',
		'Contact',
		'Account'
	],
	checkIfSupportedObjectName : function(component) {
		var me = this;
		return new Promise(function (resolve, reject) {
			var sObjectName = component.get("v.sObjectName");
			if (me.supportedObjectNames.indexOf(sObjectName) > -1 || component.get("v.componentMode").toLowerCase().trim() === "custom") {
				if (sObjectName === 'Account') {
					var isPersonAccount = component.get("c.isPersonAccount");
					isPersonAccount.setParams({
						"recordId": component.get("v.recordId")
					});
					// 'me' is needed here because LAB requires this parameter on the setCallback function
					isPersonAccount.setCallback(me, function(d) {
						if (d.getReturnValue() !== false) {
							resolve();
						} else {
							reject('unsupportedEntity');
						}
					});
					$A.enqueueAction(isPersonAccount);
				} else {
					resolve();
				}
			} else {
				reject('unsupportedEntity');
			}
		});
	},
	createActivityComponents : function(activities, component) {
		var definitions = this.buildDefinitionsFromActivities(activities);
		$A.createComponents(definitions, function(components, status) {
			if (status === "SUCCESS" && component && component.isValid()) {
				component.set("v.historyComponents", components);
			}
		});
	},
	showActivities : function(component, page) {
		page = page || 1;
		var data = component.get("v.data");
		var limit = component.get("v.limit");
		var numOfPages = component.get("v.totalPages");
		var isLastPage = page == (numOfPages - 1) ? true : false;
		var isFirstPage = page == 2 ? true : false;
		if (page <= numOfPages) {
			var start = limit*(page - 1);
			var end = limit*page;
			if (end > data.length) {
				end = data.length;
			}
			var ehPaginator = component.find("engHistPaginator");
			ehPaginator.indexChange(start+1, end, isLastPage, isFirstPage);
			if (data.length > limit) {
				ehPaginator.setShowPaginator(true);
			}
			this.createActivityComponents(data.slice(start, end), component);
		}
	},
	buildDefinitionsFromActivities : function(activities) {
		var definitions = new Array()
		for(var i=0;i<activities.length;i++) {
			var activity = activities[i];
			definitions.push(["pi:EngagementHistoryListItem", {"item":activity}]);
		}
		return definitions;
	},
	hideMessages: function(component) {
		if (component && component.isValid()) {
			component.set('v.messageText', null);
			component.set('v.messageComponent', null);
		}
	},
	toggleSpinner: function(component) {
		var spinner = component.find("spinner");
		$A.util.toggleClass(spinner, "slds-hidden");
	},
	toggleBody: function(component) {
		var lcbody = component.find("lcbody");
		$A.util.toggleClass(lcbody, "slds-hidden");
	}
});