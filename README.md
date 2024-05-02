# CS Livness Flutter Plugin
## Instruções de uso

Adicione um arquivo `.gradle.env` que contenha as seguintes variávies:

```
CS_LIVENESS_TEC_ARTIFACTS_FEED_URL=ARTIFACTS_FEED_URL // valor fornecido pela clear sale
CS_LIVENESS_TEC_ARTIFACTS_FEED_NAME=ARTIFACTS_FEED_NAME // valor fornecido pela clear sale
CS_LIVINESS_TEC_USER=USERNAME // valor fornecido pela clear sale
CS_LIVINESS_TEC_PASS=ACCESSTOKEN // valor fornecido pela clear sale
CS_LIVENESS_VERSION=LAST_VERSION // valor fornecido pela clear sale
```

Após isso, adicione no seu projeto Android, no arquivo build.gradle, após o buildscript a seguinte linha:
```
def defaultPath = System.env.DIRNAME ?: System.env.PWD
System.properties["ENV_FILE"] = defaultPath + "/../.gradle.env"
```

Ex.:
```
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

## Para uso do plugin

Para inicializar o sdk, crie uma instância da classe `CsLiveness`, passando as credenciais de acesso que foram recebidas pela ClearSale, IdentifierId, cpf do usuário e configurações (OPCIONAL):

Ex.: 
```
final _csLiveness = CsLiveness(
    clientId: clientId,
    clientSecret: clientSecret,
    identifierId: identifierId,
    cpf: cpf,
    config: config
  );
```

Existe um método Future chamado `start`que retorna um tipo `CsLivenessResult`, use-o para inicializar o SDK:

Ex.: 
```
final result = await _csLiveness.start();
```
