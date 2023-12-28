use_frameworks!
source 'https://github.com/CocoaPods/Specs.git'
source 'https://gitee.com/sander_shan/sanderspecs.git'

platform :ios, '13.0'


# Basic
def basic_pods
  pod 'Alamofire',          '~> 4.4'
  pod 'CodableAlamofire'
  pod 'ColorCompatibility'
  pod 'RxSwift',            '~> 5.0'
  pod 'RxCocoa',            '~> 5.0'
  pod 'RxSwiftExt',         '~> 5.0'
  pod 'RxDataSources',      '~> 4.0'
  pod 'SwiftyBeaver'
  pod 'SwiftHEXColors'
  pod 'SwiftDate'
  pod 'SDWebImage'
  pod 'FlexLayout'
  pod 'SPIndicator'
  pod 'SwiftyFitsize', :git => 'https://gitee.com/sander_shan/swifty-fitsize.git'
  pod 'PinLayout'
  pod 'CRRefresh'
  pod 'CocoaAsyncSocket'
  pod 'pop'
  pod 'ProgressHUD'
  pod 'KYDrawerController'
  
  pod 'FSPagerView'
  
  pod 'IQKeyboardManager'
  
  pod  'MBProgressHUD'
  
  pod 'ZLPhotoBrowser',   :git => 'https://gitee.com/sander_shan/zlphoto-browser.git'
  
  pod 'EZPlayer', :git => 'https://gitee.com/sander_shan/ezplayer.git'
  
  
  pod 'WsRTC'
  pod 'HHBAliAuthSDK'
  
  pod 'SnapKit',           '~> 5.6.0'
  
end

# Testing
def test_pods
  pod 'RxBlocking',         '~> 5.0'
  pod 'RxTest',             '~> 5.0'
end

target 'game_wwj' do

  use_frameworks!

  basic_pods
  
  pod 'AFNetworking'
  pod 'SDWebImage'
  pod 'Masonry'
  pod 'MJExtension'
  pod 'HandyJSON'
  
end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
    installer.pods_project.targets.each do |target|
      if target.name == 'RxSwift'
        target.build_configurations.each do |config|
          if config.name == 'Debug'
            config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
          end
        end
      end
    end
    installer.pods_project.build_configurations.each do |config|
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      end
end

