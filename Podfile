# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Flash Chat iOS13' do
  use_frameworks!

  # Pods for Flash Chat iOS13
  pod 'CLTypingLabel'
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'

end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
  end
 end
end
