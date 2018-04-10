({
    afterRender: function (component, helper) {
        this.superAfterRender();
        if (component.get("v.isVisit") == true) {
            var visitId = component.get("v.visitId");
            var pageViewCount = component.get("v.pageViewCount");
            var since = component.get("v.since");
            $A.createComponent(
                "pi:EngagementHistoryPageViewList",
                {
                    "visitId": visitId,
                    "pageViewCount": pageViewCount,
                    "since": since
                },
                function(pageViewTable, status, errorMessage){
                    if (status === "SUCCESS" && component && component.isValid()) {
                        var body = component.get("v.body");
                        body.push(pageViewTable);
                        component.set("v.body", body);
                    }
                }
            );
        }
    }
})