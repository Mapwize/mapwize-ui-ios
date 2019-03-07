Pod::Spec.new do |s|
  s.name         = "MapwizeUI"
  s.version      = "1.0.3"
  s.license      = { :type => 'MIT' }
  s.summary      = "Fully featured and ready to use UIView to add Mapwize Indoor Maps and Navigation in your iOS app."
  s.homepage     = "https://github.com/Mapwize/mapwize-ui-ios"
  s.author       = { "Mapwize" => "support@mapwize.io" }
  s.platform     = :ios
  s.ios.deployment_target = '10.0'
  s.source       = { :git => "https://github.com/Mapwize/mapwize-ui-ios.git", :tag => "#{s.version}" }
  s.source_files  = "MapwizeUI/**/*.{h,m}"
  s.resources = "MapwizeUI/Resources/*"
  s.dependency "MapwizeForMapbox", "~> 2.0"
end
