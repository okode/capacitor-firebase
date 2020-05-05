# capacitor-firebase

## Generate dist files
After any change it is needed to generate all distribution files again and push them to the git repository

```
$ npm run build
```

## Configure Firebase Dynamic Deeplinks

### Android
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

## Configure Crashlytics

### Android
1 - In your project-level build.gradle file, add the Crashlytics Gradle plugin:

```
buildscript {
    repositories {
        // Check that you have Google's Maven repository (if not, add it).
        google()
    }

    dependencies {
        // ...

        // Check that you have the Google Services Gradle plugin v4.3.2 or later
        // (if not, add it).
        classpath 'com.google.gms:google-services:4.3.3'

        // Add the Crashlytics Gradle plugin.
        classpath 'com.google.firebase:firebase-crashlytics-gradle:2.0.0'
    }
}

allprojects {
    repositories {
        // Check that you have Google's Maven repository (if not, add it).
        google()
    }
}
```
2 - In your app-level build.gradle file, apply the Crashlytics Gradle plugin:

```
// Apply the Crashlytics Gradle plugin
apply plugin: 'com.google.firebase.crashlytics'
```

## iOS

Configure compilation with dSYM files

1 - Select its project file in the left navigator.

2 - Select the Build Settings tab

3 - Set "Debug Information Format" to "dWARF with dSYM File" for Debug and Release.

Configure Run script

1 - Select its project file in the left navigator.

2 - From the Select a project or target dropdown, select your main build target.

3 - Select the Build Phases tab, then click add > New Run Script Phase.

4 - Expand the new Run Script section that appears. In the script field (located under the Shell field), add a new run script:

```
"${PODS_ROOT}/FirebaseCrashlytics/run"
```

5 - Add your app’s dSYM location as an input file that enables Crashlytics to automatically generate dSYMs for large apps more quickly. For example:

```
${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}
```

You can also provide your app's built Info.plist location to the build phase's Input Files field:

```
${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}
```
