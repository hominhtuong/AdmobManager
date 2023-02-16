Pod::Spec.new do |s|
  s.name             = 'AdmobManager'
  s.version          = '1.1.0'
  s.summary          = 'AdmobManager for iOS'
  s.swift_version = ['5.1', '5.2', '5.3', '5.4', '5.5', '5.6', '5.7']
  s.description  = <<-DESC
  This CocoaPods library is software development kit for iOS. Easy way to manage Google Mobile Ads SDK to show ads within app. 
                   DESC

  s.homepage         = 'https://github.com/hominhtuong/AdmobManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hominhtuong' => 'minhtuong2502@gmail.com' }
  s.source           = { :git => 'https://github.com/hominhtuong/AdmobManager.git', :tag => s.version.to_s }
  s.social_media_url = 'https://facebook.com/minhtuongitc'
  s.ios.deployment_target = '13.0'

  s.source_files = 'Sources/*.swift'
  s.static_framework   = true
  s.dependency     'Google-Mobile-Ads-SDK'
  s.dependency     'MTSDK'
end
