({
    doInit : function(component, event, helper) {
        var item = component.get("v.item");
        if (item) {
            // name is the 'type' converted from the backend convention to the frontend convention
            var name = item.name;
            if (name) {
                helper.setIconForType(component, name);
                helper.setIconStatusForType(component, name)
            }

            var createdAt = new Date(item.createdAtUnix * 1000);
            if (item.howLongAgo) {
                component.set("v.since", item.howLongAgo);
            } else if (createdAt) {
                helper.setSinceForActivityCreatedAt(component, createdAt);
            }

            var metadata = item.metadata;
            if (metadata) {
                helper.buildMetadataComponents(component, metadata);
            }
        }
    }
})