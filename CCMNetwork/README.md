# CCMNetwork

Módulo responsável pela camada de Network.
Frameworks utilizados: `URLSession`
  
## Instalação

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/AlexandreBCardoso/CCMNetwork.git", .upToNextMajor(from: "1.0.0"))
]
```

## Como usar?

Classe para fazer uma chamada de network utilizando o URLSession
```swift
URLSessionNetworkClient(client: URLSession.shared)
```

É possível criar a sua própria implementação utilizando o protocolo NetworkClien
```swift
public protocol NetworkClient {
    func execute(_ request: NetworkRequest, completion: @escaping(Result<Data, NetworkError>) -> Void)
}
```

E para a tratativa de erros temos enum 
```swift
public enum NetworkError: Error {
    case invalidURL
    case networkError
    case invalidStatusCode
    case noData
}
```
