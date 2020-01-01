package com.affan.sumenep_tourism

import android.content.Context
import android.content.res.AssetManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory

object Helper {
    fun getBitmapFromAsset(context: Context, assetName: String): Bitmap? {
        val assetManager: AssetManager = context.assets
        var bitmap: Bitmap? = null
        try {
            val istr = assetManager.open(assetName)
            bitmap = BitmapFactory.decodeStream(istr)
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return bitmap
    }
}