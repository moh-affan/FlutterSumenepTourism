package com.affan.sumenep_tourism

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { methodCall, result ->
            if (methodCall.method == "counter") {
                Log.d("methodChannel", methodCall.method)
                val counter = methodCall.argument<Int>("counter")
                Log.d("counter", counter.toString())
                Toast.makeText(this@MainActivity, methodCall.method + " : counter = $counter", Toast.LENGTH_SHORT).show()
                result.success(counter)
            } else if (methodCall.method == "showDetail") {
                val i = Intent(this@MainActivity, DetailActivity::class.java)
                val vrImage = methodCall.argument<String>("vrImage")
                val deskripsi = methodCall.argument<String>("deskripsi")
                val nama = methodCall.argument<String>("nama")
                i.putExtra(KEY_BITMAP, flutterView.getLookupKeyForAsset(vrImage))
                i.putExtra(KEY_DESKRIPSI, deskripsi)
                i.putExtra(KEY_NAMA, nama)
                startActivity(i)
                result.success("showDetail")
            }
            result.success("AA")
        }
    }

    companion object {
        const val CHANNEL = "com.affan.sumenep_tourism/method_channel"
        const val KEY_BITMAP = "vr_bmp"
        const val KEY_DESKRIPSI = "deskripsi"
        const val KEY_NAMA = "nama"
    }
}
