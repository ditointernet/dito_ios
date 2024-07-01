# DitoSDK
SDK iOS 

## Features

- [ x ] Initialize
- [ x ] Identify
- [ x ] Conversão SHA1
- [ x ] Track
- [ x ] Notification
- [ x ] Tratamento de Deeplink
- [ x ] Offline Management

## Requirements
- iOS 11.0+
- Xcode 11.3.1+

## Installation

### Cocoapods
Para instalar a versão mais recente do SDK Dito em seu projeto através do Cocoapods, adicione o pod em seu podfile:

pod 'DitoSDK'

Para instalar uma versão específica, inclua o número da versão:

pod 'DitoSDK', '~> 1.0.0'

Em alguns casos, pode ser necessário utilizar uma branch específica para algum ajuste ou correção pontual ou urgente. Neste caso, basta especificar a branch:

pod 'DitoSDK', :git => 'https://github.com/ditointernet/dito_ios.git', :branch => 'NOME_DA_BRANCH'

ps.: Para incluir cocoapods em um projeto, [siga o tutorial] (https://guides.cocoapods.org/using/using-cocoapods.html)


Após adição no podfile, execute o comando pod install --repo-update para instalar e utilizar o pod no projeto.

### Manual

Para instalar o SDK Dito em seu projeto de forma manual, sem utilizar cocoapods, é necessário arrastar o arquivo DitoSDK.framework, disponível na pasta Framework do projeto.

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

#### Conversão SHA1
```swift
    let sha1String = Dito.sha1(for: "String to convert")
```

#### Track
```swift
    let event = DitoEvent(action: "my-current-event-to-track")
    Dito.track(event: event)
```

#### Push Notification

Para captura e tratamento de notificações, é necessário incluir no projeto a função inicial, responsável por capturar notificações nativas.
A função pode ser encontrada no projeto de exemplo, e executa o processo de leitura e notificação interna sobre o push recebido.
Deve ser incluída na classe 'AppDelegate' do lado nativo do projeto

```swift
    func application(_ application: UIApplication, 
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any], 
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //Ver sessão 'tratamento de deeplink' para definição interna desta função
    }

```

##### Tratamento de Deeplink

O projeto conta com opção para receber o deeplink de notificações durante a leitura das mesmas. 
Para isso, basta incluir o envio da closure na chamada notificationRead. 

```swift
Dito.notificationRead(with: userInfo, callback: { deeplink in 
							print(deeplink) })
```

No exemplo, a variável. “deeplink” é retornada com o valor do deeplink, e a ação de print é executada no bloco.
A inclusão é opcional, e pode ser omitida caso não haja necessidade de captura de deeplink

```swift
Dito.notificationRead(with: userInfo)
```

De forma completa, há duas opções para a função adicionada ao AppDelegate.

Com captura de Deeplink: 
```swift
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Dito.notificationRead(with: userInfo, callback: { deeplink in print(deeplink) })
    }

```

Ou sem captura de deeplink
```swift
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Dito.notificationRead(with: userInfo)
    }
```
##### Register Device

```swift
    Dito.registerDevice(token: "My notification token", tokenType: .apple)
```
##### Unregister Device
```swift
    Dito.unregisterDevice(token: "My notification token", tokenType: .apple)
```
##### Register notification reading

O método recebe como parâmetro um ```dictionary``` que é enviado no push. Não necessáriamente precisa ser implementado no método do delegate como no exemplo abaixo:

```swift
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Dito.notificationRead(with: userInfo)
    }
```

Também é possível obter o ```deepLink``` para direcionamento de fluxo como no exemplo abaixo:

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
