# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
target 'MapwizeUI' do
  workspace 'MapwizeUIApp'
  project './MapwizeUI.xcodeproj'
  use_frameworks!
  pod 'MapwizeSDK', '3.6.1'
  pod 'IndoorLocation'
end

if ENV['BUILD_RELEASE'] != "true"
  target 'MapwizeUIApp' do
    workspace 'MapwizeUIApp'
    project './MapwizeUIApp.xcodeproj'
    use_frameworks!
    pod 'MapwizeUI', path: '.'
  end

  target 'MapwizeUIAppSwift' do
    workspace 'MapwizeUIApp'
    project './MapwizeUIAppSwift.xcodeproj'
    use_frameworks!
    pod 'MapwizeUI', path: '.'
  end
end
