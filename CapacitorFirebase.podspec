
  Pod::Spec.new do |s|
    s.name = 'CapacitorFirebase'
    s.version = '1.1.0'
    s.summary = 'Capacitor plugin to integrate Firebase in an Ionic application'
    s.license = 'MIT'
    s.homepage = 'https://github.com/okode/capacitor-firebase'
    s.author = 'Okode'
    s.source = { :git => 'https://github.com/okode/capacitor-firebase', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '11.0'
    s.dependency 'Capacitor'
    s.dependency 'Firebase/RemoteConfig', '7.2.0'
    s.dependency 'Firebase/Messaging', '7.2.0'
    s.dependency 'Firebase/Analytics', '7.2.0'
    s.dependency 'Firebase/DynamicLinks', '7.2.0'
    s.dependency 'Firebase/Crashlytics', '7.2.0'
    s.static_framework = true
  end