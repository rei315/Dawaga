# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Dawaga' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Dawaga

pod 'RxSwift'
pod 'RxCocoa'
pod 'Action'
pod 'RxDataSources'
pod 'RxGesture'

pod 'RxCoreLocation'

pod 'Alamofire'

pod 'SnapKit'

pod 'RealmSwift'
pod 'SwiftyJSON'

pod 'GoogleMaps'
pod 'RxGoogleMaps'

end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
