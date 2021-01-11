# DitoSDK
SDK iOS 

## Features

- [ x ] Initialize
- [ x ] Identify
- [ x ] Track
- [ ] Notification
- [ ] Offline Management

## Requirements
- iOS 11.0+
- Xcode 11.3.1+

## Installation
Para instalar o SDK Dito em seu projeto é necessário arrastar o arquivo DitoSDK.framework, disponível na pasta Framework do projeto.
## Example
Há neste repositório presente na pasta Example a forma de utilização e configuração do SDK.

### Usage example

#### Initialize
```swift
import DitoSDK
DTInitialize.configure(apiKey: "yourapikey", apiSecret: "yourapisecret")
```
#### Identify
```swift
        let json = ["x": "y"]
                
        let dtuser = DTUser(name: "My name",
                          gender: .masculino,
                          email: "teste@teste.com.br",
                          birthday: birthday,
                          location: "My city",
                          createdAt: Date(),
                          json: json)
        DTInitialize.identify(id: user.id, data:dtuser)
```
#### Track
```swift
    let event = DTEvent(action: "My current event to track")
    DTInitialize.track(event: event)
```
## Author

ioasys, contato@ioasys.com.br

## License
DitoSDK is available under the MIT license. See the LICENSE file for more info.
