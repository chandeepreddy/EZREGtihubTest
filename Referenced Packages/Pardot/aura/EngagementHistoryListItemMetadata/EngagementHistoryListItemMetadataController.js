({
    doInit : function(component, event, helper) {
        var value = component.get('v.value')
        var type = "ui:outputText"
        var attributes = {}

        if (typeof value === 'string'){
            attributes.value = value
            attributes.title = value
        } else if (typeof value === 'object') {
            if (value.component) {
                type = value.component
            }
            if (value.attributes) {
                attributes = value.attributes
            }
        }

        $A.createComponent(type, attributes, function(valueComponent, status, errorMessage) {
            if (status === "SUCCESS" && valueComponent && valueComponent.isValid()) {
                component.set('v.valueComponent', valueComponent)
            }
        })
    }
})