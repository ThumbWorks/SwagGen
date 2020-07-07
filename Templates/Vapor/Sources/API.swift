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
