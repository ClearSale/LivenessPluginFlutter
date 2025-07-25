#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint liveness_flutter_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'liveness_flutter_sdk'
  s.version          = '4.0.0'
  s.summary          = 'ClearSale CSLiveness Flutter SDK'
  s.description      = <<-DESC
ClearSale Liveness Flutter SDK
                       DESC
  s.homepage         = 'https://devs.plataformadatatrust.clearsale.com.br/docs/sdk-flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'ClearSale' => 'matheus.castro-ext@clear.sale' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.info_plist = {
      "NSCameraUsageDescription" => "This app requires access to the camera."
  }

  s.dependency 'CSLivenessSDK'
end
