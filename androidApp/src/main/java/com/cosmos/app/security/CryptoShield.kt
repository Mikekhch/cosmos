package com.cosmos.app.security

import java.security.MessageDigest
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec
import javax.crypto.spec.SecretKeySpec

class CryptoShield {
    private var masterKey: SecretKey = generateMasterKey()

    private fun generateMasterKey(): SecretKey {
        val keyGen = KeyGenerator.getInstance("AES")
        keyGen.init(256)
        return keyGen.generateKey()
    }

    fun deriveHkdfSubkey(salt: ByteArray, info: String): SecretKey {
        val md = MessageDigest.getInstance("SHA-256")
        md.update(salt)
        md.update(info.toByteArray(Charsets.UTF_8))
        val derivedBytes = md.digest(masterKey.encoded)
        return SecretKeySpec(derivedBytes, "AES")
    }

    fun encryptAes256Gcm(plaintext: String, key: SecretKey): Pair<ByteArray, ByteArray> {
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.ENCRYPT_MODE, key)
        val iv = cipher.iv
        val ciphertext = cipher.doFinal(plaintext.toByteArray(Charsets.UTF_8))
        return Pair(ciphertext, iv)
    }

    fun decryptAes256Gcm(ciphertext: ByteArray, iv: ByteArray, key: SecretKey): String {
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        val spec = GCMParameterSpec(128, iv)
        cipher.init(Cipher.DECRYPT_MODE, key, spec)
        val plaintext = cipher.doFinal(ciphertext)
        return String(plaintext, Charsets.UTF_8)
    }

    fun rotateMasterKey(): SecretKey {
        masterKey = generateMasterKey()
        return masterKey
    }
}
