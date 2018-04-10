({
    previousPage : function(component, event, helper) {
        var pageChange = component.getEvent("EngagementHistoryPageChange");
        helper.enableLink(component);
        if (component.get("v.isFirstPage") == true) {
            helper.disableLink(component, "first");
        } else {
            helper.enableLink(component);
        }
        event.target.blur(); //remove focus state
        pageChange.setParams({ "direction": "previous"});
        pageChange.fire();
    },
    nextPage : function(component, event, helper) {
        var pageChange = component.getEvent("EngagementHistoryPageChange");
        helper.enableLink(component);
        if (component.get("v.isLastPage") == true) {
            helper.disableLink(component, "last");
        } else {
            helper.enableLink(component);
        }
        event.target.blur(); //remove focus state
        pageChange.setParams({ "direction": "next"});
        pageChange.fire();
    },
    firstPage : function(component, event, helper) {
        var pageChange = component.getEvent("EngagementHistoryPageChange");
        helper.disableLink(component, "first");
        event.target.blur(); //remove focus state
        pageChange.setParams({ "direction": "first"});
        pageChange.fire();
    },
    indexChange: function(component, event, helper) {
        var start, end, isLastPage, isFirstPage;
        var params = event.getParam('arguments');
        if (params) {
            start = params.start;
            end = params.end;
            isLastPage = params.isLastPage;
            isFirstPage = params.isFirstPage;
            component.set("v.start", start);
            component.set("v.end", end);
            component.set("v.isLastPage", isLastPage);
            component.set("v.isFirstPage", isFirstPage);
        }
    },
    setShowPaginator: function(component, event, helper) {
        var params = event.getParam('arguments');
        var showPaginator;
        if (params) {
            showPaginator = params.showPaginator;
            var container = component.find("container");
            if (showPaginator) {
                $A.util.removeClass(container, "slds-hide");
            } else {
                $A.util.addClass(container, "slds-hide");
            }
        }
    }
})