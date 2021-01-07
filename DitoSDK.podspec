Pod::Spec.new do |s|
  s.name             = 'DitoSDK'
  s.version          = '1.0.0'
  s.summary          = 'A short description of DitoSDK.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ditointernet/dito_ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'brennobemoura' => 'brennobemoura@outlook.com' }
  s.source           = { :git => 'https://github.com/ditointernet/dito_ios.git', :tag => s.version.to_s }

  s.swift_version = "5.3"
  s.ios.deployment_target = '10.0'
  s.source_files = 'Sources/**/*'
  s.exclude_files = "Sources/Info.plist"
end
