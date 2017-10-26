
Pod::Spec.new do |s|
  s.name             = 'Houston'
  s.version          = '0.1.0'
  s.summary          = 'A lightweight logger in Swift for iOS'
  s.description      = <<-DESC
Houston is a lightweight logger in Swift.
                       DESC
  s.homepage         = 'https://github.com/RudyB/Houston'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'RudyB' => 'hello@rudybermudez.io' }
  s.source           = { :git => 'https://github.com/RudyB/Houston.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/RudyB_'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Source/*.swift'

end
