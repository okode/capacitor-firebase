import Foundation
import Capacitor
import FirebaseCore
import FirebaseAnalytics
import FirebaseRemoteConfig

@objc(Firebase)
public class Firebase: CAPPlugin {
    
    var firebase: FirebaseApp? = nil;
    var remoteConfig: RemoteConfig? = nil;
    
    public override func load() {
        if (FirebaseApp.app() == nil) {
            FirebaseApp.configure();
            firebase = FirebaseApp.app()
            remoteConfig = RemoteConfig.remoteConfig();
        }
    }
    
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
        if name != nil && value != nil {
            DispatchQueue.main.async {
                Analytics.setUserProperty(value, forName: name!);
                call.success();
            }
        } else {
            call.error("You must pass a User Property name and value")
            self.bridge.modulePrint(self, "A user property name and value was not passed.")
            return
        }
    }
    
    @objc func setUserId(_ call: CAPPluginCall) {
        let userId = call.getString("userId");
        
        if userId != nil {
            DispatchQueue.main.async {
                Analytics.setUserID(userId);
                call.success();
            }
        } else {
            call.error("You must pass a userId.")
            self.bridge.modulePrint(self, "A userId was not passed.")
            return
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
        self.remoteConfig?.fetch(completionHandler: { (status, error) in
            if status == .success {
                call.resolve();
            } else {
                call.error("Error fetching remote config", error);
                self.bridge.modulePrint(self, "Error fetching remote config")
            }
        })
    }
    
    @objc func getRemoteConfigValue(_ call: CAPPluginCall) {
        let key = call.getString("key");
        if key != nil {
            let configValue = self.remoteConfig?.value(forKey: key!);
            call.resolve([ "value": configValue! ]);
        } else {
            call.error("You must pass 'key'")
            self.bridge.modulePrint(self, "You must pass 'key'")
        }
    }

}
