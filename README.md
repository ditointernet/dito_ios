# DitoSDK
SDK iOS 

## Features

- [ x ] Initialize
- [ x ] Identify
- [ x ] Track
- [ ] Notification
- [ x ] Offline Management

## Requirements
- iOS 11.0+
- Xcode 11.3.1+

## Installation
Para instalar o SDK Dito em seu projeto é necessário arrastar o arquivo DitoSDK.framework, disponível na pasta Framework do projeto.
## Example
Há neste repositório presente na pasta Example a forma de utilização e configuração do SDK.

### Usage example
É necessário fazer a inicialização do SDK no arquivo AppDelegate.swift do seu projeto.

#### Initialize
```swift
import DitoSDK

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    ...
        
    Dito.shared.configure()
        
    ...
}
```
#### Identify
```swift
        let customData = ["x": "y"]
                
        let ditoUser = DitoUser(name: "My name",
                          gender: .masculino,
                          email: "teste@teste.com.br",
                          birthday: Date(),
                          location: "My city",
                          createdAt: Date(),
                          customData: customData)
        Dito.identify(id: "My user id", data: ditoUser)
```
#### Track
```swift
    let event = DitoEvent(action: "my-current-event-to-track")
    Dito.track(event: event)
```

## Debug mode
Para ativar os logs é necessário colocar a flag ```EnabledDebug``` ativada no Arguments Passed On Launch que fica no scheme do seu projeto.

## Author

ioasys, contato@ioasys.com.br

## License
DitoSDK is available under the MIT license. See the LICENSE file for more info.
