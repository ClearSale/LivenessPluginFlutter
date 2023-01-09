#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint cs_liveness_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'cs_liveness_flutter'
  s.version          = '1.0.0'
  s.summary          = 'Clearsale Liveness'
  s.description      = <<-DESC
  Clearsale Liveness.
                       DESC
  s.homepage         = 'http://clearsale.com.br'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Clearsale' => 'suporte@clearsale.com.br' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.4'
  s.dependency "CSLivenessSDK"
  s.dependency "CSLivenessSDKTec"
  
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 arm64'}
  s.swift_version = '5.0'
end
