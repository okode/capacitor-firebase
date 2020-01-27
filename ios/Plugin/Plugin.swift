import Foundation
import Capacitor
import FirebaseCore
import FirebaseAnalytics
import FirebaseRemoteConfig
import FirebaseInstanceID
import FirebaseDynamicLinks

@objc(Firebase)
public class Firebase: CAPPlugin {
    
    private static let DynamicLinkNotificationName = "dynamicLinkNotification"
    
    var firebase: FirebaseApp? = nil;
    var remoteConfig: RemoteConfig? = nil;
    
    public override func load() {
        if (FirebaseApp.app() == nil) {
            FirebaseApp.configure();
            firebase = FirebaseApp.app()
            remoteConfig = RemoteConfig.remoteConfig();
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleDynamicLink(notification:)), name: Notification.Name(Firebase.DynamicLinkNotificationName), object: nil)
    }
    
    // Firebase Analytics
    
    @objc func logEvent(_ call: CAPPluginCall) {
        let name = call.getString("name");
        let parameters = call.getObject("parameters") ?? nil;
        if name != nil {
            DispatchQueue.main.async {
                Analytics.logEvent(name!, parameters: parameters);
                call.success();
            }
        } else {
            call.error("You must pass an event name.")
            self.bridge.modulePrint(self, "An event name and value was not passed.")
            return
        }
    }
    
    @objc func setUserProperty(_ call: CAPPluginCall) {
        let name = call.getString("name");
        let value = call.getString("value");
        if name != nil {
            DispatchQueue.main.async {
                Analytics.setUserProperty(value, forName: name!);
                call.success();
            }
        } else {
            call.error("You must pass a User Property name")
            self.bridge.modulePrint(self, "A user property name was not passed.")
            return
        }
    }
    
    @objc func setUserId(_ call: CAPPluginCall) {
        let userId = call.getString("userId");
        DispatchQueue.main.async {
            Analytics.setUserID(userId);
            call.success();
        }
    }
    
    @objc func setScreenName(_ call: CAPPluginCall) {
        let screenName = call.getString("screenName");
        let screenClassOverride = call.getString("screenClassOverride");
        if screenName != nil {
            DispatchQueue.main.async {
                Analytics.setScreenName(screenName, screenClass: screenClassOverride);
                call.success();
            }
        } else {
            call.error("You must pass a screen name")
            self.bridge.modulePrint(self, "A screen name was not passed")
            return
        }
    }
    
    // Firebase Remote Config
    
    @objc func activateFetched(_ call: CAPPluginCall) {
        let activated = self.remoteConfig?.activateFetched();
        if activated != nil {
            call.resolve([ "activated": activated! ]);
        } else {
            call.error("Error activating fetched remote config");
            self.bridge.modulePrint(self, "Error activating fetched remote config")
        }
    }
    
    @objc func fetch(_ call: CAPPluginCall) {
        let completionHandler: RemoteConfigFetchCompletion =  { (status, error) in
            if status == .success {
                call.resolve();
            } else {
                call.error("Error fetching remote config", error);
                self.bridge.modulePrint(self, "Error fetching remote config")
            }
        };
        let cache = call.getInt("cache");
        if let cache = cache {
            self.remoteConfig?.fetch(withExpirationDuration: TimeInterval(cache), completionHandler: completionHandler)
        } else {
            self.remoteConfig?.fetch(completionHandler: completionHandler)
        }
    }
    
    @objc func getRemoteConfigValue(_ call: CAPPluginCall) {
        let key = call.getString("key");
        if key != nil {
            let configValue = self.remoteConfig?.configValue(forKey: key!);
            let configValueAsString = configValue != nil ? configValue!.stringValue : nil;
            call.resolve([ "value": configValueAsString != nil ? configValueAsString!: NSNull() ]);
        } else {
            call.error("You must pass 'key'")
            self.bridge.modulePrint(self, "You must pass 'key'")
        }
    }
    
    // Firebase Messaging
    
    @objc func getToken(_ call: CAPPluginCall) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                call.error("Cant get token", error)
            } else if let result = result {
                call.success([ "token": result.token ])
            }
        }
    }
    
    // Firebase Dynamic Deeplinks
    
    @objc public static func handleOpenUrl(_ url: URL, _ options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
          NotificationCenter.default.post(name: Notification.Name(Firebase.DynamicLinkNotificationName), object: dynamicLink)
          return true
      }
      return false
    }
    
    @objc public static func handleContinueActivity(_ userActivity: NSUserActivity, _ restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if (userActivity.webpageURL == nil) { return false }
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamicLink, error) in
            NotificationCenter.default.post(name: Notification.Name(Firebase.DynamicLinkNotificationName), object: dynamicLink)
        }
        return handled
    }

    @objc public func handleDynamicLink(notification: NSNotification) {
        guard let dynamicLink = notification.object as? DynamicLink else {
            return
        }
        if (dynamicLink.url == nil) { return }
        let deeplink = dynamicLink.url!.absoluteString
        notifyListeners("dynamicDeeplinkOpen", data:[
            "url": deeplink
        ], retainUntilConsumed: true)
    }

}
