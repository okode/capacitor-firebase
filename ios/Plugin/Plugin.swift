import Foundation
import Capacitor
import FirebaseCore
import FirebaseAnalytics
import FirebaseRemoteConfig
import FirebaseDynamicLinks
import FirebaseMessaging

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
                call.resolve();
            }
        } else {
            call.reject("You must pass an event name.")
            CAPLog.print("An event name and value was not passed.")
            return
        }
    }
    
    @objc func setUserProperty(_ call: CAPPluginCall) {
        let name = call.getString("name");
        let value = call.getString("value");
        if name != nil {
            DispatchQueue.main.async {
                Analytics.setUserProperty(value, forName: name!);
                call.resolve();
            }
        } else {
            call.reject("You must pass a User Property name")
            CAPLog.print("A user property name was not passed.")
            return
        }
    }
    
    @objc func setUserId(_ call: CAPPluginCall) {
        let userId = call.getString("userId");
        DispatchQueue.main.async {
            Analytics.setUserID(userId);
            call.resolve();
        }
    }
    
    @objc func setScreenName(_ call: CAPPluginCall) {
        let screenName = call.getString("screenName");
        let screenClassOverride = call.getString("screenClassOverride");
        if screenName != nil {
            DispatchQueue.main.async {
                var parameters = [AnalyticsParameterScreenName: screenName!]
                if (screenClassOverride != nil) {
                    parameters.updateValue(screenClassOverride!, forKey: AnalyticsParameterScreenClass)
                }
                Analytics.logEvent(AnalyticsEventScreenView, parameters: parameters);
                call.resolve()
            }
        } else {
            call.reject("You must pass a screen name")
            CAPLog.print("A screen name was not passed")
            return
        }
    }
    
    // Firebase Remote Config
    
    @objc func activateFetched(_ call: CAPPluginCall) {
        self.remoteConfig?.activate(completion: { (changed, error) in
            if error == nil {
                call.resolve([ "activated": true ])
            } else {
                call.reject("Error activating fetched remote config", nil, error)
                CAPLog.print(error!.localizedDescription)
            }
        })
    }

    @objc func fetch(_ call: CAPPluginCall) {
        let completionHandler: RemoteConfigFetchCompletion =  { (status, error) in
            if status == .success {
                call.resolve();
            } else {
                call.reject("Error fetching remote config", nil, error);
                CAPLog.print("Error fetching remote config")
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
            call.reject("You must pass 'key'")
            CAPLog.print("You must pass 'key'")
        }
    }
    
    // Firebase Messaging
    
    @objc func getToken(_ call: CAPPluginCall) {
        Messaging.messaging().token { (token, error) in
            if let error = error {
                call.reject("Cant get token", nil, error)
            } else if let token = token {
                call.resolve([ "token": token ])
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
