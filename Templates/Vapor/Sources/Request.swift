{% include "Includes/Header.stencil" %}

import Vapor

extension Client {
   {% for response in responses %}
   func {{ type|lowerCamelCase }}(headers:  HTTPHeaders) -> EventLoopFuture<{{ response.type }}> {
      let uri = URI(string: "\(Server.main){{ path }}")
      return send(.{{ method | uppercase }}, headers: headers, to: uri)
         .flatMapThrowing { clientResponse  in
                return try clientResponse.content.decode({{response.type | upperCamelCase }}.self)
      }
   }
   {% endfor %}
}


