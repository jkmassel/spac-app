Pod::Spec.new do |s|
  s.name = 'BoxCast'
  s.version = '0.5.3'
  s.license = 'MIT'
  s.summary = 'BoxCast is a SDK for integrating with the BoxCast API on Apple platforms.'
  s.homepage = 'https://github.com/boxcast/boxcast-sdk-apple'
  s.social_media_url = 'https://twitter.com/boxcast'
  s.authors = { 'Camden Fullmer' => 'camden.fullmer@boxcast.com' }

  s.source = { git: 'https://github.com/boxcast/boxcast-sdk-apple.git', tag: s.version }
  s.source_files = 'Source/**/*.swift'
  s.swift_versions = ['5.0']

  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.12'
end
