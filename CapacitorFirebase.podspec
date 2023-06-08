require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name = 'CapacitorFirebase'
  s.version = package['version']
  s.summary = package['description']
  s.license = package['license']
  s.homepage = package['repository']['url']
  s.author = package['author']
  s.source = { :git => package['repository']['url'], :tag => s.version.to_s }
  s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
  s.ios.deployment_target  = '13.0'
  s.dependency 'Capacitor'
  s.dependency 'Firebase/RemoteConfig', '8.14.0'
  s.dependency 'Firebase/Messaging', '8.14.0'
  s.dependency 'Firebase/Analytics', '8.14.0'
  s.dependency 'Firebase/DynamicLinks', '8.14.0'
  s.dependency 'Firebase/Crashlytics', '8.14.0'
  s.static_framework = true
  s.swift_version = '5.1'
end
