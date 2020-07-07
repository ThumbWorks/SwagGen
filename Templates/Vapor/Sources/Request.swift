{% include "Includes/Header.stencil" %}

import Vapor

extension Client {
   {% for response in responses %}
   func {{ type|lowerCamelCase }}(headers:  HTTPHeaders) -> EventLoopFuture<{{ response.type }}> {
      send(.{{ method | uppercase }}, headers: headers, to: "{{ path }}")
         .flatMapThrowing { clientResponse  in
                return try clientResponse.content.decode({{response.type | upperCamelCase }}.self)
      }
   }
   {% endfor %}
}


