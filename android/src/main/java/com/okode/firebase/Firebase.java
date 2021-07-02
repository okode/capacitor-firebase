package com.okode.firebase;

import android.Manifest;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.annotation.Permission;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.analytics.FirebaseAnalytics;
import com.google.firebase.dynamiclinks.FirebaseDynamicLinks;
import com.google.firebase.dynamiclinks.PendingDynamicLinkData;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.remoteconfig.FirebaseRemoteConfig;
import com.google.firebase.remoteconfig.FirebaseRemoteConfigValue;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;

import static android.content.ContentValues.TAG;

@CapacitorPlugin(
    permissions = {
        @Permission(strings = { Manifest.permission.ACCESS_NETWORK_STATE }, alias = "accessNetPermission" ),
        @Permission(strings = { Manifest.permission.INTERNET }, alias = "internetPermission" ),
        @Permission(strings = { Manifest.permission.WAKE_LOCK }, alias = "wakeLockPermission" )
    }
)
public class Firebase extends Plugin {

    private static final String EVENT_DEEPLINK_OPEN = "dynamicDeeplinkOpen";
    private FirebaseAnalytics firebaseAnalytics;

    @Override
    public void load() {
        super.load();
        firebaseAnalytics = FirebaseAnalytics.getInstance(getContext());
    }

    // Firebase Analytics

    @PluginMethod()
    public void logEvent(PluginCall call) {
        final String eventName = call.getString("name", null);
        final JSONObject params = call.getData().optJSONObject("parameters");

        if (eventName == null) {
            call.reject("key 'name' does not exist");
            return;
        }

        // Preparing event bundle
        Bundle bundle = new Bundle();
        if (params != null) {
            try {
                Iterator<String> keys = params.keys();
                while (keys.hasNext()) {
                    String key = keys.next();
                    Object value = params.get(key);

                    if (value instanceof String) {
                        bundle.putString(key, (String) value);
                    } else if (value instanceof Integer) {
                        bundle.putInt(key, (Integer) value);
                    } else if (value instanceof Double) {
                        bundle.putDouble(key, (Double) value);
                    } else if (value instanceof Long) {
                        bundle.putLong(key, (Long) value);
                    } else if (value != null) {
                        bundle.putString(key, value.toString());
                    } else {
                        call.reject("Value for key " + key + " cannot be NULL");
                    }
                }
            } catch (JSONException e) {
                call.reject(e.getLocalizedMessage(), e);
            }
        }

        firebaseAnalytics.logEvent(eventName, bundle);
        call.resolve();
    }


    @PluginMethod()
    public void setUserProperty(PluginCall call) {
        final String name = call.getString("name");
        final String value = call.getString("value");
        if (name != null) {
            firebaseAnalytics.setUserProperty(name, value);
            call.resolve();
        } else {
            call.reject("key 'name' does not exist");
        }
    }

    @PluginMethod()
    public void setUserId(PluginCall call) {
        final String userId = call.getString("userId");
        firebaseAnalytics.setUserId(userId);
        call.resolve();
    }

    @PluginMethod()
    public void setScreenName(PluginCall call) {
        final String value = call.getString("screenName");
        final String overrideName = call.getString("screenClassOverride", null);
        getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Bundle bundle = new Bundle();
                bundle.putString(FirebaseAnalytics.Param.SCREEN_NAME, value);
                bundle.putString(FirebaseAnalytics.Param.SCREEN_CLASS, overrideName);
                firebaseAnalytics.logEvent(FirebaseAnalytics.Event.SCREEN_VIEW, bundle);
            }
        });
        call.resolve();
    }

    // Firebase Remote Config

    @PluginMethod()
    public void activateFetched(final PluginCall call) {
        FirebaseRemoteConfig.getInstance().activate()
            .addOnSuccessListener(new OnSuccessListener<Boolean>() {
                @Override
                public void onSuccess(Boolean activated) {
                final JSObject res = new JSObject();
                res.put("activated", activated);
                call.resolve(res);
                }
            }).addOnFailureListener(new OnFailureListener() {
                @Override
                public void onFailure(@NonNull Exception e) {
                call.reject("Error activating fetched remote config");
                }
            });
    }

    @PluginMethod()
    public void fetch(final PluginCall call) {
        JSObject callData = call.getData();

        Long cacheTime;
        try {
            cacheTime = callData != null ? callData.getLong("cache") : null;
        } catch (JSONException e) {
            cacheTime = null;
        }

        Task<Void> fetchTask = cacheTime != null ?
                FirebaseRemoteConfig.getInstance().fetch(cacheTime)
                : FirebaseRemoteConfig.getInstance().fetch();

        fetchTask.addOnSuccessListener(new OnSuccessListener<Void>() {
                @Override
                public void onSuccess(Void aVoid) {
                    call.resolve();
                }
            }).addOnFailureListener(new OnFailureListener() {
        @Override
        public void onFailure(@NonNull Exception e) {
                    call.reject("Error fetching remote config");
                }
            });
    }

    @PluginMethod()
    public void getRemoteConfigValue(PluginCall call) {
        final String key = call.getString("key");
        if (key != null) {
            FirebaseRemoteConfigValue configValue = FirebaseRemoteConfig.getInstance().getValue(key);
            final JSObject res = new JSObject();
            res.put("value", configValue.asString());
            call.resolve(res);
        } else {
            call.reject("You must pass 'key'");
        }
    }

    // Firebase Messaging

    @PluginMethod()
    public void getToken(final PluginCall call) {
        FirebaseMessaging.getInstance().getToken().addOnCompleteListener(new OnCompleteListener<String>() {
            @Override
            public void onComplete(@NonNull Task<String> task) {
                if (!task.isSuccessful()) {
                    call.reject("Cant get token", task.getException());
                    return;
                }
                String token = task.getResult();
                final JSObject res = new JSObject();
                res.put("token", token);
                call.resolve(res);
            }
        });
    }

    /**
     * Handle ACTION_VIEW intents to store a URL that was used to open the app
     */
    @Override
    protected void handleOnNewIntent(Intent intent) {
        super.handleOnNewIntent(intent);

        FirebaseDynamicLinks.getInstance()
            .getDynamicLink(intent)
            .addOnSuccessListener(new OnSuccessListener<PendingDynamicLinkData>() {
                @Override
                public void onSuccess(PendingDynamicLinkData pendingDynamicLinkData) {
                // Get deep link from result (may be null if no link is found)
                Uri deepLink = null;
                if (pendingDynamicLinkData != null) {
                    deepLink = pendingDynamicLinkData.getLink();
                }

                if (deepLink != null) {
                    final JSObject res = new JSObject();
                    res.put("url", deepLink.toString());
                    notifyListeners(EVENT_DEEPLINK_OPEN, res, true);
                }
                }

            })
            .addOnFailureListener(new OnFailureListener() {
                @Override
                public void onFailure(@NonNull Exception e) {
                    Log.w(TAG, "getDynamicLink:onFailure", e);
                }
            });
    }

}
