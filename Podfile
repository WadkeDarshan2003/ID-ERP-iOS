# Podfile for ID ERP iOS Application
platform :ios, '14.0'

target 'ID-ERP-iOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Firebase pods
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/Messaging'
  pod 'Firebase/Analytics'
  pod 'Firebase/RemoteConfig'
  
  # Networking
  pod 'Alamofire', '~> 5.7'
  pod 'Reachability'
  
  # UI/UX
  pod 'Kingfisher', '~> 7.0' # Image caching and downloading
  
  # Utilities
  pod 'SwiftyJSON'
  pod 'KeychainSwift'
  pod 'CryptoSwift'
  
  # Development pods
  target 'ID-ERP-iOSTests' do
    inherit! :search_paths
    pod 'Firebase/Firestore'
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'FIREBASE_ANALYTICS_COLLECTION_ENABLED=1'
      ]
    end
  end
end
