# DitoSDK para iOS

<p align="center">
  <img src="https://user-images.githubusercontent.com/76013839/105905864-5c010c00-5ff9-11eb-9961-eda5c9a62d4b.png" alt="Dito SDK" width="200"/>
</p>

<p align="center">
  SDK iOS oficial da Dito para integração com a plataforma de CRM e Marketing Automation
</p>

<p align="center">
  <a href="#sobre">Sobre</a> •
  <a href="#features">Features</a> •
  <a href="#requirements">Requirements</a> •
  <a href="#installation">Installation</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#api-reference">API Reference</a> •
  <a href="#push-notifications">Push Notifications</a> •
  <a href="#troubleshooting">Troubleshooting</a>
</p>

---

## 📋 Sobre

O **DitoSDK** é a biblioteca oficial da Dito para aplicações iOS, permitindo que você integre complemente seu app com a plataforma de CRM e Marketing Automation da Dito.

Com o DitoSDK você pode:

- 🔐 **Identificar usuários** e sincronizar seus dados com a plataforma
- 📊 **Rastrear eventos** e comportamentos dos usuários
- 🔔 **Gerenciar notificações push** via Firebase Cloud Messaging
- 🔗 **Processar deeplinks** de notificações
- 💾 **Gerenciar dados offline** automaticamente
- 🔒 **Converter emails para SHA1** facilmente

---

## ✨ Features

- ✅ **Identificação de Usuários** - Sincronize dados completos do usuário com a plataforma Dito
- ✅ **Tracking de Eventos** - Rastreie eventos personalizados e comportamentos
- ✅ **Push Notifications** - Integração completa com Firebase Cloud Messaging (FCM)
- ✅ **Notificações em Background** - Capture notificações mesmo com app em background
- ✅ **Deeplink Handling** - Processe deeplinks de notificações automaticamente
- ✅ **Offline Management** - Gerenciamento automático de operações offline
- ✅ **SHA1 Conversion** - Utilitário para hash de emails
- ✅ **Thread-Safe** - Compatível com iOS 16+ (CoreData thread-safety)
- ✅ **Firebase Integration** - Integração nativa com Firebase
- ✅ **Suporte a iOS 13+** - Funciona em versões antigas de iOS

---

## 📱 Requirements

| Requisito | Versão Mínima |
|-----------|--------------|
| iOS | 13.0+ |
| Xcode | 14.0+ |
| Swift | 5.5+ |
| Firebase iOS SDK | 9.0+ |
| CocoaPods | 1.11.0+ |

---

## 📦 Installation

### Opção 1: Via CocoaPods (Recomendado)

#### 1.1 Adicione o DitoSDK ao Podfile

```ruby
pod 'DitoSDK', :git => 'https://github.com/ditointernet/dito_ios.git', :branch => 'main'
```

#### 1.2 Instale as dependências

```bash
pod install --repo-update
```

#### 1.3 Abra o workspace

```bash
open YourProject.xcworkspace
```

> ℹ️ **Importante**: Sempre use `.xcworkspace` após instalar CocoaPods, nunca abra o `.xcodeproj` diretamente.

**Mais informações sobre CocoaPods**: [Guide to Using CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

### Opção 2: Instalação Manual

1. Clone o repositório
2. Arraste `DitoSDK.framework` para seu projeto
3. Adicione `DitoSDK.framework` em **Frameworks, Libraries, and Embedded Content**
4. Certifique-se que está marcado como **Embed & Sign**

---

## 🎯 Quick Start

### Passo 1: Configure o Firebase no projeto

**Antes de usar o DitoSDK, você deve configurar Firebase no seu app.**

#### 1.1 Adicione Firebase ao Podfile

```ruby
pod 'Firebase/Core'
pod 'Firebase/Messaging'
```

#### 1.2 Baixe o GoogleService-Info.plist

1. Acesse [Firebase Console](https://console.firebase.google.com)
2. Selecione seu projeto
3. Vá para **Project Settings** → **Your Apps**
4. Clique em seu app iOS
5. Clique no botão **Download GoogleService-Info.plist**
6. Adicione o arquivo ao seu projeto Xcode (marque **Copy items if needed**)

**Documentação completa**: [Firebase iOS Setup](https://firebase.google.com/docs/ios/setup)

### Passo 2: Configure as credenciais Dito no Info.plist

O DitoSDK lê as credenciais do seu `Info.plist`. Adicione as seguintes chaves:

```xml
<dict>
    ...
    <key>DITO_API_KEY</key>
    <string>sua_api_key_aqui</string>
    <key>DITO_API_SECRET</key>
    <string>seu_api_secret_aqui</string>
    ...
</dict>
```

Você pode encontrar essas credenciais no [Dashboard Dito](https://dashboard.dito.com.br)

### Passo 3: Configure o AppDelegate

```swift
import UIKit
import Firebase
import FirebaseMessaging
import DitoSDK
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    var fcmToken: String?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // ⚠️ ORDEM IMPORTANTE para iOS 18+
        // 1. Configure Firebase PRIMEIRO
        FirebaseApp.configure()

        // 2. Configure Messaging delegate
        Messaging.messaging().delegate = self

        // 3. Inicialize DitoSDK
        Dito.shared.configure()

        // 4. Configure notificações
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications(application: application)

        return true
    }

    private func registerForPushNotifications(application: UIApplication) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]

        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions
        ) { granted, error in
            if let error = error {
                print("❌ Erro ao solicitar autorização: \(error.localizedDescription)")
                return
            }

            guard granted else {
                print("⚠️ Permissão de notificações não concedida")
                return
            }

            print("✅ Permissão de notificações concedida")
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }

    // MARK: - Remote Notifications (APNS Token)

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // ⚠️ CRÍTICO: Defina APNS token ANTES de usar FCM (iOS 18+)
        Messaging.messaging().apnsToken = deviceToken
        print("✅ APNS token registrado")
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("❌ Falha ao registrar para remote notifications: \(error.localizedDescription)")
    }

    // MARK: - Background Notification (Silent / Content-Available)

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        // Registra leitura de notificação em background
        if let token = self.fcmToken {
            Dito.notificationRead(with: userInfo, token: token)
        } else {
            // Se token não está armazenado, obtém do Firebase
            Messaging.messaging().token { [weak self] token, error in
                if let token = token {
                    self?.fcmToken = token
                    Dito.notificationRead(with: userInfo, token: token)
                    completionHandler(.newData)
                } else {
                    print("⚠️ Token FCM indisponível: \(error?.localizedDescription ?? "unknown")")
                    completionHandler(.noData)
                }
            }
            return
        }
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(.newData)
    }
}

// MARK: - Notification Center Delegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    /// Chamado quando a notificação chega com o app em FOREGROUND
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        
        // Notifique o Firebase que recebeu a mensagem
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Mostre o banner mesmo com app em foreground
        if #available(iOS 14.0, *) {
            completionHandler([[.banner, .list, .sound, .badge]])
        } else {
            completionHandler(.alert)
        }
    }

    /// Chamado quando o usuário CLICA na notificação (app em foreground ou background)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        print("🔔 Notificação tocada: \(userInfo)")

        // Registra que a notificação foi lida (mesmo se já foi em background)
        Messaging.messaging().token { [weak self] fcmToken, error in
            if let fcmToken = fcmToken {
                Dito.notificationRead(with: userInfo, token: fcmToken)
            }
            // Registra que foi clicada
            Dito.notificationClick(with: userInfo)
        }

        // Notifique o Firebase
        Messaging.messaging().appDidReceiveMessage(userInfo)

        completionHandler()
    }
}

// MARK: - Messaging Delegate

extension AppDelegate: MessagingDelegate {
    
    /// Chamado quando o token FCM é atualizado
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        guard let fcmToken = fcmToken else { return }
        
        print("🔑 Novo token FCM: \(fcmToken)")
        self.fcmToken = fcmToken
        
        // Registra o token no DitoSDK
        Dito.registerDevice(token: fcmToken)
    }
}
```

> 📚 **Documentação Firebase**: [Firebase Cloud Messaging for iOS](https://firebase.google.com/docs/cloud-messaging/ios/client)

---

## 📚 API Reference

### Dito.configure()

Inicializa o DitoSDK. **Deve ser chamado no AppDelegate**.

```swift
// No AppDelegate, após FirebaseApp.configure()
Dito.shared.configure()
```

- ✅ Carrega credenciais do Info.plist
- ✅ Inicializa gerenciador de persistência offline
- ✅ Inicia monitor de conectividade

**Erro comum**: Chamar `configure()` ANTES de `FirebaseApp.configure()` causará erro

---

### Dito.identify(id:data:)

**Identifica um usuário na plataforma Dito.**

Deve ser chamado assim que você sabe quem é o usuário (após login, por exemplo).

#### Parâmetros

- `id` (String): ID único do usuário SHA1 (normalmente hash do email)
- `data` (DitoUser): Dados completos do usuário

#### Exemplo

```swift
import DitoSDK

// Crie um usuário com dados completos
let customData = [
    "tipo_cliente": "premium",
    "pontos": 1500
]

let user = DitoUser(
    name: "João Silva",
    gender: .masculino,
    email: "joao@example.com",
    birthday: Date(timeIntervalSince1970: 0), // Data de nascimento
    location: "São Paulo",
    createdAt: Date(),
    customData: customData
)

// Identifique o usuário
let userId = Dito.sha1(for: "joao@example.com") // Converte email para SHA1
Dito.identify(id: userId, data: user)

print("✅ Usuário identificado")
```

#### Dados disponíveis

```swift
let user = DitoUser(
    name: String,              // Nome completo
    gender: DitoGender,        // .masculino, .feminino ou .outro
    email: String,             // Email
    birthday: Date?,           // Data de nascimento
    location: String?,         // Localização
    createdAt: Date?,          // Data de criação
    customData: [String: Any]? // Dados customizados (JSON)
)
```

#### ⚠️ Importante

- Sempre identifique o usuário antes de rastrear eventos
- Use SHA1 do email como ID (veja `Dito.sha1(for:)`)
- Os dados são sincronizados automaticamente com a plataforma

**Documentação Dito**: [User Identification](https://docs.dito.com.br/sdk-ios/identificacao)

---

### Dito.track(event:)

**Rastreia eventos e comportamentos do usuário.**

Use para registrar qualquer ação importante no seu app.

#### Parâmetros

- `event` (DitoEvent): O evento a ser rastreado

#### Exemplo

```swift
import DitoSDK

// Evento simples
let event = DitoEvent(action: "tela_visualizada")
Dito.track(event: event)

// Evento com dados customizados
let purchaseEvent = DitoEvent(
    action: "compra_realizada",
    customData: [
        "produto_id": "123",
        "produto_nome": "Tênis Nike",
        "preco": 299.90,
        "categoria": "Esportes",
        "quantidade": 1
    ]
)
Dito.track(event: purchaseEvent)

// Exemplo de eventos comuns
let viewEvent = DitoEvent(action: "produto_visualizado", customData: ["id": "456"])
let addToCartEvent = DitoEvent(action: "item_adicionado_carrinho", customData: ["valor": 50.00])
let checkoutEvent = DitoEvent(action: "checkout_iniciado", customData: ["itens": 3])

Dito.track(event: viewEvent)
Dito.track(event: addToCartEvent)
Dito.track(event: checkoutEvent)
```

#### Dados de Evento

```swift
let event = DitoEvent(
    action: String,            // Nome da ação (obrigatório)
    customData: [String: Any]? // Dados adicionais em JSON
)
```

#### Exemplos de ações comuns

```
// E-commerce
"produto_visualizado"
"adicionar_carrinho"
"remover_carrinho"
"checkout_iniciado"
"compra_realizada"
"compra_cancelada"

// App
"tela_visualizada"
"botao_clicado"
"formulario_enviado"
"login"
"logout"
"compartilhamento"

// Notificações
"receive-ios-notification" (automático)
```

#### ⚠️ Importante

- Sempre identifique o usuário antes de rastrear eventos
- Os dados são sincronizados automaticamente
- Em offline, os eventos são salvos e sincronizados quando online

**Documentação Dito**: [Event Tracking](https://docs.dito.com.br/sdk-ios/rastreamento-eventos)

---

### Dito.sha1(for:)

**Converte uma string (normalmente email) para SHA1.**

O SHA1 é usado como ID único do usuário para identificação.

#### Parâmetros

- `email` (String): String a ser convertida (normalmente email)

#### Retorno

- (String): Hash SHA1 da string

#### Exemplo

```swift
import DitoSDK

let email = "joao@example.com"
let sha1Hash = Dito.sha1(for: email)

print("Email: \(email)")
print("SHA1: \(sha1Hash)") // Exemplo: "a1b2c3d4e5f6..."

// Use o SHA1 para identificar
Dito.identify(id: sha1Hash, data: userData)
```

#### ⚠️ Importante

- O SHA1 é determinístico: o mesmo email sempre gera o mesmo SHA1
- Use sempre o mesmo email para manter consistência
- O SHA1 não pode ser revertido (é hash criptográfico)

---

### Dito.registerDevice(token:)

**Registra o token FCM do dispositivo para receber notificações push.**

Normalmente é chamado automaticamente quando o Firebase atualiza o token.

#### Parâmetros

- `token` (String): Token FCM obtido do Firebase

#### Exemplo

```swift
import FirebaseMessaging
import DitoSDK

// No MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        guard let fcmToken = fcmToken else { return }
        
        print("🔑 Novo token FCM: \(fcmToken)")
        
        // Registra o token no Dito
        Dito.registerDevice(token: fcmToken)
    }
}
```

#### ⚠️ Importante

- Chamada automaticamente via `MessagingDelegate`
- Você pode chamar manualmente se necessário
- O token é persistido automaticamente

**Documentação Firebase**: [Get Registration Token](https://firebase.google.com/docs/cloud-messaging/ios/client#retrieve_the_current_registration_token)

---

### Dito.unregisterDevice(token:)

**Cancela o registro do token FCM.**

Use quando o usuário faz logout ou desinstal o app.

#### Parâmetros

- `token` (String): Token FCM a ser desregistrado

#### Exemplo

```swift
import DitoSDK

// Ao fazer logout
func handleLogout() {
    Messaging.messaging().token { fcmToken, error in
        if let fcmToken = fcmToken {
            Dito.unregisterDevice(token: fcmToken)
        }
    }
}
```

---

## 🔔 Push Notifications

O DitoSDK oferece suporte completo para notificações push via Firebase Cloud Messaging (FCM).

### Fluxo de Notificações

Existem 4 cenários diferentes quando uma notificação é recebida:

#### 1️⃣ App em Foreground (Visível)

```
Notificação Chega
    ↓
willPresent() chamado
    ↓
Banner mostrado (iOS 14+)
    ↓
Usuário clica
    ↓
didReceive() chamado
```

#### 2️⃣ App em Background

```
Notificação Chega
    ↓
(armazenada na bandeja do sistema)
    ↓
Usuário clica no banner
    ↓
didReceive() chamado
    ↓
didReceiveRemoteNotification() chamado
```

#### 3️⃣ App Encerrado

```
Notificação Chega
    ↓
(armazenada na bandeja do sistema)
    ↓
Usuário clica no banner
    ↓
App inicia
    ↓
didReceive() chamado
```

#### 4️⃣ Silent Notification (content-available)

```
Notificação Chega (sem UI)
    ↓
didReceiveRemoteNotification() chamado
    ↓
Seu código executa em background
    ↓
App pode atualizar dados
```

### Métodos de Notificação do Dito

#### Dito.notificationRead(with:token:)

**Registra quando uma notificação é RECEBIDA (não clicada).**

Deve ser chamado quando a notificação chega, ANTES do clique do usuário.

#### Parâmetros

- `userInfo` ([AnyHashable: Any]): Dados da notificação
- `token` (String): Token FCM do dispositivo

#### Exemplos

```swift
// Quando notificação chega em foreground
func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
) {
    let userInfo = notification.request.content.userInfo
    
    // Registra recebimento em foreground
    Messaging.messaging().token { fcmToken, error in
        if let fcmToken = fcmToken {
            Dito.notificationRead(with: userInfo, token: fcmToken)
        }
    }
    
    completionHandler([[.banner, .list, .sound, .badge]])
}

// Quando notificação chega em background (silent)
func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
) {
    if let token = self.fcmToken {
        Dito.notificationRead(with: userInfo, token: token)
    }
    completionHandler(.newData)
}

// Quando usuário abre app do background (clica no banner)
func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
) {
    let userInfo = response.notification.request.content.userInfo
    
    Messaging.messaging().token { fcmToken, error in
        if let fcmToken = fcmToken {
            // Registra que foi lida
            Dito.notificationRead(with: userInfo, token: fcmToken)
        }
    }
    
    completionHandler()
}
```

#### Dados capturados

```swift
// O Dito automaticamente registra:
[
    "titulo": "Seu Título",
    "mensagem": "Sua Mensagem",
    "notificacao_id": "01K9D3247BYF6ME8X1RPNT2VRN",
    "usuario_id": "a24696993af35a5190a0f7f41a7e508bf87a11eb",
    "referencia": "19302a24696993af35a5190a0f7f41a7e508bf87a11eb",
    "link": "app://deeplink",
    "canal": "DITO",
    "dispositivo": "APPLE IPHONE"
]
```

---

#### Dito.notificationClick(with:callback:)

**Registra quando uma notificação é CLICADA.**

Chamado apenas quando o usuário toca no banner.

#### Parâmetros

- `userInfo` ([AnyHashable: Any]): Dados da notificação
- `callback` ((String) -> Void)?: Closure com o deeplink (opcional)

#### Retorno

- (DitoNotificationReceived): Dados da notificação processados

#### Exemplo

```swift
// Quando usuário CLICA na notificação
func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
) {
    let userInfo = response.notification.request.content.userInfo

    // Registra o clique
    let notificationData = Dito.notificationClick(with: userInfo) { deeplink in
        // Callback com o deeplink
        print("🔗 Deeplink: \(deeplink)")
        
        // Processe o deeplink para navegar
        if !deeplink.isEmpty {
            self.handleDeeplink(deeplink)
        }
    }
    
    // Acesse os dados da notificação
    print("📱 Notificação: \(notificationData.notification)")
    print("👤 Usuário: \(notificationData.identifier)")

    completionHandler()
}

// Função para processar deeplink
func handleDeeplink(_ deeplink: String) {
    // Exemplo: app://produtos/123
    if let url = URL(string: deeplink) {
        // Navegue para a tela apropriada
    }
}
```

#### Dados retornados

```swift
let notification: DitoNotificationReceived = [
    "notification": "ID da notificação",
    "identifier": "ID do usuário",
    "reference": "SHA1 do usuário",
    "title": "Título",
    "message": "Mensagem",
    "deeplink": "app://link",
    "deviceType": "APPLE IPHONE",
    "channel": "DITO",
    "notificationName": "Nome da campanha"
]
```

---

### Exemplo Completo: Tratamento de Notificações

```swift
import UIKit
import Firebase
import FirebaseMessaging
import DitoSDK
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    var fcmToken: String?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // 1. Firebase
        FirebaseApp.configure()
        
        // 2. Messaging
        Messaging.messaging().delegate = self
        
        // 3. Dito
        Dito.shared.configure()
        
        // 4. Notificações
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications(application: application)

        return true
    }

    private func registerForPushNotifications(application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { granted, error in
            guard granted else {
                print("⚠️ Notificações não autorizadas")
                return
            }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }

    // MARK: - Remote Notifications

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        // Silent notification
        if let token = self.fcmToken {
            Dito.notificationRead(with: userInfo, token: token)
        }
        completionHandler(.newData)
    }
}

// MARK: - Notification Delegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        print("🔔 Notificação em foreground: \(userInfo)")
        
        completionHandler([[.banner, .list, .sound, .badge]])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        // Notificação foi clicada
        Messaging.messaging().token { [weak self] fcmToken, error in
            if let fcmToken = fcmToken {
                // Registra leitura
                Dito.notificationRead(with: userInfo, token: fcmToken)
                
                // Registra clique
                let notification = Dito.notificationClick(
                    with: userInfo
                ) { deeplink in
                    // Processe o deeplink
                    print("🔗 Deeplink: \(deeplink)")
                }
                
                print("✅ Notificação processada: \(notification.notification)")
            }
        }

        completionHandler()
    }
}

// MARK: - Messaging Delegate

extension AppDelegate: MessagingDelegate {
    
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        guard let fcmToken = fcmToken else { return }
        
        print("🔑 FCM Token: \(fcmToken)")
        self.fcmToken = fcmToken
        
        // Registra no Dito
        Dito.registerDevice(token: fcmToken)
    }
}
```

---

### Checklist: Notificações não aparecem?

1. ✅ Firebase configurado (`GoogleService-Info.plist` adicionado)
2. ✅ Permissões solicitadas (`requestAuthorization`)
3. ✅ `registerForRemoteNotifications()` chamado
4. ✅ Token FCM registrado (`Dito.registerDevice(token:)`)
5. ✅ `Messaging.messaging().delegate = self` configurado
6. ✅ Capabilities: **Push Notifications** habilitada
7. ✅ Certificates APNs válidos no Firebase Console
8. ✅ App não tem notificações desabilitadas em Settings

**Documentação Firebase**: [Troubleshoot FCM for iOS](https://firebase.google.com/docs/cloud-messaging/ios/troubleshoot)

---

## 🔧 Troubleshooting

### ❌ Erro: "APNS device token not set before retrieving FCM Token" (iOS 18)

**Causa**: Ordem incorreta de inicialização.

**Solução**: Siga esta ordem EXATA no AppDelegate:

```swift
func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
    // 1️⃣ Firebase PRIMEIRO
    FirebaseApp.configure()
    
    // 2️⃣ Messaging delegate SEGUNDO
    Messaging.messaging().delegate = self
    
    // 3️⃣ Dito por último
    Dito.shared.configure()
    
    // 4️⃣ Notificações
    UNUserNotificationCenter.current().delegate = self
    
    return true
}
```

**Importante**: No `didRegisterForRemoteNotificationsWithDeviceToken`, defina o APNS token ANTES de qualquer operação FCM:

```swift
func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
) {
    // ⚠️ SEMPRE PRIMEIRO
    Messaging.messaging().apnsToken = deviceToken
    
    // Depois pedir o token FCM
    Messaging.messaging().token { token, error in
        if let token = token {
            Dito.registerDevice(token: token)
        }
    }
}
```

---

### ❌ Notificações não aparecem quando app em foreground

**Causa**: `willPresent` não mostra notificações por padrão.

**Solução**: Configure `completionHandler` com opções visuais:

```swift
func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
) {
    // Mostra com banner, lista e som
    if #available(iOS 14.0, *) {
        completionHandler([[.banner, .list, .sound, .badge]])
    } else {
        completionHandler(.alert)
    }
}
```

---

### ❌ Eventos não aparecem no painel Dito

**Checklist**:

1. ✅ `apiKey` e `apiSecret` corretos no Info.plist
2. ✅ Usuário identificado ANTES de rastrear: `Dito.identify(id:data:)`
3. ✅ Conexão com internet (ou aguardar sincronização offline)

```swift
// ❌ ERRADO - evento antes da identificação
Dito.track(event: event)
Dito.identify(id: userId, data: userData)

// ✅ CORRETO - identifique primeiro
Dito.identify(id: userId, data: userData)
Dito.track(event: event)
```

---

### ❌ Crashes de CoreData (iOS 16+)

**Causa**: Violações de thread-safety ao acessar context de threads background.

**Solução**: O DitoSDK já é otimizado para iOS 16+. Se tiver problemas:

```swift
// Certifique-se que não está acessando viewContext de thread background
// O DitoSDK usa performBackgroundTask automaticamente
```

---

## 📖 Documentação Adicional

### Documentação Oficial

- 🌐 [Website Dito](https://www.dito.com.br)
- 📚 [Documentação Dito](https://docs.dito.com.br)
- 🔥 [Firebase iOS Documentation](https://firebase.google.com/docs/ios/setup)
- 🔔 [Firebase Cloud Messaging iOS](https://firebase.google.com/docs/cloud-messaging/ios/client)
- 📱 [Apple User Notifications](https://developer.apple.com/documentation/usernotifications)

### Guias de Migração

- 📄 [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) - Guia completo de migração
- 📄 [IOS18_MIGRATION_NOTES.md](IOS18_MIGRATION_NOTES.md) - Correções iOS 18
- 📄 [COREDATA_IOS16_FIXES.md](COREDATA_IOS16_FIXES.md) - Correções CoreData

---

## 📱 Sample Application

O projeto inclui um exemplo completo em `SampleApplication/` com:

- ✅ Configuração completa do Firebase
- ✅ Implementação de todos os delegates
- ✅ Identificação de usuários
- ✅ Rastreamento de eventos
- ✅ Gerenciamento de notificações
- ✅ Tratamento de deeplinks

Para executar:

```bash
cd /caminho/para/dito_ios
pod install
open DitoSDK.xcworkspace

# Selecione o scheme "Sample"  e execute (⌘R)
```

---

## 🤝 Contributing

Contribuições são bem-vindas!

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/amazing-feature`)
3. Commit suas mudanças (`git commit -m 'Add amazing feature'`)
4. Push para a branch (`git push origin feature/amazing-feature`)
5. Abra um Pull Request

### Desenvolvimento

```bash
git clone https://github.com/ditointernet/dito_ios.git
cd dito_ios
pod install
open DitoSDK.xcworkspace
```

### Executando Testes

```bash
# Via Xcode
⌘ + U

# Via terminal
xcodebuild test -workspace DitoSDK.xcworkspace \
                -scheme DitoSDK \
                -destination 'platform=iOS Simulator,name=iPhone 15'
```

---

## 📞 Support

- 📧 **Email**: suporte@dito.com.br
- 🐛 **Issues**: [GitHub Issues](https://github.com/ditointernet/dito_ios/issues)
- 💬 **Slack**: [Dito Community](https://dito-community.slack.com) (se disponível)

---

## 📄 License

DitoSDK está disponível sob a licença MIT. Veja [LICENSE](LICENSE) para mais informações.

---

## 👥 Authors

**Dito Team** - [Dito CRM](https://www.dito.com.br)

---

<p align="center">
  Feito com ❤️ pela equipe Dito
</p>




<p align="center"><p align="center">

  <img src="https://user-images.githubusercontent.com/76013839/105905864-5c010c00-5ff9-11eb-9961-eda5c9a62d4b.png" alt="Dito SDK" width="200"/>  <img src="https://user-images.githubusercontent.com/76013839/105905864-5c010c00-5ff9-11eb-9961-eda5c9a62d4b.png" alt="Dito SDK" width="200"/>

</p></p>



<p align="center"><p align="center">

  SDK iOS oficial da Dito para integração com a plataforma de CRM e Marketing Automation  SDK iOS oficial da Dito para integração com a plataforma de CRM e Marketing Automation

</p></p>



<p align="center"><p align="center">

  <a href="#features">Features</a> •  <a href="#features">Features</a> •

  <a href="#requirements">Requirements</a> •  <a href="#requirements">Requirements</a> •

  <a href="#installation">Installation</a> •  <a href="#installation">Installation</a> •

  <a href="#quick-start">Quick Start</a> •  <a href="#quick-start">Quick Start</a> •

  <a href="#documentation">Documentation</a> •  <a href="#documentation">Documentation</a> •

  <a href="#migration">Migration</a>  <a href="#migration">Migration</a>

</p></p>



------



## 📋 Sobre## 📋 Sobre



O **DitoSDK** é a biblioteca oficial da Dito para aplicações iOS, permitindo a integração completa com a plataforma de CRM e Marketing Automation. Com ele você pode:O **DitoSDK** é a biblioteca oficial da Dito para aplicações iOS, permitindo a integração completa com a plataforma de CRM e Marketing Automation. Com ele você pode:



- 🔐 Identificar usuários e sincronizar dados- 🔐 Identificar usuários e sincronizar dados

- 📊 Rastrear eventos e comportamentos- 📊 Rastrear eventos e comportamentos

- 🔔 Gerenciar notificações push- 🔔 Gerenciar notificações push

- 🔗 Processar deeplinks- 🔗 Processar deeplinks

- 💾 Gerenciar dados offline- 💾 Gerenciar dados offline

- 🔒 Hash SHA1 de emails- 🔒 Hash SHA1 de emails



------



## ✨ Features## ✨ Features



- ✅ **Identificação de Usuários** - Sincronize dados de usuários com a plataforma Dito- ✅ **Identificação de Usuários** - Sincronize dados de usuários com a plataforma Dito

- ✅ **Tracking de Eventos** - Rastreie eventos personalizados e comportamentos- ✅ **Tracking de Eventos** - Rastreie eventos personalizados e comportamentos

- ✅ **Push Notifications** - Integração completa com Firebase Cloud Messaging- ✅ **Push Notifications** - Integração completa com Firebase Cloud Messaging

- ✅ **Deeplink Handling** - Processe deeplinks de notificações- ✅ **Deeplink Handling** - Processe deeplinks de notificações

- ✅ **Offline Management** - Gerenciamento automático de operações offline- ✅ **Offline Management** - Gerenciamento automático de operações offline

- ✅ **SHA1 Conversion** - Utilitário para hash de emails- ✅ **SHA1 Conversion** - Utilitário para hash de emails

- ✅ **Thread-Safe** - Compatível com iOS 16+ (CoreData thread-safety)- ✅ **Thread-Safe** - Compatível com iOS 16+ (CoreData thread-safety)

- ✅ **Firebase Integration** - Integração nativa com Firebase- ✅ **Firebase Integration** - Integração nativa com Firebase



------



## 📱 Requirements## 📱 Requirements



| Requisito | Versão Mínima || Requisito | Versão Mínima |

|-----------|---------------||-----------|---------------|

| iOS | 16.0+ || iOS | 16.0+ |

| Xcode | 11.3.1+ || Xcode | 11.3.1+ |

| Swift | 5.3+ || Swift | 5.3+ |

| CocoaPods | 1.10.0+ || CocoaPods | 1.10.0+ |



### Dependências Externas### Dependências Externas



- **Firebase/Core** - Para analytics e configuração- **Firebase/Core** - Para analytics e configuração

- **Firebase/Messaging** - Para push notifications (obrigatório)- **Firebase/Messaging** - Para push notifications (obrigatório)



------



## 🚀 Installation## 🚀 Installation



### CocoaPods (Recomendado)### Cocoapods

Para instalar a versão mais recente do SDK Dito em seu projeto através do Cocoapods, adicione o pod em seu podfile:

Adicione ao seu `Podfile`:

pod 'DitoSDK'

```ruby

pod 'DitoSDK', :git => 'https://github.com/ditointernet/dito_ios.git', :branch => 'NOME_DA_BRANCH'Para instalar uma versão específica, inclua o número da versão:

```

pod 'DitoSDK', '~> 1.0.0'

Depois execute:

Em alguns casos, pode ser necessário utilizar uma branch específica para algum ajuste ou correção pontual ou urgente. Neste caso, basta especificar a branch:

```bash

pod install

```### CocoaPods (Recomendado)



> 💡 **Novo no CocoaPods?** Siga o [guia oficial](https://guides.cocoapods.org/using/using-cocoapods.html)Adicione ao seu `Podfile`:



### Swift Package Manager```ruby

pod 'DitoSDK', :git => 'https://github.com/ditointernet/dito_ios.git', :branch => 'NOME_DA_BRANCH'

Em breve! 🚧```



### Manual InstallationDepois execute:



1. Baixe o projeto```bash

2. Arraste `DitoSDK.xcodeproj` para o seu projetopod install

3. Adicione `DitoSDK.framework` em **Frameworks, Libraries, and Embedded Content**```

4. Certifique-se que está marcado como **Embed & Sign**

> 💡 **Novo no CocoaPods?** Siga o [guia oficial](https://guides.cocoapods.org/using/using-cocoapods.html)

---

### Swift Package Manager

## 🎯 Quick Start

Em breve! 🚧

### 1. Configure o Firebase

### Manual Installation

Antes de usar o DitoSDK, configure o Firebase no seu projeto:

1. Baixe o projeto

#### 1.1 Adicione Firebase ao Podfile2. Arraste `DitoSDK.xcodeproj` para o seu projeto

3. Adicione `DitoSDK.framework` em **Frameworks, Libraries, and Embedded Content**

```ruby4. Certifique-se que está marcado como **Embed & Sign**

pod 'Firebase/Core'

pod 'Firebase/Messaging'---

```

## 🎯 Quick Start

#### 1.2 Configure no AppDelegate

### 1. Configure o Firebase

```swift

import UIKitAntes de usar o DitoSDK, configure o Firebase no seu projeto:

import Firebase

import DitoSDK#### 1.1 Adicione Firebase ao Podfile



@UIApplicationMain```ruby

class AppDelegate: UIResponder, UIApplicationDelegate {pod 'Firebase/Core'

pod 'Firebase/Messaging'

    func application(_ application: UIApplication,```

                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        #### 1.2 Configure no AppDelegate

        // 1. Configure Firebase PRIMEIRO

        FirebaseApp.configure()```swift

        import UIKit

        // 2. Configure Messaging delegateimport Firebase

        Messaging.messaging().delegate = selfimport DitoSDK



        // 3. Inicialize DitoSDK@UIApplicationMain

        Dito.shared.configure(apiKey: "SUA_API_KEY", secretKey: "SUA_SECRET_KEY")class AppDelegate: UIResponder, UIApplicationDelegate {



        // 4. Configure notificações    func application(_ application: UIApplication,

        UNUserNotificationCenter.current().delegate = self                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in

            if granted {        // 1. Configure Firebase PRIMEIRO

                DispatchQueue.main.async {        FirebaseApp.configure()

                    application.registerForRemoteNotifications()

                }        // 2. Configure Messaging delegate

            }        Messaging.messaging().delegate = self

        }

                // 3. Inicialize DitoSDK

        return true        Dito.shared.configure(apiKey: "SUA_API_KEY", secretKey: "SUA_SECRET_KEY")

    }

}        // 4. Configure notificações

```        UNUserNotificationCenter.current().delegate = self

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in

#### 1.3 Implemente os delegates necessários            if granted {

                DispatchQueue.main.async {

```swift                    application.registerForRemoteNotifications()

// MARK: - UNUserNotificationCenterDelegate                }

extension AppDelegate: UNUserNotificationCenterDelegate {            }

            }

    func userNotificationCenter(_ center: UNUserNotificationCenter,

                              didReceive response: UNNotificationResponse,        return true

                              withCompletionHandler completionHandler: @escaping () -> Void) {    }

        let userInfo = response.notification.request.content.userInfo}

        Dito.shared.handleNotification(userInfo: userInfo)```

        completionHandler()

    }#### 1.3 Implemente os delegates necessários



    func userNotificationCenter(_ center: UNUserNotificationCenter,```swift

                              willPresent notification: UNNotification,// MARK: - UNUserNotificationCenterDelegate

                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {extension AppDelegate: UNUserNotificationCenterDelegate {

        completionHandler([.alert, .badge, .sound])

    }    func userNotificationCenter(_ center: UNUserNotificationCenter,

}                              didReceive response: UNNotificationResponse,

                              withCompletionHandler completionHandler: @escaping () -> Void) {

// MARK: - MessagingDelegate        let userInfo = response.notification.request.content.userInfo

extension AppDelegate: MessagingDelegate {        Dito.shared.handleNotification(userInfo: userInfo)

            completionHandler()

    func application(_ application: UIApplication,    }

                    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        // ⚠️ IMPORTANTE: Defina o token APNS ANTES de solicitar o FCM token (iOS 18+)    func userNotificationCenter(_ center: UNUserNotificationCenter,

        Messaging.messaging().apnsToken = deviceToken                              willPresent notification: UNNotification,

    }                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

            completionHandler([.alert, .badge, .sound])

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {    }

        guard let fcmToken = fcmToken else { return }}



        // Registre o token Firebase no DitoSDK// MARK: - MessagingDelegate

        Dito.shared.registerDevice(token: fcmToken)extension AppDelegate: MessagingDelegate {

    }

}    func application(_ application: UIApplication,

```                    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        // ⚠️ IMPORTANTE: Defina o token APNS ANTES de solicitar o FCM token (iOS 18+)

> ⚠️ **Importante para iOS 18**: A ordem de inicialização (`FirebaseApp.configure()` → `Messaging.messaging().delegate` → `Dito.shared.configure()`) é crucial para evitar o erro "APNS device token not set before retrieving FCM Token"        Messaging.messaging().apnsToken = deviceToken

    }

### 2. Identificar Usuário

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

```swift        guard let fcmToken = fcmToken else { return }

import DitoSDK

        // Registre o token Firebase no DitoSDK

// Identificar com email SHA1        Dito.shared.registerDevice(token: fcmToken)

Dito.shared.identify(sha1: "hash_sha1_do_email") { result in    }

    switch result {}

    case .success:```

        print("✅ Usuário identificado")

    case .error(let error):> ⚠️ **Importante para iOS 18**: A ordem de inicialização (`FirebaseApp.configure()` → `Messaging.messaging().delegate` → `Dito.shared.configure()`) é crucial para evitar o erro "APNS device token not set before retrieving FCM Token"

        print("❌ Erro: \(error)")

    }### 2. Identificar Usuário

}

```swift

// Identificar com dados completosimport DitoSDK

let userData: [String: Any] = [

    "name": "João Silva",// Identificar com email SHA1

    "email": "joao@example.com",Dito.shared.identify(sha1: "hash_sha1_do_email") { result in

    "age": 30,    switch result {

    "premium": true    case .success:

]        print("✅ Usuário identificado")

    case .error(let error):

Dito.shared.identify(sha1: "hash_sha1", data: userData) { result in        print("❌ Erro: \(error)")

    // Handle result    }

}}

```

// Identificar com dados completos

### 3. Rastrear Eventoslet userData: [String: Any] = [

    "name": "João Silva",

```swift    "email": "joao@example.com",

// Evento simples    "age": 30,

Dito.shared.track(eventType: "button_clicked")    "premium": true

]

// Evento com dados

let eventData: [String: Any] = [Dito.shared.identify(sha1: "hash_sha1", data: userData) { result in

    "product_id": "123",    // Handle result

    "product_name": "Tênis Nike",}

    "price": 299.90,```

    "category": "Esportes"

]### 3. Rastrear Eventos



Dito.shared.track(eventType: "product_viewed", data: eventData) { result in```swift

    switch result {// Evento simples

    case .success:Dito.shared.track(eventType: "button_clicked")

        print("✅ Evento rastreado")

    case .error(let error):// Evento com dados

        print("❌ Erro: \(error)")let eventData: [String: Any] = [

    }    "product_id": "123",

}    "product_name": "Tênis Nike",

```    "price": 299.90,

    "category": "Esportes"

### 4. Gerenciar Notificações]



```swiftDito.shared.track(eventType: "product_viewed", data: eventData) { result in

// Registrar dispositivo para notificações    switch result {

// (Automaticamente chamado no MessagingDelegate)    case .success:

Dito.shared.registerDevice(token: fcmToken)        print("✅ Evento rastreado")

    case .error(let error):

// Desregistrar dispositivo        print("❌ Erro: \(error)")

Dito.shared.unregisterDevice(token: fcmToken) { result in    }

    switch result {}

    case .success:```

        print("✅ Dispositivo desregistrado")

    case .error(let error):### 4. Gerenciar Notificações

        print("❌ Erro: \(error)")

    }```swift

}// Registrar dispositivo para notificações

// (Automaticamente chamado no MessagingDelegate)

// Processar notificação recebidaDito.shared.registerDevice(token: fcmToken)

Dito.shared.handleNotification(userInfo: userInfo)

```// Desregistrar dispositivo

Dito.shared.unregisterDevice(token: fcmToken) { result in

### 5. Utilitários    switch result {

    case .success:

```swift        print("✅ Dispositivo desregistrado")

// Converter email para SHA1    case .error(let error):

let sha1Hash = Dito.shared.convertSHA1(email: "usuario@example.com")        print("❌ Erro: \(error)")

print("SHA1: \(sha1Hash)")    }

}

// Ativar modo debug

Dito.shared.setDebugMode(true)// Processar notificação recebida

```Dito.shared.handleNotification(userInfo: userInfo)

```

---

### 5. Utilitários

## 📚 Documentation

```swift

### iOS Version Compatibility// Converter email para SHA1

let sha1Hash = Dito.shared.convertSHA1(email: "usuario@example.com")

| iOS Version | DitoSDK Support | Notes |
|-------------|----------------|-------|
| iOS 18.x | ✅ Full Support | Requer ordem específica de inicialização Firebase |
| iOS 17.x | ✅ Full Support | |
| iOS 16.x | ✅ Full Support | Versão mínima suportada - CoreData thread-safety otimizado |## 📚 Documentation



### Architecture Overview### iOS Version Compatibility



```text| iOS Version | DitoSDK Support | Notes |

DitoSDK|-------------|----------------|-------|

├── Controllers/| iOS 18.x | ✅ Full Support | Requer ordem específica de inicialização Firebase |

│   ├── Dito.swift              # API principal (singleton)| iOS 17.x | ✅ Full Support | |

│   ├── DitoIdentify.swift      # Gerenciamento de identificação| iOS 16.x | ✅ Full Support | CoreData thread-safety otimizado |

│   ├── DitoTrack.swift         # Rastreamento de eventos| iOS 15.x | ✅ Full Support | |

│   ├── DitoNotification.swift  # Gerenciamento de notificações| iOS 14.x | ✅ Full Support | |

│   └── Offline/                # Sistema de retry offline| iOS 13.x | ✅ Full Support | Versão mínima suportada |

├── Persistence/| iOS 12.x | ⚠️ Deprecated | Não recomendado |

│   ├── DitoCoreDataManager.swift        # Stack CoreData (thread-safe)

│   ├── DitoIdentifyDataManager.swift   # Persistência de identificação### Architecture Overview

│   ├── DitoTrackDataManager.swift      # Persistência de eventos

│   └── DitoNotification*DataManager.swift # Persistência de notificações```

├── Services/DitoSDK

│   └── Network services├── Controllers/

└── Model/│   ├── Dito.swift              # API principal (singleton)

    └── Data models│   ├── DitoIdentify.swift      # Gerenciamento de identificação

```│   ├── DitoTrack.swift         # Rastreamento de eventos

│   ├── DitoNotification.swift  # Gerenciamento de notificações

### API Reference│   └── Offline/                # Sistema de retry offline

├── Persistence/

#### Dito.shared│   ├── DitoCoreDataManager.swift        # Stack CoreData (thread-safe)

│   ├── DitoIdentifyDataManager.swift   # Persistência de identificação

```swift│   ├── DitoTrackDataManager.swift      # Persistência de eventos

// Configuração inicial│   └── DitoNotification*DataManager.swift # Persistência de notificações

func configure(apiKey: String, secretKey: String, isDebug: Bool = false)├── Services/

│   └── Network services

// Identificação└── Model/

func identify(sha1: String, completion: ((DitoResult) -> Void)?)    └── Data models

func identify(sha1: String, data: [String: Any], completion: ((DitoResult) -> Void)?)```



// Tracking### API Reference

func track(eventType: String)

func track(eventType: String, data: [String: Any], completion: ((DitoResult) -> Void)?)#### Dito.shared



// Notificações (Firebase apenas)```swift

func registerDevice(token: String)// Configuração inicial

func unregisterDevice(token: String, completion: ((DitoResult) -> Void)?)func configure(apiKey: String, secretKey: String, isDebug: Bool = false)

func handleNotification(userInfo: [AnyHashable: Any])

// Identificação

// Utilitáriosfunc identify(sha1: String, completion: ((DitoResult) -> Void)?)

func convertSHA1(email: String) -> Stringfunc identify(sha1: String, data: [String: Any], completion: ((DitoResult) -> Void)?)

func setDebugMode(_ isDebug: Bool)

```// Tracking

func track(eventType: String)

### Offline Managementfunc track(eventType: String, data: [String: Any], completion: ((DitoResult) -> Void)?)



O DitoSDK gerencia automaticamente operações offline:// Notificações (Firebase apenas)

func registerDevice(token: String)

- ✅ **Armazenamento automático** de operações quando offlinefunc unregisterDevice(token: String, completion: ((DitoResult) -> Void)?)

- ✅ **Retry automático** quando a conexão é restabelecidafunc handleNotification(userInfo: [AnyHashable: Any])

- ✅ **Thread-safe** com CoreData em background (iOS 16+)

- ✅ **Persistência** entre sessões do app// Utilitários

func convertSHA1(email: String) -> String

```swiftfunc setDebugMode(_ isDebug: Bool)

// Todas as operações funcionam offline automaticamente```

Dito.shared.identify(sha1: "hash") { result in

    // Será executado quando possível (online ou após retry)### Offline Management

}

O DitoSDK gerencia automaticamente operações offline:

Dito.shared.track(eventType: "purchase", data: purchaseData) { result in

    // Salvo localmente se offline, enviado quando onlineps.: Para incluir cocoapods em um projeto, [siga o tutorial] (https://guides.cocoapods.org/using/using-cocoapods.html)

}

```

Após adição no podfile, execute o comando pod install --repo-update para instalar e utilizar o pod no projeto.

### Debug Mode

### Manual

Ative logs detalhados para troubleshooting:

Para instalar o SDK Dito em seu projeto de forma manual, sem utilizar cocoapods, é necessário arrastar o arquivo DitoSDK.framework, disponível na pasta Framework do projeto.

```swift

// No AppDelegate ou início do app## Example

Dito.shared.setDebugMode(true)Há neste repositório presente na pasta Example a forma de utilização e configuração do SDK.



// Logs serão exibidos no console:### Usage example

// [DitoSDK] 📤 Enviando evento: product_viewed

// [DitoSDK] ✅ Identificação bem-sucedidaÉ necessário setar o ```App Key``` e ```App secret``` do seu dashboard Dito no arquivo ```.plist``` do seu projeto, utilizar as chaves exatamente como no exemplo abaixo:

// [DitoSDK] ⚠️ Offline - operação salva para retry

```![plist](https://user-images.githubusercontent.com/76013839/105905864-5c010c00-5ff9-11eb-9961-eda5c9a62d4b.png)



---#### Initialize



## 🔧 TroubleshootingÉ necessário fazer a inicialização do SDK no arquivo ```AppDelegate.swift``` do seu projeto.



### Erro: "APNS device token not set before retrieving FCM Token" (iOS 18)```swift

import DitoSDK

**Causa**: Ordem incorreta de inicialização do Firebase e Messaging.

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

**Solução**: Siga a ordem exata no AppDelegate:    ...



```swift    Dito.shared.configure()

func application(_ application: UIApplication,

                didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {    ...

    }

    // 1. Firebase primeiro```

    FirebaseApp.configure()#### Identify

    ```swift

    // 2. Messaging delegate depois        let customData = ["x": "y"]

    Messaging.messaging().delegate = self

            let ditoUser = DitoUser(name: "My name",

    // 3. Dito por último                          gender: .masculino,

    Dito.shared.configure(apiKey: "...", secretKey: "...")                          email: "teste@teste.com.br",

                              birthday: Date(),

    return true                          location: "My city",

}                          createdAt: Date(),

                          customData: customData)

// E no delegate:        Dito.identify(id: "My user id", data: ditoUser)

func application(_ application: UIApplication,```

                didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    // SEMPRE defina apnsToken ANTES de usar FCM#### Conversão SHA1

    Messaging.messaging().apnsToken = deviceToken```swift

}    let sha1String = Dito.sha1(for: "String to convert")

``````



📖 Veja mais: [IOS18_MIGRATION_NOTES.md](IOS18_MIGRATION_NOTES.md)#### Track

```swift

### Crashes relacionados a CoreData (iOS 16+)    let event = DitoEvent(action: "my-current-event-to-track")

    Dito.track(event: event)

**Causa**: Violações de thread-safety ao acessar viewContext de threads background.```



**Solução**: O DitoSDK já está atualizado para iOS 16+. Se você usa uma versão antiga, atualize:#### Push Notification



```rubyPara captura e tratamento de notificações, é necessário incluir no projeto a função inicial, responsável por capturar notificações nativas.

pod update DitoSDKA função pode ser encontrada no projeto de exemplo, e executa o processo de leitura e notificação interna sobre o push recebido.

```Deve ser incluída na classe 'AppDelegate' do lado nativo do projeto



📖 Veja mais: [COREDATA_IOS16_FIXES.md](COREDATA_IOS16_FIXES.md)```swift

    func application(_ application: UIApplication,

### Notificações não aparecem                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],

                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

**Checklist**:        //Ver sessão 'tratamento de deeplink' para definição interna desta função

    }

1. ✅ Firebase configurado no projeto (`GoogleService-Info.plist` adicionado)

2. ✅ Permissões solicitadas (`requestAuthorization`)```

3. ✅ `application.registerForRemoteNotifications()` chamado

4. ✅ Token FCM registrado (`Dito.shared.registerDevice(token:)`)##### Tratamento de Deeplink

5. ✅ Capabilities: **Push Notifications** e **Background Modes > Remote notifications** habilitados

6. ✅ Certificados APNs válidos no Firebase ConsoleO projeto conta com opção para receber o deeplink de notificações durante a leitura das mesmas.

Para isso, basta incluir o envio da closure na chamada notificationRead.

### Eventos não aparecem no painel Dito

```swift

**Checklist**:Dito.notificationRead(with: userInfo, callback: { deeplink in

							print(deeplink) })

1. ✅ `apiKey` e `secretKey` corretos```

2. ✅ Usuário identificado antes de rastrear eventos

3. ✅ Debug mode ativo para ver logsNo exemplo, a variável. “deeplink” é retornada com o valor do deeplink, e a ação de print é executada no bloco.

4. ✅ Conexão com internet (ou aguardar retry offline)A inclusão é opcional, e pode ser omitida caso não haja necessidade de captura de deeplink



```swift```swift

// Sempre identifique antes de rastrearDito.notificationRead(with: userInfo)

Dito.shared.identify(sha1: "hash") { result in```

    if case .success = result {

        // Agora pode rastrear eventosDe forma completa, há duas opções para a função adicionada ao AppDelegate.

        Dito.shared.track(eventType: "app_opened")

    }Com captura de Deeplink:

}```swift

```    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        Dito.notificationRead(with: userInfo, callback: { deeplink in print(deeplink) })

### Como obter SHA1 de um email    }



```swift```

let email = "usuario@example.com"

let sha1 = Dito.shared.convertSHA1(email: email)Ou sem captura de deeplink

print("SHA1: \(sha1)")```swift

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

// Use o SHA1 para identificar        Dito.notificationRead(with: userInfo)

Dito.shared.identify(sha1: sha1)    }

``````

##### Register Device

---

⚠️ **Importante:** DitoSDK agora trabalha exclusivamente com tokens do Firebase Cloud Messaging (FCM).

## 🔄 Migration Guides

```swift

### Migrando para versão com suporte apenas Firebase    // Registrar token FCM (Firebase Cloud Messaging)

    Dito.registerDevice(token: "FCM_TOKEN_FROM_FIREBASE")

Se você está atualizando de uma versão que suportava APNS direto:```



📖 **Guia completo**: [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)**Exemplo completo com Firebase:**

```swift

**Mudanças principais**:import FirebaseMessaging



```swift// No AppDelegate, depois de obter o token FCM

// ❌ ANTES (deprecated)Messaging.messaging().token { token, error in

Dito.shared.registerDevice(token: token, tokenType: .firebase)    if let error = error {

        print("Error fetching FCM token: \(error)")

// ✅ AGORA (Firebase apenas)    } else if let token = token {

Dito.shared.registerDevice(token: fcmToken)        print("FCM token: \(token)")

```        Dito.registerDevice(token: token)

    }

### Outros documentos de migração}

```

- 📄 [MIGRATION_FIREBASE_ONLY.md](MIGRATION_FIREBASE_ONLY.md) - Migração detalhada Firebase-only

- 📄 [IOS18_MIGRATION_NOTES.md](IOS18_MIGRATION_NOTES.md) - Correções específicas iOS 18##### Unregister Device

- 📄 [COREDATA_IOS16_FIXES.md](COREDATA_IOS16_FIXES.md) - Correções CoreData iOS 16+```swift

- 📄 [FIXES_SUMMARY.md](FIXES_SUMMARY.md) - Resumo executivo de todas as correções    // Cancelar registro do token FCM

- 📄 [VALIDATION_CHECKLIST.md](VALIDATION_CHECKLIST.md) - Checklist completo de validação    Dito.unregisterDevice(token: "FCM_TOKEN_FROM_FIREBASE")

```

---##### Register notification reading



## 📖 Additional ResourcesO método recebe como parâmetro um ```dictionary``` que é enviado no push. Não necessáriamente precisa ser implementado no método do delegate como no exemplo abaixo:



### Sample Application```swift

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

O projeto inclui um app de exemplo completo em `SampleApplication/`:        Dito.notificationRead(with: userInfo)

    }

```swift```

// Veja exemplos de:

- Configuração completa do FirebaseTambém é possível obter o ```deepLink``` para direcionamento de fluxo como no exemplo abaixo:

- Implementação dos delegates

- Identificação de usuários```swift

- Rastreamento de eventos    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

- Gerenciamento de notificações        let notificationRead = Dito.notificationRead(with: userInfo)

- Tratamento de deeplinks        print(notificationRead.deepLink)

```    }

```

Para executar:

## Debug mode

```bashPara ativar os logs é necessário colocar a flag ```EnabledDebug``` ativada no ```Arguments Passed On Launch``` que fica no ```scheme``` do seu projeto.

cd /caminho/para/dito_ios

pod install## Author

open DitoSDK.xcworkspace

# Selecione o scheme "Sample" e executeioasys, contato@ioasys.com.br

```

## License

### Links ÚteisDitoSDK is available under the MIT license. See the LICENSE file for more info.


- 🌐 [Documentação Oficial Dito](https://www.dito.com.br)
- 🔥 [Firebase iOS Setup](https://firebase.google.com/docs/ios/setup)
- 🔔 [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging/ios/client)
- 📱 [Apple Push Notifications](https://developer.apple.com/documentation/usernotifications)
- 🍎 [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

---

## 🤝 Contributing

Contribuições são bem-vindas! Por favor:

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/amazing-feature`)
3. Commit suas mudanças (`git commit -m 'Add amazing feature'`)
4. Push para a branch (`git push origin feature/amazing-feature`)
5. Abra um Pull Request

### Desenvolvimento

```bash
# Clone o repositório
git clone https://github.com/ditointernet/dito_ios.git

# Instale dependências
cd dito_ios
pod install

# Abra o workspace
open DitoSDK.xcworkspace
```

### Executando Testes

```bash
# Via Xcode
⌘ + U

# Ou via terminal
xcodebuild test -workspace DitoSDK.xcworkspace \
                -scheme DitoSDK \
                -destination 'platform=iOS Simulator,name=iPhone 15'
```

---

## 📝 License

DitoSDK está disponível sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais informações.

---

## 👥 Authors

**Dito Team** - [Dito CRM](https://www.dito.com.br)

---

## 📞 Support

- 📧 Email: suporte@dito.com.br
- 💬 Slack: [Dito Community](https://dito-community.slack.com)
- 🐛 Issues: [GitHub Issues](https://github.com/ditointernet/dito_ios/issues)

---

<p align="center">
  Feito com ❤️ pela equipe Dito
</p>
