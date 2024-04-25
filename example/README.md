# Amostra de aplicativo Liveness (Flutter)

## Introdução
_______

O objetivo deste manual é fornecer todas as informações necessárias para instalação e uso da ferramenta nos aplicativos desenvolvidos para plataforma Flutter.

Este plugin realiza a captura de faces para processamento de liveness pela ClearSale. Todas as informações coletadas são dados relacionados apenas ao dispositivo, sem relação com aplicativo integrado.

As informações de captura de imagem dependem da permissão concedida pelo usuário no momento de captura. Neste caso é necessário que o aplicativo solicite o acesso à câmera ao usuário para dar prosseguimento com a coleta de prova de vida.

O Plugin respeita a política de privacidade da Apple para a captura dos dados do dispositivo e o nível de permissão atribuído pelo usuário (usuário do dispositivo).

___

# Android

## Requisitos:

- 25 MB de espaço em disco
- Versão do sistema operacional Android: v5.0 (API v21) ou superior.
- compileSdkVersão: 33
- targetSdkVersion: 33
- com.google.android.material:material superior a 1.5.0
- kotlin_version igual ou superior 1.6.10
- plugin Android SDK Build-Tools 30.0.3

## Instruções de uso

Adicione um arquivo `.gradle.env` na pasta raiz do projeto (LivenessSampleFlutter) que contenha as seguintes variávies:

```
CS_LIVENESS_TEC_ARTIFACTS_FEED_URL=ARTIFACTS_FEED_URL // valor fornecido pela clear sale
CS_LIVENESS_TEC_ARTIFACTS_FEED_NAME=ARTIFACTS_FEED_NAME // valor fornecido pela clear sale
CS_LIVINESS_TEC_USER=USERNAME // valor fornecido pela clear sale
CS_LIVINESS_TEC_PASS=ACCESSTOKEN // valor fornecido pela clear sale
CS_LIVENESS_VERSION=LAST_VERSION // valor fornecido pela clear sale
```

Ex.:
```gradle
buildscript {
    ext.kotlin_version = '1.6.10'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:7.1.2'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}

def defaultPath = System.env.DIRNAME ?: System.env.PWD
System.properties["ENV_FILE"] = defaultPath + "/../.gradle.env"

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```
---
# iOS

## Requisitos

- Versão do sistema operacional iOS: 12.4 ou superior.
- Versão do projeto Swift 4+: funciona com Xcode anterior ao 13.

### Instalação do Pacote

CocoaPods
Para adicionar o SDK ao seu projeto utilizando Cocoapods basta adicionar o seguinte comando ao seu Podfile:

Instalação em ambiente de desenvolvimento e testes

### Instalação em ambiente de desenvolvimento e testes

```ruby
platform :ios, '12.4'

use_frameworks!
target 'NOME_DO_SEU_PROJETO' do
    pod 'CSLivenessSDK', :git => 'URL DO REPOSITÓRIO ENVIADO PELA CLEAR SALE', :tag => '1.2.0-hml'
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    # Adicionar
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.4'
    end
    flutter_additional_ios_build_settings(target)
  end
end
```

### Instalação em ambiente de produção

```ruby
platform :ios, '12.4'

use_frameworks!
target 'NOME_DO_SEU_PROJETO' do
    pod 'CSLivenessSDK', :git => 'URL DO REPOSITÓRIO ENVIADO PELA CLEAR SALE', :tag => '1.2.0'
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    # Adicionar
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.4'
    end
    flutter_additional_ios_build_settings(target)
  end
end
```
## Configuração

Instruções para configuração do framework no projeto:

- Adicionar as seguintes entradas ao arquivo Info.plist do projeto de destino:

```
<key>NSCameraUsageDescription</key>
<string>This app requires access to the camera.</string>
```

> Após confifurações executar `pod install`

## Flutter

## Início rápido

### 1. Instalação

Adicione nas dependencias do `pubspec.yaml`:

```yaml
cs_liveness_flutter:
git:
    url: https://github.com/ClearSale/LivenessPluginFlutter.git
    ref: 1.2.0
```

### 2. Credenciais
Preencha as variáveis abaixo no arquivo liveness_store.dart
* linha 8: clientId - identifica o client junto a ClearSale, este valor é fornecido pela ClearSale.
* linha 9: clientSecret - token de autenticação do cliente, este valor é fornecido pela ClearSale.

### Método `start`:

> Inicializa o reconhecimento e retorna um `CSLivenessResult`.

### Retorno `result`:

> `CSLivenessResult` que possui: `image` (`Image?`), `base64Image` (`String?`), `sessionId` (`String?`), `real` (`bool?`) que são as informações acerca do reconhecimento.

```dart
final csLiveness = CsLiveness(
    clientId: "CLIENT_ID",
    clientSecret: "CLIENT_SECRET",
    vocalGuidance: true,
);

final livenessResult = await csLiveness.start();
Image? recognizedImage = livenessResult.image;
String? sessionId = livenessResult.sessionId;
bool? recognizedImage = livenessResult.real;
```

## Detalhes de privacidade

**Uso de dados**

Todas as informações coletadas pelo SDK da ClearSale são com exclusiva finalidade de prevenção à fraude e proteção ao próprio usuário, aderente à política de segurança e privacidade das plataformas Google e Apple e à LGPD. Por isso, estas informações devem constar na política de privacidade do aplicativo.

**Tipo de dados coletados**

O SDK da ClearSale coleta as seguintes informações do dispositivo :

Características físicas do dispositivo/ hardware (Como tela, modelo, nome do dispositivo);
Características de software (Como versão, idioma, build, controle parental);
Informações da câmera;
Licença de Uso
Ao realizar o download e utilizar nosso SDK você estará concordando com a seguinte licença:

**Copyright © 2022 ClearSale**

Todos os direitos são reservados, sendo concedida a permissão para usar o software da maneira como está, não sendo permitido qualquer modificação ou cópia para qualquer fim. O Software é licenciado com suas atuais configurações “tal como está” e sem garantia de qualquer espécie, nem expressa e nem implícita, incluindo mas não se limitando, garantias de comercialização, adequação para fins particulares e não violação de direitos patenteados. Em nenhuma hipótese os titulares dos Direitos Autorais podem ser responsabilizados por danos, perdas, causas de ação, quer seja por contrato ou ato ilícito, ou outra ação tortuosa advinda do uso do Software ou outras ações relacionadas com este Software sem prévia autorização escrita do detentor dos direitos autorais.
