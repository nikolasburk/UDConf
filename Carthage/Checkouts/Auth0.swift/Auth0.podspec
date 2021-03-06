version = `agvtool mvers -terse1`.strip

web_auth_files = [
  'Auth0/_ObjectiveWebAuth.swift',
  'Auth0/ControllerModalPresenter.swift',
  'Auth0/OAuth2Grant.swift',
  'Auth0/AuthTransaction.swift',
  'Auth0/TransactionStore.swift',
  'Auth0/WebAuth.swift',
  'Auth0/WebAuthError.swift',
  'Auth0/SafariWebAuth.swift',
  'Auth0/SafariSession.swift',
  'Auth0/NativeAuth.swift',
  'Auth0/AuthProvider.swift'
]

Pod::Spec.new do |s|
  s.name             = 'Auth0'
  s.version          = version
  s.summary          = "Swift toolkit for Auth0 API"
  s.description      = <<-DESC
                        Auth0 API toolkit written in Swift for iOS, watchOS, tvOS & macOS apps
                        DESC
  s.homepage         = 'https://github.com/auth0/Auth0.swift'
  s.license          = 'MIT'
  s.author           = { 'Auth0' => 'oss@auth0.com', 'Hernan Zalazar' => 'hernan@auth0.com' }
  s.source           = { :git => 'https://github.com/auth0/Auth0.swift.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/auth0'

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
  s.requires_arc = true

  s.ios.source_files = 'Auth0/*.{swift,h,m}'
  s.ios.frameworks = 'UIKit', 'SafariServices'
  s.osx.source_files = 'Auth0/*.swift'
  s.osx.exclude_files = web_auth_files
  s.watchos.source_files = 'Auth0/*.swift'
  s.watchos.exclude_files = web_auth_files
  s.tvos.source_files = 'Auth0/*.swift'
  s.tvos.exclude_files = web_auth_files
end
