package com.example.shhnatycemexdriver

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin
import io.flutter.view.FlutterMain
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin
import com.tekartik.sqflite.SqflitePlugin
import com.baseflow.geolocator.GeolocatorPlugin
import io.flutter.plugins.pathprovider.PathProviderPlugin
import rekab.app.background_locator.IsolateHolderService
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin


class Application : FlutterApplication(), PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingService.setPluginRegistrant(this);
        IsolateHolderService.setPluginRegistrant(this)
//                 LocatorService.setPluginRegistrant(this);
        FlutterMain.startInitialization(this);
    }

    override fun registerWith(registry: PluginRegistry?) {

        if (!registry!!.hasPlugin("io.flutter.plugins.firebasemessaging")) {
            FirebaseMessagingPlugin.registerWith(registry!!.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
        }
        if (!registry!!.hasPlugin("io.flutter.plugins.sharedpreferences")) {
            SharedPreferencesPlugin.registerWith(registry!!.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
        }
        if (!registry!!.hasPlugin("com.tekartik.sqflite")) {
            SqflitePlugin.registerWith(registry!!.registrarFor("com.tekartik.sqflite.SqflitePlugin"));
        }
        if (!registry!!.hasPlugin("io.flutter.plugins.pathprovider")) {
            PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider"))
        }

        if(!registry!!.hasPlugin("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin")) {
            FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"))
        }

    }
}