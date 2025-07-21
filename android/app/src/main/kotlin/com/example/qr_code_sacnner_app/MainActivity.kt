package com.example.qr_code_sacnner_app

import android.content.ActivityNotFoundException
import android.content.Intent
import android.os.Bundle
import android.provider.ContactsContract
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.ContentValues


class MainActivity : FlutterActivity() {
    private val CHANNEL = "vcard_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "insertContactFromVCard") {
                val vcard = call.argument<String>("vcard")
                if (vcard != null) {
                    openContactInsertWithVCard(vcard)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "vCard data is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }


private fun openContactInsertWithVCard(vcard: String) {
    val lines = vcard.lines()

    var fullName: String? = null
    val phones = mutableListOf<String>()
    val emails = mutableListOf<String>()
    var organization: String? = null
    var title: String? = null
    var birthday: String? = null
    var note: String? = null
    var website: String? = null

    var street: String? = null
    var city: String? = null
    var region: String? = null
    var postalCode: String? = null
    var country: String? = null

    for (line in lines) {
        when {
            line.startsWith("FN:") -> fullName = line.substringAfter("FN:")
            line.startsWith("TEL") -> phones.add(line.substringAfter(":"))
            line.startsWith("EMAIL") -> emails.add(line.substringAfter(":"))
            line.startsWith("ORG:") -> organization = line.substringAfter("ORG:")
            line.startsWith("TITLE:") -> title = line.substringAfter("TITLE:")
            line.startsWith("BDAY:") -> birthday = line.substringAfter("BDAY:")
            line.startsWith("NOTE:") -> note = line.substringAfter("NOTE:")
            line.startsWith("URL:") -> website = line.substringAfter("URL:")
            line.startsWith("ADR") -> {
                val parts = line.substringAfter(":").split(";")
                street = parts.getOrNull(2)
                city = parts.getOrNull(3)
                region = parts.getOrNull(4)
                postalCode = parts.getOrNull(5)
                country = parts.getOrNull(6)
            }
        }
    }

    // Construct single-line postal address if components found
    val address = listOfNotNull(street, city, region, postalCode, country)
        .joinToString(", ").ifBlank { null }

    val notes = listOfNotNull(note).joinToString("\n")

    val dataList = arrayListOf<ContentValues>()

    // Add website (via ContentValues because no direct EXTRA exists for website)
    website?.let {
        val websiteData = ContentValues().apply {
            put(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Website.CONTENT_ITEM_TYPE)
            put(ContactsContract.CommonDataKinds.Website.URL, it)
            put(ContactsContract.CommonDataKinds.Website.TYPE, ContactsContract.CommonDataKinds.Website.TYPE_WORK)
        }
        dataList.add(websiteData)
    }

    // Add birthday
    birthday?.let {
        val birthdayData = ContentValues().apply {
            put(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Event.CONTENT_ITEM_TYPE)
            put(ContactsContract.CommonDataKinds.Event.TYPE, ContactsContract.CommonDataKinds.Event.TYPE_BIRTHDAY)
            put(ContactsContract.CommonDataKinds.Event.START_DATE, it)
        }
        dataList.add(birthdayData)
    }

    val intent = Intent(Intent.ACTION_INSERT).apply {
        type = ContactsContract.RawContacts.CONTENT_TYPE

        // ✅ Use NAME extra for full name
        putExtra(ContactsContract.Intents.Insert.NAME, fullName)

        // ✅ Use standard address line
        address?.let {
            putExtra(ContactsContract.Intents.Insert.POSTAL, it)
        }

        if (phones.isNotEmpty()) {
            putExtra(ContactsContract.Intents.Insert.PHONE, phones[0])
            if (phones.size > 1) putExtra(ContactsContract.Intents.Insert.SECONDARY_PHONE, phones[1])
            if (phones.size > 2) putExtra(ContactsContract.Intents.Insert.TERTIARY_PHONE, phones[2])
        }

        if (emails.isNotEmpty()) {
            putExtra(ContactsContract.Intents.Insert.EMAIL, emails[0])
            if (emails.size > 1) putExtra(ContactsContract.Intents.Insert.SECONDARY_EMAIL, emails[1])
        }

        putExtra(ContactsContract.Intents.Insert.COMPANY, organization)
        putExtra(ContactsContract.Intents.Insert.JOB_TITLE, title)
        putExtra(ContactsContract.Intents.Insert.NOTES, notes)

        // Add website + birthday as extras
        if (dataList.isNotEmpty()) {
            putParcelableArrayListExtra(ContactsContract.Intents.Insert.DATA, dataList)
        }
    }

    try {
        startActivity(intent)
    } catch (e: ActivityNotFoundException) {
        Toast.makeText(this, "No contact app found", Toast.LENGTH_SHORT).show()
    }
}


}
