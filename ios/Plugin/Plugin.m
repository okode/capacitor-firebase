#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(Firebase, "Firebase",
           CAP_PLUGIN_METHOD(logEvent, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setUserProperty, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setUserId, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setScreenName, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getAppInstanceID, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(activateFetched, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(fetch, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getRemoteConfigValue, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getToken, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setDefaults, CAPPluginReturnPromise);
)
