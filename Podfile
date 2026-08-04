# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :osx, '10.13'
use_frameworks!
#use_modular_headers!


def common_pods
  pod 'Masonry'
  pod 'SnapKit'
  pod 'SnapKitExtend'
  
  pod 'RxBlocking'
  pod 'RxCocoa'
  pod 'RxSwift'
      
  pod 'YYModel'
  pod 'HandyJSON'

  pod 'SwiftExpand', :path => '../SwiftExpand'
  pod 'Then'
  pod 'Highlightr'

end


target 'MacTemplet' do
  common_pods
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
#      config.build_settings["CODE_SIGNING_ALLOWED"] = false;
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'YES'
      config.build_settings['CODE_SIGN_IDENTITY'] = '-'
      config.build_settings['CODE_SIGN_IDENTITY[sdk=macosx*]'] = '-'
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.13'
    end
  end
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.13'
      end
    end
  end
end
