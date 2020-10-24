#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint extended_shared_preferences.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'extended_shared_preferences'
  s.version          = '1.0.3'
  s.summary          = 'Implements SharedPreferendes of Android and NSUserDefaults of iOS in Flutter.'
  s.description      = 'Implements SharedPreferendes of Android and NSUserDefaults of iOS in Flutter.'

  s.homepage         = 'https://github.com/MarloKessler/flutter-extended_shared_preferences'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Connapptivity' => 'marlo.kessler@connapptivity.de' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
