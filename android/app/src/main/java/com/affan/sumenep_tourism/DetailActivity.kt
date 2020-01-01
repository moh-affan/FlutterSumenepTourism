package com.affan.sumenep_tourism

import android.graphics.Bitmap
import android.os.Bundle
import com.google.android.material.snackbar.Snackbar
import androidx.appcompat.app.AppCompatActivity
import android.view.MenuItem
import com.google.vr.sdk.widgets.pano.VrPanoramaView

import kotlinx.android.synthetic.main.activity_detail.*
import kotlinx.android.synthetic.main.content_detail.*

class DetailActivity : AppCompatActivity() {
    private var bitmap: Bitmap? = null
    private var deskripsi: String? = null
    private var nama: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_detail)
        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        val key = intent.getStringExtra(MainActivity.KEY_BITMAP)
        deskripsi = intent.getStringExtra(MainActivity.KEY_DESKRIPSI)
        nama = intent.getStringExtra(MainActivity.KEY_NAMA)
        nama?.let {
            supportActionBar?.title = it
        }
        bitmap = Helper.getBitmapFromAsset(this, key!!)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)

        initComponents()
    }

    private fun initComponents() {
        pano_view.setInfoButtonEnabled(false)
        if (bitmap != null) {
            val options = VrPanoramaView.Options()
            options.inputType = VrPanoramaView.Options.TYPE_MONO
            pano_view.loadImageFromBitmap(bitmap, options)
        }
        deskripsi?.let {
            txt_deskripsi.text = it
        }
    }

    override fun onOptionsItemSelected(item: MenuItem?): Boolean {
        when (item?.itemId) {
            android.R.id.home -> onBackPressed()
        }
        return super.onOptionsItemSelected(item!!)
    }

}
