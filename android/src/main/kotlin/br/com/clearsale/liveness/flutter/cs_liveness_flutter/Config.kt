package br.com.clearsale.liveness.flutter.cs_liveness_flutter

import java.io.Serializable

@kotlinx.serialization.Serializable
data class Config @JvmOverloads constructor(
    val vocalGuidance: Boolean = false,
    val colors: Colors? = null
): Serializable