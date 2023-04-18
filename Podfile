# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'

target 'MovieApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MovieApp
  
  # Для работы с сетевыми запросами
  pod 'Alamofire'  

  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources', '~> 4.0'

  # Для верстки
  pod 'SnapKit'
  pod 'PaddingLabel', '1.2'
  pod 'Cosmos'

  # Для удобного интерфейса для получения и отображения картинки по URL.
  pod 'Kingfisher' 
   
  # Для добавления анимаций
  pod 'lottie-ios'


  # Fixing bug
post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
end
