# capacitor-firebase

## Generate dist files
After any change it is needed to generate all distribution files again and push them to the git repository

```
$ npm run build
```

## Configure Firebase Dynamic Deeplinks

### Android
- As with plain deep links, you must add a new intent filter to the activity that handles deep links for your app. The intent filter should catch deep links of your domain, since the Dynamic Link will redirect to your domain if your app is installed. This is required for your app to receive the Dynamic Link data after it is installed/updated from the Play Store and one taps on Continue button. In AndroidManifest.xml:
```
  <!-- Dynamic links config -->
  <intent-filter>
      <action android:name="android.intent.action.VIEW"/>
      <category android:name="android.intent.category.DEFAULT"/>
      <category android:name="android.intent.category.BROWSABLE"/>
      <data android:host="[DEEPLINK_HOST]" android:scheme="https"/>
      <data android:host="[DEEPLINK_HOST]" android:scheme="http"/>
  </intent-filter>
```

When users open a Dynamic Link with a deep link to the scheme and host you specify, your app will start the activity with this intent filter to handle the link.


### iOS
- In the Info tab of your app's Xcode project, create a new URL type to be used for Dynamic Links. Set the Identifier field to a unique value and the URL scheme field to be your bundle identifier, which is the default URL scheme used by Dynamic Links.

- In the Capabilities tab of your app's Xcode project, enable Associated Domains and add the following to the Associated Domains list:

- Add these imports in your AppDelegate
```
import CapacitorFirebase
```

- Next, in the application:continueUserActivity:restorationHandler: method of your application AppDelegate
```
func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                 restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    Firebase.handleContinueActivity(userActivity, restorationHandler)
    ...
}

func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
  Firebase.handleOpenUrl(url, options)
  ...
}

```
