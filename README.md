# DitoSDK
SDK iOS 

## Features

- [ x ] Initialize
- [ x ] Identify
- [ x ] Track
- [ x ] Notification
- [ x ] Offline Management

## Requirements
- iOS 11.0+
- Xcode 11.3.1+

## Installation
Para instalar o SDK Dito em seu projeto é necessário arrastar o arquivo DitoSDK.framework, disponível na pasta Framework do projeto.
## Example
Há neste repositório presente na pasta Example a forma de utilização e configuração do SDK.

### Usage example

É necessário setar o ```App Key``` e ```App secret``` do seu dashboard Dito no arquivo ```.plist``` do seu projeto, utilizar as chaves exatamente como no exemplo abaixo:

![plist](https://user-images.githubusercontent.com/76013839/105905864-5c010c00-5ff9-11eb-9961-eda5c9a62d4b.png)

#### Initialize

É necessário fazer a inicialização do SDK no arquivo ```AppDelegate.swift``` do seu projeto.

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

#### Push Notification

##### Register Device

```swift
    Dito.registerDevice(token: "My notification token", tokenType: .apple)
```
##### Unregister Device
```swift
    Dito.unegisterDevice(token: "My notification token", tokenType: .apple)
```
##### Register notification reading
    O método recebe como parâmetro um ```dictionary``` que é enviado no push. Não necessáriamente precisa ser implementado no método do delegate como no exemplo abaixo.

```swift
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Dito.notificationRead(with: userInfo)
    }
```

    É possível também obter o deepLink para direcionamento de fluxo igual ao exemplo abaixo:

```swift
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let notificationRead = Dito.notificationRead(with: userInfo)
        print(notificationRead.deepLink)
    }
``` 

## Debug mode
Para ativar os logs é necessário colocar a flag ```EnabledDebug``` ativada no ```Arguments Passed On Launch``` que fica no ```scheme``` do seu projeto.

## Author

ioasys, contato@ioasys.com.br

## License
DitoSDK is available under the MIT license. See the LICENSE file for more info.
