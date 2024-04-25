package br.com.clearsale.liveness.flutter.cs_liveness_flutter

import java.io.Serializable

@kotlinx.serialization.Serializable
public class Colors @JvmOverloads constructor(
    val primary: String? = null,
    val secondary: String? = null,
    val title: String? = null,
    val paragraph: String? = null
): Serializable