{% include "Includes/Header.stencil" %}

import Vapor

extension Client {
    private func genericRequest<T: Content>(method: HTTPMethod, url: URI, headers:  HTTPHeaders, returnType: T.Type, with client: Client) -> EventLoopFuture<T> {
        return client.send(method, headers: headers, to: url)
            .flatMapThrowing { clientResponse  in
                return try clientResponse.content.decode(returnType.self)
        }
    }
}
{% if servers %}
public enum Server {
    {% for server in servers %}
    {% if info.version %}
    public static let version = "{{ info.version }}"
    {% endif %}
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
