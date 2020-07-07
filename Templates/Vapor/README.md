# {{ options.name }}

This is an api generated from a OpenAPI 3.0 spec with [SwagGen](https://github.com/yonaskolb/SwagGen) using a [Vapor](https://vapor.codes) specific [template](https://github.com/ThumbWorks/SwagGen/tree/ff03326935e50a5f60094dcab62ce48b14d2021f/Templates/Vapor). 

## Operation

Each operation is an extension on Vapor's [Client](https://github.com/vapor/vapor/blob/633b2a81f547383aa6becb6ba1ad011dc7174779/Sources/Vapor/Client/Client.swift) object.

## Model
Models that are sent and returned from the API are {% if options.mutableModels %}mutable{% else %}immutable{% endif %} classes. Each model conforms to Vapor's `Content` protocol.

`Required` properties are non optional and non-required are optional

All properties can be passed into the initializer, with `required` properties being mandatory.

If a model has `additionalProperties` it will have a subscript to access these by string

## Request template
The extension is used to encode, send, and decode the requests. There is a `Server.main` that uses the default base URL:

```swift
func getObject(headers:  HTTPHeaders) -> EventLoopFuture<SomeResponseType> 
```

The name of the func will be defined by the spec and is a combination of `[get|post|put|delete]<pathName>`. The return type is an `EventLoopFuture<T>` where `T` is the model defined in the `Response` on the spec.


#### Making a request
To make a request first initialize a [Request](#request) and then pass it to `makeRequest`. The `complete` closure will be called with an `APIResponse`

```swift
func makeRequest<T>(_ request: APIRequest<T>, behaviours: [RequestBehaviour] = [], queue: DispatchQueue = DispatchQueue.main, complete: @escaping (APIResponse<T>) -> Void) -> Request? {
```

Example request (that is not neccessarily in this api):

```swift

let client: Client
let headers: HTTPHeaders
client.getMyObject(headers)
      .flatMap { object in
         print(object.someCoolObjectProperty)
      }

```

#### Encoding and Decoding
Only JSON requests and responses are supported. These are encoded and decoded by `JSONEncoder` and `JSONDecoder` respectively, using Swift's `Codable` apis.
There are some options to control how invalid JSON is handled when decoding and these are available as static properties on `{{ options.name }}`:

- `safeOptionalDecoding`: Whether to discard any errors when decoding optional properties. Defaults to `true`.
- `safeArrayDecoding`: Whether to remove invalid elements instead of throwing when decoding arrays. Defaults to `true`.

Dates are encoded and decoded differently according to the swagger date format. They use different `DateFormatter`'s that you can set.
- `date-time`
    - `DateTime.dateEncodingFormatter`: defaults to `yyyy-MM-dd'T'HH:mm:ss.Z`
    - `DateTime.dateDecodingFormatters`: an array of date formatters. The first one to decode successfully will be used
- `date`
    - `DateDay.dateFormatter`: defaults to `yyyy-MM-dd`

## Models

{% for model in schemas %}
- **{{ model.type }}**
{% endfor %}

## Requests

{% for operationTag in operationsByTag %}
{% if operationTag.name != "" %}
- **{{ options.name }}.{{ options.tagPrefix }}{{ operationTag.name|upperCamelCase }}{{ options.tagSuffix }}**
	{% for operation in operationTag.operations %}
	- **{{ operation.type }}**: {{ operation.method }} `{{ operation.path | lowercase }}`
	{% endfor %}
{% else %}
{% for operation in operationTag.operations %}
- **{{ options.name }}.{{ operation.type }}**: {{ operation.method }} `{{ operation.path | lowercase }}`
{% endfor %}
{% endif %}
{% endfor %}
