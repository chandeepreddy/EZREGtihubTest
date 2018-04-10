({
    renderIcon: function(component) {
        var prefix = "slds-";
        var svgns = "http://www.w3.org/2000/svg";
        var xlinkns = "http://www.w3.org/1999/xlink";
        var size = component.get("v.size");
        var name = component.get("v.name");
        var classname = component.get("v.class");
        var containerclass = component.get("v.containerClass");
        var category = component.get("v.category");

        var containerClassName = [
            prefix+"icon_container",
            (category && name ? prefix + "icon-" + category + "-" + name : ""),
            containerclass
        ].join(' ');
        component.set("v.containerClass", containerClassName);
        var svgpng;

        if (this.isIE()) {
            svgpng = document.createElement("img");
            svgpng.setAttribute("src", this.getPngPath(component.get("v.svgPath")));
            svgpng.setAttribute("alt", "Activity icon");
            if (size === "x-small") {
                svgpng.setAttribute("class", "ie-icons-x-small");
            } else {
                svgpng.setAttribute("class", "ie-icons");
            }
        } else {
            svgpng = document.createElementNS(svgns, "svg");
            var iconClassName = prefix+"icon "+prefix+"icon--" + size+" "+classname;
            svgpng.setAttribute("aria-hidden", "true");
            svgpng.setAttribute("class", iconClassName);
            svgpng.setAttribute("name", name);

            var shape = document.createElementNS(svgns, "use");
            shape.setAttributeNS(xlinkns, "href", component.get("v.svgPath"));
            svgpng.appendChild(shape);
        }

        var container = component.find("container").getElement();
        container.insertBefore(svgpng, container.firstChild);
    },
    isIE : function() {
        var ua = window.navigator.userAgent;
        if (ua.indexOf("Trident/7.0") > 0 || ua.indexOf("Trident/6.0") > 0 || ua.indexOf("Trident/5.0") > 0)
            return true;
        else
            return false;
    },
    getPngPath : function(svgPath) {
        return svgPath.substring(0, svgPath.indexOf('-sprite')) + '/' + svgPath.split('#')[1] + '_60.png';
    }
})