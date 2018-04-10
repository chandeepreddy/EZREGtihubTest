({
    BLUE_TYPES : ["Email Sent", "Opportunity Associated", "Opportunity Created", "Email Preferences Open", "Twilio", "User Voice", "Webinar Invited"],
    RED_TYPES : ["Email Hard Bounce", "Email Spam Complaint", "Email Unsubscribe", "Form Error", "Opportunity Lost", "Webinar Absent"],
    GREY_TYPES : ['Email Soft Bounce'],
    WARNING_TYPES : ["Form Error", "Email Hard Bounce", "Email Spam Complaint", "Email Unsubscribe"],

    setIconForType : function(component, type) {
        var componentAttributes = this.getComponentAttributesForType(type)
        $A.createComponent("pi:SvgIcon", componentAttributes, function(icon, status){
            if(status === "SUCCESS" && component && component.isValid()) {
                component.set("v.icon", icon)
            }
        })
    },

    setIconStatusForType : function(component, type) {
        if(this.WARNING_TYPES.indexOf(type) > -1) {
            var svgPath = $A.get('$Resource.PardotLightningDesignSystem_unversioned') + '/icons/utility-sprite/svg/symbols.svg#warning'
            $A.createComponent("pi:SvgIcon", {
                svgPath : svgPath,
                class : "slds-icon-text-default",
                size : "x-small"
            }, function(icon, status) {
                if(status === "SUCCESS" && component && component.isValid()) {
                    component.set("v.iconStatus", icon)
                }
            })
        }
    },

    getComponentAttributesForType : function(type) {

        var name = this.getNameForType(type)
        var svgPath = $A.get('$Resource.PardotLightningDesignSystem_unversioned') + this.getSvgPathForType(type)

        return {
            svgPath : svgPath,
            category : "standard",
            name : name,
            size : "small"
        }
    },

    getNameForType : function(type) {
        var name = "task"
        if(this.RED_TYPES.indexOf(type) > -1) {
            name = "event"
        } else if(this.BLUE_TYPES.indexOf(type) > -1) {
            name = "drafts"
        } else if(this.GREY_TYPES.indexOf(type) > -1) {
            name = "email"
        }
        return name
    },

    getSvgPathForType : function(type) {
        var svgPath = "/standard-sprite/svg/symbols.svg#task"
        if(/Email/.test(type)) {
            svgPath = "/standard-sprite/svg/symbols.svg#email"
        } else if(type === "Tracked Link Clicked") {
            svgPath = "/standard-sprite/svg/symbols.svg#link"
        } else if(type === "Form Error" || type === "Form Success") {
            svgPath = "/custom-sprite/svg/symbols.svg#custom18"
        } else if(type === "Form View") {
            svgPath = "/custom-sprite/svg/symbols.svg#custom21"
        } else if(type === "Landing Page View") {
            svgPath = "/standard-sprite/svg/symbols.svg#document"
        } else if(type === "File Accessed") {
            svgPath = "/standard-sprite/svg/symbols.svg#file"
        } else if(type === "Olark Live Chat") {
            svgPath = "/standard-sprite/svg/symbols.svg#feedback"
        } else if(/Opportunity/.test(type)) {
            svgPath = "/standard-sprite/svg/symbols.svg#opportunity"
        } else if(type === "Priority Page View") {
            svgPath = "/standard-sprite/svg/symbols.svg#today"
        } else if(/Search/.test(type)) {
            svgPath = "/standard-sprite/svg/symbols.svg#question_feed"
        } else if(type === "Wistia Video Viewed") {
            svgPath = "/custom-sprite/svg/symbols.svg#custom99"
        } else if(type === "Website Visit") {
            svgPath = "/standard-sprite/svg/symbols.svg#recent"
        } else if(/Webinar/.test(type) || type === "Twilio") {
            svgPath = "/custom-sprite/svg/symbols.svg#custom71"
        } else if(/Event/.test(type)) {
            svgPath = "/standard-sprite/svg/symbols.svg#event"
        } else if(type === "User Voice") {
            svgPath = "/standard-sprite/svg/symbols.svg#post"
        } else if(type === "AddThis Share") {
            svgPath = "/standard-sprite/svg/symbols.svg#social"
        }
        return '/icons' + svgPath
    },

    buildMetadataComponents : function(component, metadata) {
        var definitions = [];
        var activityType = component.get('v.item').type;
        for (var property in metadata) {
            if (metadata.hasOwnProperty(property)) {
                var value = metadata[property];
                if (value) {
                    if (activityType === 'Visit' && property === 'VisitId') {
                        definitions.push(["pi:EngagementHistoryListItemMetadata", {
                            value: 'show',
                            label: 'Page Views',
                            isVisit: true,
                            visitId: metadata['VisitId'],
                            pageViewCount: metadata['Page View Count'],
                            since: component.get("v.since")
                        }])
                    } else if (property !== 'Page View Count') {
                        definitions.push(["pi:EngagementHistoryListItemMetadata", {
                            value: value,
                            label: property
                        }]);
                    }
                }
            }
        }
        $A.createComponents(definitions, function(components, status){
            if(status === "SUCCESS" && component && component.isValid()) {
                component.set("v.metadata", components)
            }
        })
    },

    setSinceForActivityCreatedAt : function(component, createdAt) {
        var difference = new Date(Date.now() - createdAt)
        var sinceParts = []
        var isAgingComputed = false;

        var years = difference.getUTCFullYear() - 1970
        var months = difference.getUTCMonth()
        var days = difference.getUTCDate()-1
        var hours = difference.getUTCHours()
        var minutes = difference.getUTCMinutes()

        if (years > 0) {
            sinceParts.push(years + " " + (years > 1 ? "yrs" : "yr"));
            if (months > 0) {
                sinceParts.push(months + " " + (months > 1 ? "mos" : "mo"));
            }
        } else if (months > 0) {
            sinceParts.push(months + " " + (months > 1 ? "mos" : "mo"));
            if (days > 0) {
                sinceParts.push(days + " " + (days > 1 ? "days" : "day"));
            }
        } else if (days > 0) {
            sinceParts.push(days + " " + (days > 1 ? "days" : "day"));
            if (hours > 0) {
                sinceParts.push(hours + " " + (hours > 1 ? "hrs" : "hr"))
            }
        } else if (hours > 0) {
            sinceParts.push(hours + " " + (hours > 1 ? "hrs" : "hr"))
            if(minutes > 0) {
                sinceParts.push(minutes + " " + (minutes > 1 ? "mins" : "min"))
            }
        } else if (minutes > 0) {
            sinceParts.push(minutes + " " + (minutes > 1 ? "mins" : "min"))
        } else {
            sinceParts.push('seconds')
        }

        component.set("v.since", sinceParts.join(' '))
    }
})