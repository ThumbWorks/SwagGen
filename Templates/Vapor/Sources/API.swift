{% include "Includes/Header.stencil" %}

import Vapor

public struct {{ options.name }} {

    public static var safeOptionalDecoding = {% if options.safeOptionalDecoding %}true{% else %}false{% endif %}
    public static var safeArrayDecoding = {% if options.safeArrayDecoding %}true{% else %}false{% endif %}
    /// Used to encode Dates when uses as string params
    public static var dateEncodingFormatter = DateFormatter(formatString: "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
                                                            locale: Locale(identifier: "en_US_POSIX"),
                                                            calendar: Calendar(identifier: .gregorian))
}

{% if servers %}
public enum Server {

    {% if info.version %}
    public static let version = "{{ info.version }}"
    {% endif %}
    {% for server in servers %}
    {% if server.variables %}
    public static func {{ server.name }}({% for variable in server.variables %}{{ variable.name }}: String = "{{ variable.defaultValue }}"{% ifnot forloop.last %}, {% endif %}{% endfor %}) -> String {
        var url = "{{ server.url }}"
        {% for variable in server.variables %}
        url = url.replacingOccurrences(of: {{'"{'}}{{variable.name}}{{'}"'}}, with: {{variable.name}})
        {% endfor %}
        return url
    }
    {% else %}
    public static let {{ server.name }} = "{{ server.url }}"
    {% endif %}
    {% endfor %}
}
{% else %}

// No servers defined in swagger. Documentation for adding them: https://swagger.io/specification/#schema
{% endif %}
