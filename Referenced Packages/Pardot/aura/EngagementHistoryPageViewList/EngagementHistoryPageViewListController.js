({
    doInit : function(component, event, helper) {
        var showHideLink = component.find("showHidePageViews");
        showHideLink.set("v.label", component.get("v.pageViewCount") + ' (Show)');
    },
    toggle : function(component, event, helper) {
        var showHideLink = component.find("showHidePageViews");
        var label = showHideLink.get("v.label");
        if (label.indexOf("Show") !== -1) {
            showHideLink.set("v.label", label.replace("Show", "Hide"));
            helper.loadPageViews(component, component.get("v.visitId"));
        } else {
            helper.hidePageViewsSection(component);
            showHideLink.set("v.label", label.replace("Hide", "Show"));
        }
    }
})