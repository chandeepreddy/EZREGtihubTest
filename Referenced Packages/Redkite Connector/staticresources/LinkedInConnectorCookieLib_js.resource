/*!
 * Cookie.js
 *  Javascript Library used to store key value pairs into a browser cookie
 *
 *  RedKite
 *  01/2010
 *
 */


function getCookie(m_key) {
    var retValue = "";
    
    if (document.cookie.length > 0) {
        var start = document.cookie.indexOf(m_key + "=");
        
        if (start != -1) {
            start = start + m_key.length + 1;
            var end = document.cookie.indexOf(";", start);
            if (end == -1) end = document.cookie.length;
            retValue = unescape(document.cookie.substring(start, end));
        }
    }
    return retValue;
}

function setCookie(m_key, m_value, m_expiredays, m_path) {
    var expireString = "";
    if (m_expiredays != null) {
        var exdate = new Date();
        exdate.setDate(exdate.getDate() + m_expiredays);
        expireString = ";expires=" + exdate.toGMTString();
    }
    var pathString = "";
    if (m_path != null) {
        pathString = ";path=" + m_path;
    }
    
    document.cookie = m_key + "=" + escape(m_value) + expireString + pathString;
}