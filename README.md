# DitoSDK para iOS - Deprecado
Módulo atual - [https://github.com/ditointernet/sdk-mobile](https://github.com/ditointernet/sdk-mobile)

<p align="center">
  SDK iOS oficial da Dito para integração com a plataforma de CRM e Marketing Automation
</p>

<p align="center">
  <a href="#sobre">Sobre</a> •
  <a href="#features">Features</a> •
  <a href="#requirements">Requirements</a> •
  <a href="#installation">Installation</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="/API_REFERENCE.md">API Reference</a> •
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

## ⚠️ Breaking Changes importantes

A versão 2.0.0 do DitoSDK introduz mudanças que podem quebrar integrações existentes. Leia atentamente e siga os passos de migração abaixo para evitar quebras no seu app (para mais detalhes leia o [guia de migração](MIGRATION_GUIDE.md)):

- API de registro de dispositivo: os métodos que aceitavam `tokenType` foram removidos/deprecados.

  - Antes: `Dito.registerDevice(token: fcmToken, tokenType: .firebase)`
  - Agora: `Dito.registerDevice(token: fcmToken)`
  - Ação: Remova o parâmetro `tokenType` em todas as chamadas `registerDevice` e `unregisterDevice`.

- Ordem de inicialização do Firebase (iOS 18): é obrigatório configurar o Firebase e definir o token APNS antes de solicitar o token FCM para evitar o erro "APNS device token not set before retrieving FCM Token".

  - Ação: No `AppDelegate`, chame `FirebaseApp.configure()` primeiro, depois `Messaging.messaging().delegate = self`, e em seguida `Dito.configure()`. Em `didRegisterForRemoteNotificationsWithDeviceToken` atribua `Messaging.messaging().apnsToken = deviceToken` antes de chamar `Messaging.messaging().token { ... }`.

- CoreData (iOS 16+): várias APIs internas foram alteradas para garantir thread-safety e executar operações em background.
  - Ação: Não acesse diretamente contexts do CoreData em background fora das APIs públicas do SDK; verifique chamadas customizadas que manipulam o `viewContext`.

Checklist rápido de migração:

- Atualize o Podfile para usar DitoSDK 2.0.0+ e rode `pod update DitoSDK`.
- Remova qualquer uso de `tokenType` nas chamadas `registerDevice`/`unregisterDevice`.
- Ajuste a ordem de inicialização no `AppDelegate` conforme descrito acima.
- Verifique `Info.plist` (chaves `ApiKey`, `ApiSecret`, `CFBundleVersion`) e o `GoogleService-Info.plist`.
- Rode os testes de compilação e verifique logs de token APNS/FCM.

Consulte `MIGRATION_GUIDE.md` para instruções completas e exemplos de código.

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
- ✅ **Suporte a iOS 16+** - Funciona em versões antigas de iOS

---

## 📱 Requirements

| Requisito        | Versão Mínima |
| ---------------- | ------------- |
| iOS              | 16.0+         |
| Xcode            | 14.0+         |
| Swift            | 5.5+          |
| Firebase iOS SDK | 9.0+          |
| CocoaPods        | 1.11.0+       |

---

## 📦 Installation

### Opção 1: Via CocoaPods (Recomendado)

#### 1.1 Adicione o DitoSDK ao Podfile

```ruby
pod 'DitoSDK', :git => 'https://github.com/ditointernet/dito_ios.git', :branch => 'v2.0.0'
```

### Passo 3: Configure o AppDelegate

```swift
import DitoSDK
import FirebaseAnalytics
import FirebaseCore
import FirebaseMessaging
import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    var fcmToken: String?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]?
    ) -> Bool {
        // ⚠️ ORDEM IMPORTANTE para iOS 18+
        // Configure Firebase PRIMEIRO
        FirebaseApp.configure()

    // Define o delegate do Firebase Messaging para tratar token e mensagens
    Messaging.messaging().delegate = self

    // Inicializa o Dito SDK (configurações internas do SDK)
    Dito.configure()

    // Configura o centro de notificações e registra o app para receber push
    UNUserNotificationCenter.current().delegate = self
    registerForPushNotifications(application: application)

        return true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // IMPORTANTE: setar o token APNS no Firebase Messaging ANTES de solicitar o token FCM
        Messaging.messaging().apnsToken = deviceToken

        Messaging.messaging().token { [weak self] fcmToken, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let fcmToken = fcmToken {
                self?.fcmToken = fcmToken
                print("FCM registration token: \(fcmToken)")
            }
        }
    }

    // MARK: Background remote notification (silent / content-available)
    // Este método é chamado quando uma notificação silenciosa é recebida
    // mesmo que o app esteja em background ou encerrado
    // é necessário ter o "Remote notifications" habilitado em Background Modes e "Background fetch" ativado
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        let callNotificationRead: (String) -> Void = { token in
            // Garantir que o evento de leitura seja disparado mesmo em background
            Dito.notificationRead(with: userInfo, token: token)
            // Notifica o Firebase Messaging sobre a mensagem recebida
            Messaging.messaging().appDidReceiveMessage(userInfo)
            // Chama o completion handler indicando que novos dados foram processados
            completionHandler(.newData)
        }

        if let token = self.fcmToken {
            callNotificationRead(token)
        } else {
                // Fallback: tentar obter o token se ainda não estiver armazenado
            Messaging.messaging().token { [weak self] token, error in
                if let token = token {
                    self?.fcmToken = token
                    callNotificationRead(token)
                } else {
                    print("FCM token indisponível em background: \(error?.localizedDescription ?? "erro desconhecido")")
                    completionHandler(.noData)
                }
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
    // Notifica o Firebase Messaging sobre a mensagem recebida
    Messaging.messaging().appDidReceiveMessage(userInfo)
    // Exibe a notificação mesmo quando o app está em primeiro plano
    completionHandler([[.banner, .list, .sound, .badge]])
    }

    private func registerForPushNotifications(application: UIApplication) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]

        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions
        ) { granted, error in
            if let error = error {
                print(
                    "Error requesting notification authorization: \(error.localizedDescription)"
                )
                return
            }

            guard granted else {
                print("Notification authorization not granted")
                return
            }

            print("Autorização de notificações concedida")
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        if let token = fcmToken {
            Dito.notificationRead(with: userInfo, token: token)
        } else {
            print("Warning: FCM token not available for notificationRead")
        }
        // Notifica o Dito SDK sobre o clique na notificação
        Dito.notificationClick(with: userInfo)

    // Notifica o Firebase Messaging sobre a interação com a notificação
    Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler()
    }
}
```

> 📚 **Documentação Firebase**: [Firebase Cloud Messaging for iOS](https://firebase.google.com/docs/cloud-messaging/ios/client)

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
    Dito.configure()

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
- 📚 [Documentação Dito](https://developers.dito.com.br)
- 🔥 [Firebase iOS Documentation](https://firebase.google.com/docs/ios/setup)
- 🔔 [Firebase Cloud Messaging iOS](https://firebase.google.com/docs/cloud-messaging/ios/client)
- 📱 [Apple User Notifications](https://developer.apple.com/documentation/usernotifications)

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

## 📞 Support

- 🐛 **Issues**: [GitHub Issues](https://github.com/ditointernet/dito_ios/issues)

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
