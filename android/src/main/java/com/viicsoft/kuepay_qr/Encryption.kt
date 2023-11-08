package android.src.main.java.com.viicsoft.kuepay_qr;

import android.annotation.TargetApi
import android.os.Build
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import android.util.Log
import java.nio.charset.StandardCharsets
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.IvParameterSpec

class Encryption {

    @TargetApi(Build.VERSION_CODES.M)
    private val keyStore = KeyStore.getInstance("AndroidKeyStore").apply {
        load(null)
    }

    @TargetApi(Build.VERSION_CODES.M)
    private fun getKey(): SecretKey {
        val secretKeyEntry = keyStore.getEntry("secret", null) as? KeyStore.SecretKeyEntry
        return secretKeyEntry?.secretKey ?: createKey()
    }

    @TargetApi(Build.VERSION_CODES.M)
    private fun createKey() : SecretKey {
        return KeyGenerator.getInstance(ALGORITHM).apply {
            init(
                KeyGenParameterSpec.Builder(
                    "secret",
                    KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
                )
                    .setBlockModes(BLOCK_MODE)
                    .setEncryptionPaddings(PADDING)
                    .build()
            )
        }.generateKey()
    }

    @TargetApi(Build.VERSION_CODES.M)
    companion object {
        private const val ALGORITHM = KeyProperties.KEY_ALGORITHM_AES
        private const val BLOCK_MODE = KeyProperties.BLOCK_MODE_CBC
        private const val PADDING = KeyProperties.ENCRYPTION_PADDING_PKCS7
        private const val TRANSFORMATION = "$ALGORITHM/$BLOCK_MODE/$PADDING"
    }

    @TargetApi(Build.VERSION_CODES.M)
    fun encryptString(data: String): String {
        return try{
            val encryptionCipher = Cipher.getInstance(TRANSFORMATION).apply {
                init(Cipher.ENCRYPT_MODE, getKey())
            }

            val cipherText = Base64.encodeToString(encryptionCipher.doFinal(data.toByteArray()), Base64.DEFAULT)
            val iv = Base64.encodeToString(encryptionCipher.iv, Base64.DEFAULT)

            "$cipherText.$iv"
        } catch (e: Exception) {
            Log.e("Encryption.kt:", "Error message - ${e.message}")
            ""
        }
    }

    @TargetApi(Build.VERSION_CODES.M)
    fun decryptData(data: String): String {
        return try{

            val fields = data.split(".")

            val encryptedBytes = Base64.decode(fields[0], Base64.DEFAULT)
            val ivBytes = Base64.decode(fields[1], Base64.DEFAULT)

            val decryptionCipher = Cipher.getInstance(TRANSFORMATION).apply {
                init(Cipher.DECRYPT_MODE, getKey(), IvParameterSpec(ivBytes))
            }

            val text = decryptionCipher.doFinal(encryptedBytes)

            String(text, 0, text.size, StandardCharsets.UTF_8)
        } catch (e: Exception) {
            Log.e("Encryption.kt:", "Error message - ${e.message}")
            ""
        }
    }
}
