package com.marlokessler.sharedpreferences

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.Registrar



/** SharedPreferencesPlugin  */
class SharedpreferencesPlugin : FlutterPlugin {

  private var channel: MethodChannel? = null



  companion object {

    private const val CHANNEL_NAME = "com.marlokessler.sharedpreferences"

    fun registerWith(registrar: Registrar) {
      val plugin = SharedpreferencesPlugin()
      plugin.setupChannel(registrar.messenger(), registrar.context())
    }
  }



  override fun onAttachedToEngine(binding: FlutterPluginBinding) {
    setupChannel(binding.flutterEngine.dartExecutor, binding.applicationContext)
  }

  override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
    teardownChannel()
  }

  private fun setupChannel(messenger: BinaryMessenger, context: Context) {
    channel = MethodChannel(messenger, CHANNEL_NAME)
    val handler = MethodCallHandlerSharedPreferences(context)
    channel!!.setMethodCallHandler(handler)
  }

  private fun teardownChannel() {
    channel!!.setMethodCallHandler(null)
    channel = null
  }
}


