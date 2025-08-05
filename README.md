# liveness_flutter_sdk

CSLiveness Flutter

## Instalação

```sh
flutter pub add liveness_flutter_sdk
```

Então, adicione nosso repositório na sua lista de repositórios (no seu arquivo `build.gradle.kts` ou `build.gradle`) no seu projeto `android` nativo:

```kotlin
allprojects {
    repositories {
        ...
        maven {
          url = uri("https://pkgs.dev.azure.com/CS-PublicPackages/SDKS/_packaging/SDKS/maven/v1")
        }
    }
}
```

Para `iOS`, primeiro instale o plugin [cocoapods-azure-universal-packages](https://github.com/microsoft/cocoapods-azure-universal-packages).

Após isso, certifique-se de logar no azure cli com az devops login usando o `PAT` que foi enviado para você por e-mail.

```shell
az devops login --organization https://dev.azure.com/CS-PublicPackages
```

Feito isso, adicione nosso repositório no seu Podfile:

```ruby
plugin 'cocoapods-azure-universal-packages', {
    :organization => 'https://dev.azure.com/CS-PublicPackages/'
}
```

Então, adicione o `SDK` como sua dependência no `Podfile`:

```ruby
  pod "CSLivenessSDK", :http => 'https://dev.azure.com/CS-PublicPackages/SDKS/_apis/packaging/feeds/SDKS/upack/packages/cslivenesssdk-ios/versions/4.0.1'
```

## Instruções de uso
Importe o plugin no seu projeto e use o método `openCSLiveness` que irá chamar a SDK nativa do dispositivo.

O resultado da função `open` é um `future` que pode retornar os seguintes valores:
```dart
class CSLivenessResult {
  final bool real;
  final String sessionId;
  final String image;
  final String? responseMessage;
}
```

Caso o `future` seja rejeitado, ela retorna o erro que causou a rejeição (`CSLivenessResult no Android`, `CSLivenessError no iOS` e `UserCancel`).

## Exemplo de uso
```dart
// Platform messages are asynchronous, so we initialize in an async method.
Future<void> callCSLivenessSDK(
    String accessToken,
    String transactionId,
    bool vocalGuidance,
    Color primaryColor,
    Color secondaryColor,
    Color titleColor,
    Color paragraphColor) async {
  // Platform messages may fail, so we use a try/catch PlatformException.
  // We also handle the message potentially returning null.
  String result;
  try {
    var sdkResponse =
    await _livenessFlutterSdkPlugin.openCSLiveness(
        accessToken,
        transactionId,
        vocalGuidance,
        primaryColor,
        secondaryColor,
        titleColor,
        paragraphColor,
        environment: LivenessEnvironments.hml);

    result = jsonEncode(sdkResponse);
  } on PlatformException catch (e) {
    result = "Error: $e";
  } catch (e) {
    result = "Error: $e";
  }

  // If the widget was removed from the tree while the asynchronous platform
  // message was in flight, we want to discard the reply rather than calling
  // setState to update our non-existent appearance.
  if (!mounted) return;

  setState(() {
    _result = result;
  });
}
```

### Como obter o accessToken e transactionId?
- `accessToken`: Faça a autenticação seguindo as instruções da [API DataTrust](https://devs.plataformadatatrust.clearsale.com.br/reference/post_v1-authentication) e obtenha o `token` do retorno.
- `transactionId`: Crie uma transação seguindo as instruções da [API DataTrust](https://devs.plataformadatatrust.clearsale.com.br/reference/post_v1-transaction) e obtenha o `id` do retorno.


## Executando o aplicativo de exemplo

1. Conecte um dispositivo físico (`Android` ou `iOS` - o nosso `SDK` não roda em emuladores, apenas em dispositivos fisícos) à sua máquina de desenvolvimento.
2. Clone esse repositório e rode `flutter pub get`.
3. Coloque suas credenciais no arquivo `clearsale.gradle.env` na raiz do projeto de exemplo e adicione também as credenciais no arquivo `example/ios/Podfile`.
4. Inicie o app
5. Ao pressionar o botão `Open CSLiveness` o SDK Liveness iniciará. Após completar o fluxo o aplicativo retorna o resultado.

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
