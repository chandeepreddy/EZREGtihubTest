({
    loadPageViews : function(component, visitId) {
        var pageViewTable = component.find("pageViews");
        var spinner = component.find("spinner");
        var noData = component.find("noData");

        this.hidePageViewsSection(component);

        //If data is already loaded then do not make another api call
        if (component.get("v.loadState") === "loaded") {
            this.showPageViewsTable(component);
            return;
        } else if (component.get("v.loadState") === "empty") {
            this.showMessageWhenNoData(component);
            return;
        }

        this.showSpinner(component);

        //Make api call to load data first time
        var action = component.get("c.getActionsByVisitId");
        action.setParams({
            "id": visitId
        });
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var data = response.getReturnValue();
                if (data && data.actions && data.actions.action) {
                    var arr = [];
                    var title, url, pv, time, unixTime;
                    var pageViewsCount = data.actions.action.length;
                    if (!pageViewsCount && data.actions.action.pageView) {
                        title = null;
                        url = null;
                        pv = null;
                        time = null;
                        if (data.actions.action.pageView) {
                            pv = data.actions.action.pageView;
                            title = !pv.title || pv.title.trim() === "" ? pv.url : pv.title;
                            url = pv.url;
                            if (data.actions.action.visitDuration) {
                                unixTime = this.getMockedTime(component.get("v.since"), data.actions.action.visitDuration);
                                time = this.getTimeFromUnixTime(unixTime);
                            } else {
                                time = this.getTimeFromUnixTime(data.actions.action.createdAtUnix);
                            }
                            arr.push({
                                "page" : title,
                                "url" : url,
                                "time" : time
                            });
                        }
                    } else if (pageViewsCount > 0) {
                        for (var i = 0; i < pageViewsCount; i++) {
                            title = null;
                            url = null;
                            pv = null;
                            time = null;
                            if (data.actions.action[i].pageView) {
                                pv = data.actions.action[i].pageView;
                                title = !pv.title || pv.title.trim() === "" ? pv.url : pv.title;
                                url = pv.url;
                                if (data.actions.action[i].visitDuration) {
                                    unixTime = this.getMockedTime(component.get("v.since"), data.actions.action[i].visitDuration);
                                    time = this.getTimeFromUnixTime(unixTime);
                                } else {
                                    time = this.getTimeFromUnixTime(data.actions.action[i].createdAtUnix);
                                }
                                arr.push({
                                    "page" : title,
                                    "url" : url,
                                    "time" : time
                                });
                            }
                        }
                    }
                    if (arr.length > 0) {
                        component.set("v.pageViews", arr);
                        component.set("v.loadState", "loaded");
                        this.hideSpinner(component);
                        this.showPageViewsTable(component);
                        return;
                    }
                }
                component.set("v.loadState", "empty");
                this.showMessageWhenNoData(component);
            } else if (response.getState() === 'ERROR') {
                var error = response.getError();
                var message = "An error has occurred";
                var messageParams = {};
                this.hideSpinner(component);
                if (error && error.length > 0) {
                    if (error[0].message === 'PardotSalesforceSSONotSet') {
                        messageParams.showUnlinkedAccountMessage = true;
                    } else if (error[0].message === 'PardotApiTimeoutError') {
                        messageParams.showPardotApiTimeoutMessage = true;
                    }
                }
                this.setErrorMessage(message, component, messageParams);
            }
        });
        $A.enqueueAction(action);
    },
    setErrorMessage : function(message, component, params) {
        params = params || {};
        $A.createComponent("pi:ErrorMessage", {
                "title": params.title || "",
                "severity": params.severity || "error",
                "message": message,
                "showUnlinkedAccountMessage": params.showUnlinkedAccountMessage || false,
                "showPardotApiTimeoutMessage": params.showPardotApiTimeoutMessage || false
            },
            function (errorMessage, status) {
                if (status === "SUCCESS") {
                    component.set("v.errorComponent", errorMessage);
                    var errorMessageContainer = component.find("pageViewListErrorMessage");
                    $A.util.removeClass(errorMessageContainer, "hide");
                }
            }
        );
    },
    hidePageViewsSection : function (component) {
        var dataTable = component.find("pageViews");
        var noData = component.find("noData");
        var spinner = component.find("spinner");
        var errorMessage = component.find("pageViewListErrorMessage");
        $A.util.addClass(dataTable, "hide");
        $A.util.addClass(noData, "hide");
        $A.util.addClass(spinner, "slds-hide");
        $A.util.addClass(errorMessage, "hide");
    },
    showPageViewsTable : function (component) {
        var dataTable = component.find("pageViews");
        var noData = component.find("noData");
        var spinner = component.find("spinner");
        $A.util.removeClass(dataTable, "hide");
        $A.util.addClass(noData, "hide");
        $A.util.addClass(spinner, "slds-hide");
    },
    showSpinner : function (component) {
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner : function (component) {
        var spinner = component.find("spinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    showMessageWhenNoData : function (component) {
        var spinner = component.find("spinner");
        var noData = component.find("noData");
        var dataTable = component.find("pageViews");
        $A.util.addClass(spinner, "slds-hide");
        $A.util.removeClass(noData, "hide");
        $A.util.addClass(dataTable, "hide");
    },
    getTimeFromUnixTime : function (unixTime) {
        var date = new Date(unixTime * 1000)
        var hour = date.getHours();
        var minute = date.getMinutes();
        var amPM = (hour > 11) ? "pm" : "am";
        if(hour > 12) {
            hour -= 12;
        } else if(hour == 0) {
            hour = "12";
        }
        if(minute < 10) {
            minute = "0" + minute;
        }
        if(hour < 10) {
            hour = "0" + hour;
        }
        return hour + ":" + minute + amPM;
    },
    getMockedTime : function(since, duration) {
        var secondsAgo = this.getSecondsFromUnits(since);
        var currentTime = Math.floor( Date.now() / 1000 );
        var fromTime = currentTime - secondsAgo;
        var toTime = fromTime + duration;
        return this.getRandomTime(fromTime, toTime);

    },
    getSecondsFromUnits : function(howLongAgo) {
        var arr = howLongAgo.split(' ');
        var index;
        index = arr.indexOf('day');
        if (index === -1) {
            index = arr.indexOf('days');
        }
        var days = index > -1 ? arr[index-1] : 0;

        index = arr.indexOf('hr');
        if (index === -1) {
            index = arr.indexOf('hrs');
        }
        var hours = index > -1 ? arr[index-1] : 0;

        index = arr.indexOf('min');
        if (index === -1) {
            index = arr.indexOf('mins');
        }
        var minutes = index > -1 ? arr[index-1] : 0;

        index = arr.indexOf('second');
        if (index === -1) {
            index = arr.indexOf('seconds');
        }
        var seconds = index > -1 ? arr[index-1] : 0;

        return days*86400 + hours*3600 + minutes*60 + seconds;
    },
    getRandomTime : function (min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }
})