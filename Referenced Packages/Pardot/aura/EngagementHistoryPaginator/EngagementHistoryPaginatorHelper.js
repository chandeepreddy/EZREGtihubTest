({
    disableLink : function(cmp, page) {
        var firstPageLink = cmp.find('firstPageLink');
        var nextFiveLink = cmp.find('nextFiveLink');
        var prevFiveLink = cmp.find('previousPageLink');
        if (page === 'first') {
            $A.util.addClass(firstPageLink, 'disable-click');
            $A.util.addClass(prevFiveLink, 'disable-click');
            $A.util.removeClass(nextFiveLink, 'disable-click');
        } else if (page === 'last') {
            $A.util.removeClass(firstPageLink, 'disable-click');
            $A.util.removeClass(prevFiveLink, 'disable-click');
            $A.util.addClass(nextFiveLink, 'disable-click');
        }
    },
    enableLink : function(cmp) {
        var firstPageLink = cmp.find('firstPageLink');
        var nextFiveLink = cmp.find('nextFiveLink');
        var prevFiveLink = cmp.find('previousPageLink');
        $A.util.removeClass(firstPageLink, 'disable-click');
        $A.util.removeClass(prevFiveLink, 'disable-click');
        $A.util.removeClass(nextFiveLink, 'disable-click');
    }
})