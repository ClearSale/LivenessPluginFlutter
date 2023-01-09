# CS Livness Flutter Plugin
## Instruções de uso

Adicione um arquivo `.env.gradle` que contenha as seguintes variávies:

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

Existem 2 métodos Future na classe `CsLivenessFlutter`:

`livenessRecognition`: retorna uma String base64

Ex.: 
```
final CsLivenessFlutter _csLivenessFlutterPlugin = CsLivenessFlutter();
String? base64Image = _csLivenessFlutterPlugin.livenessRecognition(
    clientId: "CLIENT_ID",
    clientSecret: "CLIENT_SECRET",
);
```

`livenessRecognitionImage`: retorna uma imagem do Flutter.

Ex.: 
```
final CsLivenessFlutter _csLivenessFlutterPlugin = CsLivenessFlutter();
Image reconizedImage = _csLivenessFlutterPlugin.livenessRecognitionImage(
    clientId: "CLIENT_ID",
    clientSecret: "CLIENT_SECRET",
);
```

Para os dois métodos, os parâmetros clientId e clientSecret são obrigatórios e devem ser fornecidos pela ClearSale.
