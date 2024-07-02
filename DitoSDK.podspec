
Pod::Spec.new do |s|
  s.name             = 'DitoSDK'
  s.version          = '1.1.1'
  s.summary          = 'SDK da Dito CRM'
  s.description      ='https://developers.dito.com.br/reference/ios'
  s.homepage         = 'https://github.com/ditointernet/dito_ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'brennobemoura' => 'brennobemoura@outlook.com', 'igorduarte' => 'igor.duarte@dito.com.br' }
  s.source           = { :git => 'https://github.com/ditointernet/dito_ios.git', :tag => 'v' + s.version.to_s }

  s.swift_version = "5.3"
  s.ios.deployment_target = '13.0'
  s.source_files = 'DitoSDK/Sources/**/*', 'DitoSDK/Persistence/*.{swift}'
  s.resources = 'DitoSDK/Persistence/*.{xcdatamodeld}'
  s.exclude_files = "DitoSDK/Sources/Info.plist"
end
