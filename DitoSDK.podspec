Pod::Spec.new do |s|
  s.name             = 'DitoSDK'
  s.version          = '1.1.0-beta'
  s.summary          = 'SDK da Dito CRM'

  s.description      = <<-DESC
'https://developers.dito.com.br/reference/ios'
                       DESC

  s.homepage         = 'https://github.com/ditointernet/dito_ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'brennobemoura' => 'brennobemoura@outlook.com' }
  s.source           = { :git => 'https://github.com/ditointernet/dito_ios.git', :tag => 'v' + s.version.to_s }

  s.swift_version = "5.3"
  s.ios.deployment_target = '10.0'
  s.source_files = 'Sources/**/*', 'Persistence/*.{swift}'
  s.resources = 'Persistence/*.{xcdatamodeld}'
  s.exclude_files = "Sources/Info.plist"
end
