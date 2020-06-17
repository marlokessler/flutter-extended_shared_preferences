package com.connapptivity.developer.sharedpreferences

// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import android.annotation.SuppressLint
import android.content.Context
import android.content.SharedPreferences
import android.os.AsyncTask
import android.provider.ContactsContract.CommonDataKinds.StructuredName.PREFIX
import android.util.Base64
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import java.io.*
import java.math.BigInteger
import java.util.*


/**
 * Implementation of the [MethodChannel.MethodCallHandler] for the plugin. It is also
 * responsible of managing the [android.content.SharedPreferences].
 */
internal class MethodCallHandlerSharedPreferences(private val context: Context) : MethodCallHandler {



    companion object {
        // Fun fact: The following is a base64 encoding of the string "This is the prefix for a list."
        private const val LIST_IDENTIFIER = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu"
        private const val BIG_INTEGER_PREFIX = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBCaWdJbnRlZ2Vy"
        private const val DOUBLE_PREFIX = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBEb3VibGUu"
    }



    @SuppressLint("CommitPrefEdits")
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val key = call.argument<String>("key")
        if (key == null) {
            result.error("001", "Key is null", "The passed key from call.arguments[\"key\"] is null.")
            return
        }

        val filename = call.argument<String>("filename")
        if (filename == null) {
            result.error("002", "Filename is null", "The passed filename from call.arguments[\"filename\"] is null.")
            return
        }

        val preferences: SharedPreferences = getPreferences(filename)

        try {
            when (call.method) {

                "getAll" -> {
                    result.success(getAllPrefs(filename))
                    return
                }

                "setBool" -> commitAsync(preferences.edit().putBoolean(key, call.argument<Boolean>("value")!!), result)

                "setInt" -> {
                    val number = call.argument<Number>("value")
                    if (number is BigInteger) {
                        commitAsync(preferences.edit().putString(key, BIG_INTEGER_PREFIX + number.toString(Character.MAX_RADIX)), result)
                    } else {
                        commitAsync(preferences.edit().putLong(key, number?.toLong() ?: 0), result)
                    }
                }

                "setDouble" -> {
                    val doubleValue: Double = (call.argument<Any>("value") as Number?)!!.toDouble()
                    val doubleValueStr = doubleValue.toString()
                    commitAsync(preferences.edit().putString(key, DOUBLE_PREFIX + doubleValueStr), result)
                }

                "setString" -> {
                    val value = call.argument<Any>("value") as String
                    if (value.startsWith(LIST_IDENTIFIER) || value.startsWith(BIG_INTEGER_PREFIX)) {
                        result.error("StorageError", "This string cannot be stored as it clashes with special identifier prefixes.", null)
                        return
                    }
                    commitAsync(preferences.edit().putString(key, value), result)
                }

                "setStringList" -> {
                    val list = call.argument<List<String>>("value")!!
                    commitAsync(preferences.edit().putString(key, LIST_IDENTIFIER + encodeList(list)), result)
                }

                "remove" -> commitAsync(preferences.edit().remove(key), result)

                "clear" -> commitAsync(preferences.edit().clear(), result)

                else -> result.notImplemented()
            }
        } catch (e: IOException) {
            result.error("IOException encountered", call.method, e)
        }
    }



    /**
     * @param filename The file to store the preferences.
     * @return An instance of [SharedPreferences].
     */
    private fun getPreferences(filename: String): SharedPreferences {
        return context.getSharedPreferences(filename, Context.MODE_PRIVATE)
    }

    private fun commitAsync(editor: SharedPreferences.Editor, result: MethodChannel.Result) {
        object : AsyncTask<Void?, Void?, Boolean?>() {
            override fun doInBackground(vararg voids: Void?): Boolean {
                return editor.commit()
            }

            override fun onPostExecute(value: Boolean?) {
                result.success(value)
            }
        }.execute()
    }

    @kotlin.jvm.Throws(IOException::class)
    private fun decodeList(encodedList: String): List<String> {
        var stream: ObjectInputStream? = null
        return try {
            stream = ObjectInputStream(ByteArrayInputStream(Base64.decode(encodedList, 0)))
            stream.readObject() as List<String>
        } catch (e: ClassNotFoundException) {
            throw IOException(e)
        } finally {
            stream?.close()
        }
    }

    @kotlin.jvm.Throws(IOException::class)
    private fun encodeList(list: List<String?>): String {
        var stream: ObjectOutputStream? = null
        return try {
            val byteStream = ByteArrayOutputStream()
            stream = ObjectOutputStream(byteStream)
            stream.writeObject(list)
            stream.flush()
            Base64.encodeToString(byteStream.toByteArray(), 0)
        } finally {
            stream?.close()
        }
    }

    // Filter preferences to only those set by the flutter app.
    @kotlin.jvm.Throws(IOException::class)
    private fun getAllPrefs(filename: String): Map<String, Any> {
        val preferences: SharedPreferences = getPreferences(filename)

        val allPrefs: Map<String, *> = preferences.all

        val filteredPrefs: MutableMap<String, Any> = HashMap()

        for (key in allPrefs.keys) {

            if (key.startsWith(PREFIX)) {

                var value = allPrefs[key] ?: error("")

                if (value is String) {
                    when {
                        value.startsWith(LIST_IDENTIFIER) -> value = decodeList(value.substring(LIST_IDENTIFIER.length))

                        value.startsWith(BIG_INTEGER_PREFIX) -> {
                            val encoded: String = value.substring(BIG_INTEGER_PREFIX.length)
                            value = BigInteger(encoded, Character.MAX_RADIX)
                        }

                        value.startsWith(DOUBLE_PREFIX) -> {
                            val doubleStr: String = value.substring(DOUBLE_PREFIX.length)
                            value = java.lang.Double.valueOf(doubleStr)
                        }
                    }
                }

                filteredPrefs[key] = value
            }
        }

        return filteredPrefs
    }
}
